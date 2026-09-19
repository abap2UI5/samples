" @keywords link href default action check_prevent_default
" @summary A Link whose default browser action is suppressed (check_prevent_default), so the app handles the click instead of the href.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/frontend
CLASS z2ui5_cl_smp_app_472 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_472 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      block_navigation = abap_true.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `LINK_PRESS`.

        IF block_navigation = abap_true.
          last_press = `Link pressed - the browser did NOT follow the href, the backend decides what happens.`.
        ELSE.
          last_press = `Link pressed - the href was followed by the browser as usual.`.
        ENDIF.

      WHEN `TOGGLE`.
        " the flag is part of the event registration, so the view has to be
        " rebuilt for the change to reach the frontend
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA form TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE z2ui5_if_client=>ty_s_event_control.
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
            )->a( n = `title`          v = `abap2UI5 - Event - Link with preventDefault`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A sap.m.Link normally follows its href when pressed. Registered with ` &&
                   `s_ctrl-check_prevent_default the event cancels that built-in default ` &&
                   `(oEvent.preventDefault()) before the roundtrip - the event still reaches the ` &&
                   `backend, so the app decides what happens instead. Flip the switch to compare.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    form = page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Link with a cancelled default`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form` ).

    
    CLEAR temp1.
    temp1-check_prevent_default = block_navigation.
    form->tag( `Label`
        )->a( n = `text` v = `Cancel the browser navigation`
        )->tag( `Switch`
            )->a( n = `state`  v = client->_bind( block_navigation )
            )->a( n = `change` v = client->_event( `TOGGLE` )
        )->tag( `Label`
            )->a( n = `text` v = `Link`
        )->tag( `Link`
            )->a( n = `text`   v = `Open abap2ui5.org`
            )->a( n = `target` v = `_blank`
            )->a( n = `href`   v = `https://abap2ui5.org`
            )->a( n = `press`  v = client->_event(
                val    = `LINK_PRESS`
                s_ctrl = temp1 )
        )->tag( `Label`
            )->a( n = `text` v = `Result`
        )->tag( `Text`
            )->a( n = `text` v = client->_bind( last_press ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
