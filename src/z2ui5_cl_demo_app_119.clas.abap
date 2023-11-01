CLASS z2ui5_cl_demo_app_119 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA product TYPE string .
    DATA quantity TYPE string .
    DATA check_initialized TYPE abap_bool .

    DATA ms_drive_config TYPE z2ui5_cl_cc_driver_js=>ty_config.
    DATA mv_custom_css TYPE string.

    METHODS view_main.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_119 IMPLEMENTATION.


  METHOD view_main.

    DATA(view) = z2ui5_cl_xml_view=>factory( client ).

    view->_cc_plain_xml( `<html:style>` && z2ui5_cl_cc_driver_js=>get_css_local( ) && `</html:style>` )->get_parent( ).

    view->_cc_plain_xml( `<html:style>` && mv_custom_css && `</html:style>` )->get_parent( ).

    client->view_display( z2ui5_cl_xml_view=>factory( client
    )->_cc( )->driver_js( )->set_drive_config( config = ms_drive_config
    )->stringify( ) ).

    view->_cc( )->driver_js( )->set_drive_config( config = ms_drive_config )->get_parent( ).

    client->view_display( view->shell(
          )->page(
                  title          = 'abap2UI5 - DriverJs'
                  navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                  shownavbutton  = abap_true
              )->header_content(
                  )->link(
                      text = 'Source_Code'
                      href = view->hlp_get_source_code_url(  )
                      target = '_blank'
                  )->button( text = `TOUR` press = client->_event_client( val = `DRIVE` )
              )->get_parent(
              )->simple_form( title = 'Form Title' editable = abap_true
                  )->content( 'form'
                      )->title( 'Input'
                      )->label( 'quantity'
                      )->input( value = client->_bind_edit( quantity ) id = `choper725`
                      )->label( `product`
                      )->input( value = product enabled = abap_false id = `choper725-1`
                      )->button( id = `choper725-2`
                          text  = 'post'
                          press = client->_event( val = 'BUTTON_POST' )
           )->stringify( ) ).
  ENDMETHOD.


  METHOD z2ui5_if_app~main.
    me->client = client.
    IF check_initialized = abap_false.
      check_initialized = abap_true.

      DATA ls_steps TYPE z2ui5_cl_cc_driver_js=>ty_config_steps.

      ms_drive_config-show_progress = abap_true.
      ms_drive_config-popover_class = 'driverjs-theme'.
      ms_drive_config-show_buttons = z2ui5_cl_cc_driver_js=>buttons-next_previous.
*      ls_steps-element = '#__xmlview5--choper725'.
      ls_steps-element = 'choper725'.
      ls_steps-elementview = client->cs_view-main.
      ls_steps-popover-title = 'Animated Tour Example'.
      ls_steps-popover-description = `Here is the code example showing animated tour. Let's walk you through it.'`.
      ls_steps-popover-side = z2ui5_cl_cc_driver_js=>side-left.
      ls_steps-popover-align = z2ui5_cl_cc_driver_js=>align-start.
      APPEND ls_steps TO ms_drive_config-steps.

*      ls_steps-element = '#__xmlview5--choper725-1'.
      ls_steps-element = 'choper725-1'.
      ls_steps-elementview = client->cs_view-main.
      ls_steps-popover-title = 'Animated Tour Example'.
      ls_steps-popover-description = `Here is the code example showing animated tour. Let's walk you through it.'`.
      ls_steps-popover-side = z2ui5_cl_cc_driver_js=>side-left.
      ls_steps-popover-align = z2ui5_cl_cc_driver_js=>align-start.
      APPEND ls_steps TO ms_drive_config-steps.

*      ls_steps-element = '#__xmlview5--choper725-2'.
      ls_steps-element = 'choper725-2'.
      ls_steps-elementview = client->cs_view-main.
      ls_steps-popover-title = 'Import the Library'.
      ls_steps-popover-description = `It works the same in vanilla JavaScript as well as frameworks.'`.
      ls_steps-popover-disable_buttons = z2ui5_cl_cc_driver_js=>buttons-previous.
      ls_steps-popover-side = z2ui5_cl_cc_driver_js=>side-bottom.
      ls_steps-popover-align = z2ui5_cl_cc_driver_js=>align-start.
      APPEND ls_steps TO ms_drive_config-steps.


      mv_custom_css = `.driver-popover.driverjs-theme {` && |\n| &&
                      ` background-color: #fde047;` && |\n| &&
                      ` color: #000;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-title {` && |\n| &&
                      ` font-size: 20px;` && |\n| &&
                      `}` && |\n| &&
                      `driver-popover.driverjs-theme .driver-popover-title,` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-description,` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-progress-text {` && |\n| &&
                      ` color: #000;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme button {` && |\n| &&
                      ` flex: 1;` && |\n| &&
                      ` text-align: center;` && |\n| &&
                      ` background-color: #000;` && |\n| &&
                      ` color: #ffffff;` && |\n| &&
                      ` border: 2px solid #000;` && |\n| &&
                      ` text-shadow: none;` && |\n| &&
                      ` font-size: 14px;` && |\n| &&
                      ` padding: 5px 8px;` && |\n| &&
                      ` border-radius: 6px;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme button:hover {` && |\n| &&
                      ` background-color: #000;` && |\n| &&
                      ` color: #ffffff;` && |\n| &&
                      `}` && |\n| &&
                      `driver-popover.driverjs-theme .driver-popover-navigation-btns {` && |\n| &&
                      ` justify-content: space-between;` && |\n| &&
                      ` gap: 3px;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-close-btn {` && |\n| &&
                      ` color: #9b9b9b;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-close-btn:hover {` && |\n| &&
                      ` color: #000;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-arrow-side-left.driver-popover-arrow {` && |\n| &&
                      ` border-left-color: #fde047;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-arrow-side-right.driver-popover-arrow {` && |\n| &&
                      ` border-right-color: #fde047;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-arrow-side-top.driver-popover-arrow {` && |\n| &&
                      ` border-top-color: #fde047;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-arrow-side-bottom.driver-popover-arrow {` && |\n| &&
                      ` border-bottom-color: #fde047;` && |\n| &&
                      `}`.


      product  = 'tomato'.
      quantity = '500'.

      client->view_display( z2ui5_cl_xml_view=>factory( client
        )->_cc( )->driver_js( )->load_lib( local_js = abap_true "js_url = `https://cdn.jsdelivr.net/npm/driver.js@1.0.1/dist/driver.js.iife.js`
        )->stringify( ) ).

      client->timer_set( event_finished = client->_event( `START` ) interval_ms = `0` ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'START'.

        view_main( ).

      WHEN 'BUTTON_POST'.
        client->message_toast_display( |{ product } { quantity } - send to the server| ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
