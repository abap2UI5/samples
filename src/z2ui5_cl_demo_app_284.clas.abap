CLASS z2ui5_cl_demo_app_284 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_284 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_page_01) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Flexible sizing - Toolbar`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page_01->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `CLICK_HINT_ICON` ) ).

    lo_page_01->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Page/sample/sap.m.sample.PageListReportToolbar` ).

    DATA(lo_page_02) = lo_page_01->page( enablescrolling = abap_true
                                   title           = `Title`
                                   class           = `sapUiResponsivePadding--header sapUiResponsivePadding--footer`
                              )->content(
                                  )->vbox( fitcontainer = abap_true
                                      )->simple_form( id = `SimpleFormDisplay480`
                                          editable       = abap_false
                                          layout         = `ResponsiveGridLayout`
                                          title          = `Address`
                                          labelspanl     = `4`
                                          labelspanm     = `4`
                                          emptyspanl     = `0`
                                          emptyspanm     = `0`
                                          columnsl       = `2`
                                          columnsm       = `2`
                                          )->content( ns = `form`
                                              )->title( ns   = `core`
                                                        text = `Office`
                                              )->label( text = `Name`
                                              )->text( text = `Red Point Stores`
                                              )->label( text = `Street/No.`
                                              )->text( text = `Main St 1618`
                                              )->label( text = `ZIP Code/City`
                                              )->text( text = `31415 Maintown`
                                              )->label( text = `Country`
                                              )->text( text = `Germany`
                                              )->title( ns   = `core`
                                                        text = `Online`
                                              )->label( text = `Web`
                                              )->text( text = `http://www.sap.com`
                                              )->label( text = `Twitter`
                                              )->text( text = `@sap` )->get_parent(
                                          )->layout_data( ns = `form`
                                              )->flex_item_data( shrinkfactor     = `0`
                                                                 backgrounddesign = `Solid`
                                                                 styleclass       = `sapContrastPlus` )->get_parent( )->get_parent(
                                      )->analytical_table( ns            = `table`
                                                           selectionmode = `MultiToggle`
                                          )->rowmode( ns = `table`
                                              )->auto( ns               = `trm`
                                                       rowcontentheight = `32` )->get_parent( )->get_parent(
                                          )->toolbar( ns = `table`
                                            )->overflow_toolbar(
                                              )->title( text = `Title Bar Here`
                                              )->toolbar_spacer(
                                              )->search_field( width = `12rem`
                                              )->segmented_button(
                                                )->items(
                                                  )->segmented_button_item( icon = `sap-icon://table-view`
                                                  )->segmented_button_item( icon = `sap-icon://bar-chart` )->get_parent( )->get_parent(
                                              )->button( icon = `sap-icon://group-2`
                                                         type = `Transparent`
                                              )->button( icon = `sap-icon://action-settings`
                                                         type = `Transparent` )->get_parent( )->get_parent(
                                          )->columns( ns = `table`
                                              )->analytical_column( ns = `table` )->get_parent(
                                              )->analytical_column( ns = `table` )->get_parent(
                                              )->analytical_column( ns = `table` )->get_parent( )->get_parent(
                                          )->layout_data( ns = `table`
                                              )->flex_item_data( growfactor = `1`
                                                                 basesize   = `0%`
                                                                 styleclass = `sapUiResponsiveContentPadding` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
                              )->footer(
                                  )->overflow_toolbar(
                                      )->content(
                                          )->toolbar_spacer(
                                          )->button( text = `Grouped View`
                                          )->button( text = `Classical Table` ).

    mo_client->view_display( lo_page_02->stringify( ) ).
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
                                  description = `This page shows flexible sizing with a Toolbar. ` &&
                                                `The upper part extends with its content, but doesn't react to viewport changes. ` &&
                                                `The lower part reacts to the viewport size. The table inside takes the available space. ` &&
                                                `If the minimum size of the table is reached, the page begins to scroll.` ).

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
