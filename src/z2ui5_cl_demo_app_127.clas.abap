CLASS z2ui5_cl_demo_app_127 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

*    DATA product  TYPE string.
*    DATA quantity TYPE string.
    DATA check_initialized TYPE abap_bool.

    DATA:
      BEGIN OF nav_params,
        product  TYPE string,
        quantity TYPE string,
      END OF nav_params.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_127 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    DATA(lt_startup_params) = client->get( )-s_config-t_startup_params.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      nav_params-product  = '102343333'.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      client->view_display( view->shell(
            )->page(
                     showheader       = xsdbool( abap_false = client->get( )-check_launchpad_active )
                    title          = 'abap2UI5 - Cross App Navigation App 127 - This App only works when started via Launchpad'
                    navbuttonpress = client->_event( val = 'BACK' )
                    shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
                )->header_content(
                    )->link(
                        text = 'Source_Code'

                        target = '_blank'
                )->get_parent(
                )->simple_form( title = 'App 127' editable = abap_true
                    )->content( 'form'
                        )->label( `Product`
                        )->input( client->_bind_edit( nav_params-product )
                        )->button(  text  = 'BACK' press = client->_event_client( client->cs_event-cross_app_nav_to_prev_app )
                        )->button(
                            text  = 'go to app 128'
                            press = client->_event_client(
            val    = client->cs_event-cross_app_nav_to_ext
            t_arg  = VALUE #(
                ( `{ semanticObject: "Z2UI5_CL_DEMO_APP_128",  action: "Z2UI5_CL_DEMO_APP_128" }` )
*                ( `{ "Product" : "102343333" }` )
                ( `$` && client->_bind_edit( nav_params ) )
                 )
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
