"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MenuButton/sample/sap.m.sample.MenuButton
"! This control is used to open a menu in both desktop and mobile.
CLASS z2ui5_cl_demo_app_372 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS file_menu_display
      IMPORTING
        menu_button TYPE REF TO z2ui5_cl_xml_view.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_372 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA toolbar TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA vbox TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp7 TYPE string_table.
    page = z2ui5_cl_xml_view=>factory( )->shell(
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MenuButton/sample/sap.m.sample.MenuButton` ).

    " the original attaches the itemSelected event of the menu - here every menu item fires its own press event
    " the split mode 'Calculator' buttons of the original need nested menu items - not supported by the view API, therefore omitted
    
    toolbar = page->overflow_toolbar( ).
    toolbar->toolbar_spacer( ).
    toolbar->label( `In a toolbar` ).
    " the original adds custom data to the 'Edit' item - not supported by the view API, therefore omitted
    
    CLEAR temp1.
    INSERT `${$source>/text}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `${$source>/text}` INTO TABLE temp2.
    
    CLEAR temp4.
    INSERT `${$source>/text}` INTO TABLE temp4.
    toolbar->menu_button( text = `File`
        )->menu(
            )->menu_item( text  = `Edit`
                          icon  = `sap-icon://edit`
                          press = client->_event( val = `ITEM_PRESS` t_arg = temp1 )
            )->menu_item( text  = `Save`
                          icon  = `sap-icon://save`
                          press = client->_event( val = `ITEM_PRESS` t_arg = temp2 )
            )->menu_item( text  = `Open`
                          icon  = `sap-icon://open-folder`
                          press = client->_event( val = `ITEM_PRESS` t_arg = temp4 ) ).
    toolbar->toolbar_spacer( ).

    
    vbox = page->vbox( `sapUiSmallMargin` ).

    vbox->label( `Regular mode button` ).
    file_menu_display( vbox->menu_button( text = `File` ) ).

    " the beforeMenuOpen event of the original is only available since UI5 1.94, therefore omitted
    vbox->label( `Split mode button with associated last action` ).
    file_menu_display( vbox->menu_button( text          = `File Menu`
                                          buttonmode    = `Split`
                                          defaultaction = client->_event( `DEFAULT_ACTION` ) ) ).

    vbox->label( `Split mode button with associated last action with initial icon` ).
    file_menu_display( vbox->menu_button( text          = `File Menu`
                                          buttonmode    = `Split`
                                          defaultaction = client->_event( `DEFAULT_ACTION` ) ) ).

    " the useDefaultActionOnly property of the original is not available in the view API, therefore omitted
    vbox->label( `Split mode button with default action only` ).
    file_menu_display( vbox->menu_button( text          = `File Menu`
                                          buttonmode    = `Split`
                                          defaultaction = client->_event( `DEFAULT_ACTION` ) ) ).

    vbox->label( `Split mode with type Accept and constant default action` ).
    
    CLEAR temp3.
    INSERT `${$source>/text}` INTO TABLE temp3.
    
    CLEAR temp5.
    INSERT `${$source>/text}` INTO TABLE temp5.
    
    CLEAR temp7.
    INSERT `${$source>/text}` INTO TABLE temp7.
    vbox->menu_button( text          = `Accept`
                       buttonmode    = `Split`
                       type          = `Accept`
                       defaultaction = client->_event( `DEFAULT_ACTION_ACCEPT` )
        )->menu(
            )->menu_item( text  = `Send the response now`
                          icon  = `sap-icon://response`
                          press = client->_event( val = `MENU_ACTION` t_arg = temp3 )
            )->menu_item( text  = `Edit the response before sending`
                          icon  = `sap-icon://edit-outside`
                          press = client->_event( val = `MENU_ACTION` t_arg = temp5 )
            )->menu_item( text  = `Do not send a response`
                          icon  = `sap-icon://action`
                          press = client->_event( val = `MENU_ACTION` t_arg = temp7 ) ).

    " the two buttons of the original demonstrating the menuPosition property are omitted - the property is not available in the view API

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD file_menu_display.

    DATA temp5 TYPE string_table.
    DATA temp7 TYPE string_table.
    DATA temp9 TYPE string_table.
    CLEAR temp5.
    INSERT `${$source>/text}` INTO TABLE temp5.
    
    CLEAR temp7.
    INSERT `${$source>/text}` INTO TABLE temp7.
    
    CLEAR temp9.
    INSERT `${$source>/text}` INTO TABLE temp9.
    menu_button->menu(
        )->menu_item( text  = `Edit`
                      icon  = `sap-icon://edit`
                      press = client->_event( val = `MENU_ACTION` t_arg = temp5 )
        )->menu_item( text  = `Save`
                      icon  = `sap-icon://save`
                      press = client->_event( val = `MENU_ACTION` t_arg = temp7 )
        )->menu_item( text  = `Open`
                      icon  = `sap-icon://open-folder`
                      press = client->_event( val = `MENU_ACTION` t_arg = temp9 ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `ITEM_PRESS`.
        client->message_toast_display( |{ client->get_event_arg( ) } Pressed| ).

      WHEN `MENU_ACTION`.
        client->message_toast_display( |Action triggered on item: { client->get_event_arg( ) }| ).

      WHEN `DEFAULT_ACTION`.
        client->message_toast_display( `Default action triggered` ).

      WHEN `DEFAULT_ACTION_ACCEPT`.
        client->message_toast_display( `Accepted` ).

      WHEN `CLICK_HINT_ICON`.
        popover_display( `button_hint_id` ).
    ENDCASE.

  ENDMETHOD.


  METHOD popover_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory_popup( ).
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
