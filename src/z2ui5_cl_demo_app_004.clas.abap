CLASS z2ui5_cl_demo_app_004 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.
    DATA check_initialized TYPE abap_bool.
    DATA mv_view_main TYPE string.

  PROTECTED SECTION.

    METHODS z2ui5_view_main_display.
    METHODS z2ui5_view_second_display.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_004 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_view_main_display( ).
      client->message_box_display( 'app started, init values set' ).
      RETURN.
    ENDIF.

    CASE client->get( )-event.

      WHEN 'BUTTON_ROUNDTRIP'.
        client->message_box_display( 'server-client roundtrip, method on_event of the abap controller was called' ).

      WHEN 'BUTTON_RESTART'.
        client->nav_app_leave( NEW z2ui5_cl_demo_app_004( ) ).

      WHEN 'BUTTON_CHANGE_VIEW'.
        CASE mv_view_main.
          WHEN 'MAIN'.
            z2ui5_view_second_display( ).
          WHEN 'SECOND'.
            z2ui5_view_main_display( ).
        ENDCASE.

      WHEN 'BUTTON_ERROR'.
        DATA(lv_dummy) = 1 / 0.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_view_main_display.

    mv_view_main = 'MAIN'.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = 'abap2UI5 - Controller'
            navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
            shownavbutton = abap_true
            )->header_content(
                )->link(
                    text = 'Source_Code'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                    target = '_blank'
            )->get_parent( ).

    page->grid( 'L6 M12 S12' )->content( 'layout'
        )->simple_form( 'Controller' )->content( 'form'
            )->label( 'Roundtrip'
            )->button(
                text  = 'Client/Server Interaction'
                press = client->_event( 'BUTTON_ROUNDTRIP' )
            )->label( 'System'
            )->button(
                text  = 'Restart App'
                press = client->_event( 'BUTTON_RESTART' )
            )->label( 'Change View'
            )->button(
                text  = 'Display View SECOND'
                press = client->_event( 'BUTTON_CHANGE_VIEW' )
            )->label( 'CX_SY_ZERO_DIVIDE'
            )->button(
                text  = 'Error not catched by the user'
                press = client->_event( 'BUTTON_ERROR' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_view_second_display.

    mv_view_main = 'SECOND'.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell( )->page(
     title          = 'abap2UI5 - Controller'
     navbuttonpress = client->_event( 'BACK' )
     shownavbutton = abap_true
     ).

    page->grid( 'L12 M12 S12' )->content( 'layout'
        )->simple_form( 'View Second' )->content( 'form'
            )->label( 'Change View'
            )->button(
                text  = 'Display View MAIN'
                press = client->_event( 'BUTTON_CHANGE_VIEW' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
