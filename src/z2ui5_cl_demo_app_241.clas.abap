class Z2UI5_CL_DEMO_APP_241 definition
  public
  create public .

public section.

  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_241 IMPLEMENTATION.


  METHOD DISPLAY_VIEW.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Tile Content'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
       )->button( id = `hint_icon`
           icon = `sap-icon://hint`
           tooltip = `Sample information`
           press = client->_event( 'POPOVER' ) ).

    page->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.TileContent/sample/sap.m.sample.TileContent' ).

    DATA(layout) = page->grid( containerquery = abap_true class = `sapUiSmallMarginTop`
                          )->tile_content( footer = `Current Quarter` unit = `EUR` "class = `sapUiSmallMargin`
                              )->numeric_content( scale = `M` value = `1.96`
                                                  valuecolor = `Error` indicator = `Up` )->get_parent( )->get_parent(
                          )->tile_content( footer = `Leave Requests` class = `sapUiSmallMargin`
                              )->numeric_content( value = `3`
                                                  icon = `sap-icon://travel-expense`  )->get_parent( )->get_parent(
                          )->tile_content( footer = `Hours since last Activity` class = `sapUiSmallMargin`
                              )->numeric_content( value = `9` icon = `sap-icon://locked` )->get_parent( )->get_parent(
                          )->tile_content( footer = `New Notifications` class = `sapUiSmallMargin`
                              )->feed_content( contenttext = `@@notify Great outcome of the Presentation today. The new functionality and the new design was well received.`
                                               subheader = `about 1 minute ago in Computer Market` value = `132` )->get_parent( )->get_parent(
                          )->tile_content( footer = `August 21, 2013` class = `sapUiSmallMargin`
                              )->news_content( contenttext = `SAP Unveils Powerful New Player Comparison Tool Exclusively on NFL.com`
                                               subheader = `SAP News`
                   ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD ON_EVENT.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'POPOVER'.
        z2ui5_display_popover( `hint_icon` ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_DISPLAY_POPOVER.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom` width = `auto`
              )->quick_view_page( pageid = `sampleInformationId`
                                  header = `Sample information`
                                  description = `Shows the universal container for different content types and context information in the footer area.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id
    ).

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
