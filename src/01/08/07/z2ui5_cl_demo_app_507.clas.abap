"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.Float/sample/sap.ui.core.sample.TypeFloat
"! Formats and parses both integer and decimal digits.
CLASS z2ui5_cl_demo_app_507 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA number TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_507 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      number = `123.456`.

      view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(number_path) = client->_bind_edit( val  = number
                                            path = abap_true ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Float Format`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.Float/sample/sap.ui.core.sample.TypeFloat` ).

    page->simple_form(
        width      = `auto`
        class      = `sapUiResponsiveMargin`
        layout     = `ResponsiveGridLayout`
        editable   = abap_true
        labelspanl = `3`
        labelspanm = `3`
        emptyspanl = `4`
        emptyspanm = `4`
        columnsl   = `1`
        columnsm   = `1`
        title      = `Number Input`
        )->content( `form`
        )->label( `Number`
        )->input( |\{ path: '{ number_path }', type: 'sap.ui.model.type.Float' \}| ).

    page->simple_form(
        width      = `auto`
        class      = `sapUiResponsiveMargin`
        layout     = `ResponsiveGridLayout`
        labelspanl = `3`
        labelspanm = `3`
        emptyspanl = `4`
        emptyspanm = `4`
        columnsl   = `1`
        columnsm   = `1`
        title      = `Minimal Number of Non-Fraction Digits (minIntegerDigits)`
        )->content( `form`
        )->label( `3 digits`
        )->text( |\{ path: '{ number_path }', type: 'sap.ui.model.type.Float', formatOptions: \{ minIntegerDigits: 3 \} \}|
        )->label( `5 digits`
        )->text( |\{ path: '{ number_path }', type: 'sap.ui.model.type.Float', formatOptions: \{ minIntegerDigits: 5 \} \}| ).

    page->simple_form(
        width      = `auto`
        class      = `sapUiResponsiveMargin`
        layout     = `ResponsiveGridLayout`
        labelspanl = `3`
        labelspanm = `3`
        emptyspanl = `4`
        emptyspanm = `4`
        columnsl   = `1`
        columnsm   = `1`
        title      = `Maximal Number of Non-Fraction Digits (maxIntegerDigits)`
        )->content( `form`
        )->label( `2 digits`
        )->text( |\{ path: '{ number_path }', type: 'sap.ui.model.type.Float', formatOptions: \{ maxIntegerDigits: 2 \} \}|
        )->label( `5 digits`
        )->text( |\{ path: '{ number_path }', type: 'sap.ui.model.type.Float', formatOptions: \{ maxIntegerDigits: 5 \} \}| ).

    page->simple_form(
        width      = `auto`
        class      = `sapUiResponsiveMargin`
        layout     = `ResponsiveGridLayout`
        labelspanl = `3`
        labelspanm = `3`
        emptyspanl = `4`
        emptyspanm = `4`
        columnsl   = `1`
        columnsm   = `1`
        title      = `Minimal Number of Fraction Digits (minFractionDigits)`
        )->content( `form`
        )->label( `2 digits`
        )->text( |\{ path: '{ number_path }', type: 'sap.ui.model.type.Float', formatOptions: \{ minFractionDigits: 2 \} \}|
        )->label( `5 digits`
        )->text( |\{ path: '{ number_path }', type: 'sap.ui.model.type.Float', formatOptions: \{ minFractionDigits: 5 \} \}| ).

    " the preserveDecimals format option was introduced after UI5 1.71 - the preserveDecimals rows of the original are omitted
    page->simple_form(
        width      = `auto`
        class      = `sapUiResponsiveMargin`
        layout     = `ResponsiveGridLayout`
        labelspanl = `3`
        labelspanm = `3`
        emptyspanl = `4`
        emptyspanm = `4`
        columnsl   = `1`
        columnsm   = `1`
        title      = `Maximal Number of Fraction Digits (maxFractionDigits)`
        )->content( `form`
        )->label( `2 digits`
        )->text( |\{ path: '{ number_path }', type: 'sap.ui.model.type.Float', formatOptions: \{ maxFractionDigits: 2 \} \}|
        )->label( `5 digits`
        )->text( |\{ path: '{ number_path }', type: 'sap.ui.model.type.Float', formatOptions: \{ maxFractionDigits: 5 \} \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
