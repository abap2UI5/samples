CLASS z2ui5_cl_demo_app_459 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        category TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_459 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_products.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      
      CLEAR temp1.
      
      temp2-name = `Notebook Basic 15`.
      temp2-category = `Laptops`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Notebook Basic 17`.
      temp2-category = `Laptops`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Ergo Screen E-I`.
      temp2-category = `Screens`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Flat Basic`.
      temp2-category = `Screens`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Comfort Easy`.
      temp2-category = `PDAs`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `ITelO Vault`.
      temp2-category = `PDAs`.
      INSERT temp2 INTO TABLE temp1.
      t_products = temp1.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
            DATA temp3 TYPE i.
            DATA lv_from TYPE i.
            DATA temp4 TYPE i.
            DATA lv_to TYPE i.
            DATA lv_pos TYPE string.
            DATA ls_row LIKE LINE OF t_products.
            DATA temp1 LIKE LINE OF t_products.
            DATA temp2 LIKE sy-tabix.

    CASE client->get( )-event.

      WHEN `REORDER`.
        " the three event args arrive resolved client-side from the drop
        " event: dragged row index, drop target index (both 0-based) and
        " the drop position (Before/After)
        TRY.
            
            temp3 = client->get_event_arg( ).
            
            lv_from = temp3 + 1.
            
            temp4 = client->get_event_arg( 2 ).
            
            lv_to   = temp4 + 1.
            
            lv_pos  = client->get_event_arg( 3 ).
            
            
            
            temp2 = sy-tabix.
            READ TABLE t_products INDEX lv_from INTO temp1.
            sy-tabix = temp2.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            ls_row = temp1.
          CATCH cx_root.
            RETURN.
        ENDTRY.
        " dropping a row onto itself is a no-op
        IF lv_from = lv_to.
          RETURN.
        ENDIF.
        DELETE t_products INDEX lv_from.
        IF lv_from < lv_to.
          lv_to = lv_to - 1.
        ENDIF.
        IF lv_pos = `Before`.
          INSERT ls_row INTO t_products INDEX lv_to.
        ELSE.
          INSERT ls_row INTO t_products INDEX lv_to + 1.
        ENDIF.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    DATA temp5 TYPE z2ui5_if_types=>ty_t_name_value.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell(
        )->page(
            title          = `abap2UI5 - Drag and Drop - Table reorder`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Drag a row and drop it between two others: the dnd:DragDropInfo drop event ` &&
                   `sends the dragged/drop indexes and the drop position to the backend, ABAP ` &&
                   `reorders the table, view_model_update refreshes the list.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    
    tab = page->table( id    = `reorderTable`
                             items = client->_bind( t_products ) ).

    " dragDropConfig is a plain sap.m aggregation here (ns = ``); the
    " DragDropInfo goes through _generic because the typed builder method
    " has no dropPosition parameter
    
    CLEAR temp5.
    
    temp6-n = `sourceAggregation`.
    temp6-v = `items`.
    INSERT temp6 INTO TABLE temp5.
    temp6-n = `targetAggregation`.
    temp6-v = `items`.
    INSERT temp6 INTO TABLE temp5.
    temp6-n = `dropPosition`.
    temp6-v = `Between`.
    INSERT temp6 INTO TABLE temp5.
    temp6-n = `drop`.
    
    CLEAR temp3.
    INSERT `${$parameters>/draggedControl/oParent}.indexOfItem(${$parameters>/draggedControl})` INTO TABLE temp3.
    INSERT `${$parameters>/droppedControl/oParent}.indexOfItem(${$parameters>/droppedControl})` INTO TABLE temp3.
    INSERT `${$parameters>/dropPosition}` INTO TABLE temp3.
    temp6-v = client->_event(
val = `REORDER`
t_arg = temp3 ).
    INSERT temp6 INTO TABLE temp5.
    tab->drag_drop_config( ``
        )->_generic(
            name   = `DragDropInfo`
            ns     = `dnd`
            t_prop = temp5 ).

    tab->columns(
        )->column( )->text( `Product` )->get_parent(
        )->column( )->text( `Category` )->get_parent( ).

    tab->items(
        )->column_list_item(
            )->cells(
                )->text( `{NAME}`
                )->text( `{CATEGORY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
