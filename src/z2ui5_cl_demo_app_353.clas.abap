CLASS z2ui5_cl_demo_app_353 DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES
      z2ui5_if_app.

    DATA one               TYPE string.
    DATA focus_field       TYPE string.
    DATA mv_check_active   TYPE abap_bool.
    DATA ui5_version       TYPE string.
    DATA ui5_theme         TYPE string.
    DATA ui5_gav           TYPE string.
    DATA device_systemtype TYPE string.
    DATA device_os         TYPE string.
    DATA device_browser    TYPE string.

    DATA device_phone      TYPE abap_bool.
    DATA device_desktop    TYPE abap_bool.
    DATA device_tablet     TYPE abap_bool.
    DATA device_combi      TYPE abap_bool.
    DATA device_height     TYPE string.
    DATA device_width      TYPE string.

  PRIVATE SECTION.
    DATA initialized TYPE abap_bool.
    DATA client      TYPE REF TO z2ui5_if_client.

    METHODS render.
    METHODS event.

ENDCLASS.


CLASS z2ui5_cl_demo_app_353 IMPLEMENTATION.

  METHOD event.

    CASE client->get( )-event.
      WHEN 'TIMER_FINISHED'.

        client->message_toast_display( 'Timer finished' ).
      WHEN 'INFO_FINISHED'.

        client->message_toast_display( 'Frontend finished' ).
      WHEN 'BACK'.

        client->nav_app_leave( ).

    ENDCASE.

    client->view_model_update( ).

  ENDMETHOD.

  METHOD render.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
          )->page( title          = 'abap2UI5 - Multiple Timers'
                   navbuttonpress = client->_event( 'BACK' )
                   shownavbutton  = client->check_app_prev_stack( ) ).

    page->_z2ui5( )->timer( finished    = client->_event( 'TIMER_FINISHED' )
                            delayms     = `4000`
                            checkactive = client->_bind( mv_check_active ) ).

    page->_z2ui5( )->info_frontend( finished          = client->_event( `INFO_FINISHED` )
                                    device_browser    = client->_bind_edit( device_browser )
                                    device_os         = client->_bind_edit( device_os )
                                    device_systemtype = client->_bind_edit( device_systemtype )
                                    ui5_gav           = client->_bind_edit( ui5_gav )
                                    ui5_theme         = client->_bind_edit( ui5_theme )
                                    ui5_version       = client->_bind_edit( ui5_version )
                                    device_phone      = client->_bind_edit( device_phone )
                                    device_desktop    = client->_bind_edit( device_desktop )
                                    device_tablet     = client->_bind_edit( device_tablet )
                                    device_combi      = client->_bind_edit( device_combi )
                                    device_height     = client->_bind_edit( device_height )
                                    device_width      = client->_bind_edit( device_width ) ).

    DATA(form) = page->_z2ui5( )->focus( focusid = client->_bind( focus_field )

          )->simple_form( editable = abap_true

                                )->content( ns = `form` ).

    form->label( 'device_browser'
                          )->input( client->_bind_edit( device_os )
                          )->label( `device_systemtype`

                         )->label( 'Cursor here -> '
                         )->input( id    = `IdOne`
                                   type  = ``
                                   value = client->_bind_edit( one ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF initialized = abap_false.
      initialized = abap_true.
      focus_field = 'IdOne'.
      mv_check_active = abap_true.
      render( ).
    ENDIF.

    event( ).

  ENDMETHOD.

ENDCLASS.
