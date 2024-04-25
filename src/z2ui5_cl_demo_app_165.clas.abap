CLASS z2ui5_cl_demo_app_165 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS ui5_display.
    METHODS ui5_event.
    METHODS ui5_callback.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_165 IMPLEMENTATION.


  METHOD ui5_event.

    CASE client->get( )-event.

      WHEN 'POPUP'.
        TRY.
            DATA(lv_dummy) = 1 / 0.
          CATCH cx_root INTO DATA(lx).
        ENDTRY.
        DATA(lo_app) = z2ui5_cl_pop_error=>factory( lx ).
        client->nav_app_call( lo_app ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD ui5_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Popup Error'
                navbuttonpress = client->_event( val = 'BACK' )
                shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            )->header_content(
                )->link(
                    text = 'Source_Code'
                    target = '_blank'

                    )->get_parent(
           )->button(
            text  = 'Open Popup...'
            press = client->_event( 'POPUP' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.
      ui5_display( ).
      ui5_callback( ).
      RETURN.
    ENDIF.

    ui5_event( ).

  ENDMETHOD.

  METHOD ui5_callback.

    TRY.
        DATA(lo_prev) = client->get_app( client->get(  )-s_draft-id_prev_app ).
        DATA(lo_dummy) = CAST z2ui5_cl_pop_to_inform( lo_prev ).
        client->message_box_display( `callback after popup to inform` ).
      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
