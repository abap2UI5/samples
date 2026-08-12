CLASS z2ui5_cl_smp_app_321 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_quantity TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_321 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_navigated( ).
      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      client->view_display( view->shell(
             )->page(
                     title          = `abap2UI5 - Navigation with app state`
                     navbuttonpress = client->_event( `BACK` )
                     shownavbutton  = client->check_app_prev_stack( )
          )->message_strip(
              text     = `set_app_state_active( ) carries the app state id in the URL, so the page can be `
                      && `bookmarked and the entered data is restored when the bookmark is opened again. `
                      && `Enter a quantity, press the button and reload the page.`
              type     = `Information`
              showicon = abap_true
              class    = `sapUiSmallMargin`
          )->simple_form( title = `Form Title` editable = abap_true
                     )->content( `form`
                         )->title( `Input`
                         )->label( `quantity`
                         )->input( client->_bind( mv_quantity )
                         )->button(
                             text  = `post with state`
                             press = client->_event( `BUTTON_POST` )
              )->stringify( ) ).
    ENDIF.

    CASE client->get_event( ).
      WHEN `BUTTON_POST`.
        client->message_toast_display( `data updated` ).
        "this is where the magic happens...
        client->set_app_state_active( ).
      WHEN `BACK`.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
