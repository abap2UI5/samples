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

    IF client->check_on_init( ).
      " the initial response already carries BOTH: the view build and the
      " popover anchored to a control of that very view
      view_display( ).
      popover_display( ).
    ELSEIF client->check_on_event( `REBUILD_AND_OPEN` ).
      " same pair on an event roundtrip: the view is REPLACED and the
      " popover opens on the freshly built anchor
      counter = counter + 1.
      view_display( ).
      popover_display( ).
    ELSEIF client->check_on_event( `OPEN_ONLY` ).
      " popover alone - the view stays as it is
      counter = counter + 1.
      popover_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Popover - opened with the view build`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `This response built the page AND opened the popover in one roundtrip - ` &&
                   `the popover anchors to the button below, which only exists once this ` &&
                   `view is rendered. Both buttons re-open it: the first rebuilds the view ` &&
                   `with it, the second opens it alone.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->vbox( `sapUiSmallMargin`
        )->button( id    = `btnAnchor`
                   text  = `rebuild view + open popover`
                   icon  = `sap-icon://refresh`
                   press = client->_event( `REBUILD_AND_OPEN` )
        )->button( text  = `open popover only (view untouched)`
                   press = client->_event( `OPEN_ONLY` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popover_display.

    DATA(popover) = z2ui5_cl_xml_view=>factory_popup( ).
    popover->popover( title        = `Opened with the view`
                      placement    = `Bottom`
                      contentwidth = `20rem`
        )->vbox( `sapUiSmallMargin`
            )->text( `This popover travelled in the SAME response as the view it is ` &&
                     `anchored to.`
            )->object_status( text  = |roundtrips so far: { counter }|
                              state = `Information` ).

    client->popover_display( xml   = popover->stringify( )
                             by_id = `btnAnchor` ).

  ENDMETHOD.

ENDCLASS.
