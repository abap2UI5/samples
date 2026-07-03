CLASS z2ui5_cl_demo_app_122 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA ui5_version            TYPE string.
    DATA ui5_theme              TYPE string.
    DATA ui5_gav                TYPE string.
    DATA ui5_build_timestamp    TYPE string.
    DATA device_systemtype      TYPE string.
    DATA device_os              TYPE string.
    DATA device_os_version      TYPE string.
    DATA device_browser         TYPE string.
    DATA device_browser_version TYPE string.
    DATA device_orientation     TYPE string.
    DATA device_phone           TYPE abap_bool.
    DATA device_desktop         TYPE abap_bool.
    DATA device_tablet          TYPE abap_bool.
    DATA device_combi           TYPE abap_bool.
    DATA device_touch           TYPE abap_bool.
    DATA device_pointer         TYPE abap_bool.
    DATA device_retina          TYPE abap_bool.
    DATA device_height          TYPE string.
    DATA device_width           TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS read_frontend_info.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_122 IMPLEMENTATION.

  METHOD read_frontend_info.

    DATA(ls_get) = client->get( ).

    device_browser         = ls_get-s_device-browser-name.
    device_browser_version = ls_get-s_device-browser-version.
    device_os              = ls_get-s_device-os-name.
    device_os_version      = ls_get-s_device-os-version.
    device_systemtype      = ls_get-s_device-system.
    device_orientation     = ls_get-s_device-orientation.
    device_height          = CONV string( ls_get-s_device-resize-height ).
    device_width           = CONV string( ls_get-s_device-resize-width ).
    device_phone           = xsdbool( ls_get-s_device-system = z2ui5_if_types=>cs_device-system-phone ).
    device_desktop         = xsdbool( ls_get-s_device-system = z2ui5_if_types=>cs_device-system-desktop ).
    device_tablet          = xsdbool( ls_get-s_device-system = z2ui5_if_types=>cs_device-system-tablet ).
    device_combi           = xsdbool( ls_get-s_device-system = z2ui5_if_types=>cs_device-system-combi ).
    device_touch           = ls_get-s_device-support-touch.
    device_pointer         = ls_get-s_device-support-pointer.
    device_retina          = ls_get-s_device-support-retina.
    ui5_version            = ls_get-s_ui5-version.
    ui5_theme              = ls_get-s_ui5-theme.
    ui5_gav                = ls_get-s_ui5-gav.
    ui5_build_timestamp    = ls_get-s_ui5-build_timestamp.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
            title          = `abap2UI5`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
            )->simple_form(
                title    = `Information`
                editable = abap_true
                )->content( `form`
                )->label( `device_browser`
                )->input( client->_bind_edit( device_browser )
                )->label( `device_browser_version`
                )->input( client->_bind_edit( device_browser_version )
                )->label( `device_os`
                )->input( client->_bind_edit( device_os )
                )->label( `device_os_version`
                )->input( client->_bind_edit( device_os_version )
                )->label( `device_systemtype`
                )->input( client->_bind_edit( device_systemtype )
                )->label( `device_orientation`
                )->input( client->_bind_edit( device_orientation )
                )->label( `device_height`
                )->input( client->_bind_edit( device_height )
                )->label( `device_width`
                )->input( client->_bind_edit( device_width )
                )->label( `device_phone`
                )->input( client->_bind_edit( device_phone )
                )->label( `device_desktop`
                )->input( client->_bind_edit( device_desktop )
                )->label( `device_tablet`
                )->input( client->_bind_edit( device_tablet )
                )->label( `device_combi`
                )->input( client->_bind_edit( device_combi )
                )->label( `device_touch`
                )->input( client->_bind_edit( device_touch )
                )->label( `device_pointer`
                )->input( client->_bind_edit( device_pointer )
                )->label( `device_retina`
                )->input( client->_bind_edit( device_retina )
                )->label( `ui5_version`
                )->input( client->_bind_edit( ui5_version )
                )->label( `ui5_theme`
                )->input( client->_bind_edit( ui5_theme )
                )->label( `ui5_gav`
                )->input( client->_bind_edit( ui5_gav )
                )->label( `ui5_build_timestamp`
                )->input( client->_bind_edit( ui5_build_timestamp ) ).
    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      read_frontend_info( ).
      view_display( ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
