CLASS z2ui5_cl_demo_app_361 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_361 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_util_xml=>factory( ).
      DATA(root) = view->__( n = `View` ns = `mvc`
          p = VALUE #( ( n = `displayBlock` v = abap_true )
                       ( n = `height`       v = `100%` )
                       ( n = `xmlns`        v = `sap.m` )
                       ( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ) ) ).

      DATA(page) = root->__( `Shell`
         )->__( n = `Page`
                p = VALUE #( ( n = `navButtonPress` v = client->_event_nav_app_leave( ) )
                             ( n = `showNavButton`  v = client->check_app_prev_stack( ) )
                             ( n = `title`          v = `abap2UI5 - System Logout` ) ) ).

      page->_(
          n = `Text`
          p = VALUE #(
                  ( n = `class`    v = `sapUiMediumMargin` )
                  ( n = `showIcon` v = abap_true )
                  ( n = `text`
                    v = `Trigger SYSTEM_LOGOUT on the client. Inside a Fiori Launchpad the shell container handles the sign-out; otherwise the app navigates to the ICF logoff endpoint.` )
                  ( n = `type`     v = `Information` ) )
         )->_( n = `Button`
               p = VALUE #( ( n = `class` v = `sapUiSmallMargin` )
                            ( n = `icon`  v = `sap-icon://log` )
                            ( n = `text`  v = `Logout now` )
                            ( n = `type`  v = `Reject` )
                            ( n = `press` v = client->_event_client( client->cs_event-system_logout ) ) ) ).

      page->_(
          n = `Text`
          p = VALUE #(
                  ( n = `class`    v = `sapUiMediumMargin` )
                  ( n = `showIcon` v = abap_true )
                  ( n = `text`
                    v = `Trigger SYSTEM_LOGOUT on the client and a redirect to google.com` )
                  ( n = `type`     v = `Information` ) )
         )->_( n = `Button`
               p = VALUE #( ( n = `class` v = `sapUiSmallMargin` )
                            ( n = `icon`  v = `sap-icon://log` )
                            ( n = `text`  v = `Logout now` )
                            ( n = `type`  v = `Reject` )
                            ( n = `press` v = client->_event_client(
                                                val   = client->cs_event-system_logout
                                                t_arg = value #( ( `/sap/public/bc/icf/logoff?redirecturl=www.google.com` ) )
                                              ) ) ) ).

      page->_( n = `Text`
               p = VALUE #( ( n = `class`    v = `sapUiMediumMargin` )
                            ( n = `showIcon` v = abap_true )
                            ( n = `text`     v = `Trigger Event LOGOUT which is handled in the APP.` )
                            ( n = `type`     v = `Information` ) )
         )->_( n = `Button`
               p = VALUE #( ( n = `class` v = `sapUiSmallMargin` )
                            ( n = `icon`  v = `sap-icon://log` )
                            ( n = `text`  v = `Logout now` )
                            ( n = `type`  v = `Reject` )
                            ( n = `press` v = client->_event( `LOGOUT` ) ) ) ).

      client->view_display( view->stringify( ) ).

    ELSE.

      IF client->check_on_event( `LOGOUT` ).
        client->action->gen( client->cs_event-system_logout ).
      ENDIF.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
