CLASS z2ui5_cl_demo_app_150 DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

ENDCLASS.


CLASS z2ui5_cl_demo_app_150 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    CASE abap_true.

      WHEN client->check_on_init( ).

        DATA(view) = z2ui5_cl_xml_view=>factory( ).
        view->shell(
            )->page( title          = 'abap2UI5 - Popup To Confirm'
                     navbuttonpress = client->_event_nav_app_leave( )
                     shownavbutton  = client->check_app_prev_stack( )
            )->button( text  = 'Open Popup...'
                       press = client->_event( `POPUP` ) ).
        client->view_display( view->stringify( ) ).

      WHEN client->check_on_event( `POPUP` ).

        DATA(lo_app) = z2ui5_cl_pop_to_confirm=>factory( i_question_text = `this is a question`
                                                         i_event_confirm = `POPUP_TRUE`
                                                         i_event_cancel  = 'POPUP_FALSE' ).
        client->nav_app_call( lo_app ).

      WHEN client->check_on_event( `POPUP_TRUE` ).
        client->message_box_display( `the result is SUCCESS` ).

      WHEN client->check_on_event( `POPUP_FALSE` ).
        client->message_box_display( `the result is CANCEL` ).

    ENDCASE.
  ENDMETHOD.
ENDCLASS.
