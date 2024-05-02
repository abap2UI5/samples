CLASS z2ui5_cl_demo_app_198 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA product TYPE string .
    DATA quantity TYPE string .
    DATA check_initialized TYPE abap_bool .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_198 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

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
                        press = client->_event( val = 'BUTTON_POST' t_arg = VALUE #( ( `$event.mParameters` ) ) )
             )->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'BUTTON_POST'.
        DATA(lt_arg) = client->get( )-t_event_arg.
        DATA(lv_json) = lt_arg[ 1 ].
        DATA(lo_json) = z2ui5_cl_ajson=>parse( lv_json ).
        DATA(lv_id) = lo_json->get( `/id`).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
