CLASS z2ui5_cl_demo_app_471 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_471 IMPLEMENTATION.

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
    shortcuts_set( event_save   = `SAVE`
                   event_delete = `DELETE` ).
    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SAVE`.
        INSERT VALUE #( entry = `Ctrl+S - save triggered` ) INTO TABLE t_log.
        client->message_toast_display( `Ctrl+S: save triggered` ).
        client->view_model_update( ).

      WHEN `DELETE`.
        INSERT VALUE #( entry = `Ctrl+D - delete triggered` ) INTO TABLE t_log.
        client->message_toast_display( `Ctrl+D: delete triggered` ).
        client->view_model_update( ).

      WHEN `TOGGLE_REGISTRATION`.
        registered = xsdbool( registered = abap_false ).

        IF registered = abap_true.
          shortcuts_set( event_save   = `SAVE`
                         event_delete = `DELETE` ).
        ELSE.
          " an empty event name removes the binding again
          shortcuts_set( event_save   = ``
                         event_delete = `` ).
        ENDIF.
        view_display( ).

      WHEN `CLEAR`.
        t_log = VALUE #( ).
        client->view_model_update( ).

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

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Keyboard Shortcuts`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Ctrl+S and Ctrl+D fire the backend events SAVE and DELETE - the same events the ` &&
                   `buttons below send, but from the keyboard and without a control. The binding is ` &&
                   `pure data (cs_event-keyboard_shortcut with the combination and the event name), ` &&
                   `the browser default for the combination is suppressed.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->hbox( class = `sapUiSmallMargin`
        )->button(
            text  = COND #( WHEN registered = abap_true
                            THEN `Unregister the shortcuts`
                            ELSE `Register the shortcuts` )
            icon  = `sap-icon://keyboard-and-mouse`
            press = client->_event( `TOGGLE_REGISTRATION` )
        )->button(
            text  = `Save (Ctrl+S)`
            type  = `Emphasized`
            class = `sapUiTinyMarginBegin`
            press = client->_event( `SAVE` )
        )->button(
            text  = `Delete (Ctrl+D)`
            class = `sapUiTinyMarginBegin`
            press = client->_event( `DELETE` )
        )->button(
            text  = `Clear log`
            class = `sapUiTinyMarginBegin`
            press = client->_event( `CLEAR` ) ).

    page->list(
        headertext = `Triggered events`
        items      = client->_bind( t_log )
        )->standard_list_item( title = `{ENTRY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
