CLASS z2ui5_cl_smp_app_443 DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA value   TYPE string.
    DATA enabled TYPE abap_bool.
    DATA info    TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_443 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      enabled = abap_true.
      value   = `86801398`.
      info    = `Step 1: Lock the field. Step 2: Re-enable + SET_CURSOR in the same roundtrip.`.

      DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
          )->ele( n = `View` ns = `mvc`
              )->a( n = `displayBlock` v = `true`
              )->a( n = `height`       v = `100%`
              )->a( n = `xmlns`        v = `sap.m`
              )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
              )->a( n = `xmlns:core`   v = `sap.ui.core`
              )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
              )->ele( `Shell`
                  )->ele( `Page`
                      )->a( n = `title` v = `abap2UI5 - SET_CURSOR after enabled binding`
                      )->ele( n = `SimpleForm` ns = `form`
                          )->a( n = `editable` b = abap_true
                          )->ele( n = `content` ns = `form`
                              )->tag( n = `Title` ns = `core`
                                  )->a( n = `text` v = client->_bind( info )
                              )->tag( `Label`
                                  )->a( n = `text` v = `Document Number`
                              )->tag( `Input`
                                  )->a( n = `id`      v = `inpDocNum`
                                  )->a( n = `enabled` v = client->_bind( enabled )
                                  )->a( n = `value`   v = client->_bind( value )
                              )->tag( `Label`
                                  )->a( n = `text` v = ``
                              )->tag( `Button`
                                  )->a( n = `press` v = client->_event( `LOCK` )
                                  )->a( n = `text`  v = `1 - Lock field (enabled = false)`
                              )->tag( `Label`
                                  )->a( n = `text` v = ``
                              )->tag( `Button`
                                  )->a( n = `press` v = client->_event( `UNLOCK_AND_SET_CURSOR` )
                                  )->a( n = `text`  v = `2 - Re-enable field + SET_CURSOR (one roundtrip)`
                                  )->a( n = `type`  v = `Emphasized`
                              )->tag( `Label`
                                  )->a( n = `text` v = ``
                              )->tag( `Button`
                                  )->a( n = `press` v = client->_event( `SET_CURSOR_ONLY` )
                                  )->a( n = `text`  v = `Reference: SET_CURSOR only (no enabled change)` ).
      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `LOCK` ).
      " The field gets locked via binding - just like a real app that
      " blocks input while processing is running.
      enabled = abap_false.
      info    = `Field is locked - now run step 2.`.

    ELSEIF client->check_on_event( `UNLOCK_AND_SET_CURSOR` ).
      " Exactly the bug scenario: the same response re-enables the field
      " via binding AND sends SET_FOCUS. The control immediately reports
      " enabled=true, but the DOM still carries the old disabled input
      " until UI5 re-renders asynchronously. The browser silently ignores
      " focus() on a disabled element - without the fix in
      " FrontendAction.js the cursor position is therefore lost.
      enabled = abap_true.
      info    = `Field re-enabled - the cursor must now be in the field (characters 0-4 selected).`.
      client->follow_up_action( val   = client->cs_event-set_focus
                                t_arg = VALUE #( ( `inpDocNum` ) ( `0` ) ( `4` ) ) ).

    ELSEIF client->check_on_event( `SET_CURSOR_ONLY` ).
      " Reference case without an enabled change: here the DOM input is
      " already editable, so SET_FOCUS works even without the fix.
      info = `SET_CURSOR without enabled change - always works.`.
      client->follow_up_action( val   = client->cs_event-set_focus
                                t_arg = VALUE #( ( `inpDocNum` ) ( `0` ) ( `4` ) ) ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.

