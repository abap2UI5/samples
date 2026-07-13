"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTile/sample/sap.m.sample.GenericTileAsKPITile
"! Shows KPI Tile samples that can contain header, subheader, key value, trend, scale, unit, and a
"! footer.
CLASS z2ui5_cl_demo_app_431 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_431 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( `PRESS` ).
      client->message_toast_display( `The tile is pressed.` ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " custom CSS class tileLayout (float: left) omitted - native CSS is not supported here
    " frameType OneByHalf / TwoByHalf omitted on all tiles - introduced with UI5 1.83 (after 1.71)
    " systemInfo and appShortcut omitted - introduced with UI5 1.92 (after 1.71)
    " url omitted on the link tiles - introduced with UI5 1.76 (after 1.71)

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: KPI Tile`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTile/sample/sap.m.sample.GenericTileAsKPITile` ).

    page->generic_tile(
        class     = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header    = `Country-Specific Profit Margin`
        subheader = `Expenses`
        press     = client->_event( `PRESS` )
        )->tile_content(
            unit   = `EUR`
            footer = `Current Quarter`
            )->numeric_content(
                scale      = `M`
                value      = `1.96`
                valuecolor = `Error`
                indicator  = `Up`
                withmargin = abap_false ).

    page->generic_tile(
        class  = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header = `US Profit Margin`
        press  = client->_event( `PRESS` )
        )->tile_content( unit = `Unit`
            )->numeric_content(
                scale      = `%`
                value      = `12`
                valuecolor = `Critical`
                indicator  = `Up`
                withmargin = abap_false ).

    page->generic_tile(
        class     = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header    = `Sales Fulfillment Application Title`
        subheader = `Subtitle`
        press     = client->_event( `PRESS` )
        )->tile_content(
            unit   = `EUR`
            footer = `Current Quarter`
            )->image_content( src = `sap-icon://home-share` ).

    page->generic_tile(
        class     = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header    = `Manage Activity Master Data Type`
        subheader = `Subtitle`
        press     = client->_event( `PRESS` )
        )->tile_content(
            )->image_content( src = `https://sapui5.hana.ondemand.com/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png` ).

    page->generic_tile(
        class     = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header    = `Manage Activity Master Data Type With a Long Title Without an Icon`
        subheader = `Subtitle Launch Tile`
        mode      = `HeaderMode`
        press     = client->_event( `PRESS` )
        )->tile_content(
            unit   = `EUR`
            footer = `Current Quarter` ).

    page->generic_tile(
        class     = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header    = `Jessica D. Prince Senior Consultant`
        subheader = `Department`
        press     = client->_event( `PRESS` )
        )->tile_content(
            )->image_content( src = `https://sapui5.hana.ondemand.com/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/ProfileImage_LargeGenTile.png` ).

    page->generic_tile(
        class           = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        backgroundimage = `https://sapui5.hana.ondemand.com/test-resources/sap/m/images/NewsImage1.png`
        frametype       = `OneByOne`
        press           = client->_event( `PRESS` )
        )->tile_content(
            footer    = `Report Available`
            frametype = `OneByOne`
            )->news_content(
                contenttext = `Realtime Business Service Analytics`
                subheader   = `SAP Analytics Cloud` ).

    page->generic_tile(
        class           = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        backgroundimage = `https://sapui5.hana.ondemand.com/test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage1.png`
        frametype       = `TwoByOne`
        press           = client->_event( `PRESS` )
        )->tile_content( footer = `August 21, 2016`
            )->news_content(
                contenttext = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                subheader   = `Today, SAP News` ).

    page->generic_tile(
        class     = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header    = `Country-Specific Profit Margin`
        subheader = `Expenses`
        press     = client->_event( `PRESS` )
        )->tile_content(
            unit   = `EUR`
            footer = `Current Quarter`
            )->numeric_content(
                scale      = `M`
                value      = `1.96`
                valuecolor = `Error`
                indicator  = `Up`
                withmargin = abap_false ).

    DATA(slide_tile) = page->slide_tile(
                           class          = `sapUiTinyMarginBegin sapUiTinyMarginTop`
                           transitiontime = `250`
                           displaytime    = `2500` ).
    slide_tile->generic_tile(
        backgroundimage = `https://sapui5.hana.ondemand.com/test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage1.png`
        frametype       = `TwoByOne`
        press           = client->_event( `PRESS` )
        )->tile_content( footer = `August 21, 2016`
            )->news_content(
                contenttext = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                subheader   = `Today, SAP News` ).
    slide_tile->generic_tile(
        backgroundimage = `https://sapui5.hana.ondemand.com/test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage2.png`
        frametype       = `TwoByOne`
        state           = `Failed`
        )->tile_content( footer = `August 21, 2016`
            )->news_content(
                contenttext = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
                subheader   = `Today, SAP News` ).

    page->generic_tile(
        class     = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header    = `Feed Tile that shows updates of the last feeds given to a specific topic:`
        frametype = `TwoByOne`
        press     = client->_event( `PRESS` )
        )->tile_content( footer = `New Notifications`
            )->feed_content(
                contenttext = `@@notify Great outcome of the Presentation today. New functionality well received.`
                subheader   = `About 1 minute ago in Computer Market`
                value       = `352` ).

    page->generic_tile(
        class  = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header = `Country-Specific Profit Margin`
        press  = client->_event( `PRESS` )
        )->tile_content(
            unit   = `EUR`
            footer = `Current Quarter`
            )->numeric_content(
                scale      = `M`
                value      = `1.96`
                valuecolor = `Error`
                indicator  = `Up`
                withmargin = abap_false ).

    page->generic_tile(
        class     = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header    = `Cumulative Totals`
        subheader = `Expenses`
        press     = client->_event( `PRESS` )
        )->tile_content(
            unit   = `Unit`
            footer = `Footer Text`
            )->numeric_content(
                value      = `1762`
                icon       = `sap-icon://line-charts`
                withmargin = abap_false ).

    page->generic_tile(
        class     = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header    = `Right click to open in new tab`
        subheader = `Link tile`
        press     = client->_event( `PRESS` )
        )->tile_content(
            )->image_content( src = `https://sapui5.hana.ondemand.com/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png` ).

    page->generic_tile(
        class  = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header = `US Profit Margin`
        press  = client->_event( `PRESS` )
        )->tile_content( unit = `Unit`
            )->numeric_content(
                scale      = `%`
                value      = `12`
                valuecolor = `Critical`
                indicator  = `Up`
                withmargin = abap_false ).

    page->generic_tile(
        class     = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header    = `Sales Fulfillment Application Title`
        subheader = `Subtitle`
        press     = client->_event( `PRESS` )
        )->tile_content(
            unit   = `EUR`
            footer = `Current Quarter`
            )->image_content( src = `sap-icon://home-share` ).

    page->generic_tile(
        class     = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header    = `Cumulative Totals`
        subheader = `Expenses`
        press     = client->_event( `PRESS` )
        )->tile_content(
            unit   = `Unit`
            footer = `Footer Text`
            )->numeric_content(
                value      = `1762`
                icon       = `sap-icon://line-charts`
                withmargin = abap_false ).

    page->generic_tile(
        class     = `sapUiTinyMarginBegin sapUiTinyMarginTop`
        header    = `Right click to open in new tab`
        subheader = `Link tile`
        press     = client->_event( `PRESS` )
        frametype = `TwoByOne`
        )->tile_content(
            )->image_content( src = `https://sapui5.hana.ondemand.com/test-resources/sap/m/demokit/sample/GenericTileAsLaunchTile/images/SAPLogoLargeTile_28px_height.png` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
