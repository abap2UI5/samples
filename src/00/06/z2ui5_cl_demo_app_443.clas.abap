CLASS z2ui5_cl_demo_app_443 DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA value   TYPE string.
    DATA enabled TYPE abap_bool.
    DATA info    TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_443 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      enabled = abap_true.
      value   = `86801398`.
      info    = `Step 1: Lock the field. Step 2: Re-enable + SET_CURSOR in the same roundtrip.`.

      DATA(view) = z2ui5_cl_xml_view=>factory(
        )->shell(
        )->page( `abap2UI5 - SET_CURSOR after enabled binding`
          )->simple_form( editable = abap_true
            )->content( `form`
              )->title( ns   = `core`
                        text = client->_bind( info )
              )->label( `Document Number`
              )->input( id      = `inpDocNum`
                        value   = client->_bind( value )
                        enabled = client->_bind( enabled )
              )->label( ``
              )->button( text  = `1 - Lock field (enabled = false)`
                         press = client->_event( `LOCK` )
              )->label( ``
              )->button( text  = `2 - Re-enable field + SET_CURSOR (one roundtrip)`
                         type  = `Emphasized`
                         press = client->_event( `UNLOCK_AND_SET_CURSOR` )
              )->label( ``
              )->button( text  = `Reference: SET_CURSOR only (no enabled change)`
                         press = client->_event( `SET_CURSOR_ONLY` ) ).
      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `LOCK` ).
      " The field gets locked via binding - just like a real app that
      " blocks input while processing is running.
      enabled = abap_false.
      info    = `Field is locked - now run step 2.`.
      client->view_model_update( ).

    ELSEIF client->check_on_event( `UNLOCK_AND_SET_CURSOR` ).
      " Exactly the bug scenario: the same response re-enables the field
      " via binding AND sends SET_FOCUS. The control immediately reports
      " enabled=true, but the DOM still carries the old disabled input
      " until UI5 re-renders asynchronously. The browser silently ignores
      " focus() on a disabled element - without the fix in
      " FrontendAction.js the cursor position is therefore lost.
      enabled = abap_true.
      info    = `Field re-enabled - the cursor must now be in the field (characters 0-4 selected).`.
      client->view_model_update( ).
      client->follow_up_action( val   = client->cs_event-set_focus
                                t_arg = VALUE #( ( `inpDocNum` ) ( `0` ) ( `4` ) ) ).

    ELSEIF client->check_on_event( `SET_CURSOR_ONLY` ).
      " Reference case without an enabled change: here the DOM input is
      " already editable, so SET_FOCUS works even without the fix.
      info = `SET_CURSOR without enabled change - always works.`.
      client->view_model_update( ).
      client->follow_up_action( val   = client->cs_event-set_focus
                                t_arg = VALUE #( ( `inpDocNum` ) ( `0` ) ( `4` ) ) ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.

