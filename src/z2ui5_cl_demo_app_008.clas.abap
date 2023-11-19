CLASS Z2UI5_CL_DEMO_APP_008 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    DATA check_strip_active TYPE abap_bool.
    DATA strip_type TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_008 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

        CASE client->get( )-event.

          WHEN 'BUTTON_MESSAGE_BOX'.
            client->message_box_display( 'this is a message box' ).

          WHEN 'BUTTON_MESSAGE_BOX_ERROR'.
            client->message_box_display( text = 'this is a message box' type = 'error' ).

          WHEN 'BUTTON_MESSAGE_BOX_SUCCESS'.
            client->message_box_display( text = 'this is a message box' type = 'success' ).

          WHEN 'BUTTON_MESSAGE_BOX_WARNING'.
            client->message_box_display( text = 'this is a message box' type = 'warning' ).

          WHEN 'BUTTON_MESSAGE_TOAST'.
            client->message_toast_display( 'this is a message toast' ).

          WHEN 'BUTTON_MESSAGE_STRIP_INFO'.
            check_strip_active = abap_true.
            strip_type = 'Information'.

          WHEN 'BUTTON_MESSAGE_STRIP_ERROR'.
            check_strip_active = abap_true.
            strip_type = 'Error'.

          WHEN 'BUTTON_MESSAGE_STRIP_SUCCESS'.
            check_strip_active = abap_true.
            strip_type = 'Success'.

          WHEN 'BACK'.
            client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

        ENDCASE.

    data(view) = z2ui5_cl_xml_view=>factory( ).
        DATA(page) = view->shell(
            )->page(
                title          = 'abap2UI5 - Messages'
                navbuttonpress = client->_event( 'BACK' )
                  shownavbutton = abap_true
                )->header_content(
                    )->link(
                        text = 'Source_Code'  target = '_blank'
                        href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                )->get_parent( ).

        IF check_strip_active = abap_true.
          page->message_strip( text = 'This is a Message Strip' type = strip_type ).
        ENDIF.

        page->grid( 'L6 M12 S12'
            )->content( 'layout'
                )->simple_form( 'Message Box' )->content( 'form'
                    )->button(
                        text  = 'information'
                        press = client->_event( 'BUTTON_MESSAGE_BOX' )
                    )->button(
                        text  = 'success'
                        press = client->_event( 'BUTTON_MESSAGE_BOX_SUCCESS' )
                    )->button(
                        text  = 'error'
                        press = client->_event( 'BUTTON_MESSAGE_BOX_ERROR' )
                    )->button(
                        text  = 'warning'
                        press = client->_event( 'BUTTON_MESSAGE_BOX_WARNING' ) ).

        page->grid( 'L6 M12 S12'
            )->content( 'layout'
                )->simple_form( 'Message Strip' )->content( 'form'
                    )->button(
                        text = 'success'
                        press = client->_event( 'BUTTON_MESSAGE_STRIP_SUCCESS' )
                    )->button(
                        text = 'error'
                        press = client->_event( 'BUTTON_MESSAGE_STRIP_ERROR' )
                    )->button(
                        text = 'information'
                        press = client->_event( 'BUTTON_MESSAGE_STRIP_INFO' ) ).

        page->grid( 'L6 M12 S12'
            )->content( 'layout'
                )->simple_form( 'Display' )->content( 'form'
                    )->button(
                        text = 'Message Toast'
                        press = client->_event( 'BUTTON_MESSAGE_TOAST' ) ).

        client->view_display( view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
