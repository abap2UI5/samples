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
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_453 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      t_products = VALUE #(
          ( name = `Comfort Easy` weight = `650` price = `249.99` currency = `EUR`
            width = 30 depth = 21 height = 3 dim_unit = `cm`
            status = `Available` delivery = `Shipped` )
          ( name = `Notebook Basic 15` weight = `1500` price = `956` currency = `EUR`
            width = 40 depth = 28 height = 0 dim_unit = `cm`
            status = `Out of Stock` delivery = `Failed Shipping` )
          ( name = `Ergo Screen E-I` weight = `2100` price = `230.5` currency = `EUR`
            width = 54 depth = 46 height = 8 dim_unit = `cm`
            status = `Discontinued` delivery = `Pending` ) ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    " require the framework's curated formatter module into the view - the
    " demo kit pack (weightStateByValue, stockStatusState/-Icon, round2DP,
    " dimensions, deliveryStatusState) then works as plain formatters in the
    " bindings, exactly like the demo kit samples wire their Formatter.js.
    view->_generic_property( VALUE #( n = `core:require`
                                      v = `{Formatter: 'z2ui5/model/formatter'}` ) ).

    DATA(page) = view->shell(
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

    DATA(tab) = page->table( id    = `productTable`
                             items = client->_bind_edit( t_products ) ).

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
