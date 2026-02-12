CLASS z2ui5_cl_demo_app_278 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_278 IMPLEMENTATION.

  METHOD display_view.

    DATA(lv_css) = `.tileLayout {`    &&
                `    float: left;` &&
                `}`.

    " Define the base URL for the server
    DATA lv_base_url TYPE string VALUE `https://sapui5.hana.ondemand.com/`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Feed and News Tile`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `CLICK_HINT_ICON` ) ).

    lo_page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = lv_base_url && `sdk/#/entity/sap.m.GenericTile/sample/sap.m.sample.GenericTileAsFeedTile` ).

    lo_page->generic_tile( class  = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                        header = `Feed Tile that shows updates of the last feeds given to a specific topic:`
           frametype           = `TwoByOne`
                        press  = mo_client->_event( `PRESS` )
               )->tile_content( footer = `New Notifications`
                 )->feed_content( contenttext = `@@notify Great outcome of the Presentation today. New functionality well received.`
                     subheader                = `About 1 minute ago in Computer Market`
                                  value       = `352` )->get_parent( )->get_parent( )->get_parent(
      )->slide_tile( class = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
         )->tiles(
           )->generic_tile(
               backgroundimage = lv_base_url && `test-resources/sap/m/demokit/sample/GenericTileAsFeedTile/images/NewsImage1.png`
               frametype       = `TwoByOne`
               press           = mo_client->_event( `PRESS` )
             )->tile_content( footer = `August 21, 2016`
               )->news_content(
                  contenttext = `Wind Map: Monitoring Real-Time and Fore-casted Wind Conditions across the Globe`
                  subheader   = `Today, SAP News` )->get_parent( )->get_parent( )->get_parent(
           )->generic_tile(
               backgroundimage = lv_base_url && `test-resources/sap/m/demokit/sample/GenericTileAsFeedTile/images/NewsImage2.png`
               frametype       = `TwoByOne`
               press           = mo_client->_event( `PRESS` )
             )->tile_content( footer = `August 21, 2016`
               )->news_content(
                   contenttext = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
                   subheader   = `Today, SAP News` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `CLICK_HINT_ICON`.
        display_popover( `button_hint_id` ).
      WHEN `PRESS`.
        mo_client->message_toast_display( `The GenericTile is pressed.` ).
    ENDCASE.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Shows Feed Tile and News Tile samples that can contain feed content, news content, and a footer.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).
    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.
ENDCLASS.
