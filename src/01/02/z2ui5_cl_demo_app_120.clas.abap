CLASS z2ui5_cl_demo_app_120 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_spot,
        tooltip       TYPE string,
        type          TYPE string,
        pos           TYPE string,
        scale         TYPE string,
        contentoffset TYPE string,
        key           TYPE string,
        icon          TYPE string,
      END OF ty_s_spot.

    DATA longitude TYPE string.
    DATA latitude TYPE string.
    DATA altitude TYPE string.
    DATA speed TYPE string.
    DATA altitudeaccuracy TYPE string.
    DATA accuracy TYPE string.

    DATA mt_spot TYPE TABLE OF ty_s_spot.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_120 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).
      RETURN.
    ENDIF.

    CASE client->get( )-event.

      WHEN `GEOLOCATION_ERROR`.

        " the Geolocation control fires `error` when the position cannot be
        " read; the code (1 = permission denied, 2 = position unavailable,
        " 3 = timeout) and message are passed as event arguments.
        client->message_box_display(
            text = |Location unavailable ({ client->get_event_arg( 1 ) }): { client->get_event_arg( 2 ) }|
            type = `error` ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->shell(
          )->page(
                  title          = `abap2UI5 - Device Capabilities`
                  navbuttonpress = client->_event_nav_app_leave( )
                  shownavbutton  = client->check_app_prev_stack( )
              )->_z2ui5( )->geolocation(
                                        finished         = client->_event( `GEOLOCATION_LOADED` )
                                        error            = client->_event( val   = `GEOLOCATION_ERROR`
                                                                           t_arg = VALUE #( ( `${$parameters>/code}` )
                                                                                            ( `${$parameters>/message}` ) ) )
                                        longitude        = client->_bind_edit( longitude )
                                        latitude         = client->_bind_edit( latitude )
                                        altitude         = client->_bind_edit( altitude )
                                        altitudeaccuracy = client->_bind_edit( altitudeaccuracy )
                                        accuracy         = client->_bind_edit( accuracy )
                                        speed            = client->_bind_edit( speed )
              )->simple_form( title    = `Geolocation`
                              editable = abap_false
                  )->content( `form`
                      )->label( `Longitude`
                      )->input( value = client->_bind_edit( longitude ) editable = abap_false
                      )->label( `Latitude`
                      )->input( value = client->_bind_edit( latitude ) editable = abap_false
                      )->label( `Altitude`
                      )->input( value = client->_bind_edit( altitude ) editable = abap_false
                      )->label( `Accuracy`
                      )->input( value = client->_bind_edit( accuracy ) editable = abap_false
                      )->label( `AltitudeAccuracy`
                      )->input( value = client->_bind_edit( altitudeaccuracy ) editable = abap_false
                      )->label( `Speed`
                      )->input( value = client->_bind_edit( speed ) editable = abap_false ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
