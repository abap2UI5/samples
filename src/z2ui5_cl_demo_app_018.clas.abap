CLASS z2ui5_cl_demo_app_018 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA quantity TYPE string.
    DATA textarea TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS view_second_display.
    METHODS popup_input_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_018 IMPLEMENTATION.

  METHOD on_init.

    quantity = `500`.
    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `SHOW_POPUP`.
        popup_input_display( ).
      WHEN `POPUP_CONFIRM`.
        client->message_toast_display( `confirm` ).
        client->popup_destroy( ).
      WHEN `POPUP_CANCEL`.
        textarea = VALUE #( ).
        client->message_toast_display( `cancel` ).
        client->popup_destroy( ).
      WHEN `SHOW_VIEW_MAIN`.
        view_display( ).
      WHEN `SHOW_VIEW_SECOND`.
        view_second_display( ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
                title          = `abap2UI5 - Template`
                navbuttonpress = client->_event_nav_app_leave( )
                shownavbutton  = client->check_app_prev_stack( )
            )->simple_form(
                title    = `VIEW_MAIN`
                editable = abap_true
                )->content( `form`
                    )->title( `Input`
                    )->label( `quantity`
                    )->input( client->_bind_edit( quantity )
                    )->label( `text`
                    )->input(
                        value   = client->_bind_edit( textarea )
                        enabled = abap_false
                    )->button(
                        text  = `show popup input`
                        press = client->_event( `SHOW_POPUP` )
                        )->get_parent( )->get_parent( )->footer(
                      )->overflow_toolbar(
              )->toolbar_spacer(
              )->overflow_toolbar_button(
                  text  = `Clear`
                  press = client->_event( `BUTTON_CLEAR` )
                  type  = `Reject`
                  icon  = `sap-icon://delete`
              )->button(
                  text  = `Go to View Second`
                  press = client->_event( `SHOW_VIEW_SECOND` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD view_second_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
          )->page(
                  title          = `abap2UI5 - Template`
                  navbuttonpress = client->_event_nav_app_leave( )
                  shownavbutton  = client->check_app_prev_stack( )
              )->simple_form( `VIEW_SECOND`
                  )->content( `form`
      )->get_parent( )->get_parent( )->footer(
            )->overflow_toolbar(
                )->toolbar_spacer(
                )->overflow_toolbar_button(
                    text  = `Clear`
                    press = client->_event( `BUTTON_CLEAR` )
                    type  = `Reject`
                    icon  = `sap-icon://delete`
                )->button(
                    text  = `Go to View Main`
                    press = client->_event( `SHOW_VIEW_MAIN` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_input_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->dialog(
             title = `Title`
             icon  = `sap-icon://edit`
                  )->content(
                      )->text_area(
                          height = `100%`
                          width  = `100%`
                          value  = client->_bind_edit( textarea )
                        )->button(
                          text  = `Cancel`
                          press = client->_event( `POPUP_CANCEL` )
                      )->button(
                          text  = `Confirm`
                          press = client->_event( `POPUP_CONFIRM` )
                          type  = `Emphasized` ).

    client->popup_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
