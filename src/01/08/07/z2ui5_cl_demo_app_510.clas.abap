"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.integration.widgets.Card/sample/sap.ui.integration.sample.CardExplorer
"! Card Explorer is the application where you can learn more about integration cards.
CLASS z2ui5_cl_demo_app_510 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_510 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the original opens the relative Card Explorer url of the demo kit - here the absolute url is used
    DATA(card_explorer_url) = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/integration/demokit/cardExplorer/index.html`.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
            title          = `abap2UI5 - Sample: Card Explorer`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.integration.widgets.Card/sample/sap.ui.integration.sample.CardExplorer` ).

    " the original redirects via sap.m.URLHelper in the controller - here a client event opens the url in a new tab
    page->vbox( `sapUiContentPadding`
        )->link(
            text       = `Visit the Card Explorer`
            href       = card_explorer_url
            emphasized = abap_true
            class      = `sapUiSmallMargin`
            target     = `_blank`
        )->image(
            src   = `https://sapui5.hana.ondemand.com/resources/sap/ui/documentation/sdk/images/tools/CardExplorer.png`
            alt   = `Card Explorer`
            class = `sapUiSmallMargin`
            press = client->_event_client( val   = client->cs_event-open_new_tab
                                           t_arg = VALUE #( ( card_explorer_url ) ) ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
