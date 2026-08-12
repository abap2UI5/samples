CLASS z2ui5_cl_smp_app_491 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA favicon TYPE string VALUE `data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'><circle cx='8' cy='8' r='7' fill='%23f60'/></svg>`.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_491 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
          )->page(
              title          = `abap2UI5 - Change Browser Favicon`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      page->message_strip(
          text     = `Enter an image URL (or data URI) and press the button to run the set_favicon front-end action, ` &&
                     `which updates the browser tab icon (the link rel="icon" tag) without reloading the page.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiSmallMargin` ).

      page->simple_form(
          title    = `Favicon`
          editable = abap_true
          )->content( `form`
          )->label( `favicon url`
          )->input( client->_bind( favicon )
          )->button(
              text  = `Set Favicon`
              press = client->_event( `SET_FAVICON` ) ).
      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `SET_FAVICON` ).

      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-set_favicon
          t_arg = VALUE #( ( favicon ) ) ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
