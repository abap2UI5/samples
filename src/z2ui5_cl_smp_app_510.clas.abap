" @keywords nested view destroy nest_view_destroy nest2_view_destroy slot scope cs_view nested nested2 control_by_id focus
" @summary Two nested views built and torn down on demand, and a frontend action aimed at one of them by its slot - the view parameter of follow_up_action.
"! Two containers on the main page, one nested view each. nest_view_display
"! puts a view INTO a container, nest_view_destroy takes it out again and
"! leaves the container - the same for the second slot with nest2_*.
"!
"! A control_by_id action resolves an id across every open view by default
"! (cs_view-main). The view parameter of follow_up_action scopes the lookup
"! to ONE slot - cs_view-nested or cs_view-nested2 - so the focus is looked
"! for in the view the app meant and nowhere else: a slot that is not open
"! answers with nothing instead of the first match somewhere else.
CLASS z2ui5_cl_smp_app_510 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA input_nest  TYPE string.
    DATA input_nest2 TYPE string.
    DATA status      TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.
    METHODS nest_display
      IMPORTING
        slot TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_510 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      status = `no nested view yet`.
      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `NEST_SHOW`.
        nest_display( z2ui5_if_client=>cs_view-nested ).
        status = `nested view 1 rendered into box_nest`.

      WHEN `NEST_DESTROY`.
        " the view goes, the container stays - and the bound input keeps
        " its value in the class, so a new display brings it back
        client->nest_view_destroy( ).
        status = `nested view 1 destroyed - box_nest is empty again`.

      WHEN `NEST2_SHOW`.
        nest_display( z2ui5_if_client=>cs_view-nested2 ).
        status = `nested view 2 rendered into box_nest2`.

      WHEN `NEST2_DESTROY`.
        client->nest2_view_destroy( ).
        status = `nested view 2 destroyed - box_nest2 is empty again`.

      WHEN `FOCUS_NEST`.
        " the slot decides where the lookup happens: cs_view-nested is the
        " first nested view and nothing else. Without the view parameter
        " the id would be searched across every open view
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                  view  = z2ui5_if_client=>cs_view-nested
                                  t_arg = VALUE #( ( `inp_nest` ) ( `focus` ) ) ).
        status = `focus sent to id inp_nest, scoped to cs_view-nested`.

      WHEN `FOCUS_NEST2`.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                  view  = z2ui5_if_client=>cs_view-nested2
                                  t_arg = VALUE #( ( `inp_nest2` ) ( `focus` ) ) ).
        status = `focus sent to id inp_nest2, scoped to cs_view-nested2`.

    ENDCASE.

  ENDMETHOD.


  METHOD nest_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(panel) = view->ele( `Panel`
        )->a( n = `headerText` t = |nested view in slot { slot }|
        )->a( n = `class`      v = `sapUiSmallMarginTop` ).

    IF slot = z2ui5_if_client=>cs_view-nested.

      panel->tag( `Input`
          )->a( n = `id`          v = `inp_nest`
          )->a( n = `placeholder` v = `id inp_nest, slot NEST`
          )->a( n = `value`       v = client->_bind( input_nest ) ).

      client->nest_view_display( val            = view->stringify( )
                                 id             = `box_nest`
                                 method_insert  = `addItem`
                                 method_destroy = `removeAllItems` ).

    ELSE.

      panel->tag( `Input`
          )->a( n = `id`          v = `inp_nest2`
          )->a( n = `placeholder` v = `id inp_nest2, slot NEST2`
          )->a( n = `value`       v = client->_bind( input_nest2 ) ).

      client->nest2_view_display( val            = view->stringify( )
                                  id             = `box_nest2`
                                  method_insert  = `addItem`
                                  method_destroy = `removeAllItems` ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Nested View - Destroy and Target a Slot`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Show and destroy the two nested views, then send the focus into one of them: the ` &&
                   `view parameter of follow_up_action decides which slot the id lookup is scoped to - ` &&
                   `a slot that is not open finds nothing.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `HBox`
        )->a( n = `wrap`  v = `Wrap`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Button`
            )->a( n = `text`  v = `show nested view 1`
            )->a( n = `press` v = client->_event( `NEST_SHOW` )
        )->tag( `Button`
            )->a( n = `text`  v = `destroy nested view 1`
            )->a( n = `press` v = client->_event( `NEST_DESTROY` )
        )->tag( `Button`
            )->a( n = `text`  v = `focus the input in slot nested`
            )->a( n = `press` v = client->_event( `FOCUS_NEST` )
        )->tag( `ToolbarSpacer`
            )->a( n = `width` v = `1rem`
        )->tag( `Button`
            )->a( n = `text`  v = `show nested view 2`
            )->a( n = `press` v = client->_event( `NEST2_SHOW` )
        )->tag( `Button`
            )->a( n = `text`  v = `destroy nested view 2`
            )->a( n = `press` v = client->_event( `NEST2_DESTROY` )
        )->tag( `Button`
            )->a( n = `text`  v = `focus the input in slot nested2`
            )->a( n = `press` v = client->_event( `FOCUS_NEST2` ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = client->_bind( status )
        )->a( n = `type`     v = `Success`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " the two containers the nested views are inserted into - a VBox each,
    " addItem inserts, removeAllItems clears before a repeated display
    page->ele( `HBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `VBox`
            )->a( n = `id`    v = `box_nest`
            )->a( n = `width` v = `20rem`
            )->a( n = `class` v = `sapUiSmallMarginEnd`
        )->tag( `VBox`
            )->a( n = `id`    v = `box_nest2`
            )->a( n = `width` v = `20rem` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
