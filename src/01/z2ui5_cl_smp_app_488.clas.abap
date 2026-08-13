" @keywords r_data result get_app_prev return event payload
"! Calls a second app (z2ui5_cl_smp_app_489) via client->nav_app_call( ). The
"! called app comes back with client->nav_app_leave( event = ... r_data = ... ),
"! handing an event name and a data payload to its caller without knowing who
"! called it. On return this app enters main( ) via check_on_navigated( ) and
"! reads both from client->get( ): the event name from -event, the payload as a
"! data reference from -r_event_data.
CLASS z2ui5_cl_smp_app_488 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA s_result       TYPE z2ui5_cl_smp_app_489=>ty_s_result.
    DATA returned_event TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_navigation.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_488 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).

    ELSEIF client->check_on_navigated( ).
      on_navigation( ).

    ELSEIF client->check_on_event( `CALL_APP` ).
      client->nav_app_call( NEW z2ui5_cl_smp_app_489( ) ).
    ENDIF.

  ENDMETHOD.


  METHOD on_navigation.

    DATA(ls_get) = client->get( ).
    returned_event = ls_get-event.

    IF returned_event = `DATA_CONFIRMED`.

      " the payload handed over by nav_app_leave( r_data = ... ) arrives as a
      " generic data reference - the receiver decides the type
      ASSIGN ls_get-r_event_data->* TO FIELD-SYMBOL(<s_result>).

      IF <s_result> IS ASSIGNED.

        s_result = <s_result>.
        client->message_toast_display( |Returned event { returned_event }, | &&
                                       |product { s_result-product }, quantity { s_result-quantity }| ).

      ENDIF.

    ELSEIF returned_event = `DATA_CANCELLED`.

      s_result = VALUE #( ).
      client->message_toast_display( `Returned event DATA_CANCELLED, no data passed` ).

    ENDIF.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell( )->page(
        title          = `abap2UI5 - Navigation - Return Data and Events to the Caller`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Calls a second app that returns via nav_app_leave with an event and a data ` &&
                   `payload (r_data). On return this app reads both from client->get( ) in its ` &&
                   `check_on_navigated( ) branch and shows them below.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(form) = page->grid( `L6 M12 S12`
        )->content( `layout`
        )->simple_form(
            title    = `Result returned by the called app`
            editable = abap_true
        )->content( `form` ).

    form->label( `Open the input app` ).
    form->button(
        text  = `call app (nav_app_call)`
        type  = `Emphasized`
        press = client->_event( `CALL_APP` ) ).

    form->label( `Returned event` ).
    form->input(
        value   = client->_bind( returned_event )
        enabled = abap_false ).

    form->label( `Returned product` ).
    form->input(
        value   = client->_bind( s_result-product )
        enabled = abap_false ).

    form->label( `Returned quantity` ).
    form->input(
        value   = client->_bind( s_result-quantity )
        enabled = abap_false ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
