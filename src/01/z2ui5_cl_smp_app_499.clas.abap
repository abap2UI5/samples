" @keywords routing hash url page browser back forward history deep link reload set_hash_listener set_push_state history_back navcontainer router
" @summary The app owns its URL hash like a UI5 router: #/detail while navigating, browser Back and Forward switch the pages, a deep link restores.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/routing
"! App-owned hash routing - the URL semantics of a UI5 router, 1:1:
"!
"!  - the start URL carries NO hash
"!  - opening the detail page writes '#/detail' (set_push_state, a real
"!    history entry)
"!  - the BROWSER Back/Forward buttons - and a manual edit of the hash -
"!    round-trip as the event set_hash_listener registered, and the handler
"!    shows the page the live hash (get( )-s_config-hash) names; the app
"!    instance is untouched, so the entered data survives
"!  - the in-app back button is cs_event-history_back, a real
"!    window.history.go(-1) - exactly what a router app's nav-back does
"!  - a reload or a shared link with '#/detail' lands on the detail page
"!
"! Replaces the former z2ui5_cl_smp_app_322, which pushed a suffix past the
"! UI5 HashChanger and had to reach for raw JavaScript to step back.
CLASS z2ui5_cl_smp_app_499 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA quantity TYPE string.

  PROTECTED SECTION.
    DATA client       TYPE REF TO z2ui5_if_client.
    DATA check_detail TYPE abap_bool.

    METHODS view_display.
    METHODS on_event.
    METHODS hash_apply.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_499 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_navigated( ).
      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " a deep link / reload: the live hash rides in s_config-hash on every
    " request, so a render whose hash already names the detail page starts
    " there - the routeMatched of a cold start
    hash_apply( ).

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).
    DATA(nav) = view->ele( `Shell`
        )->ele( `NavContainer`
            )->a( n = `id` v = `nav` ).

    DATA(main) = nav->ele( `Page`
        )->a( n = `id`             v = `page-main`
        )->a( n = `title`          v = `abap2UI5 - App-Owned Hash Routing`
        )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
        )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    main->tag( `MessageStrip`
        )->a( n = `text`     v = `The URL has no hash right now. Type something, open the detail page and watch ` &&
                   `the address bar: the app writes #/detail, and the BROWSER Back button returns here ` &&
                   `- with the input still set.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(form) = main->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Some state`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form` ).

    form->tag( `Label`
        )->a( n = `text` v = `quantity` ).
    form->tag( `Input`
        )->a( n = `value` v = client->_bind( quantity ) ).

    form->tag( `Button`
        )->a( n = `press` v = client->_event( `GO_DETAIL` )
        )->a( n = `text`  v = `open the detail page (#/detail)`
        )->a( n = `type`  v = `Emphasized` ).

    DATA(detail) = nav->ele( `Page`
        )->a( n = `id`             v = `page-detail`
        )->a( n = `title`          v = `Detail (#/detail)`
        )->a( n = `showNavButton`  b = abap_true
        " the router app's nav-back: one real step back in the browser
        " history - the hash change then round-trips as HASH_CHANGED below
        )->a( n = `navButtonPress` v = client->follow_up_action( z2ui5_if_client=>cs_event-history_back ) ).

    detail->tag( `MessageStrip`
        )->a( n = `text`     v = `This page is #/detail. Reload the browser or share the URL - it lands here. ` &&
                   `The back arrow is cs_event-history_back, a real window.history.go(-1): the hash ` &&
                   `change comes back as the registered event and the app switches the page.`
        )->a( n = `type`     v = `Success`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    detail->tag( `ObjectStatus`
        )->a( n = `text`  v = client->_bind( quantity )
        )->a( n = `title` v = `quantity from the first page`
        )->a( n = `class` v = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

    " hash changes the app did not write itself (browser Back/Forward, a
    " manual edit) round-trip as HASH_CHANGED - registered per render, since
    " the registration dies with an app switch
    client->follow_up_action( val   = z2ui5_if_client=>cs_event-set_hash_listener
                              t_arg = VALUE #( ( `HASH_CHANGED` ) ) ).

    " a rebuilt NavContainer is back on its first page while check_detail
    " survives as class state - re-issue the page it should show
    IF check_detail = abap_true.
      client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                t_arg = VALUE #( ( `nav` ) ( `to` ) ( `page-detail` ) ) ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `GO_DETAIL`.
        " the router's navTo: switch the page and push the app-owned hash -
        " a real history entry, so the browser Back button has a step to take
        check_detail = abap_true.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                  t_arg = VALUE #( ( `nav` ) ( `to` ) ( `page-detail` ) ) ).
        client->set_push_state( `/detail` ).

      WHEN `HASH_CHANGED`.
        " the router's routeMatched: show the page the hash now names
        hash_apply( ).
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                  t_arg = VALUE #( ( `nav` )
                                                   ( `to` )
                                                   ( COND #( WHEN check_detail = abap_true
                                                             THEN `page-detail`
                                                             ELSE `page-main` ) ) ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD hash_apply.

    check_detail = xsdbool( client->get( )-s_config-hash CS `/detail` ).

  ENDMETHOD.

ENDCLASS.
