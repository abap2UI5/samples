" @keywords shortcut hotkey ctrl key combination keyboard_shortcut
" @summary Binds keyboard shortcuts such as Ctrl+S to backend events, so the app answers a key combination the way a desktop program would.
" @docs https://abap2ui5.github.io/docs/cookbook/browser_interaction/keyboard_shortcuts
CLASS z2ui5_cl_smp_app_471 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_log,
        entry TYPE string,
      END OF ty_s_log.
    DATA t_log TYPE STANDARD TABLE OF ty_s_log WITH EMPTY KEY.
    DATA registered TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS shortcuts_set
      IMPORTING
        event_save   TYPE string
        event_delete TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_471 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    registered = abap_true.
    shortcuts_set( event_save = `SAVE` event_delete = `DELETE` ).
    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SAVE`.
        INSERT VALUE #( entry = `Ctrl+S - save triggered` ) INTO TABLE t_log.
        client->message_toast_display( `Ctrl+S: save triggered` ).

      WHEN `DELETE`.
        INSERT VALUE #( entry = `Ctrl+D - delete triggered` ) INTO TABLE t_log.
        client->message_toast_display( `Ctrl+D: delete triggered` ).

      WHEN `TOGGLE_REGISTRATION`.
        registered = xsdbool( registered = abap_false ).

        IF registered = abap_true.
          shortcuts_set( event_save = `SAVE` event_delete = `DELETE` ).
        ELSE.
          " an empty event name removes the binding again
          shortcuts_set( event_save = `` event_delete = `` ).
        ENDIF.
        view_display( ).

      WHEN `CLEAR`.
        t_log = VALUE #( ).

    ENDCASE.

  ENDMETHOD.


  METHOD shortcuts_set.

    " one registration per key combination: t_arg is positional - the
    " combination (spelled like in UI5: Ctrl+S, Ctrl+Shift+D, F2) and the name
    " of the backend event it fires. Registering the same combination again
    " rebinds it, an empty event name removes it. The registry lives in the
    " frontend, so it survives every roundtrip until the app is left.
    client->follow_up_action( val   = z2ui5_if_client=>cs_event-keyboard_shortcut
                              t_arg = VALUE #( ( `Ctrl+S` )
                                               ( event_save ) ) ).

    client->follow_up_action( val   = z2ui5_if_client=>cs_event-keyboard_shortcut
                              t_arg = VALUE #( ( `Ctrl+D` )
                                               ( event_delete ) ) ).

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
            )->a( n = `title`          v = `abap2UI5 - Event - Keyboard Shortcuts, Ctrl+S`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Ctrl+S and Ctrl+D fire the backend events SAVE and DELETE - the same events the ` &&
                   `buttons below send, but from the keyboard and without a control. The binding is ` &&
                   `pure data (cs_event-keyboard_shortcut with the combination and the event name), ` &&
                   `the browser default for the combination is suppressed.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `HBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `TOGGLE_REGISTRATION` )
            )->a( n = `text`  v = COND #( WHEN registered = abap_true
                            THEN `Unregister the shortcuts`
                            ELSE `Register the shortcuts` )
            )->a( n = `icon`  v = `sap-icon://keyboard-and-mouse`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `SAVE` )
            )->a( n = `text`  v = `Save (Ctrl+S)`
            )->a( n = `type`  v = `Emphasized`
            )->a( n = `class` v = `sapUiTinyMarginBegin`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `DELETE` )
            )->a( n = `text`  v = `Delete (Ctrl+D)`
            )->a( n = `class` v = `sapUiTinyMarginBegin`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `CLEAR` )
            )->a( n = `text`  v = `Clear log`
            )->a( n = `class` v = `sapUiTinyMarginBegin` ).

    page->ele( `List`
        )->a( n = `headerText` v = `Triggered events`
        )->a( n = `items`      v = client->_bind( t_log )
        )->tag( `StandardListItem`
            )->a( n = `title` v = `{ENTRY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
