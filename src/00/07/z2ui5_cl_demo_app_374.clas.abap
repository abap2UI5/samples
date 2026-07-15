CLASS z2ui5_cl_demo_app_374 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_item,
        title TYPE string,
        descr TYPE string,
      END OF ty_s_item.
    DATA t_items TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.

    DATA detail_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_374 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      t_items = VALUE #(
          ( title = `Product A` descr = `First product` )
          ( title = `Product B` descr = `Second product` )
          ( title = `Product C` descr = `Third product` ) ).
      detail_text = `Select an item from the master list.`.

      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Split Container`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.SplitContainer` ).

    " split_container( ) returns the page instead of the new control, the
    " aggregations below would end up under the page - create it generically
    DATA(split) = page->_generic( `SplitContainer` ).

    split->master_pages(
        )->page( `Master`
            )->list( client->_bind( t_items )
                )->standard_list_item( title       = `{TITLE}`
                                       description = `{DESCR}`
                                       type        = `Active`
                                       press       = client->_event( val = `ITEM_PRESS` t_arg = VALUE #( ( `${TITLE}` ) ) ) ).

    split->detail_pages(
        )->page( title = `Detail`
                 class = `sapUiContentPadding`
            )->text( client->_bind( detail_text ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `ITEM_PRESS`.

        detail_text = |{ client->get_event_arg( 1 ) } selected in the master list.|.
        client->view_model_update( ).

      WHEN `CLICK_HINT_ICON`.
        popover_display( `button_hint_id` ).
    ENDCASE.

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `The split container keeps a master list and a detail area side by side. On phones only one of the two pages is visible at a time.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.

ENDCLASS.
