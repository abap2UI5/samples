"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabHeader/sample/sap.m.sample.IconTabHeader
"! Icon Tab Header used standalone, outside of Icon Tab Bar.
CLASS z2ui5_cl_demo_app_214 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_214 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Standalone Icon Tab Header`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabHeader/sample/sap.m.sample.IconTabHeader` ).

    DATA(layout) = page->icon_tab_header( mode = `Inline`
                          )->items(
                              )->icon_tab_filter( key  = `info`
                                                  text = `Info` )->get_parent(
                              )->icon_tab_filter( key   = `attachments`
                                                  text  = `Attachments`
                                                  count = `3` )->get_parent(
                              )->icon_tab_filter( key   = `notes`
                                                  text  = `Notes`
                                                  count = `12` )->get_parent(
                              )->icon_tab_filter( key  = `people`
                                                  text = `People` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
