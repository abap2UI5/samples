" @keywords fixture popover_display start_timer
" @summary Fixture of check-api-keywords - the test passes the keywords itself.
CLASS zcl_fixture_api_keywords DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
    CONSTANTS:
      BEGIN OF cs_event,
        ping TYPE string VALUE `PING`,
      END OF cs_event.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_fixture_api_keywords IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    " prose is not code: client->nav_app_call( ) and z2ui5_if_client=>cs_event-set_focus
    client->popup_display( `<core:FragmentDefinition/>` ).
    client->follow_up_action( z2ui5_if_client=>cs_event-popup_close ).
    client->follow_up_action( val   = client->cs_event-start_timer
                              t_arg = VALUE #( ( `TICK` ) ( `1000` ) ) ).
    client->popover_display( xml = `<core:FragmentDefinition/>` by_id = `btn` ).
    client->message_box_display( `feedback channels are not held` ).
    client->popup_destroy( ).
    client->_event( cs_event-ping ).
    client->message_toast_display( `client->nest_view_display( ) in a literal is prose` ).
    client->follow_up_action( z2ui5_if_client=>cs_event-popup_close ).

  ENDMETHOD.

ENDCLASS.
