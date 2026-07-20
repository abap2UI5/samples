CLASS z2ui5_cl_demo_app_361 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_361 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA view TYPE REF TO z2ui5_cl_xml_view.
      DATA page TYPE REF TO z2ui5_cl_xml_view.
      DATA temp1 TYPE string_table.

    IF client->check_on_init( ) IS NOT INITIAL.

      
      view = z2ui5_cl_xml_view=>factory( ).
      
      page = view->shell(
          )->page(
              title          = `abap2UI5 - System Logout`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      page->message_strip(
          text     = `Trigger SYSTEM_LOGOUT on the client. Inside a Fiori Launchpad the shell container handles the sign-out; otherwise the app navigates to the ICF logoff endpoint.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiMediumMargin`
      )->button(
          text  = `Logout now`
          icon  = `sap-icon://log`
          type  = `Reject`
          class = `sapUiSmallMargin`
          press = client->_event_client( client->cs_event-system_logout ) ).

      
      CLEAR temp1.
      INSERT `/sap/public/bc/icf/logoff?redirecturl=www.google.com` INTO TABLE temp1.
      page->message_strip(
          text     = `Trigger SYSTEM_LOGOUT on the client and a redirect to google.com`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiMediumMargin`
      )->button(
          text  = `Logout now`
          icon  = `sap-icon://log`
          type  = `Reject`
          class = `sapUiSmallMargin`
          press = client->_event_client(
                      val   = client->cs_event-system_logout
                      t_arg = temp1 ) ).

      page->message_strip(
          text     = `Trigger Event LOGOUT which is handled in the APP.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiMediumMargin`
      )->button(
          text  = `Logout now`
          icon  = `sap-icon://log`
          type  = `Reject`
          class = `sapUiSmallMargin`
          press = client->_event( `LOGOUT` ) ).

      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `LOGOUT` ) IS NOT INITIAL.
      client->follow_up_action( client->cs_event-system_logout ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
