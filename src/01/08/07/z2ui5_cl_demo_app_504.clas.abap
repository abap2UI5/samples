"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.Date/sample/sap.ui.core.sample.TypeDateAsDate
"! This sample explains the formatting options of the Date type with the date being available as date
"! object.
CLASS z2ui5_cl_demo_app_504 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA date TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_504 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      date = |{ sy-datum DATE = ISO }|.

      view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " The original binds a JavaScript Date object - here the date is transported as ISO string, therefore a source pattern is used
    DATA(date_path) = client->_bind_edit( val  = date
                                          path = abap_true ).
    DATA(binding) = |path: '{ date_path }', type: 'sap.ui.model.type.Date'|.
    DATA(source)  = `source: { pattern: 'yyyy-MM-dd' }`.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Date Type - Source As Date`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.model.type.Date/sample/sap.ui.core.sample.TypeDateAsDate` ).

    page->simple_form(
        title      = `Date Input`
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
        )->label( `Date`
        )->date_picker( |\{ { binding }, formatOptions: \{ { source } \} \}| ).

    page->simple_form(
        title      = `Format Options`
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
        )->label( `Short`
        )->text( |\{ { binding }, formatOptions: \{ { source }, style: 'short' \} \}|
        )->label( `Medium`
        )->text( |\{ { binding }, formatOptions: \{ { source }, style: 'medium' \} \}|
        )->label( `Long`
        )->text( |\{ { binding }, formatOptions: \{ { source }, style: 'long' \} \}|
        )->label( `Full`
        )->text( |\{ { binding }, formatOptions: \{ { source }, style: 'full' \} \}| ).

    page->simple_form(
        title      = `Relative Time Format`
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
        )->label( `Relative Time`
        )->text( |\{ { binding }, formatOptions: \{ { source }, relative: true, relativeScale: 'auto' \} \}| ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
