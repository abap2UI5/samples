"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Page/sample/sap.m.sample.PageStandardClasses
"! This page implements the same sample as in 'Fiori Sample Page - sapUiFioriObjectPage' using
"! standard margin classes. In contrast to using 'sapUiFioriObjectPage', the margins used for form,
"! list, table and panel are responsive: they adapt to the available screen width. For more
"! information, please search for 'Standard Margins' and take a look at our samples.
CLASS z2ui5_cl_demo_app_470 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_470 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Fiori Object Page - Standard Classes`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Page/sample/sap.m.sample.PageStandardClasses` ).

    " the CSS class sapUiResponsivePadding--header adds a standard spacing to all the page content
    DATA(sample_page) = page->page(
        id    = `idPage`
        title = ` Product XY`
        class = `sapUiResponsivePadding--header` ).

    " data of /ProductCollection/0 of the mock model sap/ui/demo/mock/products.json used by the original sample
    DATA(header) = sample_page->object_header(
        title            = `Power Projector 4713`
        backgrounddesign = `Solid`
        number           = `856.49`
        numberunit       = `EUR` ).

    header->object_attribute(
        title = `Weight`
        text  = `1467 g` ).

    header->object_attribute(
        title = `Dimensions`
        text  = `51 x 42 X 18 cm` ).

    header->_generic( `statuses`
        )->object_status(
            title = `Status`
            text  = `In Stock`
            state = `Success` ).

    DATA(items) = sample_page->icon_tab_bar(
        expanded = `{device>/isNoPhone}`
        class    = `sapUiSmallMarginBottom sapUiResponsiveContentPadding`
        )->items( ).

    items->icon_tab_filter(
        key  = `info`
        text = `Info`
        )->simple_form(
            title  = `A Form`
            layout = `ResponsiveGridLayout`
            )->content( `form`
            )->label( `Label`
            )->text( `Value` ).

    items->icon_tab_filter(
        key  = `attachments`
        text = `Attachments`
        )->list(
            headertext     = `A List`
            showseparators = `Inner` ).

    items->icon_tab_filter(
        key  = `notes`
        text = `Notes`
        )->feed_input( ).

    sample_page->simple_form(
        title  = `A Form`
        layout = `ResponsiveGridLayout`
        class  = `sapUiForceWidthAuto sapUiResponsiveMargin`
        )->content( `form`
        )->label( `Label`
        )->text( `Value` ).

    " the width property of sap.m.List is set via a generic property - not part of the typed list method
    sample_page->list(
        headertext       = `A List`
        backgrounddesign = `Translucent`
        class            = `sapUiResponsiveMargin`
        )->_generic_property( VALUE #( n = `width` v = `auto` ) ).

    sample_page->table(
        headertext = `A Table`
        width      = `auto`
        class      = `sapUiResponsiveMargin` ).

    sample_page->panel(
        headertext = `A Panel`
        width      = `auto`
        class      = `sapUiResponsiveMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
