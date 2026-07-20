CLASS z2ui5_cl_demo_app_453 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        weight   TYPE string,
        price    TYPE string,
        currency TYPE string,
        width    TYPE i,
        depth    TYPE i,
        height   TYPE i,
        dim_unit TYPE string,
        status   TYPE string,
        delivery TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_453 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_products.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      
      CLEAR temp1.
      
      temp2-name = `Comfort Easy`.
      temp2-weight = `650`.
      temp2-price = `249.99`.
      temp2-currency = `EUR`.
      temp2-width = 30.
      temp2-depth = 21.
      temp2-height = 3.
      temp2-dim_unit = `cm`.
      temp2-status = `Available`.
      temp2-delivery = `Shipped`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Notebook Basic 15`.
      temp2-weight = `1500`.
      temp2-price = `956`.
      temp2-currency = `EUR`.
      temp2-width = 40.
      temp2-depth = 28.
      temp2-height = 0.
      temp2-dim_unit = `cm`.
      temp2-status = `Out of Stock`.
      temp2-delivery = `Failed Shipping`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Ergo Screen E-I`.
      temp2-weight = `2100`.
      temp2-price = `230.5`.
      temp2-currency = `EUR`.
      temp2-width = 54.
      temp2-depth = 46.
      temp2-height = 8.
      temp2-dim_unit = `cm`.
      temp2-status = `Discontinued`.
      temp2-delivery = `Pending`.
      INSERT temp2 INTO TABLE temp1.
      t_products = temp1.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE z2ui5_if_types=>ty_s_name_value.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    " require the framework's curated formatter module into the view - the
    " demo kit pack (weightStateByValue, stockStatusState/-Icon, round2DP,
    " dimensions, deliveryStatusState) then works as plain formatters in the
    " bindings, exactly like the demo kit samples wire their Formatter.js.
    
    CLEAR temp3.
    temp3-n = `core:require`.
    temp3-v = `{Formatter: 'z2ui5/model/formatter'}`.
    view->_generic_property( temp3 ).

    
    page = view->shell(
        )->page(
            title          = `abap2UI5 - Formatter - demo kit pack`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Every column except Product is formatted client-side by a function of the ` &&
                   `curated module z2ui5/model/formatter - the demo kit pack, wired via core:require.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    
    tab = page->table( id    = `productTable`
                             items = client->_bind( t_products ) ).

    tab->columns(
        )->column( )->text( `Product` )->get_parent(
        )->column( )->text( `Weight (g)` )->get_parent(
        )->column( )->text( `Price` )->get_parent(
        )->column( )->text( `Dimensions` )->get_parent(
        )->column( )->text( `Status` )->get_parent(
        )->column( )->text( `Delivery` )->get_parent( ).

    tab->items(
        )->column_list_item(
            )->cells(
                )->text( `{NAME}`
                )->object_number(
                    number = `{WEIGHT}`
                    state  = |\{ path: 'WEIGHT', formatter: 'Formatter.weightStateByValue' \}|
                )->object_number(
                    number = |\{ path: 'PRICE', formatter: 'Formatter.round2DP' \}|
                    unit   = `{CURRENCY}`
                )->text( |\{ parts: [\{path: 'WIDTH'\}, \{path: 'DEPTH'\}, \{path: 'HEIGHT'\}, | &&
                         |\{path: 'DIM_UNIT'\}], formatter: 'Formatter.dimensions' \}|
                )->object_status(
                    text  = `{STATUS}`
                    icon  = |\{ path: 'STATUS', formatter: 'Formatter.stockStatusIcon' \}|
                    state = |\{ path: 'STATUS', formatter: 'Formatter.stockStatusState' \}| )->get_parent(
                )->object_status(
                    text  = `{DELIVERY}`
                    state = |\{ path: 'DELIVERY', formatter: 'Formatter.deliveryStatusState' \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
