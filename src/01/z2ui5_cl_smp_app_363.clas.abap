" @keywords scroll_into_view control id validation jump
" @summary Scrolls a control into view by ID - what a validation does when the field it complains about is off screen.
" @docs https://abap2ui5.github.io/docs/cookbook/browser_interaction/scrolling
CLASS z2ui5_cl_smp_app_363 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA field_01 TYPE string.
    DATA field_02 TYPE string.
    DATA field_03 TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_363 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    DATA target TYPE string.
    DATA behavior TYPE string.
    DATA block TYPE string.
    DATA temp1 TYPE string_table.
    target = client->get_event( ).
    
    behavior = `smooth`.
    
    block = `start`.

    CASE target.
      WHEN `JUMP_BOTTOM`.
        target = `bottom_input`.
      WHEN `JUMP_MIDDLE`.
        target = `middle_input`.
        block  = `center`.
      WHEN `JUMP_TOP`.
        target = `top_input`.
      WHEN `VALIDATE`.
        IF field_02 IS INITIAL.
          target = `middle_input`.
          block  = `center`.
          client->message_toast_display( `Middle field is required` ).
        ELSE.
          client->message_toast_display( `All fields ok` ).
          RETURN.
        ENDIF.
      WHEN OTHERS.
        RETURN.
    ENDCASE.

    
    CLEAR temp1.
    INSERT target INTO TABLE temp1.
    INSERT behavior INTO TABLE temp1.
    INSERT block INTO TABLE temp1.
    client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-scroll_into_view
        t_arg = temp1 ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.
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
            )->a( n = `title`          v = `abap2UI5 - Scroll - Scroll a Control into View`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text` v = `Use the toolbar to scroll to a control by id, or press Validate - if the middle field is empty it scrolls to it automatically.`
        )->a( n = `type` v = `Information` ).

    
    form = page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Long form`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form` ).

    " Top section
    form->tag( `Label`
        )->a( n = `text` v = `Top field (id = top_input)` ).
    form->tag( `Input`
        )->a( n = `id`    v = `top_input`
        )->a( n = `value` v = client->_bind( field_01 ) ).

    " spacer
    DO 25 TIMES.
      form->tag( `Label`
          )->a( n = `text` v = `spacer` ).
      form->tag( `Text`
          )->a( n = `text` v = | spacer line { sy-index }| ).
    ENDDO.

    " Middle section (required)
    form->tag( `Label`
        )->a( n = `text` v = `Middle field - required (id = middle_input)` ).
    form->tag( `Input`
        )->a( n = `id`    v = `middle_input`
        )->a( n = `value` v = client->_bind( field_02 ) ).

    " spacer
    DO 25 TIMES.
      form->tag( `Label`
          )->a( n = `text` v = `spacer` ).
      form->tag( `Text`
          )->a( n = `text` v = | spacer line { sy-index }| ).
    ENDDO.

    " Bottom section
    form->tag( `Label`
        )->a( n = `text` v = `Bottom field (id = bottom_input)` ).
    form->tag( `Input`
        )->a( n = `id`    v = `bottom_input`
        )->a( n = `value` v = client->_bind( field_03 ) ).

    page->ele( `footer`
        )->ele( `OverflowToolbar`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `JUMP_TOP` )
                )->a( n = `text`  v = `Jump to Top`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `JUMP_MIDDLE` )
                )->a( n = `text`  v = `Jump to Middle`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `JUMP_BOTTOM` )
                )->a( n = `text`  v = `Jump to Bottom`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `VALIDATE` )
                )->a( n = `text`  v = `Validate`
                )->a( n = `type`  v = `Emphasized` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
