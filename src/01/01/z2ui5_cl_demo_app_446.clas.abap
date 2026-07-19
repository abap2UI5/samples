CLASS z2ui5_cl_demo_app_446 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_446 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `TOAST`.
        client->control_call( object = `MESSAGE_TOAST`
                              method = `show`
                              params = VALUE #( ( `Hello from control_call!` ) ) ).

      WHEN `MSGBOX`.
        client->control_call( object = `MESSAGE_BOX`
                              method = `show`
                              params = VALUE #( ( `A message box, opened via control_call.` ) ) ).

      WHEN `THEME_DARK`.
        client->control_call( object = `THEMING`
                              method = `setTheme`
                              params = VALUE #( ( `sap_horizon_dark` ) ) ).

      WHEN `THEME_LIGHT`.
        client->control_call( object = `THEMING`
                              method = `setTheme`
                              params = VALUE #( ( `sap_horizon` ) ) ).

    ENDCASE.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Action - control_call`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Each button lets the backend call a method on a global frontend object ` &&
                   `(MessageToast, MessageBox, Theming) - client-side, after the response renders, ` &&
                   `without wiring a control event.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->vbox( `sapUiSmallMargin`
        )->button( text  = `MessageToast.show`
                   icon  = `sap-icon://information`
                   press = client->_event( `TOAST` )
        )->button( text  = `MessageBox.show`
                   icon  = `sap-icon://message-popup`
                   press = client->_event( `MSGBOX` )
                   class = `sapUiTinyMarginTop`
        )->button( text  = `Theming.setTheme( dark )`
                   icon  = `sap-icon://palette`
                   press = client->_event( `THEME_DARK` )
                   class = `sapUiTinyMarginTop`
        )->button( text  = `Theming.setTheme( light )`
                   icon  = `sap-icon://palette`
                   press = client->_event( `THEME_LIGHT` )
                   class = `sapUiTinyMarginTop` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
