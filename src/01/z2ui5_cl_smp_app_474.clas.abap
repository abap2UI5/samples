" @keywords url policy link security validator relative allow deny
" @summary The URL policy of a MessagePopover: which links it will follow and which it refuses, and why the default is the strict one.
" @docs https://abap2ui5.github.io/docs/cookbook/translation_messages/message
CLASS z2ui5_cl_smp_app_474 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_474 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

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
    DATA temp1 TYPE string_table.
    DATA temp3 TYPE string_table.
    CLEAR temp1.
    INSERT `msgPopover` INTO TABLE temp1.
    INSERT `setAsyncURLHandler` INTO TABLE temp1.
    INSERT policy INTO TABLE temp1.
    client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                              t_arg = temp1 ).

    " ... and only then open it, anchored to the button that fired the event
    
    CLEAR temp3.
    INSERT `msgPopover` INTO TABLE temp3.
    INSERT `openBy` INTO TABLE temp3.
    INSERT client->get_event_arg( ) INTO TABLE temp3.
    client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                              t_arg = temp3 ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp5 TYPE string_table.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Message - MessagePopover URL Policy`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Each message below carries an in-app link and an external one. The policy ` &&
                   `applied when opening decides which of them the popover keeps clickable - ` &&
                   `RELATIVE_ONLY blocks everything that leaves the app, ALLOW_ALL keeps every ` &&
                   `link, DENY_ALL blocks all of them. The policy travels as data, the frontend ` &&
                   `installs the validator (setAsyncURLHandler).`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `dependents`
        )->ele( `MessagePopover`
            )->a( n = `id` v = `msgPopover`
            )->ele( `MessageItem`
                )->a( n = `type`              v = `Error`
                )->a( n = `title`             v = `Order cannot be released`
                )->a( n = `description`       v = `Check the <a href="#/orders/4711">order details</a> or the ` &&
                                    `<a href="https://abap2ui5.org">documentation</a>.`
                )->a( n = `markupDescription` b = abap_true
            )->end(
            )->ele( `MessageItem`
                )->a( n = `type`              v = `Warning`
                )->a( n = `title`             v = `Delivery date in the past`
                )->a( n = `description`       v = `Open the <a href="#/deliveries">delivery list</a> or the ` &&
                                    `<a href="https://sdk.openui5.org">UI5 demo kit</a>.`
                )->a( n = `markupDescription` b = abap_true
            )->end(
        )->end( ).

    
    CLEAR temp5.
    INSERT `$event.oSource.sId` INTO TABLE temp5.
    
    CLEAR temp1.
    INSERT `$event.oSource.sId` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `$event.oSource.sId` INTO TABLE temp2.
    page->ele( `HBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( val   = `OPEN_RELATIVE_ONLY`
                                    t_arg = temp5 )
            )->a( n = `text`  v = `Open with RELATIVE_ONLY`
            )->a( n = `type`  v = `Emphasized`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( val   = `OPEN_ALLOW_ALL`
                                    t_arg = temp1 )
            )->a( n = `text`  v = `Open with ALLOW_ALL`
            )->a( n = `class` v = `sapUiTinyMarginBegin`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( val   = `OPEN_DENY_ALL`
                                    t_arg = temp2 )
            )->a( n = `text`  v = `Open with DENY_ALL`
            )->a( n = `class` v = `sapUiTinyMarginBegin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
