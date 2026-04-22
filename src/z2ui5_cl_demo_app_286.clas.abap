CLASS z2ui5_cl_demo_app_286 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_name,
        title     TYPE string,
        desc      TYPE string,
        icon      TYPE string,
        highlight TYPE string,
        info      TYPE string,
      END OF ty_name.
    DATA lt_o_model TYPE TABLE OF ty_name.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_286 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Standard List Item - Info State Inverted`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemInfoStateInverted` ).

    page->list(
           id         = `myList`
           mode       = `MultiSelect`
           headertext = `Inverted Info State`
           items      = client->_bind( lt_o_model )
           )->items(
               )->standard_list_item(
                   title             = `{TITLE}`
                   description       = `{DESC}`
                   icon              = `{ICON}`
                   iconinset         = abap_false
                   highlight         = `{HIGHLIGHT}`
                   info              = `{INFO}`
                   infostate         = `{HIGHLIGHT}`
                   infostateinverted = abap_true ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `CLICK_HINT_ICON` ).
      popover_display( `button_hint_id` ).
    ENDIF.

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `This sample demonstrates the inverted rendering behavior of the info text and the info state of the StandardListItem control.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).

      lt_o_model = VALUE #(
        ( title = `Title text` desc = `Description text` icon = `sap-icon://favorite`  highlight = `Success`     info = `Completed` )
        ( title = `Title text` desc = `Description text` icon = `sap-icon://employee` highlight = `Error`       info = `Incomplete` )
        ( title = `Title text`                           icon = `sap-icon://accept`   highlight = `Information` info = `Information` )
        ( title = `Title text`                           icon = `sap-icon://activities` highlight = `None`      info = `None` )
        ( title = `Title text` desc = `Description text` icon = `sap-icon://badge`    highlight = `Warning`     info = `Warning` ) ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
