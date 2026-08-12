CLASS z2ui5_cl_smp_app_482 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA title TYPE string VALUE `my title`.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_482 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      IF client->get( )-check_launchpad_active = abap_false.
        client->message_box_display( `No Launchpad Active, Sample not working!` ).
      ENDIF.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell( )->page( showheader = abap_false ).

      page->message_strip(
          text     = `Sets the launchpad shell title from the backend via follow_up_action( ` &&
                     `cs_event-set_title_launchpad ) - type a title and press Set Title, the ` &&
                     `header above changes without a view rebuild. Only works inside a launchpad.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiSmallMargin` ).

      page->simple_form(
              title    = `Set Shell Title`
              editable = abap_true
          )->content( `form`
          )->label( ``
          )->input( client->_bind( title )
          )->label( ``
          )->button(
              text  = `Set Title`
              press = client->_event( `SET_TITLE` )
          )->button(
              text  = `Go Back`
              press = client->_event_nav_app_leave( ) ).

      client->view_display( view->stringify( ) ).

      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-set_title_launchpad
          t_arg = VALUE #( ( title ) ) ).

    ELSEIF client->check_on_event( `SET_TITLE` ).

      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-set_title_launchpad
          t_arg = VALUE #( ( title ) ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
