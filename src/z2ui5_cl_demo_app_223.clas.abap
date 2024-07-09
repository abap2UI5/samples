class z2ui5_cl_demo_app_223 definition
  public
  create public .

public section.

  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
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


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Icon Tab Bar - Inline Mode'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(layout) = page->icon_tab_bar( id  = `idIconTabBarInlineMode`
                                       headermode = `Inline`
                                       expanded = `{device>/isNoPhone}`
                                       class = `sapUiResponsiveContentPadding`
                          )->items(
                              )->icon_tab_filter( text = `Info`
                                                  key = `info`
                                                  count = `3`
                                                  )->text( text = `Info content goes here ...` )->get_parent(
                              )->icon_tab_filter( text = `Attachments`
                                                  key = `attachments`
                                                  count = `4321`
                                                  )->text( text = `Attachments go here ...` )->get_parent(
                              )->icon_tab_filter( text = `Notes`
                                                  key = `notes`
                                                  count = `333`
                                                  )->text( text = `Notes go here ...` )->get_parent(
                              )->icon_tab_filter( text = `People`
                                                  key = `people`
                                                  count = `34`
                                                  )->text( text = `People content goes here ...`
                   ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD ON_EVENT.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
