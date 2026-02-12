CLASS z2ui5_cl_demo_app_299 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_product_collection,
        product_id TYPE string,
        name       TYPE string,
      END OF ty_product_collection.

    DATA lt_product_collection  TYPE TABLE OF ty_product_collection.
    DATA lt_product_collection2 TYPE TABLE OF ty_product_collection.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS set_data.
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

CLASS z2ui5_cl_demo_app_299 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page_01) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Select - Wrapping text`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Select/sample/sap.m.sample.SelectWithWrappedItemText` ).

    lo_page_01->select(
                width         = `300px`
                wrapitemstext = abap_true
                class         = `sapUiLargeMargin`
                items         = mo_client->_bind( lt_product_collection )
                )->item( key  = `{PRODUCT_ID}`
                         text = `{NAME}`
             )->get_parent(
             )->select(
                width         = `300px`
                wrapitemstext = abap_true
                class         = `sapUiLargeMargin`
                items         = mo_client->_bind( lt_product_collection2 )
                )->item( key  = `{PRODUCT_ID}`
                         text = `{NAME}`
             )->get_parent( ).

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
                                  description = `Illustrates how the text in items wrap.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).
      set_data( ).
    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.

  METHOD set_data.

    CLEAR lt_product_collection.
    CLEAR lt_product_collection2.

    " Populating lt_product_collection
    lt_product_collection = VALUE #(
      ( product_id = `HT-1001` name = `Select option 1` )
      ( product_id = `HT-1002` name = `Lorem Ipsum is simply dummy text of the printing and typesetting industry.` )
      ( product_id = `HT-1003` name = `Select option 3` )
      ( product_id = `HT-1007` name = `Select option 4` )
      ( product_id = `HT-1010` name = `Select option 5` ) ).
    SORT lt_product_collection BY name.

    " Populating lt_product_collection2
    lt_product_collection2 = VALUE #(
      ( product_id = `key1` name = `Select option 1` )
      ( product_id = `key2` name = `Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.` )
      ( product_id = `key3` name = `Select option 3` )
      ( product_id = `key4` name = `Select option 4` )
      ( product_id = `key5` name = `Select option 5` ) ).
    SORT lt_product_collection2 BY name.
  ENDMETHOD.
ENDCLASS.
