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
                     navbuttonpress = client->follow_up_action( `HISTORY_BACK` )
                     shownavbutton  = client->check_app_prev_stack( )
          )->message_strip(
              text     = `set_push_state( ) pushes an app-owned suffix onto the browser URL, so the app can `
                      && `write its own hash (here /head/pos/<draft id>) and the browser back button `
                      && `navigates through those entries.`
              type     = `Information`
              showicon = abap_true
              class    = `sapUiSmallMargin`
          )->simple_form( title = `Form Title` editable = abap_true
                     )->content( `form`
                         )->title( `Input`
                         )->label( `quantity`
                         )->input( client->_bind( mv_quantity )
                         )->button(
                             text  = `post`
                             press = client->_event( `BUTTON_POST` )
                         )->button(
                             text  = `back`
                             press = client->follow_up_action( `HISTORY_BACK` )
              )->stringify( ) ).

      IF client->check_app_prev_stack( ).
        client->set_push_state( `/head/pos/` && client->get( )-s_draft-id ).
      ENDIF.
      RETURN.
    ENDIF.

    CASE client->get_event( ).
      WHEN `BUTTON_POST`.
        client->set_push_state( `/head/pos/` && client->get( )-s_draft-id ).
    ENDCASE.
    client->message_toast_display( `data updated` ).

  ENDMETHOD.

ENDCLASS.
