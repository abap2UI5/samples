"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.theming/sample/sap.ui.core.sample.BasicThemeParameters
"! Sample provides a link to the Theme Parameter Toolbox. There you can easily search, preview, and
"! filter semantic theme parameters.
CLASS z2ui5_cl_demo_app_502 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_502 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
           )->page(
              title          = `abap2UI5 - Sample: Basic Theme Parameters`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      page->header_content(
         )->link(
             text   = `UI5 Demo Kit`
             target = `_blank`
             href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.theming/sample/sap.ui.core.sample.BasicThemeParameters` ).

      page->vertical_layout(
          class = `sapUiContentPadding`
          width = `100%`
          )->content( `layout`
              )->message_strip(
                  text     = `This sample is replaced with the Theme Parameter Toolbox. You can easily search, preview, and filter semantic theme parameters.`
                  type     = `Information`
                  showicon = abap_true
                  class    = `sapUiMediumMarginBottom`
              )->link(
                  text   = `Click here to open the Theme Parameter Toolbox`
                  target = `_blank`
                  href   = `https://sapui5.hana.ondemand.com/test-resources/sap/m/demokit/theming/webapp/index.html` ).

      client->view_display( page->stringify( ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
