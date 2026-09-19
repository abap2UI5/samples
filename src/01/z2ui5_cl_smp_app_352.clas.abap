" @keywords mobile numeric keypad keyboard_set_mode phone input
" @summary Asks a mobile device for the numeric keypad instead of the full keyboard (keyboard_set_mode) on an Input.
" @docs https://abap2ui5.github.io/docs/cookbook/browser_interaction/soft_keyboard
CLASS z2ui5_cl_smp_app_352 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA input TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_352 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE string_table.
      DATA temp3 TYPE string_table.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
      
      CLEAR temp1.
      INSERT `ZINPUT` INTO TABLE temp1.
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-set_focus
          t_arg = temp1 ).
      
      CLEAR temp3.
      INSERT `ZINPUT` INTO TABLE temp3.
      INSERT `numeric` INTO TABLE temp3.
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-keyboard_set_mode
          t_arg = temp3 ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

    on_event( ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Browser - Soft Keyboard Mode on Mobile`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Set the on-screen soft keyboard mode (numeric or off) via the keyboard_set_mode follow-up action, and ` &&
                   `focus the input on load.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Title`
                )->a( n = `text` v = `Keyboard on/off`
            )->tag( `Label`
                )->a( n = `text` v = `Input (numeric keyboard)`
            )->tag( `Input`
                )->a( n = `id`               v = `ZINPUT`
                )->a( n = `value`            v = client->_bind( input )
                )->a( n = `valueHelpRequest` v = client->_event( `CALL_KEYBOARD` )
                )->a( n = `showValueHelp`    b = abap_true ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA temp5 TYPE string_table.

    IF client->check_on_event( `CALL_KEYBOARD` ) IS NOT INITIAL.
      
      CLEAR temp5.
      INSERT `ZINPUT` INTO TABLE temp5.
      INSERT `none` INTO TABLE temp5.
      client->follow_up_action(
          val   = z2ui5_if_client=>cs_event-keyboard_set_mode
          t_arg = temp5 ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
