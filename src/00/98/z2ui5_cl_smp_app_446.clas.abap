CLASS z2ui5_cl_smp_app_446 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_446 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `TOAST`.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_global
                                  t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                   ( `show` )
                                                   ( `Hello from CONTROL_GLOBAL!` ) ) ).

      WHEN `MSGBOX`.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_global
                                  t_arg = VALUE #( ( `MESSAGE_BOX` )
                                                   ( `show` )
                                                   ( `A message box, opened via CONTROL_GLOBAL.` ) ) ).

      WHEN `THEME_DARK`.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_global
                                  t_arg = VALUE #( ( `THEMING` )
                                                   ( `setTheme` )
                                                   ( `sap_horizon_dark` ) ) ).

      WHEN `THEME_LIGHT`.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_global
                                  t_arg = VALUE #( ( `THEMING` )
                                                   ( `setTheme` )
                                                   ( `sap_horizon` ) ) ).

    ENDCASE.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Action - CONTROL_GLOBAL`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Each button lets the backend call a whitelisted method on a global frontend object ` &&
                   `(MessageToast, MessageBox, Theming) via follow_up_action( cs_event-control_global ) - ` &&
                   `client-side, after the response renders, without wiring a control event.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " message-information, not information: the plain `information` glyph
    " reached the SAP icon font after 1.71, so on the oldest release the
    " samples must run on the button renders with no icon at all
    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `TOAST` )
            )->a( n = `text`  v = `MessageToast.show`
            )->a( n = `icon`  v = `sap-icon://message-information`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `MSGBOX` )
            )->a( n = `text`  v = `MessageBox.show`
            )->a( n = `icon`  v = `sap-icon://message-popup`
            )->a( n = `class` v = `sapUiTinyMarginTop`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `THEME_DARK` )
            )->a( n = `text`  v = `Theming.setTheme( dark )`
            )->a( n = `icon`  v = `sap-icon://palette`
            )->a( n = `class` v = `sapUiTinyMarginTop`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `THEME_LIGHT` )
            )->a( n = `text`  v = `Theming.setTheme( light )`
            )->a( n = `icon`  v = `sap-icon://palette`
            )->a( n = `class` v = `sapUiTinyMarginTop` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
