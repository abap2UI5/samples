" @keywords messagepopover messageitem dialog grouped message list
" @summary MessageView and MessagePopover over a list of messages, grouped by type, with the detail page behind each entry.
" @docs https://abap2ui5.github.io/docs/cookbook/translation_messages/message
CLASS z2ui5_cl_smp_app_452 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_452 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

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

    CASE client->get_event( ).
      WHEN `POPUP`.
        popup_display( ).
      WHEN `POPOVER`.
        popover_display( `messagePopoverBtn` ).
      WHEN `POPOVER_CLOSE`.
        client->popover_destroy( ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    " the footer button shows the current number of error messages - counted here in the backend, no frontend formatter involved
    DATA error_count TYPE i.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    error_count = 0.
    LOOP AT t_msg TRANSPORTING NO FIELDS WHERE type = `Error`.
      error_count = error_count + 1.
    ENDLOOP.

    
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Message - MessageView and MessagePopover`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This free-style demo combines the sap.m message controls: one bound message table is rendered three ways - as a full-page MessageView with grouped items, ` &&
                   `inside a dialog and as a MessagePopover. It is not a 1:1 demo kit rebuild (those live in the samples-controls repository) ` &&
                   `and stays within the UI5 1.71 control set.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `MessageView`
        )->a( n = `items`      v = client->_bind( t_msg )
        )->a( n = `groupItems` b = abap_true
        )->ele( `MessageItem`
            )->a( n = `type`        v = `{TYPE}`
            )->a( n = `title`       v = `{TITLE}`
            )->a( n = `subtitle`    v = `{SUBTITLE}`
            )->a( n = `description` v = `{DESCRIPTION}`
            )->a( n = `groupName`   v = `{GROUP}`
            )->tag( `Link`
                )->a( n = `text`   v = `Show more information`
                )->a( n = `target` v = `_blank`
                )->a( n = `href`   v = `http://sap.com` ).

    " ButtonType 'Negative' would match the error state, but it is only available since UI5 1.73 - src/01 must run on plain 1.71, so the default type is kept
    page->ele( `footer`
        )->ele( `OverflowToolbar`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `POPUP` )
                )->a( n = `text`  v = |{ error_count }|
                )->a( n = `icon`  v = `sap-icon://message-error`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `POPOVER` )
                )->a( n = `text`  v = `Message Popover`
                )->a( n = `id`    v = `messagePopoverBtn` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA dialog TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core` ).

    " the dialog keeps a plain title without a back button - closing and reopening it resets the MessageView to its list page
    
    dialog = popup->ele( `Dialog`
        )->a( n = `title`             v = `Publish order`
        )->a( n = `contentWidth`      v = `50%`
        )->a( n = `contentHeight`     v = `50%`
        )->a( n = `verticalScrolling` b = abap_false
        )->a( n = `afterClose`        v = client->follow_up_action( client->cs_event-popup_close ) ).

    dialog->ele( `MessageView`
        )->a( n = `items`      v = client->_bind( t_msg )
        )->a( n = `groupItems` b = abap_true
        )->ele( `MessageItem`
            )->a( n = `type`        v = `{TYPE}`
            )->a( n = `title`       v = `{TITLE}`
            )->a( n = `subtitle`    v = `{SUBTITLE}`
            )->a( n = `description` v = `{DESCRIPTION}`
            )->a( n = `groupName`   v = `{GROUP}`
            )->tag( `Link`
                )->a( n = `text`   v = `Show more information`
                )->a( n = `target` v = `_blank`
                )->a( n = `href`   v = `http://sap.com` ).

    dialog->ele( `endButton`
        )->tag( `Button`
            )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close )
            )->a( n = `text`  v = `Close` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popover_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core` ).

    popup->ele( `MessagePopover`
        )->a( n = `items`       v = client->_bind( t_msg )
        )->a( n = `placement`   v = `Top`
        )->a( n = `beforeClose` v = client->_event( `POPOVER_CLOSE` )
        )->ele( `MessageItem`
            )->a( n = `type`        v = `{TYPE}`
            )->a( n = `title`       v = `{TITLE}`
            )->a( n = `subtitle`    v = `{SUBTITLE}`
            )->a( n = `description` v = `{DESCRIPTION}`
            )->a( n = `groupName`   v = `{GROUP}`
            )->tag( `Link`
                )->a( n = `text`   v = `Show more information`
                )->a( n = `target` v = `_blank`
                )->a( n = `href`   v = `http://sap.com` ).

    client->popover_display( xml   = popup->stringify( )
                             by_id = id ).

  ENDMETHOD.

ENDCLASS.
