CLASS z2ui5_cl_demo_app_467 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_message,
        message        TYPE string,
        description    TYPE string,
        type           TYPE string,
        target         TYPE string,
        additionaltext TYPE string,
      END OF ty_s_message.
    DATA t_messages TYPE STANDARD TABLE OF ty_s_message WITH EMPTY KEY.
    DATA name       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_467 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      " app-authored messages - the controller's MessageManager.addMessages
      " equivalent. The z2ui5.cc.MessageManager companion reconciles this
      " table into the central message manager: each row becomes a
      " sap.ui.core.message.Message with the view's model as processor, so a
      " row with a target sets that field's valueState too.
      t_messages = VALUE #(
          ( message        = `Please enter a valid name`
            type           = `Error`
            additionaltext = `Name`
            target         = `/NAME` )
          ( message        = `Draft saved automatically`
            type           = `Information`
            additionaltext = `Autosave` ) ).

      view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Messages - app-authored via z2ui5.cc.MessageManager`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `The messages below are authored by the app (not collected from control validation) ` &&
                   `and pushed into the central message model by the invisible z2ui5.cc.MessageManager ` &&
                   `companion bound to an ABAP table - the Error targets the Name field and colours it.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    " invisible companion control: reconciles /T_MESSAGES into the message
    " manager (adds the app's messages, removes its own when they drop out,
    " leaves auto-collected validation untouched)
    page->_generic( name   = `MessageManager`
                    ns     = `z2ui5`
                    t_prop = VALUE #( ( n = `items` v = client->_bind( t_messages ) ) ) ).

    page->simple_form( title    = `Registration`
                       editable = abap_true
                       class    = `sapUiSmallMargin`
        )->content(
            )->label( `Name`
            )->input( client->_bind_edit( name ) ).

    page->list( headertext = `Collected messages (message> model)`
                items      = `{message>/}`
                class      = `sapUiSmallMargin`
        )->standard_list_item( title       = `{message>message}`
                               description = `{message>additionalText}`
                               info        = `{message>type}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
