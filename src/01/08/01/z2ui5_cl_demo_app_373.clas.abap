CLASS z2ui5_cl_demo_app_373 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS action_sheet_display
      IMPORTING
        id TYPE string.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_373 IMPLEMENTATION.

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
            title          = `abap2UI5 - Sample: Action Sheet`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ActionSheet` ).

    page->vbox( `sapUiSmallMargin`
        )->button( id = `button_action_sheet_id`
            text  = `Open Action Sheet`
            press = client->_event( `OPEN_SHEET` ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `OPEN_SHEET`.
        action_sheet_display( `button_action_sheet_id` ).

      WHEN `SHEET_ACTION`.
        client->message_toast_display( |{ client->get_event_arg( 1 ) } pressed| ).

      WHEN `CLICK_HINT_ICON`.
        popover_display( `button_hint_id` ).
    ENDCASE.

  ENDMETHOD.


  METHOD action_sheet_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->action_sheet( title            = `Choose an action`
                        placement        = `Bottom`
                        showcancelbutton = abap_true
        )->buttons(
            )->button( text  = `Approve`
                       icon  = `sap-icon://accept`
                       press = client->_event( val = `SHEET_ACTION` t_arg = VALUE #( ( `${$source>/text}` ) ) )
            )->button( text  = `Reject`
                       icon  = `sap-icon://decline`
                       press = client->_event( val = `SHEET_ACTION` t_arg = VALUE #( ( `${$source>/text}` ) ) )
            )->button( text  = `Email`
                       icon  = `sap-icon://email`
                       press = client->_event( val = `SHEET_ACTION` t_arg = VALUE #( ( `${$source>/text}` ) ) )
            )->button( text  = `Forward`
                       icon  = `sap-icon://forward`
                       press = client->_event( val = `SHEET_ACTION` t_arg = VALUE #( ( `${$source>/text}` ) ) ) ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `The action sheet displays a list of actions next to the control that opened it. On phones the actions are shown in a dialog at the bottom of the screen.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.

ENDCLASS.
