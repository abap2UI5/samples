CLASS z2ui5_cl_demo_app_071 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF s_combobox.
    TYPES ty_t_combo TYPE STANDARD TABLE OF s_combobox WITH EMPTY KEY.

    DATA mv_set_size_limit TYPE i VALUE 100.
    DATA mv_combo_number TYPE i VALUE 105.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_071 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    CASE client->get( )-event.
      WHEN `UPDATE`.
        client->follow_up_action( client->_event_client(
                                    val   = `SET_SIZE_LIMIT`
                                    t_arg = value #( ( conv #( mv_set_size_limit ) ) ( client->cs_view-main ) )
                        )    ).
        client->view_model_update( ).
        client->message_toast_display( `SizeLimitUpdated` ).
*        RETURN.

      WHEN 'BACK'.
        client->nav_app_leave( ).
        RETURN.
    ENDCASE.



    DATA(lt_combo) = VALUE ty_T_combo( ).
    DO mv_combo_number TIMES.
      INSERT VALUE #( key = sy-index text = sy-index ) INTO TABLE lt_combo.
    ENDDO.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    client->view_display( val = view->shell(
         )->page(
                 title          = 'abap2UI5 - First Example'
                 navbuttonpress = client->_event( val = 'BACK' s_ctrl = VALUE #( check_view_destroy = abap_true ) )
                 shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
             )->simple_form( title = 'Form Title' editable = abap_true
                 )->content( 'form'
                     )->title( 'Input'
                     )->label( 'Link'
                     )->label( 'setSizeLimit'
                     )->input( value =  client->_bind_edit( mv_set_size_limit )
                     )->label( 'Number of Entries'
                     )->input( value =  client->_bind_edit( mv_combo_number )
                     )->label( 'demo'
                     )->combobox( items = client->_bind_local( lt_combo )
                        )->item( key = '{KEY}' text = '{TEXT}'
                        )->get_parent( )->get_parent(
                     )->button(
                         text  = 'Press 2x update'
                         press = client->_event( val = 'UPDATE' )
        )->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
