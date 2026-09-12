" @keywords livechange keystroke queue busy roundtrip dropped event check_queue_last s_ctrl
" @summary Two identical liveChange wires side by side: the plain one drops every keystroke typed while a round-trip runs, the one registered with check_queue_last keeps the last of them, so the backend ends on what you typed.
"! abap2UI5 serializes round-trips: while one is in flight the app is busy and
"! an event fired meanwhile is DROPPED. Right for a click, wrong for a wire
"! that fires per keystroke - typing `abc` at once leaves the backend at `a`
"! until the user pauses and types again. s_ctrl-check_queue_last keeps the
"! LAST event fired during the flight in a one-slot buffer and dispatches it
"! once the response has landed: one round-trip at a time, order preserved,
"! the backend ends on the control's current value.
"!
"! Needs abap2UI5 newer than 1.144.0 - check_queue_last is appended to
"! ty_s_event_control after that release; on an older framework the class
"! does not activate (unknown component of s_ctrl).
CLASS z2ui5_cl_smp_app_511 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA plain_backend  TYPE string.
    DATA plain_count    TYPE i.
    DATA queued_backend TYPE string.
    DATA queued_count   TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_511 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).

    ELSEIF client->check_on_event( `PLAIN` ).

      plain_backend = client->get_event_arg( ).
      plain_count   = plain_count + 1.

    ELSEIF client->check_on_event( `QUEUED` ).

      queued_backend = client->get_event_arg( ).
      queued_count   = queued_count + 1.

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " Both Inputs below round-trip on every keystroke on purpose: this sample
    " EXISTS to show what the busy guard does to such a wire, and what the
    " check_queue_last flag changes about it.
    " abap2ui5lint-disable live-event-roundtrip

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock`  v = `true`
            )->a( n = `height`        v = `100%`
            )->a( n = `xmlns`         v = `sap.m`
            )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
            )->a( n = `xmlns:layout`  v = `sap.ui.layout` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Event - Keep the Last Keystroke with check_queue_last`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `abap2UI5 runs one round-trip at a time, and an event fired while one is in flight is dropped. ` &&
                   `Type quickly into both fields: the left backend value stops at an earlier keystroke, the right one ` &&
                   `ends on what you typed - its wire is registered with s_ctrl-check_queue_last, so the last event ` &&
                   `fired during the flight is kept and sent once the response has landed. The flag is for ` &&
                   `per-keystroke wires only (liveChange, liveSearch, sliderChange) and is not combined with ` &&
                   `check_allow_multi_req, which sends every keystroke at once and lets the responses land in any order.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " The Inputs are deliberately NOT bound: the keystroke travels as the
    " event argument ${$parameters>/value} and nowhere else, so what the
    " backend Text shows is exactly what the wire delivered.
    DATA(grid) = page->ele( n = `Grid` ns = `layout`
        )->a( n = `defaultSpan` v = `XL6 L6 M6 S12`
        )->ele( n = `content` ns = `layout` ).

    " left: the plain wire - keystrokes typed while a round-trip runs are dropped
    grid->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Title`
            )->a( n = `text`  v = `Plain wire - dropped while busy`
            )->a( n = `level` v = `H4`
        )->tag( `Input`
            )->a( n = `placeholder` v = `Type quickly ...`
            )->a( n = `liveChange`  v = client->_event(
                val   = `PLAIN`
                t_arg = VALUE #( ( `${$parameters>/value}` ) ) )
        )->tag( `Label`
            )->a( n = `text` v = `Value in the backend`
        )->tag( `Text`
            )->a( n = `text` v = client->_bind( plain_backend )
        )->tag( `Label`
            )->a( n = `text` v = `Round-trips`
        )->tag( `Text`
            )->a( n = `text` v = client->_bind( plain_count ) ).

    " right: the same wire with check_queue_last - the last keystroke of the
    " flight is kept and dispatched after the response
    grid->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Title`
            )->a( n = `text`  v = `check_queue_last - the last keystroke is kept`
            )->a( n = `level` v = `H4`
        )->tag( `Input`
            )->a( n = `placeholder` v = `Type quickly ...`
            )->a( n = `liveChange`  v = client->_event(
                val    = `QUEUED`
                t_arg  = VALUE #( ( `${$parameters>/value}` ) )
                s_ctrl = VALUE #( check_queue_last = abap_true ) )
        )->tag( `Label`
            )->a( n = `text` v = `Value in the backend`
        )->tag( `Text`
            )->a( n = `text` v = client->_bind( queued_backend )
        )->tag( `Label`
            )->a( n = `text` v = `Round-trips`
        )->tag( `Text`
            )->a( n = `text` v = client->_bind( queued_count ) ).

    client->view_display( view->stringify( ) ).

    " abap2ui5lint-enable live-event-roundtrip

  ENDMETHOD.

ENDCLASS.
