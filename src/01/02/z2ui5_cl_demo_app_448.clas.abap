CLASS z2ui5_cl_demo_app_448 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_448 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE xsdboolean.
        DATA temp1 TYPE string_table.
        DATA temp2 TYPE string.

    CASE client->get( )-event.

      WHEN `TOGGLE`.
        " invert the mirrored state and call the whitelisted setExpanded on
        " the panel - client-side, after the response renders, no rebuild.
        " t_arg is positional: id, view (`` = global lookup), method, params
        
        temp3 = boolc( expanded = abap_false ).
        expanded = temp3.
        
        CLEAR temp1.
        INSERT `demoPanel` INTO TABLE temp1.
        INSERT `` INTO TABLE temp1.
        INSERT `setExpanded` INTO TABLE temp1.
        
        temp2 = expanded.
        INSERT temp2 INTO TABLE temp1.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                  t_arg = temp1 ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell(
        )->page(
            title          = `abap2UI5 - Panel - setExpanded via CONTROL_BY_ID`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `The button toggles the panel via the whitelisted setExpanded method ` &&
                   `(follow_up_action with cs_event-control_by_id), client-side after render - no view rebuild.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->vbox( `sapUiSmallMargin`
        )->button( text  = `Toggle panel`
                   icon  = `sap-icon://expand-group`
                   press = client->_event( `TOGGLE` ) ).

    page->panel( id         = `demoPanel`
                 headertext = `Collapsible panel`
                 expandable = abap_true
                 width      = `auto`
                 class      = `sapUiSmallMargin`
        )->text( `Content of the panel - collapsed and expanded from the backend without a roundtrip payload.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
