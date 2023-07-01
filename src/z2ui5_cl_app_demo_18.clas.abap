CLASS z2ui5_cl_app_demo_18 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA quantity TYPE string.
    DATA mv_textarea TYPE string.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.

    METHODS z2ui5_display_view_main.
    METHODS z2ui5_display_view_second.
    METHODS z2ui5_display_popup_input.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_app_demo_18 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.

      WHEN 'SHOW_POPUP'.
        z2ui5_display_popup_input( ).

      WHEN 'POPUP_CONFIRM'.
        client->message_toast_display( |confirm| ).
        client->popup_close( ).

      WHEN 'POPUP_CANCEL'.
        CLEAR mv_textarea.
        client->message_toast_display( |cancel| ).
        client->popup_close( ).

      WHEN 'SHOW_VIEW_MAIN'.
        z2ui5_display_view_main( ).

      WHEN 'SHOW_VIEW_SECOND'.
        z2ui5_display_view_second( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    quantity = '500'.
    z2ui5_display_view_main( ).

  ENDMETHOD.


  METHOD z2ui5_display_popup_input.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( client ).
    view->dialog(
             title = 'Title'
             icon = 'sap-icon://edit'
                  )->content(
                      )->text_area(
                          height = '100%'
                          width  = '100%'
                          value  = client->_bind_edit( mv_textarea )
                  )->get_parent(
                  )->footer( )->overflow_toolbar(
                      )->toolbar_spacer(
                      )->button(
                          text  = 'Cancel'
                          press = client->_event( 'POPUP_CANCEL' )
                      )->button(
                          text  = 'Confirm'
                          press = client->_event( 'POPUP_CONFIRM' )
                          type  = 'Emphasized' ).

    client->popup_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_display_view_main.

    DATA(view) = z2ui5_cl_xml_view=>factory( client ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Template'
                navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                shownavbutton  = abap_true
            )->header_content(
                )->link(
                    text = 'Source_Code' target = '_blank'
                    href = view->hlp_get_source_code_url(  )
            )->get_parent(
            )->simple_form( title = 'VIEW_MAIN' editable = abap_true
                )->content( 'form'
                    )->title( 'Input'
                    )->label( 'quantity'
                    )->input( client->_bind_edit( quantity )
                    )->label( 'text'
                    )->input(
                        value   = client->_bind_edit( mv_textarea )
                        enabled = abap_false
                    )->button(
                        text  = 'show popup input'
                        press = client->_event( 'SHOW_POPUP' )
                        )->get_parent( )->get_parent( )->footer(
                      )->overflow_toolbar(
              )->toolbar_spacer(
              )->overflow_toolbar_button(
                  text  = 'Clear'
                  press = client->_event( 'BUTTON_CLEAR' )
                  type  = 'Reject'
                  icon  = 'sap-icon://delete'
              )->button(
                  text  = 'Go to View Second'
                  press = client->_event( 'SHOW_VIEW_SECOND' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_display_view_second.

    DATA(view) = z2ui5_cl_xml_view=>factory( client ).
    view->shell(
          )->page(
                  title          = 'abap2UI5 - Template'
                  navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                  shownavbutton  = abap_true
              )->header_content(
                  )->link(
                      text = 'Source_Code'
                      href = view->hlp_get_source_code_url( )
              )->get_parent(
              )->simple_form( 'VIEW_SECOND'
                  )->content( 'form'

            )->get_parent( )->get_parent( )->footer(
            )->overflow_toolbar(
                )->toolbar_spacer(
                )->overflow_toolbar_button(
                    text  = 'Clear'
                    press = client->_event( 'BUTTON_CLEAR' )
                    type  = 'Reject'
                    icon  = 'sap-icon://delete'
                )->button(
                    text  = 'Go to View Main'
                    press = client->_event( 'SHOW_VIEW_MAIN' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
