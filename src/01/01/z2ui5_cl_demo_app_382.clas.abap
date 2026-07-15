CLASS z2ui5_cl_demo_app_382 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA title TYPE string.
    DATA message TYPE string.
    DATA details TYPE string.

  PROTECTED SECTION.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_382 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    title   = `abap2UI5`.
    message = `This is a message box.`.
    details = `These are additional details about the message.`.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `CUSTOM`.
        client->message_box_display(
            text             = message
            title            = title
            type             = `information`
            details          = details
            actions          = VALUE #( ( `Approve` ) ( `Reject` ) )
            emphasizedaction = `Approve` ).
      WHEN OTHERS.
        client->message_box_display(
            text    = message
            title   = title
            type    = client->get( )-event
            details = details ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Message Box`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageBox/sample/sap.m.sample.MessageBox` ).

    page->panel( headertext = `Message Box Configuration`
             )->simple_form(
                 title    = `Settings`
                 editable = abap_true
                 )->content( `form`
                 )->label( `Title`
                 )->input( client->_bind_edit( title )
                 )->label( `Message`
                 )->input( client->_bind_edit( message )
                 )->label( `Details`
                 )->text_area(
                     value = client->_bind_edit( details )
                     rows  = `3` ).

    page->footer(
        )->overflow_toolbar(
            )->button(
                text  = `Back`
                icon  = `sap-icon://nav-back`
                press = client->_event_nav_app_leave( )
            )->text( `Open Message Box:`
            )->toolbar_spacer(
            )->button(
                text  = `Confirm`
                press = client->_event( `confirm` )
            )->button(
                text  = `Information`
                press = client->_event( `information` )
            )->button(
                text  = `Success`
                type  = `Success`
                press = client->_event( `success` )
            )->button(
                text  = `Warning`
                press = client->_event( `warning` )
            )->button(
                text  = `Error`
                type  = `Reject`
                press = client->_event( `error` )
            )->button(
                text  = `Custom`
                type  = `Emphasized`
                press = client->_event( `CUSTOM` ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
