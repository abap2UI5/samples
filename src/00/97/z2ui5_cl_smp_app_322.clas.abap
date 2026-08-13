CLASS z2ui5_cl_smp_app_322 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_quantity TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_322 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_navigated( ).
      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      client->view_display( view->shell(
             )->page(
                     title          = `abap2UI5 - Navigation with app state`
                     navbuttonpress = client->_event_nav_app_leave( )
                     shownavbutton  = client->check_app_prev_stack( )
          )->message_strip(
              text     = `set_push_state( ) pushes an app-owned suffix onto the browser URL, so the app can `
                      && `write its own hash (here /head/pos/<draft id>) and the browser back button `
                      && `navigates through those entries.`
              type     = `Information`
              showicon = abap_true
              class    = `sapUiSmallMargin`
          )->simple_form(
              title    = `Form Title`
              editable = abap_true
                     )->content( `form`
                         )->title( `Input`
                         )->label( `quantity`
                         )->input( client->_bind( mv_quantity )
                         )->button(
                             text  = `post`
                             press = client->_event( `BUTTON_POST` )
                         )->button(
                             text  = `back`
                             press = client->_event( `BUTTON_BACK` )
              )->stringify( ) ).

      IF client->check_app_prev_stack( ).
        client->set_push_state( `/head/pos/` && client->get( )-s_draft-id ).
      ENDIF.
      RETURN.
    ENDIF.

    CASE client->get_event( ).
      WHEN `BUTTON_POST`.
        client->set_push_state( `/head/pos/` && client->get( )-s_draft-id ).
        client->message_toast_display( `data updated` ).

      WHEN `BUTTON_BACK`.
        " step back through the entries set_push_state( ) pushed - the same
        " thing the browser back button does. follow_up_action( ) runs a raw
        " JavaScript expression when what it gets is not a framework event
        " name, which is how a browser capability without its own event is
        " reached
        client->follow_up_action( |history.back()| ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
