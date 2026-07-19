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



CLASS Z2UI5_CL_DEMO_APP_122 IMPLEMENTATION.


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

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Reads frontend information from the client - UI5 version and theme plus device, ` &&
                   `OS and browser details - and shows each value in a read-only form.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->simple_form(
        title    = `Information`
        editable = abap_true
        )->content( `form`
        )->label( `device_browser`
        )->input(
            value   = client->_bind_edit( device_browser )
            enabled = abap_false
        )->label( `device_browser_version`
        )->input(
            value   = client->_bind_edit( device_browser_version )
            enabled = abap_false
        )->label( `device_os`
        )->input(
            value   = client->_bind_edit( device_os )
            enabled = abap_false
        )->label( `device_os_version`
        )->input(
            value   = client->_bind_edit( device_os_version )
            enabled = abap_false
        )->label( `device_systemtype`
        )->input(
            value   = client->_bind_edit( device_systemtype )
            enabled = abap_false
        )->label( `device_orientation`
        )->input(
            value   = client->_bind_edit( device_orientation )
            enabled = abap_false
        )->label( `device_height`
        )->input(
            value   = client->_bind_edit( device_height )
            enabled = abap_false
        )->label( `device_width`
        )->input(
            value   = client->_bind_edit( device_width )
            enabled = abap_false
        )->label( `device_phone`
        )->input(
            value   = client->_bind_edit( device_phone )
            enabled = abap_false
        )->label( `device_desktop`
        )->input(
            value   = client->_bind_edit( device_desktop )
            enabled = abap_false
        )->label( `device_tablet`
        )->input(
            value   = client->_bind_edit( device_tablet )
            enabled = abap_false
        )->label( `device_combi`
        )->input(
            value   = client->_bind_edit( device_combi )
            enabled = abap_false
        )->label( `device_touch`
        )->input(
            value   = client->_bind_edit( device_touch )
            enabled = abap_false
        )->label( `device_pointer`
        )->input(
            value   = client->_bind_edit( device_pointer )
            enabled = abap_false
        )->label( `device_retina`
        )->input(
            value   = client->_bind_edit( device_retina )
            enabled = abap_false
        )->label( `ui5_version`
        )->input(
            value   = client->_bind_edit( ui5_version )
            enabled = abap_false
        )->label( `ui5_theme`
        )->input(
            value   = client->_bind_edit( ui5_theme )
            enabled = abap_false
        )->label( `ui5_gav`
        )->input(
            value   = client->_bind_edit( ui5_gav )
            enabled = abap_false
        )->label( `ui5_build_timestamp`
        )->input(
            value   = client->_bind_edit( ui5_build_timestamp )
            enabled = abap_false ).
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
