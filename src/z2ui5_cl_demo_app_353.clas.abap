CLASS z2ui5_cl_demo_app_353 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_353 IMPLEMENTATION.

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

    client->action->gen(
        val   = z2ui5_if_client=>cs_event-start_timer
        t_arg = VALUE #( ( client->_event( `TIMER_FINISHED` ) ) ( `4000` ) ) ).

  ENDMETHOD.


  METHOD render.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
          )->page(
              title          = `abap2UI5 - Multiple Timers`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(form) = page->simple_form(
                      editable = abap_true
                 )->content( `form` ).

    form->label( `device_browser`
        )->input( client->_bind_edit( device_browser )
        )->label( `device_os`
        )->input( client->_bind_edit( device_os )
        )->label( `device_systemtype`
        )->input( client->_bind_edit( device_systemtype )
        )->label( `device_height`
        )->input( client->_bind_edit( device_height )
        )->label( `device_width`
        )->input( client->_bind_edit( device_width )
        )->label( `ui5_version`
        )->input( client->_bind_edit( ui5_version )
        )->label( `ui5_theme`
        )->input( client->_bind_edit( ui5_theme )
        )->label( `Cursor here ->` )->input(
            id    = `IdOne`
            value = client->_bind_edit( one ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      read_device_info( ).
      render( ).
      start_timer( ).
      client->action->gen(
          val   = z2ui5_if_client=>cs_event-set_focus
          t_arg = VALUE #( ( `IdOne` ) ) ).
    ENDIF.

    IF client->check_on_event( `TIMER_FINISHED` ).

      client->message_toast_display( `Timer finished` ).
      start_timer( ).
      client->view_model_update( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
