" @keywords no formatter computed backend thin frontend prepare
" @summary The counter-example: no formatter at all. The value is computed in ABAP and bound ready-made, which keeps the frontend thin and the logic testable.
" @docs https://abap2ui5.github.io/docs/cookbook/model/formatter
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
    ELSEIF client->check_on_navigated( ).
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

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    " no core:require, no formatter, no client-side logic: every cell binds a
    " field the backend already finished
    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Formatter - When Not to Use One: Compute in ABAP`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Every column is bound to a plain model field. The state, the icon, the rounded ` &&
                   `price and the dimension string are computed in ABAP (products_prepare) - the ` &&
                   `frontend only renders. Sample 450 shows what does belong in a formatter: the ` &&
                   `date conversion the backend physically cannot do.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(tab) = page->ele( `Table`
        )->a( n = `items` v = client->_bind( t_products )
        )->a( n = `id`    v = `productTable` ).

    tab->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Product`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Weight (g)`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Price`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Dimensions`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Status`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Delivery`
        )->end( ).

    tab->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->tag( `Text`
                    )->a( n = `text` v = `{NAME}`
                )->tag( `ObjectNumber`
                    )->a( n = `number` v = `{WEIGHT}`
                    )->a( n = `state`  v = `{WEIGHT_STATE}`
                    )->a( n = `unit`   v = `g`
                )->tag( `ObjectNumber`
                    )->a( n = `number` v = `{PRICE_DISP}`
                    )->a( n = `unit`   v = `{CURRENCY}`
                )->tag( `Text`
                    )->a( n = `text` v = `{DIMENSIONS}`
                )->ele( `ObjectStatus`
                    )->a( n = `icon`  v = `{STATUS_ICON}`
                    )->a( n = `state` v = `{STATUS_STATE}`
                    )->a( n = `text`  v = `{STATUS}`
                )->end(
                )->ele( `ObjectStatus`
                    )->a( n = `state` v = `{DELIVERY_STATE}`
                    )->a( n = `text`  v = `{DELIVERY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
