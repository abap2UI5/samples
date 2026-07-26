CLASS z2ui5_cl_demo_app_073 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    METHODS view_display.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_073 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page(
        title          = `abap2UI5 - Open New Tab`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Press the button to open the app's own URL in a new browser tab: the backend builds the ` &&
                   `URL and the open_new_tab front-end action launches it.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->simple_form(
        title    = `Form Title`
        editable = abap_true
        )->content( `form`
            )->button(
                text  = `open new tab`
                press = client->_event( val = `BUTTON_OPEN_NEW_TAB` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

    CASE client->get( )-event.

      WHEN `BUTTON_OPEN_NEW_TAB`.

        DATA(ls_config) = client->get( )-s_config.
        DATA(result) = z2ui5_cl_a2ui5_context=>app_get_url( classname = `z2ui5_cl_demo_app_073`
                                                      origin    = ls_config-origin
                                                      pathname  = ls_config-pathname
                                                      search    = ls_config-search
                                                      hash      = ls_config-hash ).

        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-open_new_tab
            t_arg = VALUE #(
                ( result )
                ) ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
