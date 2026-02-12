CLASS z2ui5_cl_demo_app_276 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_276 IMPLEMENTATION.

  METHOD display_view.

    DATA(lv_css) = `.tileLayout {`    &&
                `    float: left;` &&
                `}`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Monitor Tile`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.GenericTile/sample/sap.m.sample.GenericTileAsMonitorTile` ).

    lo_page->generic_tile( class     = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                        header    = `Cumulative Totals`
                        subheader = `Expenses`
                        press     = mo_client->_event( `PRESS` )
           )->tile_content( unit   = `Unit`
                            footer = `Footer Text`
               )->numeric_content( value      = `1762`
                                   icon       = `sap-icon://line-charts`
                                   withmargin = abap_false )->get_parent( )->get_parent( )->get_parent(
      )->generic_tile( class     = `sapUiTinyMarginBegin sapUiTinyMarginTop tileLayout`
                       header    = `Cumulative Totals`
                       subheader = `Expenses`
                       press     = mo_client->_event( `PRESS` )
           )->tile_content( unit   = `Unit`
                            footer = `Footer Text`
               )->numeric_content( value      = `12`
                                   withmargin = abap_false ).

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
                                  description = `Shows Monitor Tile samples that can contain header, subheader, icon, key value, unit, and a footer.` ).

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
