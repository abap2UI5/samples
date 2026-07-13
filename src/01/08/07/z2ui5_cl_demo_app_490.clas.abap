"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.ContainerPadding/sample/sap.m.sample.ContainerResponsivePadding
"! Apply the CSS class 'sapUiResponsiveContentPadding' on a UI5 container control to add a responsive
"! padding based on the screen size around the container content area.
CLASS z2ui5_cl_demo_app_490 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_490 IMPLEMENTATION.

  METHOD view_display.

    DATA(strip_text) = `A panel by default has a fixed content padding of 1rem (16px). ` &&
      `By by setting the CSS class 'sapUiResponsiveContentPadding' to the container control ` &&
      `you will get a responsive padding based on the current screen size and the app mode around ` &&
      `the content area. On phone devices and small screens no padding is applied, on tablet devices ` &&
      `and inside a SplitApp control a medium padding is applied, and on desktop and fullscreen ` &&
      `applications a large padding is applied. Try the fullscreen mode of the Explored ` &&
      `app to see the difference`.

    DATA(lorem) = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
      `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
      `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
      `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Responsive Container Content Padding`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.ContainerPadding/sample/sap.m.sample.ContainerResponsivePadding` ).

    page->message_strip(
        text  = strip_text
        class = `sapUiTinyMargin` ).

    DATA(panel) = page->panel( class = `sapUiResponsiveContentPadding` ).

    panel->header_toolbar(
        )->toolbar( height = `3rem`
            )->text(
                text  = `Header`
                class = `sapMH4FontSize`
            )->toolbar_spacer(
            )->button( icon = `sap-icon://settings`
            )->button( icon = `sap-icon://drop-down-list` ).

    " the original binds the image against the demo kit mock model - here the mock image URL is used directly
    panel->content(
        )->horizontal_layout(
            )->image(
                width        = `10em`
                densityaware = abap_false
                src          = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg` )->get_parent(
        )->text( lorem ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
