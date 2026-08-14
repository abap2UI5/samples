CLASS z2ui5_cl_smp_app_353 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA one              TYPE string.
    DATA ui5_version      TYPE string.
    DATA ui5_theme        TYPE string.
    DATA device_systemtype TYPE string.
    DATA device_os        TYPE string.
    DATA device_browser   TYPE string.
    DATA device_height    TYPE string.
    DATA device_width     TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS render.
    METHODS read_device_info.
    METHODS start_timer.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_353 IMPLEMENTATION.

  METHOD read_device_info.

    DATA(ls_get) = client->get( ).

    device_browser    = ls_get-s_device-browser-name.
    device_os         = ls_get-s_device-os-name.
    device_systemtype = ls_get-s_device-system.
    device_height     = CONV string( ls_get-s_device-resize-height ).
    device_width      = CONV string( ls_get-s_device-resize-width ).
    ui5_version       = ls_get-s_ui5-version.
    ui5_theme         = ls_get-s_ui5-theme.

  ENDMETHOD.


  METHOD start_timer.

    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-start_timer
        t_arg = VALUE #( ( `TIMER_FINISHED` ) ( `4000` ) ) ).

  ENDMETHOD.


  METHOD render.

    DATA(page) = z2ui5_cl_ui5_view_builder=>factory( )->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `xmlns:form`   v = `sap.ui.layout.form` )->ele( `Shell` )->ele( `Page`
              )->a( n = `title`          v = `abap2UI5 - Multiple Timers`
              )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
              )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    DATA(form) = page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `editable` b = abap_true )->ele( n = `content` ns = `form` ).

    form->tag( `Label`
        )->a( n = `text` v = `device_browser` )->tag( `Input`
            )->a( n = `value` v = client->_bind( device_browser ) )->tag( `Label`
            )->a( n = `text` v = `device_os` )->tag( `Input`
            )->a( n = `value` v = client->_bind( device_os ) )->tag( `Label`
            )->a( n = `text` v = `device_systemtype` )->tag( `Input`
            )->a( n = `value` v = client->_bind( device_systemtype ) )->tag( `Label`
            )->a( n = `text` v = `device_height` )->tag( `Input`
            )->a( n = `value` v = client->_bind( device_height ) )->tag( `Label`
            )->a( n = `text` v = `device_width` )->tag( `Input`
            )->a( n = `value` v = client->_bind( device_width ) )->tag( `Label`
            )->a( n = `text` v = `ui5_version` )->tag( `Input`
            )->a( n = `value` v = client->_bind( ui5_version ) )->tag( `Label`
            )->a( n = `text` v = `ui5_theme` )->tag( `Input`
            )->a( n = `value` v = client->_bind( ui5_theme ) )->tag( `Label`
            )->a( n = `text` v = `Cursor here ->` )->tag( `Input`
            )->a( n = `id`    v = `IdOne`
            )->a( n = `value` v = client->_bind( one ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      read_device_info( ).
      render( ).
      start_timer( ).
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-set_focus
          t_arg = VALUE #( ( `IdOne` ) ) ).
    ENDIF.

    IF client->check_on_event( `TIMER_FINISHED` ).

      client->message_toast_display( `Timer finished` ).
      start_timer( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
