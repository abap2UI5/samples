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

    DATA(page) = view->shell(
          )->page(
                  title          = `abap2UI5 - Geolocation`
                  navbuttonpress = client->_event_nav_app_leave( )
                  shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `The geolocation custom control reads the device position from the browser and binds ` &&
                   `longitude, latitude, altitude, accuracy and speed into the read-only form below.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->_z2ui5( )->geolocation(
                                        finished         = client->_event( `GEOLOCATION_LOADED` )
                                        error            = client->_event( val   = `GEOLOCATION_ERROR`
                                                                           t_arg = VALUE #( ( `${$parameters>/code}` )
                                                                                            ( `${$parameters>/message}` ) ) )
                                        longitude        = client->_bind( longitude )
                                        latitude         = client->_bind( latitude )
                                        altitude         = client->_bind( altitude )
                                        altitudeaccuracy = client->_bind( altitudeaccuracy )
                                        accuracy         = client->_bind( accuracy )
                                        speed            = client->_bind( speed )
              )->simple_form( title    = `Geolocation`
                              editable = abap_false
                  )->content( `form`
                      )->label( `Longitude`
                      )->input( value = client->_bind( longitude ) editable = abap_false
                      )->label( `Latitude`
                      )->input( value = client->_bind( latitude ) editable = abap_false
                      )->label( `Altitude`
                      )->input( value = client->_bind( altitude ) editable = abap_false
                      )->label( `Accuracy`
                      )->input( value = client->_bind( accuracy ) editable = abap_false
                      )->label( `AltitudeAccuracy`
                      )->input( value = client->_bind( altitudeaccuracy ) editable = abap_false
                      )->label( `Speed`
                      )->input( value = client->_bind( speed ) editable = abap_false ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
