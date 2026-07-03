CLASS z2ui5_cl_demo_app_363 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_363 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    DATA(target) = client->get( )-event.
    DATA(behavior) = `smooth`.
    DATA(block) = `start`.

    CASE target.
      WHEN `JUMP_BOTTOM`.
        target = `bottom_input`.
      WHEN `JUMP_MIDDLE`.
        target = `middle_input`.
        block = `center`.
      WHEN `JUMP_TOP`.
        target = `top_input`.
      WHEN `VALIDATE`.
        IF field_02 IS INITIAL.

          target = `middle_input`.
          block = `center`.
          client->message_toast_display( `Middle field is required` ).
        ELSE.

          client->message_toast_display( `All fields ok` ).
          RETURN.
        ENDIF.
      WHEN OTHERS.
        RETURN.
    ENDCASE.

    client->action->gen(
        val   = z2ui5_if_client=>cs_event-scroll_into_view
        t_arg = VALUE #( ( target ) ( behavior ) ( block ) ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `scroll_into_view - jump to a control`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text = `Use the toolbar to scroll to a control by id, or press Validate - if the middle field is empty it scrolls to it automatically.`
        type = `Information` ).

    DATA(form) = page->simple_form( editable = abap_true
                                    title    = `Long form`
        )->content( `form` ).

    " Top section
    form->label( `Top field (id = top_input)` ).
    form->input( id    = `top_input`
                 value = client->_bind_edit( field_01 ) ).

    " spacer
    DO 25 TIMES.
      form->label( `spacer` ).
      form->text( | spacer line { sy-index }| ).
    ENDDO.

    " Middle section (required)
    form->label( `Middle field - required (id = middle_input)` ).
    form->input( id    = `middle_input`
                 value = client->_bind_edit( field_02 ) ).

    " spacer
    DO 25 TIMES.
      form->label( `spacer` ).
      form->text( | spacer line { sy-index }| ).
    ENDDO.

    " Bottom section
    form->label( `Bottom field (id = bottom_input)` ).
    form->input( id    = `bottom_input`
                 value = client->_bind_edit( field_03 ) ).

    page->footer( )->overflow_toolbar(
         )->button( text  = `Jump to Top`
                    press = client->_event( `JUMP_TOP` )
         )->button( text  = `Jump to Middle`
                    press = client->_event( `JUMP_MIDDLE` )
         )->button( text  = `Jump to Bottom`
                    press = client->_event( `JUMP_BOTTOM` )
         )->button( text  = `Validate`
                    press = client->_event( `VALIDATE` )
                    type  = `Emphasized` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
