CLASS z2ui5_cl_demo_app_119 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA product TYPE string .
    DATA quantity TYPE string .
    DATA check_initialized TYPE abap_bool .

    DATA ms_steps_config TYPE z2ui5_cl_cc_driver_js=>ty_config.
    DATA ms_hightlight_config TYPE z2ui5_cl_cc_driver_js=>ty_config_steps.
    DATA ms_hightlight_driver_config TYPE z2ui5_cl_cc_driver_js=>ty_config.
    DATA mv_custom_css TYPE string.

    METHODS view_main.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_119 IMPLEMENTATION.


  METHOD view_main.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->_generic( ns = `html` name = `style` )->_cc_plain_xml( z2ui5_cl_cc_driver_js=>get_css_local( ) ).
    view->_generic( ns = `html` name = `style` )->_cc_plain_xml( mv_custom_css ).

    view->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_driver_js=>get_js_config( i_steps_config = ms_steps_config
                                                    i_highlight_config        = ms_hightlight_config
                                                    i_highlight_driver_config = ms_hightlight_driver_config ) ).

    client->view_display( view->shell(
          )->page(
                  title          = 'abap2UI5 - DriverJs'
                  navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                  shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
              )->header_content(
                  )->link(
                      text = 'Source_Code'
                      href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                      target = '_blank'
                  )->button( text = `TOUR` press = `sap.z2ui5.DriverJS.drive()`
                  )->button( text = `HIGHLIGHT` press = `sap.z2ui5.DriverJS.highlight()`
              )->get_parent(
              )->simple_form( title = 'Form Title' editable = abap_true id = `choper725-highlight`
                  )->content( 'form'
                      )->title( 'Input'
                      )->label( 'quantity'
                      )->input( value = client->_bind_edit( quantity ) id = `choper725`
                      )->label( `product`
                      )->input( value = product enabled = abap_false id = `choper725-1`
                      )->button( id = `choper725-2`
                          text  = 'post'
                          type  = `Emphasized`
                          press = client->_event( val = 'BUTTON_POST' )
           )->stringify( ) ).
  ENDMETHOD.


  METHOD z2ui5_if_app~main.
    me->client = client.
    IF check_initialized = abap_false.
      check_initialized = abap_true.

      DATA ls_steps TYPE z2ui5_cl_cc_driver_js=>ty_config_steps.

      "highlight driver config
      ms_hightlight_driver_config-popover_class = 'driverjs-theme'.

      "highlight config
      "ID of sapui5 control only! other selectors are not supported
      ms_hightlight_config-element = `choper725-highlight`.
      ms_hightlight_config-elementview = client->cs_view-main.
      ms_hightlight_config-popover-title = `<strong>this is highlight title</strong>`.
      ms_hightlight_config-popover-description = `<em>this is <span style='background-color: yellow;'>highlight</span> description</em>`.

      "steps
      ms_steps_config-show_progress = abap_true.
      ms_steps_config-popover_class = 'driverjs-theme'.
*      ms_steps_config-show_buttons = z2ui5_cl_cc_driver_js=>buttons-next_previous.
      ms_steps_config-allow_close = z2ui5_cl_util=>boolean_abap_2_json( abap_false ).
      ms_steps_config-allow_close =  abap_false.
      ms_steps_config-progress_text = `{{current}} of {{total}} steps`.

      ms_steps_config-on_next_click = `//alert("this is an event function here !");` && |\n| &&
                                      `driverObj.moveNext();`.

*      ID of sapui5 control only! other selectors are not supported
      ls_steps-element = 'choper725'.
      ls_steps-elementview = client->cs_view-main.
      ls_steps-popover-title = '<strong>Animated Tour Example</strong>'.
      ls_steps-popover-side = z2ui5_cl_cc_driver_js=>side-left.
      ls_steps-popover-align = z2ui5_cl_cc_driver_js=>align-start.
      APPEND ls_steps TO ms_steps_config-steps.

