CLASS z2ui5_cl_demo_app_461 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_child,
        text TYPE string,
      END OF ty_s_child,
      ty_t_child TYPE STANDARD TABLE OF ty_s_child WITH DEFAULT KEY,
      BEGIN OF ty_s_root,
        text  TYPE string,
        nodes TYPE ty_t_child,
      END OF ty_s_root.
    DATA t_nodes TYPE STANDARD TABLE OF ty_s_root WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_461 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_nodes.
      DATA temp2 LIKE LINE OF temp1.
      DATA temp3 TYPE z2ui5_cl_demo_app_461=>ty_t_child.
      DATA temp4 LIKE LINE OF temp3.
      DATA temp5 TYPE z2ui5_cl_demo_app_461=>ty_t_child.
      DATA temp6 LIKE LINE OF temp5.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      
      CLEAR temp1.
      
      temp2-text = `Inbox`.
      
      CLEAR temp3.
      
      temp4-text = `Invoice.pdf`.
      INSERT temp4 INTO TABLE temp3.
      temp4-text = `Contract.docx`.
      INSERT temp4 INTO TABLE temp3.
      temp2-nodes = temp3.
      INSERT temp2 INTO TABLE temp1.
      temp2-text = `Archive`.
      
      CLEAR temp5.
      
      temp6-text = `Old_Report.pdf`.
      INSERT temp6 INTO TABLE temp5.
      temp2-nodes = temp5.
      INSERT temp2 INTO TABLE temp1.
      temp2-text = `Trash`.
      INSERT temp2 INTO TABLE temp1.
      t_nodes = temp1.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA lt_drag TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
        DATA lt_drop TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
        DATA lv_drag_lines TYPE i.
        DATA lv_drop_lines TYPE i.
        DATA temp3 TYPE string.
        DATA temp4 TYPE string.
        DATA temp8 TYPE string.
        DATA temp9 TYPE string.
        DATA temp1 TYPE string.
        DATA temp2 TYPE string.
            DATA temp5 TYPE i.
            DATA temp10 LIKE LINE OF lt_drag.
            DATA temp11 LIKE sy-tabix.
            DATA lv_from_root TYPE i.
            DATA temp6 TYPE i.
            DATA temp12 LIKE LINE OF lt_drag.
            DATA temp13 LIKE sy-tabix.
            DATA lv_from_child TYPE i.
            DATA temp7 TYPE i.
            DATA temp14 LIKE LINE OF lt_drop.
            DATA temp15 LIKE sy-tabix.
            DATA lv_to_root TYPE i.
            DATA ls_child TYPE z2ui5_cl_demo_app_461=>ty_s_child.
            DATA temp16 LIKE LINE OF t_nodes.
            DATA temp17 LIKE sy-tabix.
            DATA temp18 LIKE LINE OF temp16-nodes.
            DATA temp19 LIKE sy-tabix.
        FIELD-SYMBOLS <from> TYPE z2ui5_cl_demo_app_461=>ty_s_root.
        FIELD-SYMBOLS <to> TYPE z2ui5_cl_demo_app_461=>ty_s_root.

    CASE client->get( )-event.

      WHEN `MOVE_NODE`.
        " both event args arrive resolved client-side: the binding context
        " paths of the dragged and the drop target item. The two-way model
        " prefixes them with /XX/, e.g. /XX/T_NODES/0/NODES/1 (a file) and
        " /XX/T_NODES/2 (a folder) - so parse from the END of the path
        
        SPLIT client->get_event_arg( ) AT `/` INTO TABLE lt_drag.
        
        SPLIT client->get_event_arg( 2 ) AT `/` INTO TABLE lt_drop.
        
        lv_drag_lines = lines( lt_drag ).
        
        lv_drop_lines = lines( lt_drop ).
        
        CLEAR temp3.
        
        READ TABLE lt_drag INTO temp4 INDEX lv_drag_lines - 1.
        IF sy-subrc = 0.
          temp3 = temp4.
        ENDIF.
        
        CLEAR temp8.
        
        READ TABLE lt_drag INTO temp9 INDEX lv_drag_lines - 3.
        IF sy-subrc = 0.
          temp8 = temp9.
        ENDIF.
        
        CLEAR temp1.
        
        READ TABLE lt_drop INTO temp2 INDEX lv_drop_lines - 1.
        IF sy-subrc = 0.
          temp1 = temp2.
        ENDIF.
        IF lv_drag_lines < 4 OR lv_drop_lines < 2
            OR temp3 <> `NODES`
            OR temp8 <> `T_NODES`
            OR temp1 <> `T_NODES`.
          client->message_toast_display( `drop a file onto a folder` ).
          RETURN.
        ENDIF.
        TRY.
            
            
            
            temp11 = sy-tabix.
            READ TABLE lt_drag INDEX lv_drag_lines - 2 INTO temp10.
            sy-tabix = temp11.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            temp5 = temp10.
            
            lv_from_root  = temp5 + 1.
            
            
            
            temp13 = sy-tabix.
            READ TABLE lt_drag INDEX lv_drag_lines INTO temp12.
            sy-tabix = temp13.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            temp6 = temp12.
            
            lv_from_child = temp6 + 1.
            
            
            
            temp15 = sy-tabix.
            READ TABLE lt_drop INDEX lv_drop_lines INTO temp14.
            sy-tabix = temp15.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            temp7 = temp14.
            
            lv_to_root    = temp7 + 1.
            
            
            
            temp17 = sy-tabix.
            READ TABLE t_nodes INDEX lv_from_root INTO temp16.
            sy-tabix = temp17.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            
            
            temp19 = sy-tabix.
            READ TABLE temp16-nodes INDEX lv_from_child INTO temp18.
            sy-tabix = temp19.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            ls_child      = temp18.
          CATCH cx_root.
            RETURN.
        ENDTRY.
        " dropping a file onto its own parent folder is a no-op
        IF lv_from_root = lv_to_root.
          RETURN.
        ENDIF.
        
        READ TABLE t_nodes INDEX lv_from_root ASSIGNING <from>.
        IF sy-subrc <> 0.
          RETURN.
        ENDIF.
        
        READ TABLE t_nodes INDEX lv_to_root ASSIGNING <to>.
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

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA tree TYPE REF TO z2ui5_cl_xml_view.
    DATA temp8 TYPE z2ui5_if_types=>ty_t_name_value.
    DATA temp9 LIKE LINE OF temp8.
    DATA temp18 TYPE string_table.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell(
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

    
    tree = page->tree( id         = `tree1`
                             headertext = `Folders`
                             items      = client->_bind( t_nodes ) ).

    
    CLEAR temp8.
    
    temp9-n = `sourceAggregation`.
    temp9-v = `items`.
    INSERT temp9 INTO TABLE temp8.
    temp9-n = `targetAggregation`.
    temp9-v = `items`.
    INSERT temp9 INTO TABLE temp8.
    temp9-n = `dropPosition`.
    temp9-v = `On`.
    INSERT temp9 INTO TABLE temp8.
    temp9-n = `drop`.
    
    CLEAR temp18.
    INSERT `${$parameters>/draggedControl}.getBindingContext().getPath()` INTO TABLE temp18.
    INSERT `${$parameters>/droppedControl}.getBindingContext().getPath()` INTO TABLE temp18.
    temp9-v = client->_event(
val = `MOVE_NODE`
t_arg = temp18 ).
    INSERT temp9 INTO TABLE temp8.
    tree->drag_drop_config( ``
        )->_generic(
            name   = `DragDropInfo`
            ns     = `dnd`
            t_prop = temp8 ).

    tree->standard_tree_item( title = `{TEXT}` ).

    " invisible companion: preserves the tree's expand state across the
    " move roundtrips (snapshot before the request, re-apply after render)
    page->_z2ui5( )->tree( `tree1` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
