CLASS z2ui5_cl_demo_app_lp_02 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_title TYPE string VALUE `my title`.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_lp_02 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      IF client->get( )-check_launchpad_active = abap_false.
        client->message_box_display( `No Launchpad Active, Sample not working!` ).
      ENDIF.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell( )->page(
          showheader     = abap_false
          navbuttonpress = client->_event_nav_app_leave( )
          shownavbutton  = client->check_app_prev_stack( ) ).

      page->simple_form(
              title    = `Set Launchpad Title Dynamically`
              editable = abap_true
          )->content( `form`
          )->label( ``
          )->input( client->_bind_edit( mv_title )
          )->label( ``
          )->button(
              text  = `Set Title`
              press = client->_event( `SET_TITLE` )
          )->button(
              text  = `Go Back`
              press = client->_event_nav_app_leave( ) ).

      client->view_display( view->stringify( ) ).

      client->action->gen(
          val   = z2ui5_if_client=>cs_event-set_title_launchpad
          t_arg = VALUE #( ( mv_title ) ) ).

    ELSEIF client->check_on_event( `SET_TITLE` ).

      client->action->gen(
          val   = z2ui5_if_client=>cs_event-set_title_launchpad
          t_arg = VALUE #( ( mv_title ) ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
