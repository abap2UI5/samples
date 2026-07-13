"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.FixFlex/sample/sap.ui.layout.sample.FixFlexHorizontal
"! Shows a FixFlex control with a horizontal layout.
CLASS z2ui5_cl_demo_app_514 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_514 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Fix Flex - Horizontal Direction`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.FixFlex/sample/sap.ui.layout.sample.FixFlexHorizontal` ).

    " the original adds background colors for the fix and flex parts via custom CSS - omitted here
    DATA(layout) = page->fix_flex(
        ns    = `layout`
        class = `fixFlexHorizontal` ).
    " the wrapper fix_flex method does not support the vertical property - generic property used
    layout->_generic_property( VALUE #( n = `vertical` v = `false` ) ).

    " the original binds the image against the demo kit mock model - here the mock image URL is used directly
    layout->fix_content( `layout`
        )->image(
            src          = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`
            densityaware = abap_true )->get_parent(
    )->flex_content( `layout`
        )->text(
            class = `column1`
            text  = `This container is flexible and it will adapts its size to fill the remaining size in the FixFlex control` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
