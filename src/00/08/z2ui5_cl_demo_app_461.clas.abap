CLASS z2ui5_cl_demo_app_461 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_child,
        text TYPE string,
      END OF ty_s_child,
      ty_t_child TYPE STANDARD TABLE OF ty_s_child WITH EMPTY KEY,
      BEGIN OF ty_s_root,
        text  TYPE string,
        nodes TYPE ty_t_child,
      END OF ty_s_root.
    DATA t_nodes TYPE STANDARD TABLE OF ty_s_root WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_461 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      t_nodes = VALUE #(
          ( text = `Inbox` nodes = VALUE #(
              ( text = `Invoice.pdf` )
              ( text = `Contract.docx` ) ) )
          ( text = `Archive` nodes = VALUE #(
              ( text = `Old_Report.pdf` ) ) )
          ( text = `Trash` ) ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `MOVE_NODE`.
        " both event args arrive resolved client-side: the binding context
        " paths of the dragged and the drop target item, e.g.
        " /T_NODES/0/NODES/1 (a file) and /T_NODES/2 (a folder)
        SPLIT client->get_event_arg( ) AT `/` INTO TABLE DATA(lt_drag).
        SPLIT client->get_event_arg( 2 ) AT `/` INTO TABLE DATA(lt_drop).
        IF lines( lt_drag ) <> 5 OR lines( lt_drop ) <> 3.
          client->message_toast_display( `drop a file onto a folder` ).
          RETURN.
        ENDIF.
        TRY.
            DATA(lv_from_root)  = CONV i( lt_drag[ 3 ] ) + 1.
            DATA(lv_from_child) = CONV i( lt_drag[ 5 ] ) + 1.
            DATA(lv_to_root)    = CONV i( lt_drop[ 3 ] ) + 1.
            DATA(ls_child)      = t_nodes[ lv_from_root ]-nodes[ lv_from_child ].
          CATCH cx_root.
            RETURN.
        ENDTRY.
        ASSIGN t_nodes[ lv_from_root ] TO FIELD-SYMBOL(<from>).
        IF sy-subrc <> 0.
          RETURN.
        ENDIF.
        ASSIGN t_nodes[ lv_to_root ] TO FIELD-SYMBOL(<to>).
        IF sy-subrc <> 0.
          RETURN.
        ENDIF.
        DELETE <from>-nodes INDEX lv_from_child.
        APPEND ls_child TO <to>-nodes.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Tree - drag and drop`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Drag a file onto another folder: the drop event ships the binding context ` &&
                   `paths of both tree items, ABAP moves the node inside the nested table and ` &&
                   `view_model_update refreshes the tree.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(tree) = page->tree( id         = `tree1`
                             headertext = `Folders`
                             items      = client->_bind_edit( t_nodes ) ).

    tree->drag_drop_config( ``
        )->_generic(
            name   = `DragDropInfo`
            ns     = `dnd`
            t_prop = VALUE #( ( n = `sourceAggregation` v = `items` )
                              ( n = `targetAggregation` v = `items` )
                              ( n = `dropPosition`      v = `On` )
                              ( n = `drop`              v = client->_event(
                                  val   = `MOVE_NODE`
                                  t_arg = VALUE #(
                                      ( `${$parameters>/draggedControl}.getBindingContext().getPath()` )
                                      ( `${$parameters>/droppedControl}.getBindingContext().getPath()` ) ) ) ) ) ).

    tree->standard_tree_item( title = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
