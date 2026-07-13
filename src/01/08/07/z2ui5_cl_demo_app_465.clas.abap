"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderResponsiveV
"! This is a responsive Object Header without a number and with a Title, 3 Statuses/Attributes.
CLASS z2ui5_cl_demo_app_465 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_465 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Object Header Responsive V`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderResponsiveV` ).

    " data of /ProductCollection/0 of the mock model sap/ui/demo/mock/products.json used by the original sample
    DATA(header) = page->object_header(
        responsive       = abap_true
        icon             = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`
        iconalt          = `Power Projector 4713`
        intro            = `A very powerful projector with special features for Internet usability, USB`
        title            = `Power Projector 4713`
        backgrounddesign = `Translucent`
        class            = `sapUiResponsivePadding--header` ).

    header->object_attribute(
        title = `Manufacturer`
        text  = `Titanium` ).

    header->object_attribute(
        title = `Dimension per unit`
        text  = `51 x 42 x 18 cm` ).

    header->markers(
        )->object_marker( type = `Favorite` )->get_parent(
        )->object_marker( type = `Flagged` ).

    header->_generic( `statuses`
        )->object_status(
            title = `Approval`
            text  = `Pending`
            state = `Warning` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
