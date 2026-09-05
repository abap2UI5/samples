" @keywords routing mode keep navigation state preserved back nav_app_call
" @summary Hash routing in mode KEEP: the URL carries the app-state draft as well, so Back and Forward return to the state, not just to the app.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/navigation/hash
"! Hash-based app routing (UI5 Router style), mode KEEP:
"! follow_up_action( cs_event-hash_routing ) with mode KEEP makes the URL
"! carry the app-state draft as well ('#/app/[CLASS]/[DRAFT]'), so Back/Forward
"! restore the EXACT state: the input and the counter come back unchanged.
"!
"! Put in some state (type / raise the counter), open the detail page
"! (z2ui5_cl_smp_app_469) via client->nav_app_call( ), then press the BROWSER
"! Back button and watch this page - it comes back exactly as you left it.
"!
"! z2ui5_cl_smp_app_468 is the same demo in mode FRESH, where the state is lost.
CLASS z2ui5_cl_smp_app_480 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA input   TYPE string.
    DATA counter TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_480 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE REF TO z2ui5_cl_smp_app_469.

    CASE client->get_event( ).

      WHEN `INC`.
        counter = counter + 1.
        view_display( ).

      WHEN `GO_DETAIL`.
        
        CREATE OBJECT temp1 TYPE z2ui5_cl_smp_app_469.
        client->nav_app_call( temp1 ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.
      DATA temp2 TYPE string_table.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.

    " configure the routing mode once - the framework remembers it on the app
    " and re-sends it whenever the frontend may not hold it (page load,
    " Back/Forward restore, navigation hops)
    IF client->check_on_init( ) IS NOT INITIAL.
      
      CLEAR temp2.
      INSERT client->cs_nav_mode-keep INTO TABLE temp2.
      client->follow_up_action( val   = client->cs_event-hash_routing
                                t_arg = temp2 ).
    ENDIF.

    
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Navigation - Routing Mode keep`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Add some state (type / raise the counter), open the detail page, then press your ` &&
                   `BROWSER Back button and watch this page.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    form = page->ele( n = `Grid` ns = `layout`
        )->a( n = `defaultSpan` v = `L6 M12 S12`
        )->ele( n = `content` ns = `layout`
            )->ele( n = `SimpleForm` ns = `form`
                )->a( n = `title` v = `Routing mode keep`
                )->ele( n = `content` ns = `form` ).

    form->tag( `Label`
        )->a( n = `text` v = `1. Some state - type here` ).
    form->tag( `Input`
        )->a( n = `value` v = client->_bind( input ) ).

    form->tag( `Label`
        )->a( n = `text` v = `and raise a counter` ).
    form->tag( `Button`
        )->a( n = `press` v = client->_event( `INC` )
        )->a( n = `text`  v = |increment ({ counter })| ).

    form->tag( `Label`
        )->a( n = `text` v = `2. Navigate forward` ).
    form->tag( `Button`
        )->a( n = `press` v = client->_event( `GO_DETAIL` )
        )->a( n = `text`  v = `go to the detail page (nav_app_call)`
        )->a( n = `type`  v = `Emphasized` ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `keep: the URL carries the app-state draft (#/app/<CLASS>/<DRAFT>). After the detail ` &&
                   `page, the browser Back button restores this page EXACTLY - input and counter come back.`
        )->a( n = `type`     v = `Success`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
