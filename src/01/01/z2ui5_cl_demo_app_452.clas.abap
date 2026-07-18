CLASS z2ui5_cl_demo_app_452 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_msg,
        type        TYPE string,
        title       TYPE string,
        subtitle    TYPE string,
        description TYPE string,
        group       TYPE string,
      END OF ty_s_msg.
    DATA t_msg TYPE STANDARD TABLE OF ty_s_msg WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS popup_display.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_452 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    " the original controller reuses the same long description text for every message
    DATA(description) = `First Error message description. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ` &&
      `Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ` &&
      `Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ` &&
      `Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`.

    t_msg = VALUE #(
        ( type        = `Error`
          title       = `Account 801 requires an assignment`
          subtitle    = `Role is invalid`
          description = description
          group       = `Purchase Order 450001` )
        ( type        = `Warning`
          title       = `Account 821 requires a check`
          subtitle    = `Undefined task`
          description = description
          group       = `Purchase Order 450001` )
        ( type        = `Warning`
          title       = `Enter a text with maximum 6 characters length`
          description = description
          group       = `Purchase Order 450002` )
        ( type        = `Warning`
          title       = `Enter a text with maximum 8 characters length`
          description = description
          group       = `Purchase Order 450002` )
        ( type        = `Error`
          title       = `Account 802 requires an assignment`
          subtitle    = `Role is invalid`
          description = description
          group       = `Purchase Order 450002` )
        ( type        = `Information`
          title       = `Account 804 requires an assignment`
          subtitle    = `Information type subtitle`
          description = description
          group       = `Purchase Order 450002` )
        ( type        = `Error`
          title       = `Technical message without object relation`
          description = description
          group       = `General` )
        ( type        = `Warning`
          title       = `Global System will be down on Sunday`
          description = description
          group       = `General` )
        ( type        = `Error`
          title       = `Global System will be down on Sunday`
          description = description
          group       = `General` )
        ( type        = `Error`
          title       = `An Error`
          subtitle    = `Ungrouped message`
          description = description )
        ( type        = `Warning`
          title       = `A Warning`
          subtitle    = `Ungrouped message`
          description = description ) ).

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `POPUP`.
        popup_display( ).
      WHEN `POPOVER`.
        popover_display( `messagePopoverBtn` ).
      WHEN `POPOVER_CLOSE`.
        client->popover_destroy( ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    " the original derives the footer button icon and text from the highest message severity via formatters - here Error
    DATA(error_count) = 0.
    LOOP AT t_msg TRANSPORTING NO FIELDS WHERE type = `Error`.
      error_count = error_count + 1.
    ENDLOOP.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Message View with Grouping`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MessageView/sample/sap.m.sample.MessageViewWithGrouping` ).

    page->message_view(
        items      = client->_bind( t_msg )
        groupitems = abap_true
        )->message_item(
            type        = `{TYPE}`
            title       = `{TITLE}`
            subtitle    = `{SUBTITLE}`
            description = `{DESCRIPTION}`
            groupname   = `{GROUP}`
            )->link(
                text   = `Show more information`
                href   = `http://sap.com`
                target = `_blank` ).

    " the original renders the footer button with type 'Negative' - the type is only available since UI5 1.73, therefore omitted
    page->footer( )->overflow_toolbar(
        )->button(
            icon  = `sap-icon://message-error`
            text  = |{ error_count }|
            press = client->_event( `POPUP` )
        )->toolbar_spacer(
        )->button(
            id    = `messagePopoverBtn`
            text  = `Message Popover`
            press = client->_event( `POPOVER` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_display.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    " the original hosts a back button for the message details in a custom header - here the dialog keeps the plain title
    DATA(dialog) = popup->dialog(
        title             = `Publish order`
        contentheight     = `50%`
        contentwidth      = `50%`
        verticalscrolling = abap_false
        afterclose        = client->_event_client( client->cs_event-popup_close ) ).

    dialog->message_view(
        items      = client->_bind( t_msg )
        groupitems = abap_true
        )->message_item(
            type        = `{TYPE}`
            title       = `{TITLE}`
            subtitle    = `{SUBTITLE}`
            description = `{DESCRIPTION}`
            groupname   = `{GROUP}`
            )->link(
                text   = `Show more information`
                href   = `http://sap.com`
                target = `_blank` ).

    dialog->end_button( )->button(
        text  = `Close`
        press = client->_event_client( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popover_display.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    popup->message_popover(
        items       = client->_bind( t_msg )
        groupitems  = abap_true
        placement   = `Top`
        beforeclose = client->_event( `POPOVER_CLOSE` )
        )->message_item(
            type        = `{TYPE}`
            title       = `{TITLE}`
            subtitle    = `{SUBTITLE}`
            description = `{DESCRIPTION}`
            groupname   = `{GROUP}`
            )->link(
                text   = `Show more information`
                href   = `http://sap.com`
                target = `_blank` ).

    client->popover_display( xml   = popup->stringify( )
                             by_id = id ).

  ENDMETHOD.

ENDCLASS.
