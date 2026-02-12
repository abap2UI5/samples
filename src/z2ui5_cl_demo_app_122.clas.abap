CLASS z2ui5_cl_demo_app_122 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_ui5_version TYPE string.
    DATA mv_ui5_theme TYPE string.
    DATA mv_ui5_gav TYPE string.
    DATA mv_device_systemtype TYPE string.
    DATA mv_device_os TYPE string.
    DATA mv_device_browser TYPE string.

    DATA mv_device_phone   TYPE abap_bool.
    DATA mv_device_desktop TYPE abap_bool.
    DATA mv_device_tablet  TYPE abap_bool.
    DATA mv_device_combi   TYPE abap_bool.
    DATA mv_device_height  TYPE string.
    DATA mv_device_width   TYPE string.

  PROTECTED SECTION.
    DATA mo_client TYPE REF TO z2ui5_if_client.
    METHODS display_view.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_122 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    mo_client->view_display( lo_view->shell(
          )->page(
                  title          = `abap2UI5`
                  navbuttonpress = mo_client->_event_nav_app_leave( )
                  shownavbutton  = mo_client->check_app_prev_stack( )
              )->_z2ui5( )->info_frontend(
                                        finished          = mo_client->_event( `INFO_FINISHED` )
                                        device_browser    = mo_client->_bind_edit( mv_device_browser )
                                        device_os         = mo_client->_bind_edit( mv_device_os )
                                        device_systemtype = mo_client->_bind_edit( mv_device_systemtype )
                                        ui5_gav           = mo_client->_bind_edit( mv_ui5_gav )
                                        ui5_theme         = mo_client->_bind_edit( mv_ui5_theme )
                                        ui5_version       = mo_client->_bind_edit( mv_ui5_version )
                                        device_phone      = mo_client->_bind_edit( mv_device_phone )
                                        device_desktop    = mo_client->_bind_edit( mv_device_desktop )
                                        device_tablet     = mo_client->_bind_edit( mv_device_tablet )
                                        device_combi      = mo_client->_bind_edit( mv_device_combi )
                                        device_height     = mo_client->_bind_edit( mv_device_height )
                                        device_width      = mo_client->_bind_edit( mv_device_width )
              )->simple_form( title    = `Information`
                              editable = abap_true
                  )->content( `form`
                      )->label( `device_browser`
                      )->input( mo_client->_bind_edit( mv_device_browser )
                      )->label( `device_os`
                      )->input( mo_client->_bind_edit( mv_device_os )
                      )->label( `device_systemtype`
                      )->input( mo_client->_bind_edit( mv_device_systemtype )
                      )->label( `ui5_gav`
                      )->input( mo_client->_bind_edit( mv_ui5_gav )
                      )->label( `ui5_theme`
                      )->input( mo_client->_bind_edit( mv_ui5_theme )
                      )->label( `ui5_version`
                      )->input( mo_client->_bind_edit( mv_ui5_version )
                      )->label( `device_phone`
                      )->input( mo_client->_bind_edit( mv_device_phone )
                      )->label( `device_desktop`
                      )->input( mo_client->_bind_edit( mv_device_desktop )
                      )->label( `device_tablet`
                      )->input( mo_client->_bind_edit( mv_device_tablet )
                      )->label( `device_combi`
                      )->input( mo_client->_bind_edit( mv_device_combi )
                      )->label( `device_height`
                      )->input( mo_client->_bind_edit( mv_device_height )
                      )->label( `device_width`
                      )->input( mo_client->_bind_edit( mv_device_width )
      )->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( ).
    ENDIF.

    IF mo_client->check_on_event( `BACK` ).
      mo_client->nav_app_leave( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
