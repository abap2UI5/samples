CLASS z2ui5_cl_demo_app_372 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_372 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Menu Button`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( `CLICK_HINT_ICON` ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MenuButton` ).

    DATA(vbox) = page->vbox( `sapUiSmallMargin` ).

    vbox->label( `Regular mode - the button only opens the menu:` ).
    vbox->menu_button( text = `File`
        )->menu(
            )->menu_item( text  = `New`
                          icon  = `sap-icon://create`
                          press = client->_event( val = `MENU_ITEM` t_arg = VALUE #( ( `${$source>/text}` ) ) )
            )->menu_item( text  = `Open`
                          icon  = `sap-icon://open-folder`
                          press = client->_event( val = `MENU_ITEM` t_arg = VALUE #( ( `${$source>/text}` ) ) )
            )->menu_item( text  = `Save`
                          icon  = `sap-icon://save`
                          press = client->_event( val = `MENU_ITEM` t_arg = VALUE #( ( `${$source>/text}` ) ) ) ).

    vbox->label( text  = `Split mode - the button fires a default action, the arrow opens the menu:`
                 class = `sapUiSmallMarginTop` ).
    vbox->menu_button( text          = `Save`
                       buttonmode    = `Split`
                       defaultaction = client->_event( `DEFAULT_ACTION` )
        )->menu(
            )->menu_item( text  = `Save`
                          icon  = `sap-icon://save`
                          press = client->_event( val = `MENU_ITEM` t_arg = VALUE #( ( `${$source>/text}` ) ) )
            )->menu_item( text  = `Save As`
                          icon  = `sap-icon://duplicate`
                          press = client->_event( val = `MENU_ITEM` t_arg = VALUE #( ( `${$source>/text}` ) ) ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `MENU_ITEM`.
        client->message_toast_display( |{ client->get_event_arg( 1 ) } selected| ).

      WHEN `DEFAULT_ACTION`.
        client->message_toast_display( `Default action pressed` ).

      WHEN `CLICK_HINT_ICON`.
        popover_display( `button_hint_id` ).
    ENDCASE.

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `The menu button opens a menu with actions. In split mode the button itself triggers a default action while the arrow opens the menu.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.

ENDCLASS.
