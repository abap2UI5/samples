CLASS zcl_2ui5_start DEFINITION DEFERRED.
CLASS zcl_2ui5_lock DEFINITION DEFERRED.

CLASS zcl_2ui5_start DEFINITION INHERITING FROM z2ui5_cl_demo_app_351.
  PUBLIC SECTION.
    DATA text TYPE string VALUE 'call booking mask'.
    METHODS z2ui5_if_app~main                       REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_2ui5_lock DEFINITION INHERITING FROM z2ui5_cl_demo_app_351.
  PUBLIC SECTION.
    DATA check_initialized TYPE abap_bool.
    DATA varkey TYPE char120.
    METHODS z2ui5_if_app~main                       REDEFINITION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS initialize_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS set_session_stateful
      IMPORTING
        client   TYPE REF TO z2ui5_if_client
        stateful TYPE abap_bool.
ENDCLASS.

CLASS zcl_2ui5_start IMPLEMENTATION.
  METHOD z2ui5_if_app~main.
    TRY.
        IF client->check_on_init( ) OR client->check_on_navigated( )..
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
          client->set_app_state_active( ).
          RETURN.
        ENDIF.
      "  IF client->check_on_navigated( ).
      "    client->view_model_update( ).
     "     RETURN.
      "  ENDIF.
        CASE client->get( )-event.
          WHEN `CALL_BOOKING_MASK`.
            DATA: lf_key TYPE n LENGTH 4.
            DATA(lr_2ui5_lock) = NEW zcl_2ui5_lock( ).
            lr_2ui5_lock->varkey = '0001'.
            client->nav_app_call( lr_2ui5_lock ).
          WHEN `BACK`.
            client->nav_app_leave( ).
        ENDCASE.
        client->view_model_update( ).
      CATCH cx_root INTO DATA(lx).
        client->message_box_display( lx ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.

CLASS zcl_2ui5_lock IMPLEMENTATION.

  METHOD initialize_view.
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

  METHOD set_session_stateful.
    client->set_session_stateful( stateful ).
    client->view_model_update( ).
  ENDMETHOD.


  METHOD z2ui5_if_app~main.
    TRY.
        IF check_initialized = abap_false.
          check_initialized = abap_true.
          set_session_stateful( client   = client
                                stateful = abap_true ).
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
            DATA(lo_prev_stack_app) = client->get_app( client->get( )-s_draft-id_prev_app_stack ).
            set_session_stateful( client   = client
                                  stateful = abap_false ).
            client->nav_app_leave( lo_prev_stack_app ).
          ELSE.
            initialize_view( client ).
          ENDIF.
          RETURN.
        ENDIF.
        IF client->check_on_navigated( ).
          set_session_stateful( client   = client
                                stateful = abap_false ).
          TRY.
              DATA(lo_prev_z2ui5_start) = CAST zcl_2ui5_start( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
              client->nav_app_leave( lo_prev_z2ui5_start ).
              RETURN.
            CATCH cx_sy_move_cast_error ##NO_HANDLER ##CATCH_ALL.
          ENDTRY.
          TRY.
              DATA(lo_prev_z2ui5_lock) = CAST zcl_2ui5_lock( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
              client->nav_app_leave( lo_prev_z2ui5_lock ).
              RETURN.
            CATCH cx_sy_move_cast_error ##NO_HANDLER ##CATCH_ALL.
          ENDTRY.
        ENDIF.
        CASE client->get( )-event.
          WHEN `NEXT_LOCK`.
            set_session_stateful( client   = client
                                  stateful = abap_false ).
            DATA(lo_2ui5_lock) = NEW zcl_2ui5_lock( ).
            DATA: lf_new_varkey TYPE n LENGTH 4.
            lf_new_varkey = varkey+0(4).
            lf_new_varkey = lf_new_varkey + 1.
            lo_2ui5_lock->varkey = lf_new_varkey+0(4).
            client->nav_app_call( lo_2ui5_lock ).
          WHEN `BACK`.
            lo_prev_stack_app = client->get_app( client->get( )-s_draft-id_prev_app_stack ).
            set_session_stateful( client   = client
                                  stateful = abap_false ).
            client->nav_app_leave( lo_prev_stack_app ).
        ENDCASE.
        client->view_model_update( ).
      CATCH cx_root INTO DATA(lx).
        client->message_box_display( lx->get_text( ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
