CLASS z2ui5_cl_demo_app_120 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_longitude TYPE string.
    DATA mv_latitude TYPE string.
    DATA mv_altitude TYPE string.
    DATA mv_speed TYPE string.
    DATA mv_altitudeaccuracy TYPE string.
    DATA mv_accuracy TYPE string.

    TYPES:
      BEGIN OF ty_spot,
        tooltip       TYPE string,
        type          TYPE string,
        pos           TYPE string,
        scale         TYPE string,
        contentoffset TYPE string,
        key           TYPE string,
        icon          TYPE string,
      END OF ty_spot.
    DATA mt_spot TYPE TABLE OF ty_spot.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_120 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
      client->view_display( lo_view->shell(
              )->page(
                      title          = `abap2UI5 - Device Capabilities`
                      navbuttonpress = client->_event( `BACK` )
                      shownavbutton  = client->check_app_prev_stack( )
                  )->_z2ui5( )->geolocation(
                                            finished         = client->_event( `GEOLOCATION_LOADED` )
                                            longitude        = client->_bind_edit( mv_longitude )
                                            latitude         = client->_bind_edit( mv_latitude )
                                            altitude         = client->_bind_edit( mv_altitude )
                                            altitudeaccuracy = client->_bind_edit( mv_altitudeaccuracy )
                                            accuracy         = client->_bind_edit( mv_accuracy )
                                            speed            = client->_bind_edit( mv_speed )
                  )->simple_form( title    = `Geolocation`
                                  editable = abap_true
                      )->content( `form`
                          )->label( `Longitude`
                          )->input( client->_bind_edit( mv_longitude )
                          )->label( `Latitude`
                          )->input( client->_bind_edit( mv_latitude )
                          )->label( `Altitude`
                          )->input( client->_bind_edit( mv_altitude )
                          )->label( `Accuracy`
                          )->input( client->_bind_edit( mv_accuracy )
                          )->label( `AltitudeAccuracy`
                          )->input( client->_bind_edit( mv_altitudeaccuracy )
                          )->label( `Speed`
                          )->input( client->_bind_edit( mv_speed )
                          )->label( `MapContainer`
                          )->button( text  = `Display`
                                     press = client->_event( `MAP_CONTAINER_DISPLAY` )
               )->stringify( ) ).

      RETURN.
    ENDIF.

    CASE client->get( )-event.
      WHEN `MAP_CONTAINER_DISPLAY`.

        IF mv_longitude IS NOT INITIAL.
          mt_spot = VALUE #( ( pos = mv_longitude && `;` && mv_latitude && `;0`  type = `Default`  contentoffset = `0;-6` scale = `1;1;1` key = `Your Position`   tooltip = `Your Position` ) ).
        ENDIF.

        lo_view = z2ui5_cl_xml_view=>factory( ).
        client->view_display( lo_view->shell(
              )->page(
                      title          = `abap2UI5 - Device Capabilities`
                      navbuttonpress = client->_event( `BACK` )
                      shownavbutton  = client->check_app_prev_stack( )
                  )->_z2ui5( )->geolocation(
                                            finished         = client->_event( )
                                            longitude        = client->_bind_edit( mv_longitude )
                                            latitude         = client->_bind_edit( mv_latitude )
                                            altitude         = client->_bind_edit( mv_altitude )
                                            altitudeaccuracy = client->_bind_edit( mv_altitudeaccuracy )
                                            accuracy         = client->_bind_edit( mv_accuracy )
                                            speed            = client->_bind_edit( mv_speed )
                  )->simple_form( title    = `Geolocation`
                                  editable = abap_true
                      )->content( `form`
                          )->label( `Longitude`
                          )->input( client->_bind_edit( mv_longitude )
                          )->label( `Latitude`
                          )->input( client->_bind_edit( mv_latitude )
                          )->label( `Altitude`
                          )->input( client->_bind_edit( mv_altitude )
                          )->label( `Accuracy`
                          )->input( client->_bind_edit( mv_accuracy )
                          )->label( `AltitudeAccuracy`
                          )->input( client->_bind_edit( mv_altitudeaccuracy )
                          )->label( `Speed`
                          )->input( client->_bind_edit( mv_speed )
                          )->label( `MapContainer`
                          )->button( text  = `Display`
                                     press = client->_event( `MAP_CONTAINER_DISPLAY` )
               )->get_parent( )->get_parent(
               )->map_container( autoadjustheight = abap_true
                    )->content( ns = `vk`
                        )->container_content(
                          title = `Analytic Map`
                          icon  = `sap-icon://geographic-bubble-chart`
                            )->content( ns = `vk`
                                )->analytic_map(
                                  initialposition = `9.933573;50;0`
                                  initialzoom     = `6`
                                )->vos(
                                    )->spots( client->_bind( mt_spot )
                                    )->spot(
                                      position      = `{POS}`
                                      contentoffset = `{CONTENTOFFSET}`
                                      type          = `{TYPE}`
                                      scale         = `{SCALE}`
                                      tooltip       = `{TOOLTIP}`
               )->stringify( ) ).
      WHEN `BACK`.
        client->nav_app_leave( ).
        RETURN.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
