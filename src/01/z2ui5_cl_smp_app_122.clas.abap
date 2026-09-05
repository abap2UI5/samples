" @keywords client info ui5 version theme os user agent device
" @summary Asks the frontend what it is: UI5 version, theme, operating system, browser and user agent, in one call.
" @docs https://abap2ui5.github.io/docs/cookbook/device_capabilities/info
CLASS z2ui5_cl_smp_app_122 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_122 IMPLEMENTATION.


  METHOD read_frontend_info.

    DATA ls_get TYPE z2ui5_if_client=>ty_s_get.
    DATA temp1 TYPE string.
    DATA temp2 TYPE string.
    DATA temp3 TYPE xsdboolean.
    DATA temp4 TYPE xsdboolean.
    DATA temp5 TYPE xsdboolean.
    DATA temp6 TYPE xsdboolean.
    ls_get = client->get( ).

    device_browser         = ls_get-s_device-browser-name.
    device_browser_version = ls_get-s_device-browser-version.
    device_os              = ls_get-s_device-os-name.
    device_os_version      = ls_get-s_device-os-version.
    device_systemtype      = ls_get-s_device-system.
    device_orientation     = ls_get-s_device-orientation.
    
    temp1 = ls_get-s_device-resize-height.
    device_height          = temp1.
    
    temp2 = ls_get-s_device-resize-width.
    device_width           = temp2.
    
    temp3 = boolc( ls_get-s_device-system = z2ui5_if_client=>cs_device-system-phone ).
    device_phone           = temp3.
    
    temp4 = boolc( ls_get-s_device-system = z2ui5_if_client=>cs_device-system-desktop ).
    device_desktop         = temp4.
    
    temp5 = boolc( ls_get-s_device-system = z2ui5_if_client=>cs_device-system-tablet ).
    device_tablet          = temp5.
    
    temp6 = boolc( ls_get-s_device-system = z2ui5_if_client=>cs_device-system-combi ).
    device_combi           = temp6.
    device_touch           = ls_get-s_device-support-touch.
    device_pointer         = ls_get-s_device-support-pointer.
    device_retina          = ls_get-s_device-support-retina.
    ui5_version            = ls_get-s_ui5-version.
    ui5_theme              = ls_get-s_ui5-theme.
    ui5_gav                = ls_get-s_ui5-gav.
    ui5_build_timestamp    = ls_get-s_ui5-build_timestamp.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Device - Frontend Info: UI5 Version, Theme, OS, Browser`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Reads frontend information from the client - UI5 version and theme plus device, ` &&
                   `OS and browser details - and shows each value in a read-only form.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Information`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Label`
                )->a( n = `text` v = `device_browser`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_browser )
            )->tag( `Label`
                )->a( n = `text` v = `device_browser_version`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_browser_version )
            )->tag( `Label`
                )->a( n = `text` v = `device_os`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_os )
            )->tag( `Label`
                )->a( n = `text` v = `device_os_version`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_os_version )
            )->tag( `Label`
                )->a( n = `text` v = `device_systemtype`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_systemtype )
            )->tag( `Label`
                )->a( n = `text` v = `device_orientation`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_orientation )
            )->tag( `Label`
                )->a( n = `text` v = `device_height`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_height )
            )->tag( `Label`
                )->a( n = `text` v = `device_width`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_width )
            )->tag( `Label`
                )->a( n = `text` v = `device_phone`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_phone )
            )->tag( `Label`
                )->a( n = `text` v = `device_desktop`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_desktop )
            )->tag( `Label`
                )->a( n = `text` v = `device_tablet`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_tablet )
            )->tag( `Label`
                )->a( n = `text` v = `device_combi`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_combi )
            )->tag( `Label`
                )->a( n = `text` v = `device_touch`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_touch )
            )->tag( `Label`
                )->a( n = `text` v = `device_pointer`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_pointer )
            )->tag( `Label`
                )->a( n = `text` v = `device_retina`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( device_retina )
            )->tag( `Label`
                )->a( n = `text` v = `ui5_version`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( ui5_version )
            )->tag( `Label`
                )->a( n = `text` v = `ui5_theme`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( ui5_theme )
            )->tag( `Label`
                )->a( n = `text` v = `ui5_gav`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( ui5_gav )
            )->tag( `Label`
                )->a( n = `text` v = `ui5_build_timestamp`
            )->tag( `Input`
                )->a( n = `enabled` b = abap_false
                )->a( n = `value`   v = client->_bind( ui5_build_timestamp ) ).
    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.

      read_frontend_info( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
