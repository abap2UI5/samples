CLASS z2ui5_cl_demo_app_221 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    INTERFACES z2ui5_if_app.

    DATA check_initialized TYPE abap_bool.

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
         )->page( title          = 'abap2UI5 - Sample: Icon Tab Bar - Icons Only'
                  navbuttonpress = client->_event( 'BACK' )
                  shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(layout) = page->icon_tab_bar( id       = `idIconTabBarMulti`
                                       expanded = `{device>/isNoPhone}`
                                       class    = `sapUiResponsiveContentPadding`
                          )->items(
                              )->icon_tab_filter( icon = `sap-icon://hint`
                                                  key  = `info`
                                                  )->text( text = `Info content goes here ...` )->get_parent(
                              )->icon_tab_filter( icon  = `sap-icon://attachment`
                                                  key   = `attachments`
                                                  count = `3`
                                                  )->text( text = `Attachments go here ...` )->get_parent(
                              )->icon_tab_filter( icon  = `sap-icon://notes`
                                                  key   = `notes`
                                                  count = `12`
                                                  )->text( text = `Notes go here ...` )->get_parent(
                              )->icon_tab_filter( icon = `sap-icon://group`
                                                  key  = `people`
                                                  )->text( text = `People content goes here ...`
                   ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
