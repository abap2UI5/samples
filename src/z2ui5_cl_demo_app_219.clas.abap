CLASS z2ui5_cl_demo_app_219 DEFINITION
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



CLASS z2ui5_cl_demo_app_219 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Input List Item'
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(layout) = page->list( headertext = `Input`
                           )->input_list_item( `WLAN`
                               )->switch( state = `true` )->get_parent(
                           )->input_list_item( `Flight Mode`
                               )->checkbox( `true` )->get_parent(
                           )->input_list_item( `High Performance`
                               )->radio_button( groupname = `GroupInputListItem`
                                                selected  = abap_true )->get_parent( )->get_parent(
                           )->input_list_item( `Battery Saving`
                               )->radio_button( groupname = `GroupInputListItem` )->get_parent( )->get_parent(
                           )->input_list_item( `Price (EUR)`
                               )->input( placeholder = `Price`
                                         value       = `799`
                                         type        = `Number` )->get_parent(
                           )->input_list_item( `Address`
                               )->input( placeholder = `Address`
                                         value       = `Main Rd, Manchester` )->get_parent(
                           )->input_list_item( `Country`
                               )->select(
                                   )->item( key  = `GR`
                                            text = `Greece`
                                   )->item( key  = `MX`
                                            text = `Mexico`
                                   )->item( key  = `NO`
                                            text = `Norway`
                                   )->item( key  = `NX`
                                            text = `New Zealand`
                                   )->item( key  = `NL`
                                            text = `Netherlands` )->get_parent( )->get_parent(
                           )->input_list_item( `Volume`
                               )->slider( min   = `0`
                                          max   = `10`
                                          value = `7`
                                          width = `200px` ).

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
