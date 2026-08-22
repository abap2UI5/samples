" @keywords toggleby open close control_by_id whitelisted
" @summary Opens and closes a Popover by ID (toggleBy), so the anchor decides and no roundtrip is needed.
" @docs https://abap2ui5.github.io/docs/cookbook/popup_popover/popover https://abap2ui5.github.io/docs/cookbook/expert_more/follow_up_action
CLASS z2ui5_cl_smp_app_465 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_465 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
      DATA temp1 TYPE string_table.

    IF client->get_event( ) = `TOGGLE`.
      " toggle the popover open/closed, anchored to the pressed button's DOM
      " ref - the whitelisted toggleBy opens it if closed, closes it if open
      " (the controller pattern oPopover.openBy(oButton) / oPopover.close()).
      " t_arg is positional: id, method, anchor id (the view defaults to
      " cs_view-main and can be omitted for a main-view control)
      
      CLEAR temp1.
      INSERT `demoPopover` INTO TABLE temp1.
      INSERT `toggleBy` INTO TABLE temp1.
      INSERT client->get_event_arg( ) INTO TABLE temp1.
      client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                t_arg = temp1 ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Popover - Toggle by ID (toggleBy)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    " the popover kept as a dependent of the page; opened and closed
    " imperatively from the backend, anchored to the button that fired
    page->ele( `dependents`
        )->ele( `Popover`
            )->a( n = `id`           v = `demoPopover`
            )->a( n = `title`        v = `Details`
            )->a( n = `placement`    v = `Bottom`
            )->a( n = `contentWidth` v = `18rem`
            )->tag( `Text`
                )->a( n = `text` v = `Toggled open and closed from the backend - the same button opens ` &&
                     `it when closed and closes it when open, no view rebuild and no payload.`
        )->end( ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The button toggles the popover via the whitelisted toggleBy method ` &&
                   `(follow_up_action with cs_event-control_by_id), anchored to the button's DOM ref ` &&
                   `passed as $event.oSource.sId - open-if-closed, close-if-open, client-side after render.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    CLEAR temp3.
    INSERT `$event.oSource.sId` INTO TABLE temp3.
    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( val   = `TOGGLE`
                                           t_arg = temp3 )
            )->a( n = `text`  v = `Toggle popover`
            )->a( n = `icon`  v = `sap-icon://email` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
