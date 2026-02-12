CLASS z2ui5_cl_demo_app_161 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mo_client TYPE REF TO z2ui5_if_client .

    METHODS display .
    METHODS event .
    METHODS simple_popup1 .
    METHODS simple_popup2 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_161 IMPLEMENTATION.

  METHOD simple_popup1.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(lo_dialog) = lo_popup->dialog(
            afterclose = mo_client->_event( `BTN_OK_1ND` )
         )->content( ).

    DATA(lo_content) = lo_dialog->button( text  = `Open 2nd popup`
                                    press = mo_client->_event( `GOTO_2ND` ) ).

    lo_dialog->get_parent( )->buttons(
                  )->button(
                      text  = `OK`
                      press = mo_client->_event( `BTN_OK_1ND` )
                      type  = `Emphasized` ).

    mo_client->popup_display( lo_popup->stringify( ) ).
  ENDMETHOD.

  METHOD simple_popup2.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(lo_dialog) = lo_popup->dialog(
        afterclose = mo_client->_event( `BTN_OK_2ND` )
         )->content( ).

    DATA(lo_content) = lo_dialog->label( text = `this is a second popup` ).

    lo_dialog->get_parent( )->buttons(
                  )->button(
                      text  = `GOTO 1ST POPUP`
                      press = mo_client->_event( `BTN_OK_2ND` )
                      type  = `Emphasized` ).

    mo_client->popup_display( lo_popup->stringify( ) ).
  ENDMETHOD.

  METHOD display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->shell(
        )->page(
                title          = `abap2UI5 - Popup To Popup`
                navbuttonpress = mo_client->_event_nav_app_leave( )
                shownavbutton  = mo_client->check_app_prev_stack( )
           )->button(
            text  = `Open Popup...`
            press = mo_client->_event( `POPUP` ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD event.

    CASE mo_client->get( )-event.
      WHEN `GOTO_2ND`.
        simple_popup2( ).
      WHEN `BTN_OK_2ND`.
        mo_client->popup_destroy( ).
        simple_popup1( ).
      WHEN `BTN_OK_1ND`.
        mo_client->popup_destroy( ).
      WHEN `POPUP`.
        simple_popup1( ).
    ENDCASE.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->get( )-check_on_navigated = abap_true.
      display( ).
      RETURN.
    ENDIF.

    event( ).
  ENDMETHOD.
ENDCLASS.
