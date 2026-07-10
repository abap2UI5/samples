CLASS z2ui5_cl_demo_app_025 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA input              TYPE string.
    DATA input_previous     TYPE string.
    DATA input_previous_set TYPE string.
    DATA show_view          TYPE string.
    DATA event_backend      TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_025 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      IF event_backend = `NEW_APP_EVENT`.
        client->message_box_display( `new app called and event NEW_APP_EVENT raised` ).
      ENDIF.

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `BUTTON_ROUNDTRIP`.
        client->message_box_display( `server-client roundtrip, method on_event of the abap controller was called` ).

      WHEN `BUTTON_RESTART`.
        client->nav_app_call( NEW z2ui5_cl_demo_app_025( ) ).

      WHEN `BUTTON_CHANGE_APP`.
        client->nav_app_call( NEW z2ui5_cl_demo_app_001( ) ).

      WHEN `BUTTON_READ_PREVIOUS`.
        DATA(app_024) = CAST z2ui5_cl_demo_app_024( client->get_app( client->get( )-s_draft-id_prev_app ) ).
        input_previous = app_024->input2.
        client->message_toast_display( `data of previous app read` ).

      WHEN `SHOW_VIEW_MAIN`.
        show_view = `MAIN`.

      WHEN `BACK_WITH_EVENT`.
        DATA(app_back) = CAST z2ui5_cl_demo_app_024( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
        app_back->backend_event = `CALL_PREVIOUS_APP_INPUT_RETURN`.
        client->nav_app_leave( app_back ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - flow logic - APP 02`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    CASE show_view.

      WHEN `MAIN` OR ``.
        page->grid( `L6 M12 S12`
            )->content( `layout`
            )->simple_form( `View: FIRST`
            )->content( `form`
            )->label( `Input set by previous app`
            )->input( input_previous_set
            )->label( `Data of previous app`
            )->input( input_previous
            )->button(
                text  = `read`
                press = client->_event( `BUTTON_READ_PREVIOUS` )
            )->label( `Call previous app and show data of this app`
            )->input( client->_bind_edit( input )
            )->button(
                text  = `back`
                press = client->_event( `BACK_WITH_EVENT` ) ).

      WHEN `SECOND`.
        page->grid( `L6 M12 S12`
            )->content( `layout`
            )->simple_form( `View: SECOND`
            )->content( `form`
            )->label( `Demo`
            )->button(
                text  = `leave to previous app`
                press = client->_event_nav_app_leave( )
            )->label( `Demo`
            )->button(
                text  = `show view main`
                press = client->_event( `SHOW_VIEW_MAIN` ) ).

    ENDCASE.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
