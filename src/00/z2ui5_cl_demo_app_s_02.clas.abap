CLASS z2ui5_cl_demo_app_s_02 DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
    DATA mv_instance_counter TYPE i READ-ONLY.
    DATA mv_check_initialized TYPE abap_bool READ-ONLY.
    DATA mv_session_is_stateful TYPE abap_bool READ-ONLY.
    DATA mv_session_text TYPE string READ-ONLY.

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

ENDCLASS.

CLASS z2ui5_cl_demo_app_s_02 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    TRY.

        IF mv_check_initialized = abap_false.
          mv_check_initialized = abap_true.
          initialize_view( client ).
        ENDIF.

        on_event( client ).

      CATCH cx_root INTO DATA(lx).
        client->message_box_display( lx->get_text( ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD initialize_view.

    set_session_stateful( client   = client
                          stateful = abap_true ).

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_page) = lo_view->shell( )->page(
      title          = `abap2UI5 - Sample: Sticky Session`
      navbuttonpress = client->_event_nav_app_leave( )
      shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(lo_vbox) = lo_page->vbox( ).
    lo_vbox->info_label( text = client->_bind( mv_session_text ) ).

    DATA(lo_hbox) = lo_vbox->hbox( alignitems = `Center` ).
    lo_hbox->label( text  = `press button to increment counter in backend session`
                 class = `sapUiTinyMarginEnd` ).
    lo_hbox->button(
      text  = client->_bind( mv_instance_counter )
      press = client->_event( `INCREMENT` )
      type  = `Emphasized` ).

    lo_hbox = lo_vbox->hbox( ).
    lo_hbox->button(
      text  = `End session`
      press = client->_event( `END_SESSION` ) ).

    lo_hbox->button(
      text  = `Start session again`
      press = client->_event( `START_SESSION` ) ).

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    CASE client->get( )-event.
      WHEN `BACK`.
        set_session_stateful( client   = client
                              stateful = abap_false ).
        client->nav_app_leave( ).
      WHEN `INCREMENT`.
        mv_instance_counter = lcl_static_container=>increment( ).
        client->view_model_update( ).
      WHEN `END_SESSION`.
        set_session_stateful( client   = client
                              stateful = abap_false ).
      WHEN `START_SESSION`.
        set_session_stateful( client   = client
                              stateful = abap_true ).
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
ENDCLASS.
