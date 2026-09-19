" @keywords logoff signout icf session end fiori launchpad
" @summary Ends the session from the client - the logoff an ICF session or a Fiori launchpad needs, triggered as a follow-up action.
CLASS z2ui5_cl_smp_app_361 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_361 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA temp1 TYPE string_table.

    IF client->check_on_navigated( ) IS NOT INITIAL.

      
      view = z2ui5_cl_ui5_view_builder=>factory(
          )->ele( n = `View` ns = `mvc`
              )->a( n = `displayBlock` v = `true`
              )->a( n = `height`       v = `100%`
              )->a( n = `xmlns`        v = `sap.m`
              )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
              )->a( n = `xmlns:core`   v = `sap.ui.core` ).
      
      page = view->ele( `Shell`
          )->ele( `Page`
              )->a( n = `title`          v = `abap2UI5 - Browser - Logout from the Client`
              )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
              )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

      page->tag( `MessageStrip`
          )->a( n = `text`     v = `follow_up_action( ) returned straight into the press attribute: the button carries SYSTEM_LOGOUT ` &&
                     `itself, so pressing it signs out on the client without ever reaching the backend. Inside a Fiori ` &&
                     `Launchpad the shell container handles the sign-out; otherwise the app navigates to the ICF logoff endpoint.`
          )->a( n = `type`     v = `Information`
          )->a( n = `showIcon` b = abap_true
          )->a( n = `class`    v = `sapUiMediumMargin`
          )->tag( `Button`
              )->a( n = `press` v = client->follow_up_action( client->cs_event-system_logout )
              )->a( n = `text`  v = `Logout (client)`
              )->a( n = `icon`  v = `sap-icon://log`
              )->a( n = `type`  v = `Reject`
              )->a( n = `class` v = `sapUiSmallMargin` ).

      
      CLEAR temp1.
      INSERT `/sap/public/bc/icf/logoff?redirecturl=www.google.com` INTO TABLE temp1.
      page->tag( `MessageStrip`
          )->a( n = `text`     v = `The same client-side call, but with an argument: t_arg passes the ICF logoff endpoint, here with a ` &&
                     `redirect to google.com appended. Still no backend roundtrip - the argument is baked into the view.`
          )->a( n = `type`     v = `Information`
          )->a( n = `showIcon` b = abap_true
          )->a( n = `class`    v = `sapUiMediumMargin`
          )->tag( `Button`
              )->a( n = `press` v = client->follow_up_action(
                          val   = client->cs_event-system_logout
                          t_arg = temp1 )
              )->a( n = `text`  v = `Logout (client, with redirect)`
              )->a( n = `icon`  v = `sap-icon://log`
              )->a( n = `type`  v = `Reject`
              )->a( n = `class` v = `sapUiSmallMargin` ).

      page->tag( `MessageStrip`
          )->a( n = `text`     v = `The other way round: _event( 'LOGOUT' ) makes the button call the backend, and follow_up_action( ) ` &&
                     `is invoked there on client - the identical SYSTEM_LOGOUT, only queued after the response renders. ` &&
                     `Take this route when the logout depends on backend logic, e.g. saving a draft first.`
          )->a( n = `type`     v = `Information`
          )->a( n = `showIcon` b = abap_true
          )->a( n = `class`    v = `sapUiMediumMargin`
          )->tag( `Button`
              )->a( n = `press` v = client->_event( `LOGOUT` )
              )->a( n = `text`  v = `Logout (via backend)`
              )->a( n = `icon`  v = `sap-icon://log`
              )->a( n = `type`  v = `Reject`
              )->a( n = `class` v = `sapUiSmallMargin` ).

      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `LOGOUT` ) IS NOT INITIAL.
      " same method as in the two buttons above, only called on client instead of
      " returned into the view - the action is queued and runs once this response renders
      client->follow_up_action( client->cs_event-system_logout ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
