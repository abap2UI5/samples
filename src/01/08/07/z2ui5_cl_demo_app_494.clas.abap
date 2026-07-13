"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsResponsive
"! Clear the space around your control, where the margin depends on the device your are using.
CLASS z2ui5_cl_demo_app_494 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_494 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Responsive Margins`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsResponsive` ).

    page->panel(
        width = `auto`
        class = `sapUiResponsiveMargin`
        )->content(
            )->text( `All panels on this page use css class 'sapUiResponsiveMargin' to clear space all around, depending on the available width.` ).

    page->panel(
        width = `auto`
        class = `sapUiResponsiveMargin`
        )->content(
            )->text( `Please resize the browser window and/or use the 'Full Screen' button to see how the margins change.` ).

    page->panel(
        width = `auto`
        class = `sapUiResponsiveMargin`
        )->content(
            )->text( `Since panels have a default width of 100%, horizontal margins are not displayed appropriately.` ).

    page->panel(
        width = `auto`
        class = `sapUiResponsiveMargin`
        )->content(
            )->text( `Therefore we need to set each panel's 'width' property to 'auto'.` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
