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
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE string_table.
        DATA temp3 TYPE string_table.
        DATA temp5 TYPE string_table.
        DATA temp7 TYPE string_table.

    CASE client->get( )-event.

      WHEN `TOAST`.
        
        CLEAR temp1.
        INSERT `MESSAGE_TOAST` INTO TABLE temp1.
        INSERT `show` INTO TABLE temp1.
        INSERT `Hello from CONTROL_GLOBAL!` INTO TABLE temp1.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_global
                                  t_arg = temp1 ).

      WHEN `MSGBOX`.
        
        CLEAR temp3.
        INSERT `MESSAGE_BOX` INTO TABLE temp3.
        INSERT `show` INTO TABLE temp3.
        INSERT `A message box, opened via CONTROL_GLOBAL.` INTO TABLE temp3.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_global
                                  t_arg = temp3 ).

      WHEN `THEME_DARK`.
        
        CLEAR temp5.
        INSERT `THEMING` INTO TABLE temp5.
        INSERT `setTheme` INTO TABLE temp5.
        INSERT `sap_horizon_dark` INTO TABLE temp5.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_global
                                  t_arg = temp5 ).

      WHEN `THEME_LIGHT`.
        
        CLEAR temp7.
        INSERT `THEMING` INTO TABLE temp7.
        INSERT `setTheme` INTO TABLE temp7.
        INSERT `sap_horizon` INTO TABLE temp7.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_global
                                  t_arg = temp7 ).

    ENDCASE.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell(
        )->page(
            title          = `abap2UI5 - Action - CONTROL_GLOBAL`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Each button lets the backend call a whitelisted method on a global frontend object ` &&
                   `(MessageToast, MessageBox, Theming) via follow_up_action( cs_event-control_global ) - ` &&
                   `client-side, after the response renders, without wiring a control event.`
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
