"! Hash-based app routing (UI5 Router style), mode FRESH:
"! client->set_nav_routing( client->cs_nav_mode-fresh ) makes the URL mirror the
"! running app by CLASS only ('#/app/[CLASS]'). Browser Back/Forward - and a
"! reload or a bookmark - therefore start the app FRESH: the input and the
"! counter are gone.
"!
"! Put in some state (type / raise the counter), open the detail page
"! (z2ui5_cl_smp_app_469) via client->nav_app_call( ), then press the BROWSER
"! Back button and watch this page - it comes back empty.
"!
"! z2ui5_cl_smp_app_480 is the same demo in mode KEEP, where the state survives.
CLASS z2ui5_cl_smp_app_468 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA input   TYPE string.
    DATA counter TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_468 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `INC`.
        counter = counter + 1.
        view_display( ).

      WHEN `GO_DETAIL`.
        client->nav_app_call( NEW z2ui5_cl_smp_app_469( ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    " assert the routing mode on every render, so THIS page's history entry - the
    " one the browser Back button returns to - is written under it
    client->set_nav_routing( client->cs_nav_mode-fresh ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell( )->page(
        title          = `abap2UI5 - Navigation - Routing Mode fresh`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Add some state (type / raise the counter), open the detail page, then press your ` &&
                   `BROWSER Back button and watch this page.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(form) = page->grid( `L6 M12 S12`
        )->content( `layout`
        )->simple_form( `Routing mode fresh`
        )->content( `form` ).

    form->label( `1. Some state - type here` ).
    form->input( client->_bind( input ) ).

    form->label( `and raise a counter` ).
    form->button(
        text  = |increment ({ counter })|
        press = client->_event( `INC` ) ).

    form->label( `2. Navigate forward` ).
    form->button(
        text  = `go to the detail page (nav_app_call)`
        type  = `Emphasized`
        press = client->_event( `GO_DETAIL` ) ).

    page->message_strip(
        text     = `fresh: the URL carries the class only (#/app/<CLASS>). After the detail page, the ` &&
                   `browser Back button starts this app FRESH - input and counter are reset.`
        type     = `Success`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
