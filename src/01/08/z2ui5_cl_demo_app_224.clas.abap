"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarNoIcons
"! In this example, the Icon Tab Bar tabs display text only.
CLASS z2ui5_cl_demo_app_224 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_224 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `Sample: Icon Tab Bar - Text Only`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarNoIcons` ).

    DATA(layout) = page->icon_tab_bar( id       = `idIconTabBarNoIcons`
                                       expanded = `{device>/isNoPhone}`
                                       class    = `sapUiResponsiveContentPadding`
                          )->items(
                              )->icon_tab_filter( text = `Info`
                                                  key  = `info`
                                                  )->text( `Info content goes here ...` )->get_parent(
                              )->icon_tab_filter( text = `Attachments`
                                                  key  = `attachments`
                                                  )->text( `Attachments go here ...` )->get_parent(
                              )->icon_tab_filter( text = `Notes`
                                                  key  = `notes`
                                                  )->text( `Notes go here ...` )->get_parent(
                              )->icon_tab_filter( text = `People`
                                                  key  = `people`
                                                  )->text( `People content goes here ...` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
