CLASS z2ui5_cl_demo_app_274 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_274 IMPLEMENTATION.

  METHOD display_view.

    " Define the base URL for the server
    DATA lv_base_url TYPE string VALUE `https://sapui5.hana.ondemand.com/`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Slide Tile`
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
           href   = lv_base_url && `sdk/#/entity/sap.m.SlideTile/sample/sap.m.sample.SlideTile` ).

    lo_page->vertical_layout(
           )->slide_tile( class = `sapUiTinyMarginBegin sapUiTinyMarginTop`
               )->generic_tile(
                   backgroundimage = lv_base_url && `test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage2.png`
                   frametype       = `TwoByOne`
                   press           = mo_client->_event( `PRESS_ON_TILE_ONE` )
                   )->tile_content( footer = `August 21, 2016`
                       )->news_content(
                           contenttext = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
                           subheader   = `Today, SAP News` )->get_parent( )->get_parent( )->get_parent(
               )->generic_tile(
                   backgroundimage = lv_base_url && `test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage1.png`
                   frametype       = `TwoByOne`
                   press           = mo_client->_event( `PRESS_ON_TILE_TWO` )
                   )->tile_content( footer = `August 21, 2016`
                       )->news_content(
                           contenttext = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                           subheader   = `Today, SAP News` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
      )->slide_tile( class          = `sapUiTinyMarginBegin sapUiTinyMarginTop`
                     transitiontime = `250`
                     displaytime    = `2500`
               )->generic_tile(
                   backgroundimage = lv_base_url && `test-resources/sap/m/demokit/sample/SlideTile/images/NewsImage1.png`
                   frametype       = `TwoByOne`
                   press           = mo_client->_event( `PRESS_ON_TILE_ONE` )
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
                           contenttext = `AP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
                           subheader   = `Today, SAP News` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `CLICK_HINT_ICON` ).
      display_popover( `button_hint_id` ).
    ENDIF.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Shows Generic Tile with the 2x1 frame type displayed as sliding tiles.` ).

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
