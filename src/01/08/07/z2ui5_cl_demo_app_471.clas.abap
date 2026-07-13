"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Panel/sample/sap.m.sample.PanelExpanded
"! Panels also have the possibility to expand/collapse their content (including the infoToolbar if
"! available). [since rel. 1.22]
CLASS z2ui5_cl_demo_app_471 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA expanded TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_471 IMPLEMENTATION.

  METHOD view_display.

    " placeholder text reused by all three panels of the original sample
    DATA(lorem) = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
      `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
      `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
      `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Panel - Expand / Collapse`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Panel/sample/sap.m.sample.PanelExpanded` ).

    page->panel(
        expandable = abap_true
        headertext = `Panel with a header text`
        width      = `auto`
        class      = `sapUiResponsiveMargin`
        )->text( lorem ).

    page->panel(
        expandable = abap_true
        width      = `auto`
        class      = `sapUiResponsiveMargin`
        )->header_toolbar(
            )->overflow_toolbar( style = `Clear`
                )->title( `Custom Toolbar with a header text`
                )->toolbar_spacer(
                )->button( icon = `sap-icon://settings`
                )->button( icon = `sap-icon://drop-down-list`
        )->get_parent( )->get_parent(
        )->text( lorem ).

    page->panel(
        id         = `expandablePanel`
        expandable = abap_true
        expanded   = client->_bind_edit( expanded )
        width      = `auto`
        class      = `sapUiResponsiveMargin`
        )->header_toolbar(
            )->overflow_toolbar(
                active = abap_true
                press  = client->_event( `TOOLBAR_PRESSED` )
                )->title( `Clickable Custom Toolbar with a header text`
                )->toolbar_spacer(
                )->button( icon = `sap-icon://settings`
                )->button( icon = `sap-icon://drop-down-list`
        )->get_parent( )->get_parent(
        )->text( lorem ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `TOOLBAR_PRESSED` ).

      expanded = xsdbool( expanded = abap_false ).

      client->view_model_update( ).

    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
