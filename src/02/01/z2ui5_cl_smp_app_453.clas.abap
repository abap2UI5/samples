CLASS z2ui5_cl_smp_app_453 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        "! raw data as it comes from the backend
        weight         TYPE i,
        price          TYPE p LENGTH 9 DECIMALS 2,
        currency       TYPE string,
        width          TYPE i,
        depth          TYPE i,
        height         TYPE i,
        dim_unit       TYPE string,
        status         TYPE string,
        delivery       TYPE string,
        "! derived in products_prepare - the view only binds these
        weight_state   TYPE string,
        price_disp     TYPE string,
        dimensions     TYPE string,
        status_icon    TYPE string,
        status_state   TYPE string,
        delivery_state TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS products_prepare.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_453 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      t_products = VALUE #(
          ( name = `Comfort Easy` weight = 650 price = '249.99' currency = `EUR`
            width = 30 depth = 21 height = 3 dim_unit = `cm`
            status = `Available` delivery = `Shipped` )
          ( name = `Notebook Basic 15` weight = 1500 price = '956' currency = `EUR`
            width = 40 depth = 28 height = 0 dim_unit = `cm`
            status = `Out of Stock` delivery = `Failed Shipping` )
          ( name = `Ergo Screen E-I` weight = 2100 price = '230.5' currency = `EUR`
            width = 54 depth = 46 height = 8 dim_unit = `cm`
            status = `Discontinued` delivery = `Pending` ) ).
      products_prepare( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD products_prepare.

    " Everything the UI shows beyond the raw values is decided HERE, in ABAP.
    " The original UI5 demo kit samples do all of this in their frontend
    " Formatter.js - abap2UI5 is a thin frontend, so it moves server-side and
    " the view binds the finished field. Note what each of these actually is:
    " a threshold, a rounding rule, a string composition and two lookups from
    " a business status to a visual. None of them is a rendering detail the
    " browser knows better than the backend, so none of them belongs in the
    " curated formatter module (which is why the functions that used to do
    " them there were removed again).
    LOOP AT t_products REFERENCE INTO DATA(product).

      " classification by threshold - business logic, never a formatter
      product->weight_state = COND #( WHEN product->weight < 1000 THEN `Success`
                                      WHEN product->weight < 2000 THEN `Warning`
                                      ELSE `Error` ).

      " a packed field renders its declared decimals, so the display string
      " is simply its character form - no client-side rounding needed
      product->price_disp = |{ product->price }|.

      product->dimensions = |{ product->width } x { product->depth } x | &&
                            |{ product->height } { product->dim_unit }|.

      " which icon and which state stand for a business status is a backend
      " decision - the frontend must not carry the domain's vocabulary
      product->status_icon  = SWITCH #( product->status
                                        WHEN `Available`    THEN `sap-icon://accept`
                                        WHEN `Out of Stock` THEN `sap-icon://alert`
                                        WHEN `Discontinued` THEN `sap-icon://decline` ).
      product->status_state = SWITCH #( product->status
                                        WHEN `Available`    THEN `Success`
                                        WHEN `Out of Stock` THEN `Warning`
                                        WHEN `Discontinued` THEN `Error`
                                        ELSE `None` ).

      product->delivery_state = SWITCH #( product->delivery
                                          WHEN `Shipped`         THEN `Success`
                                          WHEN `Failed Shipping` THEN `Error`
                                          ELSE `None` ).
    ENDLOOP.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    " no core:require, no formatter, no client-side logic: every cell binds a
    " field the backend already finished
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Formatter - thin frontend`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Every column is bound to a plain model field. The state, the icon, the rounded ` &&
                   `price and the dimension string are computed in ABAP (products_prepare) - the ` &&
                   `frontend only renders. Sample 450 shows what does belong in a formatter: the ` &&
                   `date conversion the backend physically cannot do.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(tab) = page->table( id    = `productTable`
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
                    unit   = `g`
                    state  = `{WEIGHT_STATE}`
                )->object_number(
                    number = `{PRICE_DISP}`
                    unit   = `{CURRENCY}`
                )->text( `{DIMENSIONS}`
                )->object_status(
                    text  = `{STATUS}`
                    icon  = `{STATUS_ICON}`
                    state = `{STATUS_STATE}` )->get_parent(
                )->object_status(
                    text  = `{DELIVERY}`
                    state = `{DELIVERY_STATE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
