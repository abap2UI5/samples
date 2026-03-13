CLASS z2ui5_cl_demo_app_223 DEFINITION
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



CLASS z2ui5_cl_demo_app_223 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Icon Tab Bar - Inline Mode'
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(layout) = page->icon_tab_bar( id         = `idIconTabBarInlineMode`
                                       headermode = `Inline`
                                       expanded   = `{device>/isNoPhone}`
                                       class      = `sapUiResponsiveContentPadding`
                          )->items(
                              )->icon_tab_filter( text  = `Info`
                                                  key   = `info`
                                                  count = `3`
                                                  )->text( `Info content goes here ...` )->get_parent(
                              )->icon_tab_filter( text  = `Attachments`
                                                  key   = `attachments`
                                                  count = `4321`
                                                  )->text( `Attachments go here ...` )->get_parent(
                              )->icon_tab_filter( text  = `Notes`
                                                  key   = `notes`
                                                  count = `333`
                                                  )->text( `Notes go here ...` )->get_parent(
                              )->icon_tab_filter( text  = `People`
                                                  key   = `people`
                                                  count = `34`
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
