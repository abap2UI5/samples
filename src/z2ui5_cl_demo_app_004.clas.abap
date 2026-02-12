CLASS z2ui5_cl_demo_app_004 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_view_main TYPE string.

  PROTECTED SECTION.

    METHODS view_main_display.
    METHODS view_second_display.
    DATA mo_client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_004 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      view_main_display( ).
      mo_client->message_box_display( `app started, init values set` ).
      RETURN.
    ENDIF.

    CASE mo_client->get( )-event.
      WHEN `BUTTON_ROUNDTRIP`.
        mo_client->message_box_display( `server-client roundtrip, method on_event of the abap controller was called` ).
      WHEN `BUTTON_RESTART`.
        mo_client->nav_app_leave( NEW z2ui5_cl_demo_app_004( ) ).
      WHEN `BUTTON_CHANGE_VIEW`.
        CASE mv_view_main.
          WHEN `MAIN`.
            view_second_display( ).
          WHEN `SECOND`.
            view_main_display( ).
        ENDCASE.
      WHEN `BUTTON_ERROR`.
        DATA(lv_dummy) = 1 / 0.
    ENDCASE.
  ENDMETHOD.

  METHOD view_main_display.

    mv_view_main = `MAIN`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
        )->page(
            title            = `abap2UI5 - Controller`
            navbuttonpress   = mo_client->_event_nav_app_leave( )
               shownavbutton = mo_client->check_app_prev_stack( ) ).

    lo_page->grid( `L6 M12 S12` )->content( `layout`
        )->simple_form( title    = `Controller`
                        editable = abap_true )->content( `form`
            )->label( `Roundtrip`
            )->button(
                text  = `Client/Server Interaction`
                press = mo_client->_event( `BUTTON_ROUNDTRIP` )
            )->label( `System`
            )->button(
                text  = `Restart App`
                press = mo_client->_event( `BUTTON_RESTART` )
            )->label( `Change View`
            )->button(
                text  = `Display View SECOND`
                press = mo_client->_event( `BUTTON_CHANGE_VIEW` )
            )->label( `CX_SY_ZERO_DIVIDE`
            )->button(
                text  = `Error not catched by the user`
                press = mo_client->_event( `BUTTON_ERROR` ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD view_second_display.

    mv_view_main = `SECOND`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell( )->page(
      title          = `abap2UI5 - Controller`
      navbuttonpress = mo_client->_event_nav_app_leave( )
      shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->grid( `L12 M12 S12` )->content( `layout`
        )->simple_form( `View Second` )->content( `form`
            )->label( `Change View`
            )->button(
                text  = `Display View MAIN`
                press = mo_client->_event( `BUTTON_CHANGE_VIEW` ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
