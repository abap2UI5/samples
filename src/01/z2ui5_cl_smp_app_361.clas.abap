" @keywords logoff signout icf session end fiori launchpad
CLASS z2ui5_cl_smp_app_361 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_361 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
          )->page(
              title          = `abap2UI5 - Browser - Logout from the Client`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      page->message_strip(
          text     = `follow_up_action( ) returned straight into the press attribute: the button carries SYSTEM_LOGOUT ` &&
                     `itself, so pressing it signs out on the client without ever reaching the backend. Inside a Fiori ` &&
                     `Launchpad the shell container handles the sign-out; otherwise the app navigates to the ICF logoff endpoint.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiMediumMargin`
      )->button(
          text  = `Logout (client)`
          icon  = `sap-icon://log`
          type  = `Reject`
          class = `sapUiSmallMargin`
          press = client->follow_up_action( client->cs_event-system_logout ) ).

      page->message_strip(
          text     = `The same client-side call, but with an argument: t_arg passes the ICF logoff endpoint, here with a ` &&
                     `redirect to google.com appended. Still no backend roundtrip - the argument is baked into the view.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiMediumMargin`
      )->button(
          text  = `Logout (client, with redirect)`
          icon  = `sap-icon://log`
          type  = `Reject`
          class = `sapUiSmallMargin`
          press = client->follow_up_action(
                      val   = client->cs_event-system_logout
                      t_arg = VALUE #( ( `/sap/public/bc/icf/logoff?redirecturl=www.google.com` ) ) ) ).

      page->message_strip(
          text     = `The other way round: _event( 'LOGOUT' ) makes the button call the backend, and follow_up_action( ) ` &&
                     `is invoked there on client - the identical SYSTEM_LOGOUT, only queued after the response renders. ` &&
                     `Take this route when the logout depends on backend logic, e.g. saving a draft first.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiMediumMargin`
      )->button(
          text  = `Logout (via backend)`
          icon  = `sap-icon://log`
          type  = `Reject`
          class = `sapUiSmallMargin`
          press = client->_event( `LOGOUT` ) ).

      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `LOGOUT` ).
      " same method as in the two buttons above, only called on client instead of
      " returned into the view - the action is queued and runs once this response renders
      client->follow_up_action( client->cs_event-system_logout ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
