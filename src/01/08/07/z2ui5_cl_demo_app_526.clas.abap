"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Currency/sample/sap.ui.unified.sample.Currency
"! Display Currencies with proper Alignment
CLASS z2ui5_cl_demo_app_526 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_price,
        currency TYPE string,
        price    TYPE decfloat34,
      END OF ty_s_price.
    TYPES ty_t_prices TYPE STANDARD TABLE OF ty_s_price WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_price_string,
        currency TYPE string,
        price    TYPE string,
      END OF ty_s_price_string.
    TYPES ty_t_prices_string TYPE STANDARD TABLE OF ty_s_price_string WITH EMPTY KEY.
    DATA t_various_numbers TYPE ty_t_prices.
    DATA t_non_decimal TYPE ty_t_prices.
    DATA t_big_numbers TYPE ty_t_prices_string.
    DATA t_custom_currencies TYPE ty_t_prices_string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_526 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_various_numbers = VALUE #(
      ( currency = `EUR` price = `2300.12` )
      ( currency = `EUR` price = `38` )
      ( currency = `JPY` price = `1928472` )
      ( currency = `JPY` price = `233.9385763` )
      ( currency = `USD` price = `125.02` )
      ( currency = `USD` price = `2125.02843` )
      ( currency = `TND` price = `9283` )
      ( currency = `TND` price = `235.0298` ) ).
    t_non_decimal = VALUE #(
      ( currency = `JPY` price = `2300.12` )
      ( currency = `JPY` price = `38` )
      ( currency = `JPY` price = `1928472` )
      ( currency = `JPY` price = `233` ) ).
    t_big_numbers = VALUE #(
      ( currency = `USD` price = `12345678901234567890123` )
      ( currency = `USD` price = `123456789012345678901.23` ) ).
    t_custom_currencies = VALUE #(
      ( currency = `BGN4` price = `123.4567` )
      ( currency = `WWWW` price = `123.45676` ) ).

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
            title          = `abap2UI5 - Sample: Currency`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.unified.Currency/sample/sap.ui.unified.sample.Currency` ).

    DATA(layout_grid) = page->grid( `XL7 L12 M12 S12` ).

    layout_grid->list(
        id         = `listOneId`
        headertext = `Various currencies with and without decimals`
        items      = client->_bind( t_various_numbers )
        )->custom_list_item(
        )->currency(
            value     = `{PRICE}`
            currency  = `{CURRENCY}`
            usesymbol = abap_false ).

    layout_grid->list(
        id         = `listTwoId`
        headertext = `Currency without decimals`
        items      = client->_bind( t_non_decimal )
        )->custom_list_item(
        )->currency(
            value     = `{PRICE}`
            currency  = `{CURRENCY}`
            usesymbol = abap_false ).

    layout_grid->list(
        id         = `listThreeId`
        headertext = `Currency without decimals using maxPrecision`
        items      = client->_bind( t_non_decimal )
        )->custom_list_item(
        )->currency(
            value        = `{PRICE}`
            currency     = `{CURRENCY}`
            usesymbol    = abap_false
            maxprecision = `0` ).

    layout_grid->list(
        id         = `listFourId`
        headertext = `Currency with really big numbers`
        items      = client->_bind( t_big_numbers )
        )->custom_list_item(
        )->currency(
            stringvalue = `{PRICE}`
            currency    = `{CURRENCY}`
            usesymbol   = abap_false ).

    " The custom currency configuration (BGN4 with 4 and WWWW with 5 digits) of the original sample is client-side javascript and not ported
    layout_grid->list(
        id         = `listFiveId`
        headertext = `Custom currencies with decimals`
        items      = client->_bind( t_custom_currencies )
        )->custom_list_item(
        )->currency(
            stringvalue = `{PRICE}`
            currency    = `{CURRENCY}`
            usesymbol   = abap_false ).

    layout_grid->list(
        id         = `listSixId`
        headertext = `Different currencies with maxPrecision 3`
        items      = client->_bind( t_various_numbers )
        )->custom_list_item(
        )->currency(
            stringvalue  = `{PRICE}`
            currency     = `{CURRENCY}`
            usesymbol    = abap_false
            maxprecision = `3` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
