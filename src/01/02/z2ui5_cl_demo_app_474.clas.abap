CLASS z2ui5_cl_demo_app_474 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS popover_open
      IMPORTING
        policy TYPE string.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_474 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `OPEN_RELATIVE_ONLY`.
        popover_open( `RELATIVE_ONLY` ).

      WHEN `OPEN_ALLOW_ALL`.
        popover_open( `ALLOW_ALL` ).

      WHEN `OPEN_DENY_ALL`.
        popover_open( `DENY_ALL` ).

    ENDCASE.

  ENDMETHOD.


  METHOD popover_open.

    " setAsyncURLHandler takes a JS callback in a UI5 controller, which no
    " backend payload can carry - the frontend therefore takes the NAME of a
    " built-in policy and installs the matching validator itself:
    " RELATIVE_ONLY (only in-app links stay clickable), ALLOW_ALL, DENY_ALL
    client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                              t_arg = VALUE #( ( `msgPopover` )
                                               ( `setAsyncURLHandler` )
                                               ( policy ) ) ).

    " ... and only then open it, anchored to the button that fired the event
    client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                              t_arg = VALUE #( ( `msgPopover` )
                                               ( `openBy` )
                                               ( client->get_event_arg( ) ) ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - MessagePopover URL Policy`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Each message below carries an in-app link and an external one. The policy ` &&
                   `applied when opening decides which of them the popover keeps clickable - ` &&
                   `RELATIVE_ONLY blocks everything that leaves the app, ALLOW_ALL keeps every ` &&
                   `link, DENY_ALL blocks all of them. The policy travels as data, the frontend ` &&
                   `installs the validator (setAsyncURLHandler).`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->dependents(
        )->message_popover( id = `msgPopover`
            )->message_item(
                type              = `Error`
                title             = `Order cannot be released`
                markupdescription = abap_true
                description       = `Check the <a href="#/orders/4711">order details</a> or the ` &&
                                    `<a href="https://abap2ui5.org">documentation</a>.`
            )->get_parent(
            )->message_item(
                type              = `Warning`
                title             = `Delivery date in the past`
                markupdescription = abap_true
                description       = `Open the <a href="#/deliveries">delivery list</a> or the ` &&
                                    `<a href="https://ui5.sap.com">UI5 demo kit</a>.`
            )->get_parent(
            )->get_parent( ).

    page->hbox( class = `sapUiSmallMargin`
        )->button(
            text  = `Open with RELATIVE_ONLY`
            type  = `Emphasized`
            press = client->_event( val   = `OPEN_RELATIVE_ONLY`
                                    t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
        )->button(
            text  = `Open with ALLOW_ALL`
            class = `sapUiTinyMarginBegin`
            press = client->_event( val   = `OPEN_ALLOW_ALL`
                                    t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
        )->button(
            text  = `Open with DENY_ALL`
            class = `sapUiTinyMarginBegin`
            press = client->_event( val   = `OPEN_DENY_ALL`
                                    t_arg = VALUE #( ( `$event.oSource.sId` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
