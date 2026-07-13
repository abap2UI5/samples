"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.FileSize/sample/sap.ui.core.sample.TypeFileSize
"! This sample explains the formatting options of the FileSize type.
CLASS z2ui5_cl_demo_app_506 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA file_size TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_506 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      file_size = `100`.

      view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(size_path) = client->_bind_edit( val  = file_size
                                          path = abap_true ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: FileSize Type`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.FileSize/sample/sap.ui.core.sample.TypeFileSize` ).

    page->simple_form(
        class      = `sapUiResponsiveMargin`
        layout     = `ResponsiveGridLayout`
        editable   = abap_true
        labelspanl = `3`
        labelspanm = `3`
        emptyspanl = `4`
        emptyspanm = `4`
        columnsl   = `1`
        columnsm   = `1`
        title      = `FileSize Input`
        )->content( `form`
        )->label( `FileSize`
        )->input( |\{ path: '{ size_path }', type: 'sap.ui.model.type.FileSize' \}| ).

    page->simple_form(
        class      = `sapUiResponsiveMargin`
        layout     = `ResponsiveGridLayout`
        labelspanl = `3`
        labelspanm = `3`
        emptyspanl = `4`
        emptyspanm = `4`
        columnsl   = `1`
        columnsm   = `1`
        title      = `Min Integer Digits (minimal number of non-fraction digits)`
        )->content( `form`
        )->label( `3 digits`
        )->text( |\{ path: '{ size_path }', type: 'sap.ui.model.type.FileSize', formatOptions: \{ minIntegerDigits: 3 \} \}|
        )->label( `5 digits`
        )->text( |\{ path: '{ size_path }', type: 'sap.ui.model.type.FileSize', formatOptions: \{ minIntegerDigits: 5 \} \}| ).

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
        title      = `Max Integer Digits (maximal number of non-fraction digits)`
        )->content( `form`
        )->label( `2 digits`
        )->text( |\{ path: '{ size_path }', type: 'sap.ui.model.type.FileSize', formatOptions: \{ maxIntegerDigits: 2 \} \}|
        )->label( `5 digits`
        )->text( |\{ path: '{ size_path }', type: 'sap.ui.model.type.FileSize', formatOptions: \{ maxIntegerDigits: 5 \} \}| ).

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
        title      = `Min Fraction Digits (minimal number of fraction digits)`
        )->content( `form`
        )->label( `2 digits`
        )->text( |\{ path: '{ size_path }', type: 'sap.ui.model.type.FileSize', formatOptions: \{ minFractionDigits: 2 \} \}|
        )->label( `5 digits`
        )->text( |\{ path: '{ size_path }', type: 'sap.ui.model.type.FileSize', formatOptions: \{ minFractionDigits: 5 \} \}| ).

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
        title      = `Max Fraction Digits (maximal number of fraction digits)`
        )->content( `form`
        )->label( `2 digits`
        )->text( |\{ path: '{ size_path }', type: 'sap.ui.model.type.FileSize', formatOptions: \{ maxFractionDigits: 2 \} \}|
        )->label( `5 digits`
        )->text( |\{ path: '{ size_path }', type: 'sap.ui.model.type.FileSize', formatOptions: \{ maxFractionDigits: 5 \} \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
