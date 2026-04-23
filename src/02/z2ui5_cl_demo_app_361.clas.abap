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

      page->__( `headerContent`
         )->_( n = `Button`
               p = VALUE #( ( n = `icon`    v = `sap-icon://log` )
                            ( n = `text`    v = `Logout` )
                            ( n = `tooltip` v = `Sign out of the current session` )
                            ( n = `press`   v = client->_event_client( client->cs_event-system_logout ) ) ) ).

      page->__( n = `MessageStrip`
             p = VALUE #( ( n = `class`    v = `sapUiMediumMargin` )
                          ( n = `showIcon` v = abap_true )
                          ( n = `text`     v = `This demo shows the new system logout event. Pressing the button below triggers SYSTEM_LOGOUT on the client. Inside a Fiori Launchpad the shell container handles the sign-out; otherwise the app navigates to the ICF logoff endpoint.` )
                          ( n = `type`     v = `Information` ) )
         )->_( n = `Button`
               p = VALUE #( ( n = `class` v = `sapUiSmallMargin` )
                            ( n = `icon`  v = `sap-icon://log` )
                            ( n = `text`  v = `Logout now` )
                            ( n = `type`  v = `Reject` )
                            ( n = `press` v = client->_event_client( client->cs_event-system_logout ) ) ) ).

      client->view_display( view->stringify( ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
