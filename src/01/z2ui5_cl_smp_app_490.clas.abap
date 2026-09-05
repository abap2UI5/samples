" @keywords initial render one roundtrip anchor button
" @summary View and popover in ONE roundtrip: both displayed from the same main( ) call, with the popover anchored to a button built in that very response.
" @docs https://abap2ui5.github.io/docs/cookbook/popup_popover/popover
"! View and popover in ONE roundtrip: view_display( ) and popover_display( )
"! from the same main( ) call. The popover anchors to a button of the view
"! that is built in this very response - the framework runs the display
"! actions in order and awaits each build, so the anchor exists by the time
"! the popover opens. Also re-opens the popover TOGETHER with a view rebuild
"! on an event, and contrasts it with a popover alone (no view rebuild).
CLASS z2ui5_cl_smp_app_490 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA counter TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS popover_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_490 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      " the initial response already carries BOTH: the view build and the
      " popover anchored to a control of that very view
      view_display( ).
      popover_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( `REBUILD_AND_OPEN` ) IS NOT INITIAL.
      " same pair on an event roundtrip: the view is REPLACED and the
      " popover opens on the freshly built anchor
      counter = counter + 1.
      view_display( ).
      popover_display( ).
    ELSEIF client->check_on_event( `OPEN_ONLY` ) IS NOT INITIAL.
      " popover alone - the view stays as it is
      counter = counter + 1.
      popover_display( ).
    ENDIF.

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
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Popover - Open Together with the View Build`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This response built the page AND opened the popover in one roundtrip - ` &&
                   `the popover anchors to the button below, which only exists once this ` &&
                   `view is rendered. Both buttons re-open it: the first rebuilds the view ` &&
                   `with it, the second opens it alone.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `REBUILD_AND_OPEN` )
            )->a( n = `text`  v = `rebuild view + open popover`
            )->a( n = `icon`  v = `sap-icon://refresh`
            )->a( n = `id`    v = `btnAnchor`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `OPEN_ONLY` )
            )->a( n = `text`  v = `open popover only (view untouched)` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popover_display.

    DATA popover TYPE REF TO z2ui5_cl_ui5_view_builder.
    popover = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core` ).
    popover->ele( `Popover`
        )->a( n = `title`        v = `Opened with the view`
        )->a( n = `placement`    v = `Bottom`
        )->a( n = `contentWidth` v = `20rem`
        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->tag( `Text`
                )->a( n = `text` v = `This popover travelled in the SAME response as the view it is ` &&
                     `anchored to.`
            )->ele( `ObjectStatus`
                )->a( n = `state` v = `Information`
                )->a( n = `text`  v = |roundtrips so far: { counter }| ).

    client->popover_display( xml = popover->stringify( ) by_id = `btnAnchor` ).

  ENDMETHOD.

ENDCLASS.
