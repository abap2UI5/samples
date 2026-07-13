"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.ShellBar/sample/sap.f.sample.ShellBar
"! Shell Bar example showing the control title as part of a mega menu, configurable by the app
"! developer.
CLASS z2ui5_cl_demo_app_419 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_419 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Shell Bar with title mega menu`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.ShellBar/sample/sap.f.sample.ShellBar` ).

    " profile avatar of the original sample is omitted here - sap.m.Avatar is available only since UI5 1.73 and sap.f.Avatar is deprecated
    page->shell_bar(
        title               = `Application Title`
        secondtitle         = `Short description`
        homeicon            = `https://sapui5.hana.ondemand.com/sdk/resources/sap/ui/documentation/sdk/images/logo_sap.png`
        showcopilot         = abap_true
        showsearch          = abap_true
        shownotifications   = abap_true
        notificationsnumber = `2`
        )->_generic( name = `menu`
                     ns   = `f`
            )->_generic( `Menu`
                )->menu_item(
                    text = `Flight booking`
                    icon = `sap-icon://flight`
                )->menu_item(
                    text = `Car rental`
                    icon = `sap-icon://car-rental` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
