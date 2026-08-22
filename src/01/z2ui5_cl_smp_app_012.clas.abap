" @keywords dialog sub app destroy rerender background view
" @summary The ways to open a dialog - from this app, from a sub app, rebuilt or destroyed - and what each one does to the view behind it.
" @docs https://abap2ui5.github.io/docs/cookbook/popup_popover/popup https://abap2ui5.github.io/docs/tutorials/walkthrough/step-7
CLASS z2ui5_cl_smp_app_012 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA check_popup TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_navigation.
    METHODS on_event.
    METHODS view_display.
    METHODS popup_decide.
    METHODS popup_info.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_012 IMPLEMENTATION.

  METHOD on_navigation.
      DATA temp1 TYPE REF TO z2ui5_cl_smp_app_020.
      DATA app LIKE temp1.

    IF check_popup = abap_true.

      check_popup = abap_false.
      
      temp1 ?= client->get_app_prev( ).
      
      app = temp1.
      client->message_toast_display( |{ app->event } pressed| ).
    ENDIF.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `BUTTON_POPUP_01`.
        popup_decide( ).
        client->view_destroy( ).
      WHEN `POPUP_DECIDE_CONTINUE`.
        client->popup_destroy( ).
        client->message_toast_display( `continue pressed` ).
      WHEN `POPUP_DECIDE_CANCEL`.
        client->popup_destroy( ).
        view_display( ).
        client->message_toast_display( `cancel pressed` ).
      WHEN `BUTTON_POPUP_02`.
        view_display( ).
        popup_decide( ).
      WHEN `BUTTON_POPUP_03`.
        popup_info( ).
      WHEN `BUTTON_POPUP_04`.
        popup_decide( ).
      WHEN `BUTTON_POPUP_05`.
        check_popup = abap_true.
        client->view_destroy( ).
        client->nav_app_call( z2ui5_cl_smp_app_020=>factory(
          i_text          = `(new app) this is a popup to decide, the text is sent from the previous app and the answer will be sent back`
          i_cancel_text   = `Cancel`
          i_cancel_event  = `POPUP_DECIDE_CANCEL`
          i_confirm_text  = `Continue`
          i_confirm_event = `POPUP_DECIDE_CONTINUE`
          ) ).
      WHEN `BUTTON_POPUP_06`.
        check_popup = abap_true.
        client->nav_app_call( z2ui5_cl_smp_app_020=>factory(
          i_text          = `(new app) this is a popup to decide, the text is sent from the previous app and the answer will be sent back`
          i_cancel_text   = `Cancel`
          i_cancel_event  = `POPUP_DECIDE_CANCEL`
          i_confirm_text  = `Continue`
          i_confirm_event = `POPUP_DECIDE_CONTINUE` ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA grid TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Popup - Ways to Open a Dialog`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Shows different ways to open a popup - inside the same app or as a sub-app - ` &&
                   `and how the background view is kept, destroyed or re-rendered.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    grid = page->ele( n = `Grid` ns = `layout`
        )->a( n = `defaultSpan` v = `L7 M12 S12`
        )->ele( n = `content` ns = `layout`
            )->ele( n = `SimpleForm` ns = `form`
                )->a( n = `title`    v = `Popup in same App`
                )->a( n = `editable` b = abap_true
                )->ele( n = `content` ns = `form`
                    )->tag( `Label`
                        )->a( n = `text` v = `Demo`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `BUTTON_POPUP_01` )
                        )->a( n = `text`  v = `popup rendering, no background rendering`
                    )->tag( `Label`
                        )->a( n = `text` v = `Demo`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `BUTTON_POPUP_02` )
                        )->a( n = `text`  v = `popup rendering, background destroyed and rerendering`
                    )->tag( `Label`
                        )->a( n = `text` v = `Demo`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `BUTTON_POPUP_03` )
                        )->a( n = `text`  v = `popup, background unchanged (default) - close (no roundtrip)`
                    )->tag( `Label`
                        )->a( n = `text` v = `Demo`
                    )->tag( `Button`
                        )->a( n = `press` v = client->_event( `BUTTON_POPUP_04` )
                        )->a( n = `text`  v = `popup, background unchanged (default) - close with server`
                )->end(
            )->end( ).

    grid->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Popup in new App`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Label`
                )->a( n = `text` v = `Demo`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `BUTTON_POPUP_05` )
                )->a( n = `text`  v = `popup rendering, no background`
            )->tag( `Label`
                )->a( n = `text` v = `Demo`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `BUTTON_POPUP_06` )
                )->a( n = `text`  v = `popup rendering, hold previous view` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_decide.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).
    popup->ele( `Dialog`
        )->a( n = `title` v = `Popup - Decide`
        )->ele( `VBox`
            )->tag( `Text`
                )->a( n = `text` v = `this is a popup to decide, you have to make a decision now...`
        )->end(
        )->ele( `buttons`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `POPUP_DECIDE_CANCEL` )
                )->a( n = `text`  v = `Cancel`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `POPUP_DECIDE_CONTINUE` )
                )->a( n = `text`  v = `Continue`
                )->a( n = `type`  v = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popup_info.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).
    popup->ele( `Dialog`
        )->a( n = `title` v = `Popup - Info`
        )->ele( `VBox`
            )->tag( `Text`
                )->a( n = `text` v = `this is an information, press close to go back to the main view without a server roundtrip`
        )->end(
        )->ele( `buttons`
            )->tag( `Button`
                )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close )
                )->a( n = `text`  v = `close`
                )->a( n = `type`  v = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      on_navigation( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
