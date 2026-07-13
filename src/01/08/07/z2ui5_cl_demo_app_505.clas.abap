"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.Date/sample/sap.ui.core.sample.TypeDateAsString
"! This sample explains the formatting options of the Date type with the date being available as
"! string.
CLASS z2ui5_cl_demo_app_505 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA date TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_505 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      " current date in 'yyyy-MM-dd' format
      date = |{ sy-datum DATE = ISO }|.

      view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(date_path) = client->_bind_edit( val  = date
                                          path = abap_true ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Date Type - Source As String`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.Date/sample/sap.ui.core.sample.TypeDateAsString` ).

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
        title      = `Date Input`
        )->content( `form`
        )->label( `Date`
        )->date_picker( |\{ path: '{ date_path }', type: 'sap.ui.model.type.Date', formatOptions: \{ source: \{ pattern: 'yyyy-MM-dd' \} \} \}| ).

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
        title      = `Format Options`
        )->content( `form`
        )->label( `Short`
        )->text( |\{ path: '{ date_path }', type: 'sap.ui.model.type.Date', formatOptions: \{ style: 'short', source: \{ pattern: 'yyyy-MM-dd' \} \} \}|
        )->label( `Medium`
        )->text( |\{ path: '{ date_path }', type: 'sap.ui.model.type.Date', formatOptions: \{ style: 'medium', source: \{ pattern: 'yyyy-MM-dd' \} \} \}|
        )->label( `Long`
        )->text( |\{ path: '{ date_path }', type: 'sap.ui.model.type.Date', formatOptions: \{ style: 'long', source: \{ pattern: 'yyyy-MM-dd' \} \} \}|
        )->label( `Full`
        )->text( |\{ path: '{ date_path }', type: 'sap.ui.model.type.Date', formatOptions: \{ style: 'full', source: \{ pattern: 'yyyy-MM-dd' \} \} \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
