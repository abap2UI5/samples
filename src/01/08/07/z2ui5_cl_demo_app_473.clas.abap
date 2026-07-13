"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ScrollContainer/sample/sap.m.sample.ScrollContainer
"! The Scroll Container is a control that can display arbitrary content within a limited screen area
"! and provides touch scrolling to make all content accessible.
CLASS z2ui5_cl_demo_app_473 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA width TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_473 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      " original uses 50em on phone devices (sap/ui/Device is not available server-side)
      width = `100em`.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
          )->page(
              title          = `abap2UI5 - Sample: Scroll Container`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      page->header_content(
          )->link(
              text   = `UI5 Demo Kit`
              target = `_blank`
              href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ScrollContainer/sample/sap.m.sample.ScrollContainer` ).

      page->scroll_container(
          height    = `100%`
          width     = `100%`
          vertical  = abap_true
          focusable = abap_true
          )->image(
              src   = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`
              width = client->_bind( width ) ).

      client->view_display( view->stringify( ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
