"! The page z2ui5_cl_smp_app_531 opens. It arrives with the transition it was
"! opened with, and every way of leaving it shows what the framework plays:
"! the nav button in the header (nav_app_leave) plays the arrival reversed;
"! Deeper (nav_app_call of the next level) plays the same transition forward;
"! Re-render (view_display without a transition) rebuilds the page in place,
"! and the way back still reverses how it arrived; Replace (nav_app_leave to
"! a FRESH instance) is a forward move that takes this page's place; Popup app
"! (nav_app_call of z2ui5_cl_smp_app_534, an app that shows a dialog only)
"! moves nothing - neither on the way there nor on the way back. This app is
"! a hidden helper (never listed on its own in the overview).
CLASS z2ui5_cl_smp_app_532 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    CLASS-METHODS factory
      IMPORTING transition    TYPE string
                level         TYPE i
      RETURNING VALUE(result) TYPE REF TO z2ui5_cl_smp_app_532.

  PROTECTED SECTION.
    DATA client     TYPE REF TO z2ui5_if_client.
    DATA transition TYPE string.
    DATA level      TYPE i.
    DATA renders    TYPE i.

    METHODS on_event.
    METHODS view_display
      IMPORTING arriving TYPE abap_bool.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_532 IMPLEMENTATION.

  METHOD factory.

    CREATE OBJECT result.
    result->transition = transition.
    result->level      = level.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    " arriving - opened, back from a deeper page or the popup app, or restored
    " by the browser buttons: the page names its transition every time, the
    " framework finds the direction
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( abap_true ).

    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE REF TO z2ui5_cl_smp_app_534.

    CASE client->get_event( ).

      WHEN `DEEPER`.
        client->nav_app_call( factory( transition = transition level = level + 1 ) ).

      WHEN `RERENDER`.
        renders = renders + 1.
        view_display( abap_false ).

      WHEN `REPLACE`.
        client->nav_app_leave( factory( transition = transition level = level ) ).

      WHEN `POPUP`.
        
        CREATE OBJECT temp1 TYPE z2ui5_cl_smp_app_534.
        client->nav_app_call( temp1 ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    " one color per level, so the two pages can be told apart while they move
    DATA temp2 TYPE string.
    DATA color LIKE temp2.
    DATA temp3 TYPE string.
    DATA name LIKE temp3.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA content TYPE REF TO z2ui5_cl_ui5_view_builder.
    CASE level MOD 4.
      WHEN 1.
        temp2 = `#0a6ed1`.
      WHEN 2.
        temp2 = `#e9730c`.
      WHEN 3.
        temp2 = `#107e3e`.
      WHEN OTHERS.
        temp2 = `#bb0000`.
    ENDCASE.
    
    color = temp2.
    
    IF transition IS INITIAL.
      temp3 = `no transition`.
    ELSE.
      temp3 = transition.
    ENDIF.
    
    name = temp3.

    
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          t = |abap2UI5 - Page { level } - { name }|
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `id`       v = `arrival`
        )->a( n = `text`     t = |Page { level } arrived with: { name }. Rendered { renders + 1 } time(s). Leave it with | &&
                                 |the nav button in the header - the transition plays reversed.|
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    content = page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin` ).

    content->tag( n = `Icon` ns = `core`
        )->a( n = `src`   v = `sap-icon://paper-plane`
        )->a( n = `size`  v = `6rem`
        )->a( n = `color` t = color
        )->a( n = `class` v = `sapUiMediumMarginTopBottom` ).

    content->tag( `Button`
        )->a( n = `id`    v = `deeper`
        )->a( n = `text`  t = |Deeper - nav_app_call( ) of page { level + 1 }: { name } forward|
        )->a( n = `icon`  v = `sap-icon://navigation-right-arrow`
        )->a( n = `type`  v = `Emphasized`
        )->a( n = `class` v = `sapUiTinyMarginBottom`
        )->a( n = `press` v = client->_event( `DEEPER` ) ).
    content->tag( `Button`
        )->a( n = `id`    v = `rerender`
        )->a( n = `text`  v = `Re-render - view_display( ) without a transition: rebuilt in place`
        )->a( n = `icon`  v = `sap-icon://refresh`
        )->a( n = `class` v = `sapUiTinyMarginBottom`
        )->a( n = `press` v = client->_event( `RERENDER` ) ).
    content->tag( `Button`
        )->a( n = `id`    v = `replace`
        )->a( n = `text`  v = `Replace - nav_app_leave( ) to a new instance: a forward move`
        )->a( n = `icon`  v = `sap-icon://synchronize`
        )->a( n = `class` v = `sapUiTinyMarginBottom`
        )->a( n = `press` v = client->_event( `REPLACE` ) ).
    content->tag( `Button`
        )->a( n = `id`    v = `popup`
        )->a( n = `text`  v = `Popup app - nav_app_call( ) of a dialog-only app: its return moves nothing`
        )->a( n = `icon`  v = `sap-icon://popup-window`
        )->a( n = `press` v = client->_event( `POPUP` ) ).

    IF arriving = abap_true.
      client->view_display( val = view->stringify( ) transition = transition ).

    ELSE.
      client->view_display( view->stringify( ) ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
