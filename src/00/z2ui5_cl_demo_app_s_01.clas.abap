CLASS z2ui5_cl_demo_app_s_01 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_lock_counter TYPE i READ-ONLY .
    DATA mv_check_initialized TYPE abap_bool READ-ONLY .
    DATA mv_session_is_stateful TYPE abap_bool READ-ONLY .
    DATA mv_session_text TYPE string READ-ONLY .
    DATA mv_lock_text TYPE string READ-ONLY .
    DATA:
      BEGIN OF error READ-ONLY,
        text TYPE string,
        flag TYPE abap_bool,
      END OF error.

  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS initialize_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS set_session_stateful
      IMPORTING
        client   TYPE REF TO z2ui5_if_client
        stateful TYPE abap_bool.

    METHODS update_lock_counter.

ENDCLASS.

CLASS z2ui5_cl_demo_app_s_01 IMPLEMENTATION.

  METHOD initialize_view.

    set_session_stateful( client   = client
                          stateful = abap_true ).

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_page) = lo_view->shell( )->page(
      title          = `abap2UI5 - Sample: Sticky Session with locks - (ABAP Standard Only)`
      navbuttonpress = client->_event_nav_app_leave( )
      shownavbutton  = client->check_app_prev_stack( ) ).

    lo_page->message_strip(
        text    = client->_bind( error-text )
        type    = `Error`
        visible = client->_bind( error-flag ) ).

    DATA(lo_vbox) = lo_page->vbox( ).

    DATA(lo_hbox) = lo_vbox->hbox( alignitems = `Center` ).

    lo_hbox->info_label( text = client->_bind( mv_session_text ) ).

    lo_hbox->button(
      text  = `End session`
      press = client->_event( `END_SESSION` ) ).

    lo_hbox->button(
      text  = `Start session again`
      press = client->_event( `START_SESSION` ) ).

    lo_hbox = lo_vbox->hbox( alignitems = `Center` ).
    lo_hbox->label( text  = `press button to create lock entry (SM12) in backend session`
                 class = `sapUiTinyMarginEnd` ).
    lo_hbox->button(
      text  = `Lock`
      press = client->_event( `LOCK` )
      type  = `Emphasized` ).

    lo_hbox = lo_vbox->hbox( ).

    lo_hbox->button(
      text  = `Refresh lock counter`
      press = client->_event( `REFRESH` ) ).

    lo_hbox->button(
      text  = `Rollback Work`
      press = client->_event( `ROLLBACK` ) ).

    lo_vbox->hbox( )->info_label( client->_bind( mv_lock_text ) ).

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    CASE client->get( )-event.
      WHEN `BACK`.
        set_session_stateful( client   = client
                              stateful = abap_false ).
        client->nav_app_leave( ).
      WHEN `LOCK`.
        lcl_locking=>acquire_lock( ).
        client->message_toast_display( `Lock acquired. Press 'Refresh lock counter'` ).
        client->view_model_update( ).
      WHEN `END_SESSION`.
        set_session_stateful( client   = client
                              stateful = abap_false ).
      WHEN `START_SESSION`.
        set_session_stateful( client   = client
                              stateful = abap_true ).
      WHEN `REFRESH`.
        update_lock_counter( ).
        client->view_model_update( ).
      WHEN `ROLLBACK`.
        ROLLBACK WORK.
        client->message_toast_display( |ROLLBACK WORK done, { mv_lock_counter } locks released. Press `Refresh lock counter`| ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_session_stateful.

    client->set_session_stateful( stateful ).
    mv_session_is_stateful = stateful.
    IF stateful = abap_true.
      mv_session_text = `Session ON (stateful)`.
    ELSE.
      mv_session_text = `Session OFF (stateless)`.
    ENDIF.
    client->view_model_update( ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    TRY.

        CLEAR error.

        IF mv_check_initialized = abap_false.
          mv_check_initialized = abap_true.
          update_lock_counter( ).
          initialize_view( client ).
        ENDIF.

        TRY.
            on_event( client ).
          CATCH z2ui5_cx_util_error INTO DATA(x_error).
            error-text = x_error->get_text( ).
            error-flag = abap_true.
            client->view_model_update( ).
        ENDTRY.

      CATCH cx_root INTO DATA(lx).
        client->message_box_display( lx->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD update_lock_counter.

    mv_lock_counter = lcl_locking=>get_lock_counter( ).
    mv_lock_text = |There are { mv_lock_counter } SM12 locks|.
  ENDMETHOD.
ENDCLASS.
