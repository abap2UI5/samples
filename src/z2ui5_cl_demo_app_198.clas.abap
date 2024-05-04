class Z2UI5_CL_DEMO_APP_198 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data PRODUCT type STRING .
  data QUANTITY type STRING .
  data CHECK_INITIALIZED type ABAP_BOOL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_198 IMPLEMENTATION.


  METHOD Z2UI5_IF_APP~MAIN.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      product  = 'tomato'.
      quantity = '500'.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      view->_generic( ns = `html` name = `style` )->_cc_plain_xml( `.my-style{ background: black !important; opacity: 0.6; color: white; }` ).
      client->view_display( view->shell(
            )->page(
                    title          = 'abap2UI5 - First Example'
                    navbuttonpress = client->_event( val = 'BACK' s_ctrl = VALUE #( check_view_destroy = abap_true ) )
                    shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
                    )->button(
                        text  = 'post'
                        press = client->_event( val = 'BUTTON_POST' t_arg = VALUE #( ( `$event` ) ) )
             )->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'BUTTON_POST'.
        DATA(lt_arg) = client->get( )-t_event_arg.

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
