CLASS z2ui5_cl_demo_app_221 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .
  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_221 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Icon Tab Bar - Icons Only'
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(layout) = page->icon_tab_bar( id       = `idIconTabBarMulti`
                                       expanded = `{device>/isNoPhone}`
                                       class    = `sapUiResponsiveContentPadding`
                          )->items(
                              )->icon_tab_filter( icon = `sap-icon://hint`
                                                  key  = `info`
                                                  )->text( `Info content goes here ...` )->get_parent(
                              )->icon_tab_filter( icon  = `sap-icon://attachment`
                                                  key   = `attachments`
                                                  count = `3`
                                                  )->text( `Attachments go here ...` )->get_parent(
                              )->icon_tab_filter( icon  = `sap-icon://notes`
                                                  key   = `notes`
                                                  count = `12`
                                                  )->text( `Notes go here ...` )->get_parent(
                              )->icon_tab_filter( icon = `sap-icon://group`
                                                  key  = `people`
                                                  )->text( `People content goes here ...` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
