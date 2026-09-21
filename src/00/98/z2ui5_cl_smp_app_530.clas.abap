CLASS z2ui5_cl_smp_app_530 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " what the user typed
    DATA input         TYPE string.

    " bound to InputExt.inputMode:
    "   `none` -> soft keyboard hidden (deactivated)
    "   `text` / `numeric` / ... -> soft keyboard shown (activated)
    DATA input_mode    TYPE string VALUE `text`.

    " drives the toggle button's appearance
    DATA keyboard_type TYPE string VALUE `Emphasized`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " the mode restored when the keyboard is switched back on
    CONSTANTS c_active_mode TYPE string VALUE `text`.
    CONSTANTS c_off_mode    TYPE string VALUE `none`.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_530 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).
      " land in the field with the keyboard already active
      client->follow_up_action( val   = z2ui5_if_client=>cs_event-set_focus
                                t_arg = VALUE #( ( `ZINPUT` ) ) ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

    on_event( ).

  ENDMETHOD.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page( id             = `PAGE01`
                 title          = `abap2UI5 - Soft Keyboard (InputExt)`
                 shownavbutton  = client->check_app_prev_stack( )
                 navbuttonpress = client->_event_nav_app_leave( ) ).

    DATA(form) = page->simple_form( editable = abap_true
                                )->content( `form` ).

    form->label( `Scan / input field` ).

    DATA(box) = form->hbox( wrap = `Wrap` ).

    " The custom control - same tag/props as the KRO scan field
    box->_generic(
        name   = `InputExt`
        ns     = `z2ui5`
        t_prop = VALUE #( ( n = `id`          v = `ZINPUT` )
                          ( n = `value`       v = client->_bind_edit( input ) )
                          ( n = `inputMode`   v = client->_bind( input_mode ) )
                          ( n = `placeholder` v = `Type here...` )
                          ( n = `enabled`     v = abap_true )
                          ( n = `submit`      v = client->_event( `INPUT_DONE` ) )
                          ( n = `valueState`  v = `Success` ) ) ).

    " One-shot toggle (mirrors KRO's SOFTKEYBOARD button)
    box->button( icon  = `sap-icon://keyboard-and-mouse`
                 type  = client->_bind( keyboard_type )
                 press = client->_event( `SOFTKEYBOARD` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD on_event.

    IF client->check_on_event( `SOFTKEYBOARD` ).
      " flip active <-> none
      input_mode = COND #( WHEN input_mode = c_off_mode
                           THEN c_active_mode
                           ELSE c_off_mode ).
      keyboard_type = COND #( WHEN input_mode = c_off_mode
                              THEN `Reject`
                              ELSE `Emphasized` ).

      view_display( ).

    ELSEIF client->check_on_event( `INPUT_DONE` ).
      client->message_toast_display( |Submitted: { input }| ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
