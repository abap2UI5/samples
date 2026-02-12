CLASS z2ui5_cl_demo_app_012 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    DATA mv_check_popup TYPE abap_bool.
    METHODS popup_decide.
    METHODS popup_info_frontend_close.
    METHODS view_display.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_012 IMPLEMENTATION.

  METHOD popup_decide.

    DATA(lo_popup)  = z2ui5_cl_xml_view=>factory_popup( ).
    lo_popup->dialog( `Popup - Decide`
            )->vbox(
                )->text( `this is a popup to decide, you have to make a decision now...`
            )->get_parent(
            )->buttons(
                )->button(
                    text  = `Cancel`
                    press = mo_client->_event( `POPUP_DECIDE_CANCEL` )
                )->button(
                    text  = `Continue`
                    press = mo_client->_event( `POPUP_DECIDE_CONTINUE` )
                    type  = `Emphasized` ).

    mo_client->popup_display( lo_popup->stringify( ) ).
  ENDMETHOD.

  METHOD popup_info_frontend_close.

    DATA(lo_popup)  = z2ui5_cl_xml_view=>factory_popup( ).
    lo_popup->dialog( `Popup - Info`
            )->vbox(
                )->text( `this is an information, press close to go back to the main view without a server roundtrip`
            )->get_parent(
                )->buttons(
                )->button(
                    text  = `close`
                    press = mo_client->_event_client( mo_client->cs_event-popup_close )
                    type  = `Emphasized` ).

    mo_client->popup_display( lo_popup->stringify( ) ).
  ENDMETHOD.

  METHOD view_display.

    DATA(lo_main) = z2ui5_cl_xml_view=>factory( )->shell( ).
    DATA(lo_page) = lo_main->page(
            title          = `abap2UI5 - Popups`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    DATA(lo_grid) = lo_page->grid( `L7 M12 S12` )->content( `layout`
        )->simple_form( `Popup in same App` )->content( `form`
            )->label( `Demo`
            )->button(
                text  = `popup rendering, no background rendering`
                press = mo_client->_event( `BUTTON_POPUP_01` )
            )->label( `Demo`
            )->button(
                text  = `popup rendering, background destroyed and rerendering`
                press = mo_client->_event( `BUTTON_POPUP_02` )
            )->label( `Demo`
            )->button(
                text  = `popup, background unchanged (default) - close (no roundtrip)`
                press = mo_client->_event( `BUTTON_POPUP_03` )
            )->label( `Demo`
            )->button(
                text  = `popup, background unchanged (default) - close with server`
                press = mo_client->_event( `BUTTON_POPUP_04` )
        )->get_parent( )->get_parent( ).

    lo_grid->simple_form( `Popup in new App` )->content( `form`
        )->label( `Demo`
        )->button(
            text  = `popup rendering, no background`
            press = mo_client->_event( `BUTTON_POPUP_05` )
        )->label( `Demo`
        )->button(
            text  = `popup rendering, hold previous view`
            press = mo_client->_event( `BUTTON_POPUP_06` ) ).

    mo_client->view_display( lo_main->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->get( )-check_on_navigated = abap_true.
      view_display( ).
    ENDIF.

    IF mv_check_popup = abap_true.
      mv_check_popup = abap_false.
      DATA(lo_app) = CAST z2ui5_cl_demo_app_020( mo_client->get_app( mo_client->get( )-s_draft-id_prev_app ) ).
      mo_client->message_toast_display( lo_app->mv_event && ` pressed` ).
    ENDIF.

    CASE mo_client->get( )-event.
      WHEN `BUTTON_POPUP_01`.
        popup_decide( ).
        mo_client->view_destroy( ).
      WHEN `POPUP_DECIDE_CONTINUE`.
        mo_client->popup_destroy( ).
        view_display( ).
        mo_client->message_toast_display( `continue pressed` ).
      WHEN `POPUP_DECIDE_CANCEL`.
        mo_client->popup_destroy( ).
        view_display( ).
        mo_client->message_toast_display( `cancel pressed` ).
      WHEN `BUTTON_POPUP_02`.
        view_display( ).
        popup_decide( ).
      WHEN `BUTTON_POPUP_03`.
        popup_info_frontend_close( ).
      WHEN `BUTTON_POPUP_04`.
        popup_decide( ).
      WHEN `BUTTON_POPUP_05`.
        mv_check_popup = abap_true.
        mo_client->view_destroy( ).
        mo_client->nav_app_call( z2ui5_cl_demo_app_020=>factory(
          i_text          = `(new app )this is a popup to decide, the text is send from the previous app and the answer will be send back`
          i_cancel_text   = `Cancel `
          i_cancel_event  = `POPUP_DECIDE_CANCEL`
          i_confirm_text  = `Continue`
          i_confirm_event = `POPUP_DECIDE_CONTINUE`
          ) ).
      WHEN `BUTTON_POPUP_06`.
        mv_check_popup = abap_true.
        mo_client->nav_app_call( z2ui5_cl_demo_app_020=>factory(
          i_text          = `(new app )this is a popup to decide, the text is send from the previous app and the answer will be send back`
          i_cancel_text   = `Cancel`
          i_cancel_event  = `POPUP_DECIDE_CANCEL`
          i_confirm_text  = `Continue`
          i_confirm_event = `POPUP_DECIDE_CONTINUE` ) ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
