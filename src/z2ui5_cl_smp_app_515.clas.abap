" @keywords busy indicator global control_global show hide blocking wait spinner long running
" @summary Shows and hides the global BusyIndicator from ABAP through control_global - the singleton has no id, so a global target is the only wire that reaches it.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/frontend
CLASS z2ui5_cl_smp_app_515 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA status TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS busy_call
      IMPORTING
        method TYPE string
        arg    TYPE string OPTIONAL.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_515 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      status = `Idle - nothing running.`.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD busy_call.

    " sap.ui.core.BusyIndicator renders nothing of its own and has no id, so
    " control_by_id cannot address it - control_global is the only wire that
    " reaches a singleton like this one. t_arg is positional: the object, the
    " method, then its arguments. show( ) takes the delay in milliseconds
    " before the spinner appears; hide( ) takes none.
    client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_global
                              t_arg = COND #( WHEN arg IS INITIAL
                                              THEN VALUE #( ( `BUSY_INDICATOR` ) ( method ) )
                                              ELSE VALUE #( ( `BUSY_INDICATOR` ) ( method ) ( arg ) ) ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `START`.
        " The indicator blocks the whole screen, so nothing the user does can
        " take it away again - something in this response has to. A client
        " timer is what fills the gap here; a real app would hide it in the
        " handler of whatever it was waiting for.
        status = `Running - the BusyIndicator is up, the timer takes it away.`.
        busy_call( method = `show`
                   arg    = `0` ).
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-start_timer
                                  t_arg = VALUE #( ( `FINISHED` ) ( `2500` ) ) ).

      WHEN `FINISHED`.
        status = `Done - hide( ) was called from the timer's handler.`.
        busy_call( `hide` ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Control Behaviour - The Global Busy Indicator`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `abap2UI5 busies the screen for its own roundtrips already. This is the indicator an app ` &&
                   `drives itself, for a wait the framework knows nothing about - the eight whitelisted global objects are ` &&
                   `reached the same way, by name instead of by id.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`

        )->tag( `Button`
            )->a( n = `press` v = client->_event( `START` )
            )->a( n = `text`  v = `Show it for 2.5 seconds`
            )->a( n = `icon`  v = `sap-icon://busy`
            )->a( n = `type`  v = `Emphasized`

        )->tag( `ObjectStatus`
            )->a( n = `title` v = `Status`
            )->a( n = `text`  v = client->_bind( status )
            )->a( n = `class` v = `sapUiSmallMarginTop` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