*      ID of sapui5 control only! other selectors are not supported
      ls_steps-element = 'choper725-1'.
      ls_steps-elementview = client->cs_view-main.
      ls_steps-popover-title = '<u>Animated Tour <mark>Example</mark></u>'.
      ls_steps-popover-description = `Here is the code example showing animated tour. Let's walk you through it.`.
      ls_steps-popover-side = z2ui5_cl_cc_driver_js=>side-left.
      ls_steps-popover-align = z2ui5_cl_cc_driver_js=>align-start.
      APPEND ls_steps TO ms_steps_config-steps.

*      ID of sapui5 control only! other selectors are not supported
      ls_steps-element = 'choper725-2'.
      ls_steps-elementview = client->cs_view-main.
      ls_steps-popover-title = '<em>Import the Library</em>'.
      ls_steps-popover-description = `It works the same in vanilla JavaScript as well as frameworks.'`.
      ls_steps-popover-disable_buttons = z2ui5_cl_cc_driver_js=>buttons-previous.
      ls_steps-popover-side = z2ui5_cl_cc_driver_js=>side-bottom.
      ls_steps-popover-align = z2ui5_cl_cc_driver_js=>align-start.
      APPEND ls_steps TO ms_steps_config-steps.


      mv_custom_css = `.driver-popover.driverjs-theme {` && |\n| &&
                      ` background-color: #F5F6F7;` && |\n| &&
                      ` color: #000` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-title {` && |\n| &&
                      ` font-size: 20px;` && |\n| &&
                      ` color: #000` && |\n| &&
                      `}` && |\n| &&
                      `driver-popover.driverjs-theme .driver-popover-title,` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-description,` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-progress-text {` && |\n| &&
                      ` color: #000` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme button {` && |\n| &&
*                      ` flex: 1;` && |\n| &&
                      `direction: ltr;` && |\n| &&
                      ` text-align: center;` && |\n| &&
                      ` background-color: #fff;` && |\n| &&
                      ` color: #0064d9;` && |\n| &&
*                      ` border-color: #0070f2` && |\n| &&
                      ` text-shadow: none;` && |\n| &&
                      ` font-size: 14px;` && |\n| &&
                      ` padding: 5px 8px;` && |\n| &&
                      ` border-radius: 6px;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme button:hover {` && |\n| &&
                      ` background-color: #0070f2;` && |\n| &&
                      ` color: #ffffff;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-navigation-btns {` && |\n| &&
                      ` justify-content: space-around;` && |\n| &&
                      ` gap: 3px;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-close-btn {` && |\n| &&
                      ` color: #9b9b9b;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-close-btn:hover {` && |\n| &&
                      ` color: #000;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-arrow-side-left.driver-popover-arrow {` && |\n| &&
                      ` border-left-color: red;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-arrow-side-right.driver-popover-arrow {` && |\n| &&
                      ` border-right-color: red;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-arrow-side-top.driver-popover-arrow {` && |\n| &&
                      ` border-top-color: red;` && |\n| &&
                      `}` && |\n| &&
                      `.driver-popover.driverjs-theme .driver-popover-arrow-side-bottom.driver-popover-arrow {` && |\n| &&
                      ` border-bottom-color: red;` && |\n| &&
                      `}`.

      product  = 'tomato'.
      quantity = '500'.

      client->view_display( z2ui5_cl_xml_view=>factory(
        )->_z2ui5( )->timer(  client->_event( `START` )
        )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_driver_js=>get_js_cc( ) )->get_parent(
*         )->_cc( )->driver_js( )->load_cc( "js_url = `https://cdn.jsdelivr.net/npm/driver.js@1.0.1/dist/driver.js.iife.js`
*          )->_cc( )->driver_js( )->load_lib( local_js = abap_true "js_url = `https://cdn.jsdelivr.net/npm/driver.js@1.0.1/dist/driver.js.iife.js`
          )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_driver_js=>get_js_local( ) )->get_parent(
        )->stringify( ) ).

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
