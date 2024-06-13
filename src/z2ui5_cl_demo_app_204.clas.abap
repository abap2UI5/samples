CLASS z2ui5_cl_demo_app_204 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_arbgb TYPE string.

  PROTECTED SECTION.
    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS on_init.
    METHODS on_event.
    METHODS render_main.
    METHODS call_f4.

  PRIVATE SECTION.
    METHODS on_after_f4.

ENDCLASS.


CLASS z2ui5_cl_demo_app_204 IMPLEMENTATION.

  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN `CALL_POPUP_F4`.

        call_f4( ).

      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.

  METHOD on_init.

    render_main( ).

  ENDMETHOD.

  METHOD render_main.

    DATA(view) = z2ui5_cl_xml_view=>factory( ). "->shell( ).

    DATA(page) = view->shell( )->page(
                     title          = 'Layout'
                     navbuttonpress = client->_event( 'BACK' )
                     shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
                     class          = 'sapUiContentPadding' ).

    page->simple_form( title    = 'F4-Help'
                       editable = abap_true
                    )->content( 'form'
                        )->text( `Table t100 field ARBGB is linked to table t100a field ARBGB via a foreign key link.`
                        )->label( `ARBGB`
                        )->input( value            = client->_bind_edit( mv_arbgb )
                                  showvaluehelp    = abap_true
                                  valuehelprequest = client->_event( val   = 'CALL_POPUP_F4'
                                                                     t_arg = VALUE #( ( `ARBGB` ) ( `T100` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      on_init( ).
    ENDIF.

    on_event( ).

    on_after_f4( ).

  ENDMETHOD.

  METHOD call_f4.

    DATA(lt_arg) = client->get( )-t_event_arg.

    DATA(f4_field) = VALUE string( lt_arg[ 1 ] ).
    DATA(f4_table) = VALUE string( lt_arg[ 2 ] ).

    client->nav_app_call( z2ui5_cl_pop_f4_help=>factory( i_table = f4_table
                                                         i_fname = f4_field
                                                         i_value = CONV #( mv_arbgb ) ) ).

  ENDMETHOD.

  METHOD on_after_f4.

    IF client->get( )-check_on_navigated = abap_false.
      RETURN.
    ENDIF.

    TRY.
        DATA(app) = CAST z2ui5_cl_pop_f4_help( client->get_app( client->get( )-s_draft-id_prev_app ) ).

        IF app->mv_return_value IS NOT INITIAL.

          CASE app->mv_field.
            WHEN `ARBGB`.

              mv_arbgb = CONV #( app->mv_return_value ).

            WHEN OTHERS.

          ENDCASE.

          client->view_model_update( ).

        ENDIF.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
