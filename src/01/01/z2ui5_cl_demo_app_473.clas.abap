CLASS z2ui5_cl_demo_app_473 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_473 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Menu Item Path`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `The toast shows the full path of the selected menu item ` &&
                   `("Create New Site > Official Store"), not only its own text. ` &&
                   `$controller.textPath( ) walks the item's parent chain in the control tree ` &&
                   `and joins the texts - a walk no binding path can express. Everything happens ` &&
                   `on the client, the menu selection needs no roundtrip at all.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    " the item's breadcrumb is resolved on the client and substituted into the
    " toast template ({0}); an argument starting with $ is a client-side
    " expression, everything else travels as a plain string
    DATA(menu_selected) = client->_event_client(
        val   = z2ui5_if_client=>cs_event-control_global
        t_arg = VALUE #( ( `MESSAGE_TOAST` )
                         ( `show` )
                         ( `Action triggered on item: {0}` )
                         ( `$controller.textPath(${$parameters>/item})` ) ) ).

    DATA(menu) = page->hbox( class = `sapUiSmallMargin`
        )->menu_button( text = `Actions`
            )->menu( itemselected = menu_selected ).

    menu->_generic(
        name   = `MenuItem`
        t_prop = VALUE #( ( n = `text` v = `Create New Site` ) )
        )->menu_item( text = `Official Store`
        )->menu_item( text = `Franchise Store`
        )->menu_item( text = `Pop-up Store` ).

    menu->_generic(
        name   = `MenuItem`
        t_prop = VALUE #( ( n = `text` v = `Manage Users` ) )
        )->menu_item( text = `Add User`
        )->menu_item( text = `Remove User` ).

    menu->menu_item( text = `Log Out` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
