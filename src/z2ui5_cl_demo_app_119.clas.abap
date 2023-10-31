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

    METHODS view_main.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_119 IMPLEMENTATION.


  METHOD view_main.

    DATA(view) = z2ui5_cl_xml_view=>factory( client ).

    view->_cc_plain_xml( `<html:style>` && z2ui5_cl_cc_driver_js=>get_css_local( ) && `</html:style>` )->get_parent( ).

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

      product  = 'tomato'.
      quantity = '500'.

      client->view_display( z2ui5_cl_xml_view=>factory( client
        )->_cc( )->driver_js( )->load_lib( local_js = abap_true "js_url = `https://cdn.jsdelivr.net/npm/driver.js@1.0.1/dist/driver.js.iife.js`
        )->stringify( ) ).

      client->timer_set( event_finished = client->_event( `LOAD_DRIVE_CONFIG` ) interval_ms = `0` ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'LOAD_DRIVE_CONFIG'.
        client->view_display( z2ui5_cl_xml_view=>factory( client
        )->_cc( )->driver_js( )->set_drive_config( config = ms_drive_config
        )->stringify( ) ).

*      client->view_display( z2ui5_cl_xml_view=>factory( client
*        )->_cc_plain_xml( z2ui5_cl_fw_driver_js=>start_drive( )
*        )->stringify( ) ).

        client->timer_set( event_finished = client->_event( `START` ) interval_ms = `0` ).

      WHEN 'START'.

        view_main( ).

      WHEN 'BUTTON_POST'.
        client->message_toast_display( |{ product } { quantity } - send to the server| ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
