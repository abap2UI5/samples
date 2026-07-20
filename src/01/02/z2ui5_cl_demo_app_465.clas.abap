CLASS z2ui5_cl_demo_app_465 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_465 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `TOGGLE`.
        " toggle the popover open/closed, anchored to the pressed button's DOM
        " ref - the whitelisted toggleBy opens it if closed, closes it if open
        " (the controller pattern oPopover.openBy(oButton) / oPopover.close()).
        " t_arg is positional: id, view (`` = global lookup), method, anchor id
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                  t_arg = VALUE #( ( `demoPopover` )
                                                   ( `` )
                                                   ( `toggleBy` )
                                                   ( client->get_event_arg( ) ) ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Popover - Toggle via CONTROL_BY_ID`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    " the popover kept as a dependent of the page; opened and closed
    " imperatively from the backend, anchored to the button that fired
    page->dependents(
        )->popover( id           = `demoPopover`
                    title        = `Details`
                    placement    = `Bottom`
                    contentwidth = `18rem`
            )->text( `Toggled open and closed from the backend - the same button opens ` &&
                     `it when closed and closes it when open, no view rebuild and no payload.`
                     )->get_parent( ).

    page->message_strip(
        text     = `The button toggles the popover via the whitelisted toggleBy method ` &&
                   `(follow_up_action with cs_event-control_by_id), anchored to the button's DOM ref ` &&
                   `passed as $event.oSource.sId - open-if-closed, close-if-open, client-side after render.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->vbox( `sapUiSmallMargin`
        )->button( text  = `Toggle popover`
                   icon  = `sap-icon://email`
                   press = client->_event( val   = `TOGGLE`
                                           t_arg = VALUE #( ( `$event.oSource.sId` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
