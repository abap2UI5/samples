" @keywords panel collapse expand setexpanded control_by_id whitelisted
" @summary Expands a Panel by calling setExpanded on it by ID - a whitelisted control call, no roundtrip and no model behind it.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/frontend
CLASS z2ui5_cl_smp_app_448 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " not bound - mirrors the panel state so the toggle can invert it
    DATA expanded TYPE abap_bool.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_448 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
      DATA temp3 TYPE xsdboolean.
      DATA temp1 TYPE string_table.
      DATA temp2 TYPE string.

    IF client->get_event( ) = `TOGGLE`.
      " invert the mirrored state and call the whitelisted setExpanded on
      " the panel - client-side, after the response renders, no rebuild.
      " t_arg is positional: id, method, params (the view defaults to
      " cs_view-main and can be omitted for a main-view control)
      
      temp3 = boolc( expanded = abap_false ).
      expanded = temp3.
      " Driving a property through control_by_id IS this sample; the plain
      " binding the rule recommends is what app 449 shows instead.
      " abap2ui5lint-disable settable-property-via-action
      
      CLEAR temp1.
      INSERT `demoPanel` INTO TABLE temp1.
      INSERT `setExpanded` INTO TABLE temp1.
      
      temp2 = expanded.
      INSERT temp2 INTO TABLE temp1.
      client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                t_arg = temp1 ).
      " abap2ui5lint-enable settable-property-via-action
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
            )->a( n = `title`          v = `abap2UI5 - Control Behaviour - Expand a Panel by ID (setExpanded)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The button toggles the panel via the whitelisted setExpanded method ` &&
                   `(follow_up_action with cs_event-control_by_id), client-side after render - no view rebuild.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `TOGGLE` )
            )->a( n = `text`  v = `Toggle panel`
            )->a( n = `icon`  v = `sap-icon://expand-group` ).

    page->ele( `Panel`
        )->a( n = `expandable` b = abap_true
        )->a( n = `width`      v = `auto`
        )->a( n = `id`         v = `demoPanel`
        )->a( n = `class`      v = `sapUiSmallMargin`
        )->a( n = `headerText` v = `Collapsible panel`
        )->tag( `Text`
            )->a( n = `text` v = `Content of the panel - collapsed and expanded from the backend without a roundtrip payload.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
