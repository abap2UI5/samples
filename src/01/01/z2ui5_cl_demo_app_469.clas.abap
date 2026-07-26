"! Detail page for the routing-modes demo (z2ui5_cl_demo_app_468). It is reached
"! via client->nav_app_call( ), which - when hash routing is on - pushes a new
"! route history entry, so the browser Back button returns to the hub. This app
"! only shows what to do next; it is a hidden helper (never listed on its own in
"! the overview).
CLASS z2ui5_cl_demo_app_469 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_469 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell( )->page(
        title          = `abap2UI5 - Navigation - Detail Page`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `You navigated here from the routing-modes hub via nav_app_call. Now press your ` &&
                   `BROWSER Back button and watch the hub: keep restores its state, fresh restarts it ` &&
                   `empty, default leaves the app (use the in-app Back button then).`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->button(
        text  = `back (in-app)`
        icon  = `sap-icon://nav-back`
        press = client->_event_nav_app_leave( )
        class = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
