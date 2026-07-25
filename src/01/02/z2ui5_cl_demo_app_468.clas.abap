"! Hash-based app routing (UI5 Router style) - demonstrates the three modes of
"! client->set_nav_routing( ) so the difference between them can be observed
"! directly with the browser's Back button:
"!
"!  - default : routing off (framework behaviour before hash routing). The URL
"!              keeps no '#/app/...' route, so the browser Back button leaves
"!              the app entirely - only the in-app Back button returns.
"!  - fresh   : the URL mirrors the running app by CLASS only ('#/app/<CLASS>').
"!              Browser Back/Forward (and reload / bookmark) start the app FRESH
"!              - the input, counter and picked mode are gone.
"!  - keep    : the URL also carries the app-state draft ('#/app/<CLASS>/<DRAFT>')
"!              so browser Back/Forward restore the EXACT state - input, counter
"!              and mode come back unchanged.
"!
"! Pick a mode, put in some state (type / raise the counter), open the detail
"! page (z2ui5_cl_demo_app_469) via client->nav_app_call( ), then press the
"! BROWSER Back button and watch this page.
CLASS z2ui5_cl_demo_app_468 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mode    TYPE string.
    DATA input   TYPE string.
    DATA counter TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.
    METHODS button_type
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE string.
    METHODS mode_hint
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_468 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      mode = client->cs_nav_mode-keep.
      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `MODE_DEFAULT`.
        mode = client->cs_nav_mode-default.
        view_display( ).

      WHEN `MODE_FRESH`.
        mode = client->cs_nav_mode-fresh.
        view_display( ).

      WHEN `MODE_KEEP`.
        mode = client->cs_nav_mode-keep.
        view_display( ).

      WHEN `INC`.
        counter = counter + 1.
        view_display( ).

      WHEN `GO_DETAIL`.
        client->nav_app_call( NEW z2ui5_cl_demo_app_469( ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    " assert the picked routing mode on every render, so THIS page's history
    " entry (the one the browser Back button returns to) is written under it
    client->set_nav_routing( mode ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell( )->page(
        title          = `abap2UI5 - Navigation - Routing Modes`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Pick a routing mode, add some state (type / raise the counter), open the detail page, ` &&
                   `then press your BROWSER Back button and watch this page.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(form) = page->grid( `L6 M12 S12`
        )->content( `layout`
        )->simple_form( `Try the routing modes`
        )->content( `form` ).

    form->label( |1. Routing mode (current: { mode })| ).
    form->button(
        text  = `default`
        type  = button_type( client->cs_nav_mode-default )
        press = client->_event( `MODE_DEFAULT` ) ).
    form->button(
        text  = `fresh`
        type  = button_type( client->cs_nav_mode-fresh )
        press = client->_event( `MODE_FRESH` ) ).
    form->button(
        text  = `keep`
        type  = button_type( client->cs_nav_mode-keep )
        press = client->_event( `MODE_KEEP` ) ).

    form->label( `2. Some state - type here` ).
    form->input( client->_bind_edit( input ) ).

    form->label( `and raise a counter` ).
    form->button(
        text  = |increment ({ counter })|
        press = client->_event( `INC` ) ).

    form->label( `3. Navigate forward` ).
    form->button(
        text  = `go to the detail page (nav_app_call)`
        type  = `Emphasized`
        press = client->_event( `GO_DETAIL` ) ).

    page->message_strip(
        text     = mode_hint( )
        type     = COND #( WHEN mode = client->cs_nav_mode-default THEN `Warning` ELSE `Success` )
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD button_type.

    result = COND #( WHEN val = mode THEN `Emphasized` ELSE `Transparent` ).

  ENDMETHOD.


  METHOD mode_hint.

    result = SWITCH #( mode
      WHEN client->cs_nav_mode-keep THEN
        `keep: the URL carries the app-state draft (#/app/<CLASS>/<DRAFT>). After the detail page, the ` &&
        `browser Back button restores this page EXACTLY - input, counter and mode come back.`
      WHEN client->cs_nav_mode-fresh THEN
        `fresh: the URL carries the class only (#/app/<CLASS>). After the detail page, the browser Back ` &&
        `button starts this app FRESH - input, counter and mode are reset.`
      ELSE
        `default: no #/app route is written. After the detail page, the browser Back button leaves the ` &&
        `app entirely (as before hash routing) - use the in-app Back button to return.` ).

  ENDMETHOD.
ENDCLASS.
