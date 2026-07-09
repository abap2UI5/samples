CLASS z2ui5_cl_demo_app_024 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA input         TYPE string.
    DATA input2        TYPE string.
    DATA backend_event TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_024 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).

    ELSEIF client->check_on_navigated( ).

      IF backend_event = `CALL_PREVIOUS_APP_INPUT_RETURN`.

        DATA(app_025) = CAST z2ui5_cl_demo_app_025( client->get_app_prev( ) ).
        backend_event = VALUE #( ).
        client->message_box_display( |Input made in the previous app: { app_025->input }| ).

      ENDIF.

      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `CALL_NEW_APP`.
        client->nav_app_call( NEW z2ui5_cl_demo_app_025( ) ).

      WHEN `CALL_NEW_APP_VIEW`.
        DATA(app) = NEW z2ui5_cl_demo_app_025( ).
        app->show_view = `SECOND`.
        client->nav_app_call( app ).

      WHEN `CALL_NEW_APP_READ`.
        DATA(app_next) = NEW z2ui5_cl_demo_app_025( ).
        app_next->input_previous_set = input.
        client->nav_app_call( app_next ).

      WHEN `CALL_NEW_APP_EVENT`.
        app_next = NEW z2ui5_cl_demo_app_025( ).
        app_next->event_backend = `NEW_APP_EVENT`.
        client->nav_app_call( app_next ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
            title          = `abap2UI5 - flow logic - APP 01`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
        )->grid( `L6 M12 S12`
        )->content( `layout`
        )->simple_form( `Controller`
        )->content( `form`
        )->label( `Demo`
        )->button(
            text  = `call new app (first View)`
            press = client->_event( `CALL_NEW_APP` )
        )->label( `Demo`
        )->button(
            text  = `call new app (second View)`
            press = client->_event( `CALL_NEW_APP_VIEW` )
        )->label( `Demo`
        )->button(
            text  = `call new app (set Event)`
            press = client->_event( `CALL_NEW_APP_EVENT` )
        )->label( `Demo`
        )->input( client->_bind_edit( input )
        )->button(
            text  = `call new app (set data)`
            press = client->_event( `CALL_NEW_APP_READ` )
        )->label( `some data, you can read in the next app`
        )->input( client->_bind_edit( input2 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
