" @keywords routing hash url page browser back forward history deep link reload hash_set hash_replace hash_back hash_attach_changed navcontainer router onnavback
" @summary The whole hash_* family in one app: hash_set pushes #/detail, hash_replace rewrites it in place, hash_back steps back like a router, a deep link restores.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/navigation/hash
"! App-owned hash routing - the URL semantics of a UI5 router, 1:1, and the
"! whole hash_* family (named after sap/ui/core/routing/HashChanger) in one
"! place:
"!
"!  - the start URL carries NO hash
"!  - opening the detail page writes '#/detail' via hash_set - setHash, a
"!    real PUSHED history entry
"!  - switching the detail variant rewrites the URL via hash_replace -
"!    replaceHash, NO new entry: the browser Back button skips the variant
"!    switches and returns straight to the first page
"!  - the BROWSER Back/Forward buttons - and a manual edit of the hash -
"!    round-trip as the event hash_attach_changed registered, and the
"!    handler shows the page the live hash (get( )-s_config-hash) names;
"!    the app instance is untouched, so the entered data survives
"!  - the in-app back button is cs_event-hash_back with '/' as its
"!    FALLBACK: the UI5 onNavBack pattern. Normally one real, consumed
"!    window.history.go(-1) - but on a COLD deep link ('#/detail' opened
"!    fresh) there is no in-app step to take, so the fallback replaces to
"!    the start page instead of falling out of the app
"!  - a reload or a shared link with '#/detail' lands on the detail page
"!
"! The draft-based routing modes (cs_event-hash_routing) are the siblings
"! z2ui5_cl_smp_app_468 and z2ui5_cl_smp_app_480. Replaces the former
"! z2ui5_cl_smp_app_322, which pushed a suffix past the UI5 HashChanger and
"! had to reach for raw JavaScript to step back.
CLASS z2ui5_cl_smp_app_499 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA quantity TYPE string.
    DATA variant  TYPE string VALUE `a`.

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

    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA nav TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA main TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA detail TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA vform TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
      DATA temp5 TYPE string_table.

    " a deep link / reload: the live hash rides in s_config-hash on every
    " request, so a render whose hash already names the detail page starts
    " there - the routeMatched of a cold start
    hash_apply( ).

    
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).
    
    nav = view->ele( `Shell`
        )->ele( `NavContainer`
            )->a( n = `id` v = `nav` ).

    
    main = nav->ele( `Page`
        )->a( n = `id`             v = `page-main`
        )->a( n = `title`          v = `abap2UI5 - App-Owned Hash Routing`
        )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
        )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    main->tag( `MessageStrip`
        )->a( n = `text`     v = `The URL has no hash right now. Type something, open the detail page and watch ` &&
                   `the address bar: hash_set writes #/detail, and the BROWSER Back button returns here ` &&
                   `- with the input still set.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    form = main->ele( n = `SimpleForm` ns = `form`
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

    
    CLEAR temp1.
    INSERT `/` INTO TABLE temp1.
    
    detail = nav->ele( `Page`
        )->a( n = `id`             v = `page-detail`
        )->a( n = `title`          v = `Detail (#/detail)`
        )->a( n = `showNavButton`  b = abap_true
        " the router app's nav-back, the UI5 onNavBack pattern: one real,
        " CONSUMED step back in the browser history - and on a cold deep
        " link, where no step exists, a REPLACE to the '/' fallback. Either
        " way the hash change round-trips as HASH_CHANGED below
        )->a( n = `navButtonPress` v = client->follow_up_action( val   = z2ui5_if_client=>cs_event-hash_back
                                                                 t_arg = temp1 ) ).

    detail->tag( `MessageStrip`
        )->a( n = `text`     v = `This page is #/detail. Reload the browser or share the URL - it lands here. ` &&
                   `The back arrow is cs_event-hash_back with '/' as fallback: normally a real ` &&
                   `window.history.go(-1), and on a cold deep link a replace to the start page.`
        )->a( n = `type`     v = `Success`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    vform = detail->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `hash_replace - the URL follows, Back skips it`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form` ).

    vform->tag( `Label`
        )->a( n = `text` v = `variant (watch the URL - and note Back still returns to the first page)` ).
    vform->ele( `SegmentedButton`
        )->a( n = `selectedKey`     v = client->_bind( variant )
        )->a( n = `selectionChange` v = client->_event( val = `VARIANT` arg = `${$parameters>/item}.getKey()` )
        )->ele( `items`
            )->tag( `SegmentedButtonItem`
                )->a( n = `key`  v = `a`
                )->a( n = `text` v = `Variant A`
            )->tag( `SegmentedButtonItem`
                )->a( n = `key`  v = `b`
                )->a( n = `text` v = `Variant B`
            )->tag( `SegmentedButtonItem`
                )->a( n = `key`  v = `c`
                )->a( n = `text` v = `Variant C`

        )->end(
    )->end( ).

    detail->tag( `ObjectStatus`
        )->a( n = `text`  v = client->_bind( quantity )
        )->a( n = `title` v = `quantity from the first page`
        )->a( n = `class` v = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

    " hash changes the app did not write itself (browser Back/Forward, a
    " manual edit) round-trip as HASH_CHANGED - registered per render, since
    " the registration dies with an app switch
    
    CLEAR temp3.
    INSERT `HASH_CHANGED` INTO TABLE temp3.
    client->follow_up_action( val   = z2ui5_if_client=>cs_event-hash_attach_changed
                              t_arg = temp3 ).

    " a rebuilt NavContainer is back on its first page while check_detail
    " survives as class state - re-issue the page it should show
    IF check_detail = abap_true.
      
      CLEAR temp5.
      INSERT `nav` INTO TABLE temp5.
      INSERT `to` INTO TABLE temp5.
      INSERT `page-detail` INTO TABLE temp5.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp5 ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA temp7 TYPE string_table.
        DATA temp9 TYPE string_table.
        DATA temp1 TYPE string.

    CASE client->get_event( ).

      WHEN `GO_DETAIL`.
        " the router's navTo: switch the page and PUSH the app-owned hash -
        " a real history entry, so the browser Back button has a step to take
        check_detail = abap_true.
        
        CLEAR temp7.
        INSERT `nav` INTO TABLE temp7.
        INSERT `to` INTO TABLE temp7.
        INSERT `page-detail` INTO TABLE temp7.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp7 ).
        client->hash_set( |/detail/{ variant }| ).

      WHEN `VARIANT`.
        " the router's replace-navTo: the URL follows the variant WITHOUT a
        " new history entry - Back keeps returning to the first page, not
        " through every variant ever clicked
        variant = client->get_event_arg( ).
        client->hash_replace( |/detail/{ variant }| ).

      WHEN `HASH_CHANGED`.
        " the router's routeMatched: show the page the hash now names
        hash_apply( ).
        
        CLEAR temp9.
        INSERT `nav` INTO TABLE temp9.
        INSERT `to` INTO TABLE temp9.
        
        IF check_detail = abap_true.
          temp1 = `page-detail`.
        ELSE.
          temp1 = `page-main`.
        ENDIF.
        INSERT temp1 INTO TABLE temp9.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp9 ).

    ENDCASE.

  ENDMETHOD.


  METHOD hash_apply.

    " '/detail' or '/detail/{variant}' - everything else is the first page
    DATA lv_hash TYPE z2ui5_if_client=>ty_s_get-s_config-hash.
    DATA temp1 TYPE xsdboolean.
      DATA lv_variant TYPE string.
    lv_hash = client->get( )-s_config-hash.
    
    temp1 = boolc( lv_hash CS `/detail` ).
    check_detail = temp1.
    IF check_detail = abap_true.
      
      lv_variant = substring_after( val = lv_hash sub = `/detail/` ).
      IF lv_variant CO `abc` AND lv_variant IS NOT INITIAL.
        variant = lv_variant.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
