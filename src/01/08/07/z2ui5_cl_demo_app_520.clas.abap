"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.VerticalLayout/sample/sap.ui.layout.sample.VerticalLayout
"! The Vertical Layout control is a simple way to align multiple controls vertically. If you want more
"! sophisticated layout options, consider Grid or Flex Box based layouts.
CLASS z2ui5_cl_demo_app_520 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_520 IMPLEMENTATION.

  METHOD view_display.

    " the original binds the images against the demo kit mock model - here the mock image URL is used directly
    DATA(image_url) = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Vertical Layout`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.VerticalLayout/sample/sap.ui.layout.sample.VerticalLayout` ).

    " the original sets the image widths depending on the device type - here the desktop widths are used
    page->vertical_layout( class = `sapUiContentPadding`
        )->image(
            src          = image_url
            densityaware = abap_true
            width        = `5em`
        )->image(
            src          = image_url
            densityaware = abap_true
            width        = `10em`
        )->image(
            src          = image_url
            densityaware = abap_true
            width        = `15em` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
