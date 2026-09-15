" @keywords cursor set_focus selection position textfield
" @summary Sets the focus into an Input and selects its text, so the next keystroke overwrites rather than appends.
" @docs https://abap2ui5.github.io/docs/cookbook/browser_interaction/focus
CLASS z2ui5_cl_smp_app_133 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA field_01 TYPE string.
    DATA field_02 TYPE string.
    DATA selstart TYPE string.
    DATA selend   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_133 IMPLEMENTATION.


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
            )->a( n = `title`          v = `abap2UI5 - Focus - Set Focus and Select Text in an Input`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Pressing a button runs the set_focus front-end action, which moves keyboard focus to the ` &&
                   `target input and selects the text between the given start and end positions.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Focus & Cursor`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Title`
                )->a( n = `text` v = `Input`
            )->tag( `Label`
                )->a( n = `text` v = `Sel_Start`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( selstart )
            )->tag( `Label`
                )->a( n = `text` v = `Sel_End`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( selend )
            )->tag( `Label`
                )->a( n = `text` v = `field_01`
            )->tag( `Input`
                )->a( n = `id`    v = `BUTTON01`
                )->a( n = `value` v = client->_bind( field_01 )
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `BUTTON01` )
                )->a( n = `text`  v = `focus here`
            )->tag( `Label`
                )->a( n = `text` v = `field_02`
            )->tag( `Input`
                )->a( n = `id`    v = `BUTTON02`
                )->a( n = `value` v = client->_bind( field_02 )
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `BUTTON02` )
                )->a( n = `text`  v = `focus here` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
        DATA temp1 TYPE string_table.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      field_01 = `this is a text`.
      field_02 = `this is another text`.
      selstart = `3`.
      selend   = `7`.

      view_display( ).
      RETURN.
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ENDIF.

    CASE client->get_event( ).
      WHEN `BUTTON01` OR `BUTTON02`.
        
        CLEAR temp1.
        INSERT client->get_event( ) INTO TABLE temp1.
        INSERT selstart INTO TABLE temp1.
        INSERT selend INTO TABLE temp1.
        client->follow_up_action(
            val   = z2ui5_if_client=>cs_event-set_focus
            t_arg = temp1 ).
        client->message_toast_display( |focus changed| ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
