" @keywords menuitem nested submenu textpath controller path
" @summary A nested Menu that reports the FULL path of the item that was chosen, not just its text.
CLASS z2ui5_cl_smp_app_473 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_473 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA menu_selected TYPE string.
    DATA menu TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Menu - Full Path of the Selected Item`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The toast shows the full path of the selected menu item ` &&
                   `("Create New Site > Official Store"), not only its own text. ` &&
                   `$controller.textPath( ) walks the item's parent chain in the control tree ` &&
                   `and joins the texts - a walk no binding path can express. Everything happens ` &&
                   `on the client, the menu selection needs no roundtrip at all.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " the item's breadcrumb is resolved on the client and substituted into the
    " toast template ({0}); an argument starting with $ is a client-side
    " expression, everything else travels as a plain string
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Action triggered on item: {0}` INTO TABLE temp1.
    INSERT `$controller.textPath(${$parameters>/item})` INTO TABLE temp1.
    
    menu_selected = client->follow_up_action(
        val   = z2ui5_if_client=>cs_event-control_global
        t_arg = temp1 ).

    
    menu = page->ele( `HBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->ele( `MenuButton`
            )->a( n = `text` v = `Actions`
            )->ele( `Menu`
                )->a( n = `itemSelected` v = menu_selected ).

    menu->ele( `MenuItem`
        )->a( n = `text` v = `Create New Site`
        )->tag( `MenuItem`
            )->a( n = `text` v = `Official Store`
        )->tag( `MenuItem`
            )->a( n = `text` v = `Franchise Store`
        )->tag( `MenuItem`
            )->a( n = `text` v = `Pop-up Store` ).

    menu->ele( `MenuItem`
        )->a( n = `text` v = `Manage Users`
        )->tag( `MenuItem`
            )->a( n = `text` v = `Add User`
        )->tag( `MenuItem`
            )->a( n = `text` v = `Remove User` ).

    menu->tag( `MenuItem`
        )->a( n = `text` v = `Log Out` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
