CLASS z2ui5_cl_demo_app_277 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_277 IMPLEMENTATION.

  METHOD display_view.

    " Define the base URL for the server
    DATA lv_base_url TYPE string VALUE `https://sapui5.hana.ondemand.com/`.

    DATA(lv_css) = `.tileLayout {` &&
                ` float: left;` &&
                `}`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->_generic( name = `style`
                    ns   = `html` )->_cc_plain_xml( lv_css )->get_parent( ).

    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: KPI Tile`
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
           href   = lv_base_url && `sdk/#/entity/sap.m.GenericTile/sample/sap.m.sample.GenericTileAsKPITile` ).

    lo_page->generic_tile( class     = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                        header    = `Country-Specific Profit Margin`
                frametype         = `OneByHalf`
                        subheader = `Expenses`
                        press     = mo_client->_event( `ON_PRESS` )
            )->tile_content( unit   = `EUR`
                             footer = `Current Quarter`
                )->numeric_content( scale      = `M`
                                    value      = `1.96`
                                    valuecolor = `Error`
                                    indicator  = `Up`
                                    withmargin = abap_false )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class     = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header    = `US Profit Margin`
                       press     = mo_client->_event( `ON_PRESS` )
                       frametype = `OneByHalf`
         )->tile_content( unit = `Unit`
         )->numeric_content( scale      = `%`
                             value      = `12`
                             valuecolor = `Critical`
                             indicator  = `Up`
                             withmargin = abap_false )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class     = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header    = `Sales Fulfillment Application Title`
                subheader        = `Subtitle`
                       press     = mo_client->_event( `ON_PRESS` )
                       frametype = `TwoByHalf`
         )->tile_content( unit   = `EUR`
                          footer = `Current Quarter`
           )->image_content( src = `sap-icon://home-share` )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class  = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header = `Manage Activity Master Data Type`
                subheader     = `Subtitle`
                       press  = mo_client->_event( `ON_PRESS` ) "frameType = `OneByHalf`
         )->tile_content(
           )->image_content( src = lv_base_url && `test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png` )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class  = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header = `Manage Activity Master Data Type With a Long Title Without an Icon`
                subheader     = `Subtitle Launch Tile`
                       mode   = `HeaderMode`
                       press  = mo_client->_event( `ON_PRESS` )
         )->tile_content( unit   = `EUR`
                          footer = `Current Quarter` )->get_parent( )->get_parent(
      )->generic_tile( class  = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header = `Jessica D. Prince Senior Consultant`
                subheader     = `Department`
                       press  = mo_client->_event( `ON_PRESS` )
         )->tile_content(
           )->image_content( src = lv_base_url && `test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/ProfileImage_LargeGenTile.png` )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class            = `sapUiTinyMarginBegin sapUiTinyMarginTop`
                        backgroundimage = lv_base_url && `test-resources/sap/m/images/NewsImage1.png`
                        frametype       = `OneByOne`
                       press            = mo_client->_event( `ON_PRESS` )
         )->tile_content( footer    = `Report Available`
                          frametype = `OneByOne`
           )->news_content(
                 contenttext = `Realtime Business Service Analytics`
                 subheader   = `SAP Analytics Cloud` )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class = `sapUiTinyMarginBegin sapUiTinyMarginTop`
             backgroundimage = lv_base_url && `test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage1.png`
             frametype       = `TwoByOne`
                       press = mo_client->_event( `ON_PRESS` )
         )->tile_content( footer = `August 21, 2016`
           )->news_content(
                 contenttext = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                 subheader   = `Today, SAP News` )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class       = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header      = `Country-Specific Profit Margin`
                subheader          = `Expenses`
                       press       = mo_client->_event( `ON_PRESS` )
                       systeminfo  = `system info`
                       appshortcut = `app shortcut`
         )->tile_content( unit   = `EUR`
                          footer = `Current Quarter`
           )->numeric_content( scale      = `M`
                               value      = `1.96`
                               valuecolor = `Error`
                               indicator  = `Up`
                               withmargin = abap_false )->get_parent( )->get_parent( )->get_parent(
      )->slide_tile( class          = `sapUiTinyMarginBegin sapUiTinyMarginTop`
                     transitiontime = `250`
                     displaytime    = `2500`
         )->generic_tile(
             backgroundimage = lv_base_url && `test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage1.png`
             frametype       = `TwoByOne`
             press           = mo_client->_event( `ON_PRESS` )
         )->tile_content( footer = `August 21, 2016`
           )->news_content(
                 contenttext = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                 subheader   = `Today, SAP News` )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile(
               backgroundimage = lv_base_url && `test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage2.png`
               frametype       = `TwoByOne`
               state           = `Failed`
           )->tile_content( footer = `August 21, 2016`
             )->news_content(
                   contenttext = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
                   subheader   = `Today, SAP News` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class  = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header = `Feed Tile that shows updates of the last feeds given to a specific topic:`
                  frametype   = `TwoByOne`
                       press  = mo_client->_event( `ON_PRESS` )
           )->tile_content( footer = `New Notifications`
             )->feed_content( contenttext = `@@notify Great outcome of the Presentation today. New functionality well received.`
                       subheader          = `About 1 minute ago in Computer Market`
                              value       = `352` )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class  = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header = `Country-Specific Profit Margin`
                       press  = mo_client->_event( `ON_PRESS` )
                  frametype   = `TwoByHalf`
           )->tile_content( unit   = `EUR`
                            footer = `Current Quarter`
             )->numeric_content( scale      = `M`
                                 value      = `1.96`
                                 valuecolor = `Error`
                                 indicator  = `Up`
                                 withmargin = abap_false )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class     = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header    = `Cumulative Totals`
                       subheader = `Expenses`
                       press     = mo_client->_event( `ON_PRESS` )
                       frametype = `OneByHalf`
           )->tile_content( unit   = `Unit`
                            footer = `Footer Text`
             )->numeric_content( value      = `1762`
                                 icon       = `sap-icon://line-charts`
                                 withmargin = abap_false )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class     = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header    = `Right click to open in new tab`
              subheader          = `Link tile`
                       press     = mo_client->_event( `ON_PRESS` )
                       url       = `https://www.sap.com/`
                       frametype = `TwoByHalf`
           )->tile_content(
             )->image_content( src = lv_base_url && `test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png` )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class  = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header = `US Profit Margin`
                       press  = mo_client->_event( `ON_PRESS` )
           )->tile_content( unit = `Unit`
             )->numeric_content( scale      = `%`
                                 value      = `12`
                                 valuecolor = `Critical`
                                 indicator  = `Up`
                                 withmargin = `false` )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class       = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header      = `Sales Fulfillment Application Title`
              subheader            = `Subtitle`
                       press       = mo_client->_event( `ON_PRESS` )
                       systeminfo  = `system`
                       appshortcut = `shortcut`
           )->tile_content( unit   = `EUR`
                            footer = `Current Quarter`
             )->image_content( src = lv_base_url && `sap-icon://home-share` )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class     = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header    = `Cumulative Totals`
                       subheader = `Expenses`
                       press     = mo_client->_event( `ON_PRESS` )
           )->tile_content( unit   = `Unit`
                            footer = `Footer Text`
             )->numeric_content( value      = `1762`
                                 icon       = `sap-icon://line-charts`
                                 withmargin = abap_false )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class     = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header    = `Right click to open in new tab`
              subheader          = `Link tile`
                       press     = mo_client->_event( `ON_PRESS` )
                       url       = `https://www.sap.com/`
                       frametype = `TwoByOne`
           )->tile_content(
             )->image_content( src = lv_base_url && `test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `CLICK_HINT_ICON`.
        display_popover( `button_hint_id` ).
      WHEN `ON_PRESS`.
        mo_client->message_toast_display( `The tile is pressed.` ).
    ENDCASE.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Shows KPI Tile samples that can contain header, subheader, key value, trend, scale, unit, and a footer.` ).

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
