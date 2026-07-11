CLASS z2ui5_cl_demo_app_163 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.
    METHODS view_menu.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_163 IMPLEMENTATION.

  METHOD on_event.

    IF client->check_on_event( `OPEN_MENU` ).
      view_menu( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_menu.

    DATA(menu_view) = z2ui5_cl_xml_view=>factory_popup( ).

    menu_view->_generic_property( VALUE #( n = `core:require` v = `{ MessageToast: 'sap/m/MessageToast' }` ) ).

    menu_view->menu( title = `Choose Your Action`
      )->menu_item( text  = `Accept`
                    icon  = `sap-icon://accept`
                    press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->menu_item( text  = `Reject`
                    icon  = `sap-icon://decline`
                    press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->menu_item( text  = `Email`
                    icon  = `sap-icon://email`
                    press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->menu_item( text  = `Forward`
                    icon  = `sap-icon://forward`
                    press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->menu_item( text  = `Delete`
                    icon  = `sap-icon://delete`
                    press = `MessageToast.show('selected action is ' + ${$source>/text})`
      )->menu_item( text  = `Other`
                    press = `MessageToast.show('selected action is ' + ${$source>/text})` ).

    client->popover_display( xml   = menu_view->stringify( )
                             by_id = `menuButton` ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view           = view->shell( )->page( id = `page_main`
    title          = `abap2UI5 - Menu`
    navbuttonpress = client->_event_nav_app_leave( )
    shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(vbox) = view->vbox( ).

    vbox->button( text  = `Open Menu`
                  press = client->_event( `OPEN_MENU` )
                  id    = `menuButton`
                  class = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
