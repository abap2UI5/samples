"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.Currency/sample/sap.ui.core.sample.TypeCurrency
"! Formats the number by using the parameters defined for the given currency code. Either currency
"! symbol, currency code or none of them can be included in the final formatted string. It parses the
"! given string into an array which contains both the currency number and currency code.
CLASS z2ui5_cl_demo_app_503 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA amount TYPE p LENGTH 14 DECIMALS 3.
    DATA currency TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_503 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      amount   = `123456789.123`.
      currency = `USD`.

      view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(amount_path)   = client->_bind_edit( val  = amount
                                              path = abap_true ).
    DATA(currency_path) = client->_bind_edit( val  = currency
                                              path = abap_true ).
    DATA(parts) = |parts: [ '{ amount_path }', '{ currency_path }' ], type: 'sap.ui.model.type.Currency'|.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Currency Format`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.Currency/sample/sap.ui.core.sample.TypeCurrency` ).

    page->simple_form(
        title      = `Input`
        editable   = abap_true
        width      = `auto`
        class      = `sapUiResponsiveMargin`
        layout     = `ResponsiveGridLayout`
        labelspanl = `3`
        labelspanm = `3`
        emptyspanl = `4`
        emptyspanm = `4`
        columnsl   = `1`
        columnsm   = `1`
        )->content( `form`
        )->label( `One field`
        )->input( |\{ { parts } \}|
        )->label( `Two field`
        )->input( |\{ { parts }, formatOptions: \{ showMeasure: false \} \}|
        )->input( |\{ { parts }, formatOptions: \{ showNumber: false \} \}| ).

    " The row for the preserveDecimals format option is omitted - the option was introduced after UI5 1.71
    page->simple_form(
        title      = `Format options`
        width      = `auto`
        class      = `sapUiResponsiveMargin`
        layout     = `ResponsiveGridLayout`
        labelspanl = `3`
        labelspanm = `3`
        emptyspanl = `4`
        emptyspanm = `4`
        columnsl   = `1`
        columnsm   = `1`
        )->content( `form`
        )->label( `Default`
        )->text( |\{ { parts } \}|
        )->label( `currencyCode:false`
        )->text( |\{ { parts }, formatOptions: \{ currencyCode: false \} \}|
        )->label( `style:'short'`
        )->text( |\{ { parts }, formatOptions: \{ style: 'short' \} \}|
        )->label( `style:'long'`
        )->text( |\{ { parts }, formatOptions: \{ style: 'long' \} \}| ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
