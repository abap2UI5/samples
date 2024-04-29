CLASS z2ui5_cl_demo_app_001 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE string.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_001 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      product  = 'tomato'.
      quantity = '500'.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      client->view_display( view->shell(
            )->page(
                    title          = 'abap2UI5 - First Example'
                    navbuttonpress = client->_event( val = 'BACK' s_ctrl = VALUE #( check_view_destroy = abap_true ) )
                    shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
                )->simple_form( title = 'Form Title' editable = abap_true
                    )->content( 'form'
                        )->title( 'Input'
                        )->label( 'quantity'
                        )->input( client->_bind_edit( quantity )
                        )->label( `product`
                        )->input( value = product enabled = abap_false
                        )->button(
                            text  = 'post'
                            press = client->_event( val = 'BUTTON_POST' )
             )->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'BUTTON_POST'.
        client->message_toast_display( text = |{ product } { quantity } - send to the server| at = 'left bottom' offset = '0 -15' animationtimingfunction = `ease-in` ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
