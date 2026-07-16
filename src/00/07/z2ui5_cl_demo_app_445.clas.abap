"! Demo of the DISPLAY_MESSAGE_TOAST / DISPLAY_MESSAGE_BOX frontend events -
"! they forward their arguments 1:1 to the sap.m.MessageToast.show( ) /
"! sap.m.MessageBox[method]( ) control API. Triggered from the backend via
"! follow_up_action; the options are a JSON string passed straight through.
CLASS z2ui5_cl_demo_app_445 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_445 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `SHOW_TOAST`.
        " DISPLAY_MESSAGE_TOAST: message, options -> MessageToast.show( )
        client->follow_up_action(
            val   = client->cs_event-display_message_toast
            t_arg = VALUE #(
                ( `Toast with custom options, 1:1 to MessageToast.show( ).` )
                ( `{"duration":5000,"width":"25em","my":"center center","at":"center center"}` ) ) ).
      WHEN `SHOW_BOX`.
        " DISPLAY_MESSAGE_BOX: method, message, options -> MessageBox[method]( )
        client->follow_up_action(
            val   = client->cs_event-display_message_box
            t_arg = VALUE #(
                ( `confirm` )
                ( `Message box with title and custom actions, 1:1 to MessageBox.show( ).` )
                ( `{"title":"abap2UI5","actions":["Approve","Reject"],"emphasizedAction":"Approve"}` ) ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
            title          = `abap2UI5 - Sample: DISPLAY_MESSAGE_BOX / DISPLAY_MESSAGE_TOAST`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->panel(
            headertext = `Call the MessageToast / MessageBox control API 1:1`
        )->vbox(
            class = `sapUiSmallMargin`
            )->button(
                text  = `Show MessageToast (1:1 options)`
                class = `sapUiTinyMarginBottom`
                press = client->_event( `SHOW_TOAST` )
            )->button(
                text  = `Show MessageBox confirm (1:1 options)`
                press = client->_event( `SHOW_BOX` ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
