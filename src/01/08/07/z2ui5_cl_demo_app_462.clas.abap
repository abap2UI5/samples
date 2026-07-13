"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderImage
"! An Object Header will also make space for an image if one is specified, via a URL for the 'icon'
"! property. Note: This example shows the image inside ObjectHeader with the responsive property set
"! to false. On phone in portrait mode, the image remains visible.
CLASS z2ui5_cl_demo_app_462 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_462 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Object Header - with Image`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderImage` ).

    DATA(header) = page->object_header(
        icon             = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`
        icondensityaware = abap_false
        iconalt          = `Notebook Professional 15`
        title            = `Notebook Professional 15`
        number           = `1,999.00`
        numberunit       = `EUR`
        class            = `sapUiResponsivePadding--header` ).

    header->_generic( `statuses`
        )->object_status(
            text  = `In Stock`
            state = `Success` ).

    header->object_attribute( text = `4.3 KG`
        )->object_attribute( text = `33 x 20 x 3 cm`
        )->object_attribute( text = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
