CLASS z2ui5_cl_demo_app_459 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        category TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_459 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      t_products = VALUE #(
          ( name = `Notebook Basic 15`  category = `Laptops` )
          ( name = `Notebook Basic 17`  category = `Laptops` )
          ( name = `Ergo Screen E-I`    category = `Screens` )
          ( name = `Flat Basic`         category = `Screens` )
          ( name = `Comfort Easy`       category = `PDAs` )
          ( name = `ITelO Vault`        category = `PDAs` ) ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `REORDER`.
        " the three event args arrive resolved client-side from the drop
        " event: dragged row index, drop target index (both 0-based) and
        " the drop position (Before/After)
        TRY.
            DATA(lv_from) = CONV i( client->get_event_arg( ) ) + 1.
            DATA(lv_to)   = CONV i( client->get_event_arg( 2 ) ) + 1.
            DATA(lv_pos)  = client->get_event_arg( 3 ).
            DATA(ls_row)  = t_products[ lv_from ].
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

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
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

    DATA(tab) = page->table( id    = `reorderTable`
                             items = client->_bind_edit( t_products ) ).

    " dragDropConfig is a plain sap.m aggregation here (ns = ``); the
    " DragDropInfo goes through _generic because the typed builder method
    " has no dropPosition parameter
    tab->drag_drop_config( ``
        )->_generic(
            name   = `DragDropInfo`
            ns     = `dnd`
            t_prop = VALUE #( ( n = `sourceAggregation` v = `items` )
                              ( n = `targetAggregation` v = `items` )
                              ( n = `dropPosition`      v = `Between` )
                              ( n = `drop`              v = client->_event(
                                  val   = `REORDER`
                                  t_arg = VALUE #(
                                      ( `${$parameters>/draggedControl/oParent}.indexOfItem(${$parameters>/draggedControl})` )
                                      ( `${$parameters>/droppedControl/oParent}.indexOfItem(${$parameters>/droppedControl})` )
                                      ( `${$parameters>/dropPosition}` ) ) ) ) ) ).

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
