" @keywords css inline style background color opacity control_by_id dom node no property
" @summary Writes a whitelisted CSS declaration onto a control's own DOM node with the css control method - for a value the control has no property for.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/frontend
CLASS z2ui5_cl_smp_app_513 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " not bound - mirrors what was written last, so the buttons can alternate
    DATA highlighted TYPE abap_bool.

    METHODS view_display.
    METHODS on_event.
    METHODS css_set
      IMPORTING
        property TYPE string
        value    TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_513 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD css_set.

    " t_arg is positional: id, the pseudo-method `css`, the property, the value.
    " `css` is not a UI5 method - it is a frontend capability in method form,
    " and only ten properties are allowed: width, min-width, max-width,
    " height, min-height, max-height, color, background-color, font-size and
    " opacity. Anything else is refused and logged, never applied.
    client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                              t_arg = VALUE #( ( `demoPanel` )
                                               ( `css` )
                                               ( property )
                                               ( value ) ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `HIGHLIGHT`.
        highlighted = xsdbool( highlighted = abap_false ).
        " sap.m.Panel carries no background colour and no font size, so there
        " is no property to bind and nothing a formatter could reach. The
        " declaration lands on the panel's own DOM node.
        IF highlighted = abap_true.
          css_set( property = `background-color`
                   value    = `#fff4e5` ).
          css_set( property = `font-size`
                   value    = `1.25rem` ).
        ELSE.
          " an empty value removes the declaration again
          css_set( property = `background-color`
                   value    = `` ).
          css_set( property = `font-size`
                   value    = `` ).
        ENDIF.

      WHEN `FADE`.
        css_set( property = `opacity`
                 value    = `0.35` ).

      WHEN `RESET`.
        " the declaration lives on the element and is gone after a re-render,
        " so a fresh view is the other way back to the control's own styling
        highlighted = abap_false.
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Control Behaviour - Inline CSS on a Control (css)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The css control method writes ONE whitelisted declaration onto the control's own DOM node ` &&
                   `- for a value the control has no property for. Prefer a bound property wherever one exists; a declaration ` &&
                   `written here is gone after the next re-render.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`

        )->ele( `HBox`

            )->tag( `Button`
                )->a( n = `press` v = client->_event( `HIGHLIGHT` )
                )->a( n = `text`  v = `Toggle background and font size`
                )->a( n = `icon`  v = `sap-icon://palette`
                )->a( n = `class` v = `sapUiTinyMarginEnd`

            )->tag( `Button`
                )->a( n = `press` v = client->_event( `FADE` )
                )->a( n = `text`  v = `Fade`
                )->a( n = `icon`  v = `sap-icon://hide`
                )->a( n = `class` v = `sapUiTinyMarginEnd`

            )->tag( `Button`
                )->a( n = `press` v = client->_event( `RESET` )
                )->a( n = `text`  v = `Rebuild the view`
                )->a( n = `icon`  v = `sap-icon://refresh` ).

    page->ele( `Panel`
        )->a( n = `width`      v = `auto`
        )->a( n = `id`         v = `demoPanel`
        )->a( n = `class`      v = `sapUiSmallMargin`
        )->a( n = `headerText` v = `A panel with no colour property`
        )->tag( `Text`
            )->a( n = `text` v = `sap.m.Panel has no background-color, no font-size and no opacity. ` &&
                       `Every one of them is set here from ABAP, client-side after the response renders.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
