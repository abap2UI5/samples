" @keywords inputmode soft keyboard numeric keypad barcode scanner mobile inputext bound property
" @summary Sets the HTML inputmode of an Input through the bound inputMode property of z2ui5.cc.InputExt - the keyboard layout is model data, not an action.
" @docs https://abap2ui5.github.io/docs/cookbook/browser_interaction/soft_keyboard
CLASS z2ui5_cl_smp_app_516 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mode  TYPE string.
    DATA value TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_516 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      mode = `numeric`.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    " The mode is an ordinary bound attribute, so switching the keyboard is a
    " model update and nothing else - no follow-up action travels, and there
    " is no ordering to get right between the action and the next render.
    CASE client->get_event( ).
      WHEN `NUMERIC`.
        mode = `numeric`.
      WHEN `DECIMAL`.
        mode = `decimal`.
      WHEN `TEL`.
        mode = `tel`.
      WHEN `NONE`.
        mode = `none`.
      WHEN `OFF`.
        " empty leaves the field exactly as sap.m.Input rendered it
        mode = ``.
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Browser - Keyboard Layout of an Input (inputmode)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `inputmode asks the on-screen keyboard for a layout without changing what the field IS - ` &&
                   `numeric gives a digit pad on a field that still takes any text, and none keeps the keyboard DOWN while ` &&
                   `the field goes on taking input, which is what a barcode scanner needs. Visible on a phone or tablet.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`

        )->tag( n = `InputExt` ns = `z2ui5`
            )->a( n = `value`       v = client->_bind( value )
            )->a( n = `inputMode`   v = client->_bind( mode )
            )->a( n = `placeholder` v = `tap here on a touch device`
            )->a( n = `width`       v = `20rem`

        )->tag( `ObjectStatus`
            )->a( n = `title` v = `inputMode`
            )->a( n = `text`  v = client->_bind( mode )
            )->a( n = `class` v = `sapUiSmallMarginTop sapUiSmallMarginBottom` ).

    page->ele( `HBox`
        )->a( n = `class` v = `sapUiSmallMarginBegin`

        )->tag( `Button`
            )->a( n = `press` v = client->_event( `NUMERIC` )
            )->a( n = `text`  v = `numeric`
            )->a( n = `class` v = `sapUiTinyMarginEnd`

        )->tag( `Button`
            )->a( n = `press` v = client->_event( `DECIMAL` )
            )->a( n = `text`  v = `decimal`
            )->a( n = `class` v = `sapUiTinyMarginEnd`

        )->tag( `Button`
            )->a( n = `press` v = client->_event( `TEL` )
            )->a( n = `text`  v = `tel`
            )->a( n = `class` v = `sapUiTinyMarginEnd`

        )->tag( `Button`
            )->a( n = `press` v = client->_event( `NONE` )
            )->a( n = `text`  v = `none - no keyboard`
            )->a( n = `class` v = `sapUiTinyMarginEnd`

        )->tag( `Button`
            )->a( n = `press` v = client->_event( `OFF` )
            )->a( n = `text`  v = `plain sap.m.Input` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
