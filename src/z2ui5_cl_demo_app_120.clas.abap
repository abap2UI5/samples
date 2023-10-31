CLASS z2ui5_cl_demo_app_120 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    DATA longitude TYPE string.
    DATA latitude TYPE string.
    DATA altitude TYPE string.
    DATA speed TYPE string.
    DATA altitudeaccuracy TYPE string.
    DATA accuracy TYPE string.
    DATA check_initialized TYPE abap_bool .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_120 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.


    "on init
    IF check_initialized = abap_false.
      check_initialized = abap_true.

      client->view_display( z2ui5_cl_xml_view=>factory( client
        )->_cc( )->geolocation( )->load_cc(  )->stringify( ) ).


      client->timer_set( client->_event( ) ).
      RETURN.
    ENDIF.


    "user command
    CASE client->get( )-event.

      WHEN 'GEOLOCATION_LOADED'.
        client->message_box_display( `Geolocation loaded!`).
        RETURN.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).
        RETURN.

    ENDCASE.


    "render view
    DATA(view) = z2ui5_cl_xml_view=>factory( client ).

    client->view_display( view->shell(
          )->page(
                  title          = 'abap2UI5 - Device Capabilities'
                  navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                  shownavbutton  = abap_true
              )->header_content(
                  )->link(
                      text = 'Source_Code'
                      href = view->hlp_get_source_code_url(  )
                      target = '_blank'
              )->get_parent(
              )->_cc( )->geolocation( )->control(
                                        finished         = client->_event( `GEOLOCATION_LOADED` )
                                        longitude        = client->_bind_edit( longitude )
                                        latitude         = client->_bind_edit( latitude )
                                        altitude         = client->_bind_edit( altitude )
                                        altitudeaccuracy = client->_bind_edit( altitudeaccuracy )
                                        accuracy         = client->_bind_edit( accuracy )
                                        speed            = client->_bind_edit( speed )
              )->simple_form( title = 'Geolocation' editable = abap_true
                  )->content( 'form'
                      )->label( 'Longitude'
                      )->input( client->_bind_edit( longitude )
                      )->label( `Latitude`
                      )->input( client->_bind_edit( latitude )
                      )->label( `Altitude`
                      )->input( client->_bind_edit( altitude )
                      )->label( `Accuracy`
                      )->input( client->_bind_edit( accuracy )
                      )->label( `AltitudeAccuracy`
                      )->input( client->_bind_edit( altitudeaccuracy )
                      )->label( `Speed`
                      )->input( client->_bind_edit( speed )
           )->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
