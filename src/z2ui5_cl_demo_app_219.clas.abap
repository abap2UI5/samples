class Z2UI5_CL_DEMO_APP_219 definition
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



CLASS Z2UI5_CL_DEMO_APP_219 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Input List Item'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(layout) = page->list( headertext  = `Input`
                           )->input_list_item( label = `WLAN`
                               )->switch( state = `true` )->get_parent(
                           )->input_list_item( label = `Flight Mode`
                               )->checkbox( selected = `true` )->get_parent(
                           )->input_list_item( label = `High Performance`
                               )->radio_button( groupname = `GroupInputListItem`
                                                selected = abap_true )->get_parent( )->get_parent(
                           )->input_list_item( label = `Battery Saving`
                               )->radio_button( groupname = `GroupInputListItem` )->get_parent( )->get_parent(
                           )->input_list_item( label = `Price (EUR)`
                               )->input( placeholder = `Price`
                                         value = `799`
                                         type = `Number` )->get_parent(
                           )->input_list_item( label = `Address`
                               )->input( placeholder = `Address`
                                         value = `Main Rd, Manchester` )->get_parent(
                           )->input_list_item( label = `Country`
                               )->select(
                                   )->item( key = `GR` text = `Greece`
                                   )->item( key = `MX` text = `Mexico`
                                   )->item( key = `NO` text = `Norway`
                                   )->item( key = `NX` text = `New Zealand`
                                   )->item( key = `NL` text = `Netherlands`  )->get_parent( )->get_parent(
                           )->input_list_item( label = `Volume`
                               )->slider( min = `0` max = `10` value = `7` width = `200px`
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
