" @keywords t100 message class number exception cx_root error abend
CLASS z2ui5_cl_smp_app_008 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_smp_app_008 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `BUTTON_MESSAGE_BOX_SY`.
        DATA(ls_msg_sy) = z2ui5_cl_smp_context=>msg_get_by_msg(
            id = `NET`
            no = `001` ).
        client->message_box_display( ls_msg_sy ).
      WHEN `BUTTON_MESSAGE_BOX_BAPIRET`.
        DATA(ls_msg_bapiret) = VALUE bapiret2(
            id     = `NET`
            number = `001` ).
        client->message_box_display( ls_msg_bapiret ).
      WHEN `BUTTON_MESSAGE_BOX_CX_ROOT`.
        TRY.
            DATA(lv_val) = 1 / 0.
          CATCH cx_root INTO DATA(lx).
            client->message_box_display( lx ).
        ENDTRY.
    ENDCASE.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Message - MessageBox from SY, BAPIRET2 or Exception`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
            )->header_content(
                )->link(
            )->get_parent( ).

    page->message_strip(
        text     = `The three buttons feed a MessageBox with the message objects ABAP ` &&
                   `produces: a SY message read from T100, a BAPIRET2 structure and a ` &&
                   `caught CX_ROOT exception. message_box_display( ) accepts each of them ` &&
                   `directly, no conversion in the app.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->grid( `L6 M12 S12`
        )->content( `layout`
            )->simple_form( `Message Box from ABAP Object`
                )->content( `form`
                )->button(
                    text  = `SY Message`
                    press = client->_event( `BUTTON_MESSAGE_BOX_SY` )
                )->button(
                    text  = `BAPIRET2`
                    press = client->_event( `BUTTON_MESSAGE_BOX_BAPIRET` )
                )->button(
                    text  = `CX_ROOT`
                    press = client->_event( `BUTTON_MESSAGE_BOX_CX_ROOT` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
