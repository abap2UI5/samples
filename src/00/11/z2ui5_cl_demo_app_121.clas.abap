CLASS z2ui5_cl_demo_app_121 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_121 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).

      view->shell(
            )->page(
                    title          = `abap2UI5`
                    navbuttonpress = client->_event_nav_app_leave( )
                    shownavbutton  = client->check_app_prev_stack( )
                )->simple_form(
                    title    = `Timer Interval 2000 ms`
                    editable = abap_true
                )->content( `form` ).

      client->view_display( view->stringify( ) ).

      client->action->gen(
          val   = z2ui5_if_client=>cs_event-start_timer
          t_arg = VALUE #( ( client->_event( `TIMER_FINISHED` ) ) ( `2000` ) ) ).

      RETURN.
    ENDIF.

    CASE client->get( )-event.
      WHEN `TIMER_FINISHED`.
        client->message_box_display( `Timer finished!` ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
