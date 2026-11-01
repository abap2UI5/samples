"! An app with screens of its own, called by z2ui5_cl_smp_app_531: Next and
"! Previous rebuild ITS view, no other app is involved - so nothing tells the
"! framework which way the screen moves. Next is forward by default; Previous
"! says it with view_display( transition_back = abap_true ) and plays the
"! step being left out in reverse. Done leaves the app with nav_app_leave( ),
"! reversed too. This app is a hidden helper (never listed on its own in the
"! overview).
CLASS z2ui5_cl_smp_app_533 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    CONSTANTS steps TYPE i VALUE 3.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA step   TYPE i VALUE 1.

    METHODS view_display
      IMPORTING back TYPE abap_bool DEFAULT abap_false.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_533 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( `NEXT` ) IS NOT INITIAL.

      step = step + 1.
      view_display( ).

    ELSEIF client->check_on_event( `PREVIOUS` ) IS NOT INITIAL.

      step = step - 1.
      view_display( abap_true ).

    ELSEIF client->check_on_event( `DONE` ) IS NOT INITIAL.
      client->nav_app_leave( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA temp1 TYPE string.
    DATA color LIKE temp1.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA content TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp2 TYPE xsdboolean.
    DATA temp3 TYPE xsdboolean.
    CASE step.
      WHEN 1.
        temp1 = `#0a6ed1`.
      WHEN 2.
        temp1 = `#e9730c`.
      WHEN OTHERS.
        temp1 = `#107e3e`.
    ENDCASE.
    
    color = temp1.

    
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          t = |abap2UI5 - Wizard - Step { step } of { steps }|
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `id`       v = `step`
        )->a( n = `text`     t = |Step { step } of { steps } - the same app, a new view each time. Next moves forward, | &&
                                 |Previous says it goes back: view_display( transition_back = abap_true ).|
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    content = page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin` ).

    content->tag( n = `Icon` ns = `core`
        )->a( n = `src`   v = `sap-icon://step`
        )->a( n = `size`  v = `6rem`
        )->a( n = `color` t = color
        )->a( n = `class` v = `sapUiMediumMarginTopBottom` ).

    
    temp2 = boolc( step > 1 ).
    content->tag( `Button`
        )->a( n = `id`      v = `previous`
        )->a( n = `text`    v = `Previous - view_display( transition_back = abap_true )`
        )->a( n = `icon`    v = `sap-icon://navigation-left-arrow`
        )->a( n = `enabled` b = temp2
        )->a( n = `class`   v = `sapUiTinyMarginBottom`
        )->a( n = `press`   v = client->_event( `PREVIOUS` ) ).
    
    temp3 = boolc( step < steps ).
    content->tag( `Button`
        )->a( n = `id`      v = `next`
        )->a( n = `text`    v = `Next - view_display( transition = slide )`
        )->a( n = `icon`    v = `sap-icon://navigation-right-arrow`
        )->a( n = `enabled` b = temp3
        )->a( n = `type`    v = `Emphasized`
        )->a( n = `class`   v = `sapUiTinyMarginBottom`
        )->a( n = `press`   v = client->_event( `NEXT` ) ).
    content->tag( `Button`
        )->a( n = `id`    v = `done`
        )->a( n = `text`  v = `Done - nav_app_leave( ): back to the caller`
        )->a( n = `icon`  v = `sap-icon://accept`
        )->a( n = `press` v = client->_event( `DONE` ) ).

    client->view_display( val = view->stringify( ) transition = client->cs_transition-slide transition_back = back ).

  ENDMETHOD.

ENDCLASS.
