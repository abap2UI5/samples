CLASS z2ui5_cl_demo_app_018 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_quantity TYPE string.
    DATA mv_textarea TYPE string.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.

    METHODS display_view_main.
    METHODS display_view_second.
    METHODS display_popup_input.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_018 IMPLEMENTATION.

  METHOD display_popup_input.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->dialog(
             title = `Title`
             icon  = `sap-icon://edit`
                  )->content(
                      )->text_area(
                          height = `100%`
                          width  = `100%`
                          value  = mo_client->_bind_edit( mv_textarea )
                        )->button(
                          text  = `Cancel`
                          press = mo_client->_event( `POPUP_CANCEL` )
                      )->button(
                          text  = `Confirm`
                          press = mo_client->_event( `POPUP_CONFIRM` )
                          type  = `Emphasized` ).

    mo_client->popup_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD display_view_main.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->shell(
        )->page(
                title          = `abap2UI5 - Template`
                navbuttonpress = mo_client->_event_nav_app_leave( )
                shownavbutton  = mo_client->check_app_prev_stack( )
            )->simple_form( title    = `VIEW_MAIN`
                            editable = abap_true
                )->content( `form`
                    )->title( `Input`
                    )->label( `quantity`
                    )->input( mo_client->_bind_edit( mv_quantity )
                    )->label( `text`
                    )->input(
                        value   = mo_client->_bind_edit( mv_textarea )
                        enabled = abap_false
                    )->button(
                        text  = `show popup input`
                        press = mo_client->_event( `SHOW_POPUP` )
                        )->get_parent( )->get_parent( )->footer(
                      )->overflow_toolbar(
              )->toolbar_spacer(
              )->overflow_toolbar_button(
                  text  = `Clear`
                  press = mo_client->_event( `BUTTON_CLEAR` )
                  type  = `Reject`
                  icon  = `sap-icon://delete`
              )->button(
                  text  = `Go to View Second`
                  press = mo_client->_event( `SHOW_VIEW_SECOND` ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD display_view_second.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->shell(
          )->page(
                  title          = `abap2UI5 - Template`
                  navbuttonpress = mo_client->_event_nav_app_leave( )
                  shownavbutton  = mo_client->check_app_prev_stack( )
              )->simple_form( `VIEW_SECOND`
                  )->content( `form`
      )->get_parent( )->get_parent( )->footer(
            )->overflow_toolbar(
                )->toolbar_spacer(
                )->overflow_toolbar_button(
                    text  = `Clear`
                    press = mo_client->_event( `BUTTON_CLEAR` )
                    type  = `Reject`
                    icon  = `sap-icon://delete`
                )->button(
                    text  = `Go to View Main`
                    press = mo_client->_event( `SHOW_VIEW_MAIN` ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      on_init( ).
      RETURN.
    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `SHOW_POPUP`.
        display_popup_input( ).
      WHEN `POPUP_CONFIRM`.
        mo_client->message_toast_display( |confirm| ).
        mo_client->popup_destroy( ).
      WHEN `POPUP_CANCEL`.
        CLEAR mv_textarea.
        mo_client->message_toast_display( |cancel| ).
        mo_client->popup_destroy( ).
      WHEN `SHOW_VIEW_MAIN`.
        display_view_main( ).
      WHEN `SHOW_VIEW_SECOND`.
        display_view_second( ).
    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

    mv_quantity = `500`.
    display_view_main( ).
  ENDMETHOD.
ENDCLASS.
