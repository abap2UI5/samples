CLASS z2ui5_cl_demo_app_226 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .
  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_226 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Icon Tab Bar - Sub tabs'
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(layout) = page->label(
             wrapping = `true`
             text     = `IconTabBar with filters with own content and sub tabs. The click area is split to allow the user to display the content or alternatively to expand/collapse the sub tabs.`
             class    = `sapUiSmallMargin` ).

    layout->icon_tab_bar( class = `sapUiResponsiveContentPadding`
              )->items(
                  )->icon_tab_filter( key  = `info`
                                      text = `Info`
                      )->items(
                          )->icon_tab_filter( text = `Info one`
                              )->text( `Info one content goes here...`
                              )->text( `Select another sub tab to see its content...` )->get_parent(
                          )->icon_tab_filter( text = `Info two`
                              )->text( `Info two content goes here...` )->get_parent(
                          )->icon_tab_filter( text = `Info three`
                              )->text( `Info three content goes here...` )->get_parent(
                          )->icon_tab_filter( text = `Info four`
                              )->text( `Info four content goes here...` )->get_parent( )->get_parent(
                      )->text( `Info own content goes here...`
                      )->text( `Select a sub tab to see its content...` )->get_parent(
      )->icon_tab_filter( key  = `attachments`
                          text = `Attachments`
                      )->items(
                          )->icon_tab_filter( text = `Attachment one`
                              )->text( `Attachment one goes here...` )->get_parent(
                          )->icon_tab_filter( text = `Attachment two`
                              )->text( `Attachment two goes here...` )->get_parent( )->get_parent(
                      )->text( `Attachments own content goes here...` )->get_parent(
      )->icon_tab_filter( key  = `notes`
                          text = `Notes`
                      )->items(
                          )->icon_tab_filter( text = `Note one`
                              )->text( `Note one goes here...` )->get_parent(
                          )->icon_tab_filter( text = `Note two`
                              )->text( `Note two goes here...` )->get_parent( )->get_parent(
                      )->text( `Notes own content goes here...` )->get_parent( )->get_parent( )->get_parent(
      )->label(
                wrapping = `true`
                text     = `IconTabBar with filters without own content - only sub tabs`
                class    = `sapUiSmallMargin`
      )->icon_tab_bar( class = `sapUiResponsiveContentPadding`
                )->items(
                  )->icon_tab_filter( key  = `info`
                                      text = `Info`
                      )->items(
                          )->icon_tab_filter( text = `Info one`
                              )->text( `Info one content goes here...` )->get_parent(
                          )->icon_tab_filter( text = `Info two`
                              )->text( `Info two content goes here...` )->get_parent(
                          )->icon_tab_filter( text = `Info three`
                              )->text( `Info three content goes here...` )->get_parent(
                          )->icon_tab_filter( text = `Info four`
                              )->text( `Info four content goes here...` )->get_parent( )->get_parent( )->get_parent(
      )->icon_tab_filter( key  = `attachments`
                          text = `Attachments`
                      )->items(
                          )->icon_tab_filter( text = `Attachment one`
                              )->text( `Attachment one goes here...` )->get_parent(
                          )->icon_tab_filter( text = `Attachment two`
                              )->text( `Attachment two goes here...` )->get_parent( )->get_parent( )->get_parent(
      )->icon_tab_filter( key  = `notes`
                          text = `Notes`
                      )->items(
                          )->icon_tab_filter( text = `Note one`
                              )->text( `Note one content goes here...` )->get_parent(
                          )->icon_tab_filter( text = `Note two`
                              )->text( `Note two content goes here...` )->get_parent( )->get_parent( ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
