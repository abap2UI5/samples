" @keywords dnd dragdropinfo reorder rows move
" @summary Drag and drop of table rows (DragDropInfo), and how the new order reaches the internal table.
" @docs https://abap2ui5.github.io/docs/cookbook/model/tables
CLASS z2ui5_cl_smp_app_459 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_459 IMPLEMENTATION.

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
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `REORDER`.
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
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:dnd`    v = `sap.ui.core.dnd` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Table - Drag and Drop Rows`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text` v = `Drag a row and drop it between two others: the dnd:DragDropInfo drop event ` &&
                   `sends the dragged/drop indexes and the drop position to the backend, ABAP ` &&
                   `reorders the table and the refreshed model updates the list.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(tab) = page->ele( `Table`
        )->a( n = `items` v = client->_bind( t_products )
        )->a( n = `id`    v = `reorderTable` ).

    " dragDropConfig is a plain sap.m aggregation here (ns = ``); the
    " DragDropInfo goes through _generic because the typed builder method
    " has no dropPosition parameter
    tab->ele( `dragDropConfig`
        )->ele( n = `DragDropInfo` ns = `dnd`
            )->a( n = `sourceAggregation` v = `items`
            )->a( n = `targetAggregation` v = `items`
            )->a( n = `dropPosition`      v = `Between`
            )->a( n = `drop`              v = client->_event(
                                  val   = `REORDER`
                                  t_arg = VALUE #(
                                      ( `${$parameters>/draggedControl/oParent}.indexOfItem(${$parameters>/draggedControl})` )
                                      ( `${$parameters>/droppedControl/oParent}.indexOfItem(${$parameters>/droppedControl})` )
                                      ( `${$parameters>/dropPosition}` ) ) ) ).

    tab->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Product`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Category`
        )->end( ).

    tab->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->tag( `Text`
                    )->a( n = `text` v = `{NAME}`
                )->tag( `Text`
                    )->a( n = `text` v = `{CATEGORY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
