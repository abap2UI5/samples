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



CLASS Z2UI5_CL_DEMO_APP_461 IMPLEMENTATION.


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
        " paths of the dragged and the drop target item. The two-way model
        " prefixes them with /XX/, e.g. /XX/T_NODES/0/NODES/1 (a file) and
        " /XX/T_NODES/2 (a folder) - so parse from the END of the path
        SPLIT client->get_event_arg( ) AT `/` INTO TABLE DATA(lt_drag).
        SPLIT client->get_event_arg( 2 ) AT `/` INTO TABLE DATA(lt_drop).
        DATA(lv_drag_lines) = lines( lt_drag ).
        DATA(lv_drop_lines) = lines( lt_drop ).
        IF lv_drag_lines < 4 OR lv_drop_lines < 2
            OR VALUE #( lt_drag[ lv_drag_lines - 1 ] OPTIONAL ) <> `NODES`
            OR VALUE #( lt_drag[ lv_drag_lines - 3 ] OPTIONAL ) <> `T_NODES`
            OR VALUE #( lt_drop[ lv_drop_lines - 1 ] OPTIONAL ) <> `T_NODES`.
          client->message_toast_display( `drop a file onto a folder` ).
          RETURN.
        ENDIF.
        TRY.
            DATA(lv_from_root)  = CONV i( lt_drag[ lv_drag_lines - 2 ] ) + 1.
            DATA(lv_from_child) = CONV i( lt_drag[ lv_drag_lines ] ) + 1.
            DATA(lv_to_root)    = CONV i( lt_drop[ lv_drop_lines ] ) + 1.
            DATA(ls_child)      = t_nodes[ lv_from_root ]-nodes[ lv_from_child ].
          CATCH cx_root.
            RETURN.
        ENDTRY.
        " dropping a file onto its own parent folder is a no-op
        IF lv_from_root = lv_to_root.
          RETURN.
        ENDIF.
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
        " full view rebuild instead of view_model_update: the z2ui5.cc.Tree
        " companion re-applies the expand state (snapshotted before this
        " roundtrip) only when it renders - a pure model refresh would leave
        " the rebuilt tree binding collapsed
        view_display( ).

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
                   `redraws the view - the z2ui5.cc.Tree companion keeps the expanded nodes open.`
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

    " invisible companion: preserves the tree's expand state across the
    " move roundtrips (snapshot before the request, re-apply after render)
    page->_z2ui5( )->tree( `tree1` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
