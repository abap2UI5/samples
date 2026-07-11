CLASS z2ui5_cl_demo_app_133 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA field_01 TYPE string.
    DATA field_02 TYPE string.
    DATA selstart TYPE string.
    DATA selend   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_133 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->shell(
        )->page(
            title          = `abap2UI5 - Focus`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
            )->simple_form(
                title    = `Focus & Cursor`
                editable = abap_true
                )->content( `form`
                )->title( `Input`
                )->label( `Sel_Start`
                )->input( client->_bind_edit( selstart )
                )->label( `Sel_End`
                )->input( client->_bind_edit( selend )
                )->label( `field_01`
                )->input(
                    value = client->_bind_edit( field_01 )
                    id    = `BUTTON01`
                )->button(
                    text  = `focus here`
                    press = client->_event( `BUTTON01` )
                )->label( `field_02`
                )->input(
                    value = client->_bind_edit( field_02 )
                    id    = `BUTTON02`
                )->button(
                    text  = `focus here`
                    press = client->_event( `BUTTON02` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      field_01 = `this is a text`.
      field_02 = `this is another text`.
      selstart = `3`.
      selend   = `7`.

      view_display( ).
      RETURN.

    ENDIF.

    CASE client->get( )-event.
      WHEN `BUTTON01` OR `BUTTON02`.
        client->action->gen(
            val   = z2ui5_if_client=>cs_event-set_focus
            t_arg = VALUE #( ( client->get( )-event ) ( selstart ) ( selend ) ) ).
        client->message_toast_display( |focus changed| ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
