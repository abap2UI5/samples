"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageView/sample/sap.m.sample.MessageViewMessageManager
"! A sample showing how you can connect the MessageView with MessageManager.
CLASS z2ui5_cl_demo_app_449 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_message,
        type            TYPE string,
        message         TYPE string,
        additional_text TYPE string,
        description     TYPE string,
      END OF ty_s_message.
    DATA t_messages TYPE STANDARD TABLE OF ty_s_message WITH EMPTY KEY.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_449 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Message View connected with Message Model`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageView/sample/sap.m.sample.MessageViewMessageManager` ).

    " the MessageManager/message model is not available in abap2UI5 - the messages are bound from a hardcoded table instead
    page->message_view( items = client->_bind( t_messages )
        )->message_item(
            type        = `{TYPE}`
            title       = `{MESSAGE}`
            subtitle    = `{ADDITIONAL_TEXT}`
            description = `{DESCRIPTION}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      t_messages = VALUE #(
        ( type            = `Error`
          message         = `Error message`
          additional_text = `Example of additionalText`
          description     = `Example of description` )
        ( type            = `Information`
          message         = `Information message`
          additional_text = `Example of additionalText`
          description     = `Example of description` )
        ( type            = `Success`
          message         = `Success message`
          additional_text = `Example of additionalText`
          description     = `Example of description` )
        ( type            = `Warning`
          message         = `Warning message`
          additional_text = `Example of additionalText`
          description     = `Example of description` ) ).

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
