CLASS z2ui5_cl_demo_app_350 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
    DATA check_initialized TYPE abap_bool.
    DATA: view_id TYPE i.
    DATA text TYPE string VALUE 'call booking mask'.
    DATA varkey TYPE char120.

    METHODS initialize_view2
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS z2ui5_cl_demo_app_350 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF view_id IS INITIAL OR view_id = 1.
      view_id = 1.
      TRY.
          IF client->check_on_init( ) OR client->check_on_navigated( ).
            DATA(view) = z2ui5_cl_xml_view=>factory( ).
            DATA(page) = view->shell( )->page(
              title = `Startview` ).
            page->simple_form(
                  )->content( 'form'
                               )->button(
                                   text  = client->_bind_edit( text )
                                   width = '20%'
                                   press = client->_event( 'CALL_BOOKING_MASK' ) ).
            client->view_display( view->stringify( ) ).
            "client->set_app_state_active( ).
            RETURN.
          ENDIF.

          CASE client->get( )-event.
            WHEN `CALL_BOOKING_MASK`.
              DATA: lf_key TYPE n LENGTH 4.
              DATA(lr_view2) = NEW z2ui5_cl_demo_app_350( ).
              lr_view2->view_id = 2.
              lr_view2->varkey = '001'.
              client->nav_app_call( lr_view2 ).
              RETURN.
            WHEN `BACK`.
              client->nav_app_leave( ).
              RETURN.
          ENDCASE.

          client->view_model_update( ).
        CATCH cx_root INTO DATA(lx).
          client->message_box_display( lx ).
      ENDTRY.

    ELSEIF view_id = 2.
      TRY.
          IF check_initialized = abap_false.
            check_initialized = abap_true.

            DATA(lv_fm) = 'ENQUEUE_E_TABLE'.
            CALL FUNCTION lv_fm
              EXPORTING
                tabname        = 'ZTEST'
                varkey         = varkey
              EXCEPTIONS
                foreign_lock   = 1
                system_failure = 2
                OTHERS         = 3.
            IF sy-subrc <> 0.
              client->set_session_stateful( abap_false ).
              client->nav_app_leave( ).
            ELSE.
              client->set_session_stateful( ).
              initialize_view2( client ).
            ENDIF.
            RETURN.
          ENDIF.

          IF client->check_on_navigated( ).
            client->set_session_stateful( abap_false ).
            TRY.
                client->nav_app_leave( ).
                RETURN.
              CATCH cx_sy_move_cast_error ##NO_HANDLER ##CATCH_ALL.
            ENDTRY.
          ENDIF.

          CASE client->get( )-event.
            WHEN `NEXT_LOCK`.
              client->set_session_stateful( abap_false ).
              lr_view2 = NEW z2ui5_cl_demo_app_350( ).
              lr_view2->view_id = 2.
              DATA: lf_new_varkey TYPE n LENGTH 4.
              lf_new_varkey = varkey+0(4).
              lf_new_varkey = lf_new_varkey + 1.
              lr_view2->varkey = lf_new_varkey+0(4).
              client->nav_app_call( lr_view2 ).
              RETURN.
            WHEN `BACK`.
              client->set_session_stateful( abap_false ).
              client->nav_app_leave( ).
              RETURN.
          ENDCASE.
          client->view_model_update( ).

        CATCH cx_root INTO lx.
          client->message_box_display( lx ).
      ENDTRY.
    ENDIF.
  ENDMETHOD.

  METHOD initialize_view2.
    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell( )->page(
      title          = `Stateful Application with lock`
      navbuttonpress = client->_event( 'BACK' )
      shownavbutton  = client->check_app_prev_stack( ) ).
    DATA(vbox) = page->vbox( ).
    DATA(hbox) = vbox->hbox( alignitems = 'Center' ).
    hbox->title(
      text = 'Current Lock Value in Table ZTEST' ).
    hbox->input(
      editable = abap_false
      value    = client->_bind_edit( varkey ) ).
    hbox->button(
      text  = 'Next Lock View'
      press = client->_event( 'NEXT_LOCK' ) ).
    client->view_display( view->stringify( ) ).
  ENDMETHOD.


ENDCLASS.
