CLASS z2ui5_cl_demo_app_012 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_012 IMPLEMENTATION.

  METHOD on_navigation.

    IF check_popup = abap_true.
      check_popup = abap_false.
      DATA(app) = CAST z2ui5_cl_demo_app_020( client->get_app( client->get( )-s_draft-id_prev_app ) ).
      client->message_toast_display( |{ app->event } pressed| ).
    ENDIF.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `BUTTON_POPUP_01`.
        popup_decide( ).
        client->view_destroy( ).
      WHEN `POPUP_DECIDE_CONTINUE`.
        client->popup_destroy( ).
        view_display( ).
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
        client->nav_app_call( z2ui5_cl_demo_app_020=>factory(
          i_text          = `(new app )this is a popup to decide, the text is send from the previous app and the answer will be send back`
          i_cancel_text   = `Cancel `
          i_cancel_event  = `POPUP_DECIDE_CANCEL`
          i_confirm_text  = `Continue`
          i_confirm_event = `POPUP_DECIDE_CONTINUE`
          ) ).
      WHEN `BUTTON_POPUP_06`.
        check_popup = abap_true.
        client->nav_app_call( z2ui5_cl_demo_app_020=>factory(
          i_text          = `(new app )this is a popup to decide, the text is send from the previous app and the answer will be send back`
          i_cancel_text   = `Cancel`
          i_cancel_event  = `POPUP_DECIDE_CANCEL`
          i_confirm_text  = `Continue`
          i_confirm_event = `POPUP_DECIDE_CONTINUE` ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Popups`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(grid) = page->grid( `L7 M12 S12` )->content( `layout`
        )->simple_form( `Popup in same App` )->content( `form`
            )->label( `Demo`
            )->button(
                text  = `popup rendering, no background rendering`
                press = client->_event( `BUTTON_POPUP_01` )
            )->label( `Demo`
            )->button(
                text  = `popup rendering, background destroyed and rerendering`
                press = client->_event( `BUTTON_POPUP_02` )
            )->label( `Demo`
            )->button(
                text  = `popup, background unchanged (default) - close (no roundtrip)`
                press = client->_event( `BUTTON_POPUP_03` )
            )->label( `Demo`
            )->button(
                text  = `popup, background unchanged (default) - close with server`
                press = client->_event( `BUTTON_POPUP_04` )
        )->get_parent( )->get_parent( ).

    grid->simple_form( `Popup in new App` )->content( `form`
        )->label( `Demo`
        )->button(
            text  = `popup rendering, no background`
            press = client->_event( `BUTTON_POPUP_05` )
        )->label( `Demo`
        )->button(
            text  = `popup rendering, hold previous view`
            press = client->_event( `BUTTON_POPUP_06` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_decide.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).
    popup->dialog( `Popup - Decide`
            )->vbox(
                )->text( `this is a popup to decide, you have to make a decision now...`
            )->get_parent(
            )->buttons(
                )->button(
                    text  = `Cancel`
                    press = client->_event( `POPUP_DECIDE_CANCEL` )
                )->button(
                    text  = `Continue`
                    press = client->_event( `POPUP_DECIDE_CONTINUE` )
                    type  = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popup_info.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).
    popup->dialog( `Popup - Info`
            )->vbox(
                )->text( `this is an information, press close to go back to the main view without a server roundtrip`
            )->get_parent(
            )->buttons(
                )->button(
                    text  = `close`
                    press = client->_event_client( client->cs_event-popup_close )
                    type  = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      on_navigation( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
