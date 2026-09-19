" @keywords gps position latitude longitude altitude location
" @summary Asks the browser for the device's position - latitude, longitude and altitude - and what happens when the user says no.
" @docs https://abap2ui5.github.io/docs/cookbook/device_capabilities/geolocation
CLASS z2ui5_cl_smp_app_120 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA longitude TYPE string.
    DATA latitude TYPE string.
    DATA altitude TYPE string.
    DATA speed TYPE string.
    DATA altitudeaccuracy TYPE string.
    DATA accuracy TYPE string.


  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_120 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
      RETURN.
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

    IF client->get_event( ) = `GEOLOCATION_ERROR`.
      " the Geolocation control fires `error` when the position cannot be
      " read; the code (1 = permission denied, 2 = position unavailable,
      " 3 = timeout) and message are passed as event arguments.
      client->message_box_display(
          text = |Location unavailable ({ client->get_event_arg( 1 ) }): { client->get_event_arg( 2 ) }|
          type = `error` ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Device - Geolocation from the Browser`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text` v = `The geolocation custom control reads the device position from the browser and binds ` &&
                   `longitude, latitude, altitude, accuracy and speed into the read-only form below.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    CLEAR temp1.
    INSERT `${$parameters>/code}` INTO TABLE temp1.
    INSERT `${$parameters>/message}` INTO TABLE temp1.
    page->tag( n = `Geolocation` ns = `z2ui5`
        " abap2ui5lint-disable-next-line event-without-handler -- the position arrives with the roundtrip and the view re-renders with it
        )->a( n = `finished` v = client->_event( `GEOLOCATION_LOADED` )
        )->a( n = `error`    v = client->_event( val   = `GEOLOCATION_ERROR`
                                                                           t_arg = temp1 )
        )->a( n = `longitude`        v = client->_bind( longitude )
        )->a( n = `latitude`         v = client->_bind( latitude )
        )->a( n = `altitude`         v = client->_bind( altitude )
        )->a( n = `accuracy`         v = client->_bind( accuracy )
        )->a( n = `altitudeAccuracy` v = client->_bind( altitudeaccuracy )
        )->a( n = `speed`            v = client->_bind( speed )
        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `title`    v = `Geolocation`
            )->a( n = `editable` b = abap_false
            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text`     v = `Longitude`
                )->tag( `Input`
                    )->a( n = `editable` b = abap_false
                    )->a( n = `value`    v = client->_bind( longitude )
                )->tag( `Label`
                    )->a( n = `text`     v = `Latitude`
                )->tag( `Input`
                    )->a( n = `editable` b = abap_false
                    )->a( n = `value`    v = client->_bind( latitude )
                )->tag( `Label`
                    )->a( n = `text`     v = `Altitude`
                )->tag( `Input`
                    )->a( n = `editable` b = abap_false
                    )->a( n = `value`    v = client->_bind( altitude )
                )->tag( `Label`
                    )->a( n = `text`     v = `Accuracy`
                )->tag( `Input`
                    )->a( n = `editable` b = abap_false
                    )->a( n = `value`    v = client->_bind( accuracy )
                )->tag( `Label`
                    )->a( n = `text`     v = `AltitudeAccuracy`
                )->tag( `Input`
                    )->a( n = `editable` b = abap_false
                    )->a( n = `value`    v = client->_bind( altitudeaccuracy )
                )->tag( `Label`
                    )->a( n = `text`     v = `Speed`
                )->tag( `Input`
                    )->a( n = `editable` b = abap_false
                    )->a( n = `value`    v = client->_bind( speed ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
