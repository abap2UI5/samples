" @keywords interval polling auto refresh follow_up_action seconds
" @summary Refreshes the view every n seconds - the polling interval as a follow-up action the app renews itself.
" @docs https://abap2ui5.github.io/docs/cookbook/browser_interaction/timer
CLASS z2ui5_cl_smp_app_028 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        checkbox TYPE abap_bool,
      END OF ty_s_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    DATA counter TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS start_timer.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_028 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( `TIMER_FINISHED` ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    counter = 1.
    t_tab = VALUE #(
        ( title = |entry{ counter }|
          info  = `completed`
          descr = `this is a description`
          icon  = `sap-icon://account` ) ).

    start_timer( ).

  ENDMETHOD.


  METHOD on_event.

    counter = counter + 1.
    INSERT VALUE #(
        title = |entry{ counter }|
        info  = `completed`
        descr = `this is a description`
        icon  = `sap-icon://account` )
      INTO TABLE t_tab.

    IF counter < 3.
      start_timer( ).
    ELSE.
      client->message_toast_display( `timer deactivated` ).
    ENDIF.

  ENDMETHOD.


  METHOD start_timer.

    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-start_timer
        t_arg = VALUE #( ( `TIMER_FINISHED` ) ( `2000` ) ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Timer - Refresh the View Every n Seconds`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The list refreshes itself automatically: a client-side timer (follow_up_action) fires ` &&
                   `every 2 seconds, appending a new entry on the server until three rows exist.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `List`
        )->a( n = `headerText` v = `Data auto refresh (2 sec)`
        )->a( n = `items`      v = client->_bind( t_tab )
        )->tag( `StandardListItem`
            )->a( n = `title`       v = `{TITLE}`
            )->a( n = `description` v = `{DESCR}`
            )->a( n = `icon`        v = `{ICON}`
            )->a( n = `info`        v = `{INFO}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
