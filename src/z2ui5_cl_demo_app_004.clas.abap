CLASS z2ui5_cl_demo_app_004 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA view_main TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_main_display.
    METHODS view_second_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_004 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    view_main_display( ).
    client->message_box_display( `app started, init values set` ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `BUTTON_ROUNDTRIP`.
        client->message_box_display( `server-client roundtrip, method on_event of the abap controller was called` ).
      WHEN `BUTTON_RESTART`.
        client->nav_app_leave( NEW z2ui5_cl_demo_app_004( ) ).
      WHEN `BUTTON_CHANGE_VIEW`.
        CASE view_main.
          WHEN `MAIN`.
            view_second_display( ).
          WHEN `SECOND`.
            view_main_display( ).
        ENDCASE.
      WHEN `BUTTON_ERROR`.
        DATA(dummy) = 1 / 0.
    ENDCASE.

  ENDMETHOD.


  METHOD view_main_display.

    view_main = `MAIN`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Controller`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->grid( `L6 M12 S12`
        )->content( `layout`
        )->simple_form(
            title    = `Controller`
            editable = abap_true
            )->content( `form`
            )->label( `Roundtrip`
            )->button(
                text  = `Client/Server Interaction`
                press = client->_event( `BUTTON_ROUNDTRIP` )
            )->label( `System`
            )->button(
                text  = `Restart App`
                press = client->_event( `BUTTON_RESTART` )
            )->label( `Change View`
            )->button(
                text  = `Display View SECOND`
                press = client->_event( `BUTTON_CHANGE_VIEW` )
            )->label( `CX_SY_ZERO_DIVIDE`
            )->button(
                text  = `Error not catched by the user`
                press = client->_event( `BUTTON_ERROR` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD view_second_display.

    view_main = `SECOND`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Controller`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->grid( `L12 M12 S12`
        )->content( `layout`
        )->simple_form( `View Second`
            )->content( `form`
            )->label( `Change View`
            )->button(
                text  = `Display View MAIN`
                press = client->_event( `BUTTON_CHANGE_VIEW` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
