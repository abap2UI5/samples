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

    IF check_initialized = abap_false.
      check_initialized = abap_true.

       DATA(view) = z2ui5_cl_xml_view=>factory( ).
        client->view_display( view->shell(
              )->page(
                      title          = 'abap2UI5 - Device Capabilities'
                      navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                      shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
                  )->header_content(
                      )->link(
                          text = 'Source_Code'
                          href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                          target = '_blank'
                  )->get_parent(
                  )->_z2ui5( )->geolocation(
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
                          )->label( `MapContainer`
                          )->button( text = `Display` press = client->_event( `MAP_CONTAINER_DISPLAY` )
               )->stringify( ) ).

*      client->view_display( z2ui5_cl_xml_view=>factory( client
*        )->_z2ui5( )->timer( client->_event( `GEOLOCATION_LOADED` )
*        )->_cc( )->geolocation( )->load_cc(  )->stringify( ) ).

      RETURN.
    ENDIF.

    CASE client->get( )-event.

      WHEN 'MAP_CONTAINER_DISPLAY'.

        IF longitude IS NOT INITIAL.
          mt_spot = VALUE #( ( pos = longitude && `;` && latitude && `;0`  type = `Default`  contentoffset = `0;-6` scale = `1;1;1` key = `Your Position`   tooltip = `Your Position` ) ).
        ENDIF.

        view = z2ui5_cl_xml_view=>factory( ).
        client->view_display( view->shell(
              )->page(
                      title          = 'abap2UI5 - Device Capabilities'
                      navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                      shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
                  )->header_content(
                      )->link(
                          text = 'Source_Code'
                          href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                          target = '_blank'
                  )->get_parent(
                  )->_z2ui5( )->geolocation(
                                            finished         = client->_event(  )
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
                          )->label( `MapContainer`
                          )->button( text = `Display` press = client->_event( `MAP_CONTAINER_DISPLAY` )
               )->get_parent( )->get_parent(
               )->map_container(  autoadjustheight = abap_true
                    )->content( ns = `vk`
                        )->container_content(
                          title = `Analytic Map`
                          icon  = `sap-icon://geographic-bubble-chart`
                            )->content( ns = `vk`
                                )->analytic_map(
                                  initialposition = `9.933573;50;0`
                                  initialzoom = `6`
                                )->vos(
                                    )->spots( client->_bind( mt_spot )
                                    )->spot(
                                      position      = `{POS}`
                                      contentoffset = `{CONTENTOFFSET}`
                                      type          =  `{TYPE}`
                                      scale         =  `{SCALE}`
                                      tooltip       =  `{TOOLTIP}`
               )->stringify( ) ).


      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).
        RETURN.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
