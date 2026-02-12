CLASS z2ui5_cl_demo_app_261 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_261 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: News Content`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->header_content(
            )->button( id = `hint_icon`
                icon      = `sap-icon://hint`
                tooltip   = `Sample information`
                press     = mo_client->_event( `POPOVER` ) ).

    lo_page->header_content(
            )->link(
                text   = `UI5 Demo Kit`
                target = `_blank`
                href   = `https://sapui5.hana.ondemand.com/#/entity/sap.m.NewsContent/sample/sap.m.sample.NewsContent` ).

    lo_page->tile_content( class = `sapUiSmallMargin`
               )->content(
                   )->news_content(
                       contenttext = `SAP Unveils Powerful New Player Comparison Tool Exclusively on NFL.com`
                       subheader   = `August 21, 2013`
                       press       = mo_client->_event( `NEWS_CONTENT_PRESS` ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `POPOVER`.
        display_popover( `hint_icon` ).
      WHEN `NEWS_CONTENT_PRESS`.
        mo_client->message_toast_display( `The news content is pressed.` ).
    ENDCASE.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `This control is used to display the news content text and subheader in a tile.` ).

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
