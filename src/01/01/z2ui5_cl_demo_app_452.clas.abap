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
    DATA t_msg TYPE STANDARD TABLE OF ty_s_msg WITH DEFAULT KEY.

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
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    " the original controller reuses the same long description text for every message
    DATA description TYPE string.
    DATA temp1 LIKE t_msg.
    DATA temp2 LIKE LINE OF temp1.
    description = `First Error message description. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ` &&
      `Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ` &&
      `Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. ` &&
      `Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`.

    
    CLEAR temp1.
    
    temp2-type = `Error`.
    temp2-title = `Account 801 requires an assignment`.
    temp2-subtitle = `Role is invalid`.
    temp2-description = description.
    temp2-group = `Purchase Order 450001`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Warning`.
    temp2-title = `Account 821 requires a check`.
    temp2-subtitle = `Undefined task`.
    temp2-description = description.
    temp2-group = `Purchase Order 450001`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Warning`.
    temp2-title = `Enter a text with maximum 6 characters length`.
    temp2-description = description.
    temp2-group = `Purchase Order 450002`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Warning`.
    temp2-title = `Enter a text with maximum 8 characters length`.
    temp2-description = description.
    temp2-group = `Purchase Order 450002`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Error`.
    temp2-title = `Account 802 requires an assignment`.
    temp2-subtitle = `Role is invalid`.
    temp2-description = description.
    temp2-group = `Purchase Order 450002`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Information`.
    temp2-title = `Account 804 requires an assignment`.
    temp2-subtitle = `Information type subtitle`.
    temp2-description = description.
    temp2-group = `Purchase Order 450002`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Error`.
    temp2-title = `Technical message without object relation`.
    temp2-description = description.
    temp2-group = `General`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Warning`.
    temp2-title = `Global System will be down on Sunday`.
    temp2-description = description.
    temp2-group = `General`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Error`.
    temp2-title = `Global System will be down on Sunday`.
    temp2-description = description.
    temp2-group = `General`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Error`.
    temp2-title = `An Error`.
    temp2-subtitle = `Ungrouped message`.
    temp2-description = description.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `Warning`.
    temp2-title = `A Warning`.
    temp2-subtitle = `Ungrouped message`.
    temp2-description = description.
    INSERT temp2 INTO TABLE temp1.
    t_msg = temp1.

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
    DATA error_count TYPE i.
    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    error_count = 0.
    LOOP AT t_msg TRANSPORTING NO FIELDS WHERE type = `Error`.
      error_count = error_count + 1.
    ENDLOOP.

    
    view = z2ui5_cl_xml_view=>factory( ).
    
    page = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Message View with Grouping`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `This sample demonstrates the MessageView control listing grouped messages by ` &&
                   `severity; the same messages also appear in a dialog and a MessagePopover.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

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

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    DATA dialog TYPE REF TO z2ui5_cl_xml_view.
    popup = z2ui5_cl_xml_view=>factory_popup( ).

    " the original hosts a back button for the message details in a custom header - here the dialog keeps the plain title
    
    dialog = popup->dialog(
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

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    popup = z2ui5_cl_xml_view=>factory_popup( ).

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
