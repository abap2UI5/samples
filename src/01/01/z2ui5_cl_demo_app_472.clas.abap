CLASS z2ui5_cl_demo_app_472 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA block_navigation TYPE abap_bool.
    DATA last_press TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_472 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      block_navigation = abap_true.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `LINK_PRESS`.

        IF block_navigation = abap_true.
          last_press = `Link pressed - the browser did NOT follow the href, the backend decides what happens.`.
        ELSE.
          last_press = `Link pressed - the href was followed by the browser as usual.`.
        ENDIF.
        client->view_model_update( ).

      WHEN `TOGGLE`.
        " the flag is part of the event registration, so the view has to be
        " rebuilt for the change to reach the frontend
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Event with preventDefault`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `A sap.m.Link normally follows its href when pressed. Registered with ` &&
                   `s_ctrl-check_prevent_default the event cancels that built-in default ` &&
                   `(oEvent.preventDefault()) before the roundtrip - the event still reaches the ` &&
                   `backend, so the app decides what happens instead. Flip the switch to compare.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(form) = page->simple_form(
        title    = `Link with a cancelled default`
        editable = abap_true
        )->content( `form` ).

    form->label( `Cancel the browser navigation`
        )->switch(
            state  = client->_bind( block_navigation )
            change = client->_event( `TOGGLE` )
        )->label( `Link`
        )->link(
            text   = `Open abap2ui5.org`
            href   = `https://abap2ui5.org`
            target = `_blank`
            press  = client->_event(
                val    = `LINK_PRESS`
                s_ctrl = VALUE #( check_prevent_default = block_navigation ) )
        )->label( `Result`
        )->text( client->_bind( last_press ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
