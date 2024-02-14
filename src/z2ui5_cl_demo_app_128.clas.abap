CLASS z2ui5_cl_demo_app_128 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA product  TYPE string.
    DATA product_url  TYPE string.
    DATA quantity TYPE string.
    DATA check_initialized TYPE abap_bool.
    DATA check_launchpad_active TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_128 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    product_url = z2ui5_cl_util=>url_param_get(
                    val =  `product`
                    url = client->get( )-s_config-search ).
    check_launchpad_active = client->get( )-check_launchpad_active.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      product  = 'tomato'.
      quantity = '500'.

      client->view_display( view->shell(
            )->page(
                    showheader       = xsdbool( abap_false = client->get( )-check_launchpad_active )
                    title          = 'abap2UI5 -  Cross App Navigation App 128'
                    navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                    shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
                )->header_content(
                    )->link(
                        text = 'Source_Code'
                        href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                        target = '_blank'
                )->get_parent(
                )->simple_form( title = 'App 128' editable = abap_true
                    )->content( 'form'
                        )->title( 'Input'
                        )->label( 'product'
                        )->input( client->_bind_edit( product )
                        )->label( `quantity`
                        )->input( client->_bind_edit( quantity )
                        )->label( `url param product`
                        )->input( product_url
                        )->label( `CHECK_LAUNCHPAD_ACTIVE`
                        )->input( check_launchpad_active
                        )->button( press = client->_event(  )
                        )->button( text = 'BACK' press = client->_event_client( client->cs_event-cross_app_nav_to_prev_app )
                        )->button(
                            text  = 'go to app 127'
                            press = client->_event_client(
            val    = client->cs_event-cross_app_nav_to_ext
            t_arg  = VALUE #( ( `{ semanticObject: "Z2UI5_CL_DEMO_APP_127",  action: "Z2UI5_CL_DEMO_APP_127" }` ) ( `{ ProductID : "123234" }`) )
        )
             )->stringify( ) ).

    ENDIF.

    client->view_model_update( ).

    CASE client->get( )-event.

      WHEN 'BUTTON_POST'.

*        client->message_toast_display( |{ product } { quantity } - send to the server| ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
