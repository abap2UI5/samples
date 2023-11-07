CLASS Z2UI5_CL_DEMO_APP_128 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE string.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_128 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      product  = 'tomato'.
      quantity = '500'.

      DATA(view) = Z2UI5_cl_xml_view=>factory( client ).
      client->view_display( view->shell(
            )->page(
                    title          = 'abap2UI5 -  Cross App Navigation App 128'
                    navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                    shownavbutton  = abap_true
                )->header_content(
                    )->link(
                        text = 'Source_Code'
                        href = view->hlp_get_source_code_url(  )
                        target = '_blank'
                )->get_parent(
                )->simple_form( title = 'Form Title' editable = abap_true
                    )->content( 'form'
                        )->title( 'Input'
                        )->label( 'quantity'
                        )->input( client->_bind_edit( quantity )
                        )->label( `product`
                        )->input( value = product enabled = abap_false
                          )->button(
                            text  = 'BACK' press = client->_event_client( client->cs_event-cross_app_nav_to_prev_app )
                        )->button(
                            text  = 'go to app 127'
                            press = client->_event_client(
            val    = client->cs_event-cross_app_nav_to_ext
            t_arg  = value #( ( `{ semanticObject: "Z2UI5_CL_DEMO_APP_127",  action: "Z2UI5_CL_DEMO_APP_127" }` )  )
        )
             )->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'BUTTON_POST'.

*        client->message_toast_display( |{ product } { quantity } - send to the server| ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
