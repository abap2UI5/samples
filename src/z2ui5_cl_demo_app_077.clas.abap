CLASS z2ui5_cl_demo_app_077 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_value_map,
        pc TYPE string,
        ea TYPE string,
      END OF ty_value_map.

    TYPES:
      BEGIN OF ty_column_config,
        label             TYPE string,
        property          TYPE string,
        type              TYPE string,
        unit              TYPE string,
        delimiter         TYPE abap_bool,
        unit_property     TYPE string,
        width             TYPE string,
        scale             TYPE i,
        text_align        TYPE string,
        display_unit      TYPE string,
        true_value        TYPE string,
        false_value       TYPE string,
        template          TYPE string,
        input_format      TYPE string,
        wrap              TYPE abap_bool,
        auto_scale        TYPE abap_bool,
        timezone          TYPE string,
        timezone_property TYPE string,
        display_timezone  TYPE abap_bool,
        utc               TYPE abap_bool,
        value_map         TYPE ty_value_map,
      END OF ty_column_config.

    DATA: mt_column_config TYPE STANDARD TABLE OF ty_column_config WITH EMPTY KEY.
    DATA: mv_column_config TYPE string.

    TYPES:
      BEGIN OF ty_s_tab,
        selkz           TYPE abap_bool,
        rowid           TYPE string,
        product         TYPE string,
        createdate      TYPE string,
        createby        TYPE string,
        storagelocation TYPE string,
        quantity        TYPE i,
        meins           TYPE meins,
        price           TYPE p LENGTH 10 DECIMALS 2,
        waers           TYPE waers,
        selected        TYPE abap_bool,
      END OF ty_s_tab .
    TYPES:
      ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY .
    DATA mt_table TYPE ty_t_table.
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool VALUE abap_false.
    DATA check_load_cc   TYPE abap_bool VALUE abap_false.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_set_data.

  PRIVATE SECTION.

ENDCLASS.



CLASS z2ui5_cl_demo_app_077 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_load_cc = abap_false.
      check_load_cc = abap_true.
      z2ui5_set_data( ).
      client->nav_app_call( z2ui5_cl_popup_js_loader=>factory( z2ui5_cl_cc_spreadsheet=>get_js( mv_column_config ) ) ).
      RETURN.
    ELSEIF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page1) = view->page( id = `page_main`
            title          = 'abap2UI5 - XLSX Export'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            class = 'sapUiContentPadding' ).

    page1->header_content(
       )->link( text = 'Demo' target = '_blank' href = `https://twitter.com/abap2UI5/status/1683753816716345345`
       )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( ) ).

    DATA(page) = page1->dynamic_page( headerexpanded = abap_true headerpinned = abap_true ).

    DATA(header_title) = page->title( ns = 'f'  )->get( )->dynamic_page_title( ).
    header_title->heading( ns = 'f' )->hbox( )->title( `Table XLSX Export` ).
    header_title->expanded_content( 'f' ).
    header_title->snapped_content( ns = 'f' ).

    DATA(lo_box) = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween`
         )->flex_box( alignitems = `Start` ).

    DATA(cont) = page->content( ns = 'f' ).

    DATA(tab) = cont->table(
              id = `exportTable`
              items = client->_bind( mt_table )
          )->header_toolbar(
              )->overflow_toolbar(
                  )->title( 'title of the table'
                  )->toolbar_spacer(
                  )->_z2ui5( )->spreadsheet_export(
                tableid = 'exportTable'
                icon = 'sap-icon://excel-attachment'
                type = 'Emphasized'
          )->get_parent( )->get_parent( ).

    tab->columns(
        )->column(
            )->text( 'Row ID' )->get_parent(
        )->column(
            )->text( 'Product' )->get_parent(
        )->column(
            )->text( 'Create Date' )->get_parent(
        )->column(
            )->text( 'Create By' )->get_parent(
        )->column( )->text( 'Location' )->get_parent(
        )->column( )->text( 'Quantity' )->get_parent(
        )->column( )->text( 'Unit' )->get_parent(
        )->column( )->text( 'Price' ).

    tab->items( )->column_list_item(
      )->cells(
          )->text( text = '{ROWID}'
          )->text( text = '{PRODUCT}'
          )->text( text = '{CREATEDATE}'
          )->text( text = '{CREATEBY}'
          )->text( text = '{STORAGELOCATION}'
          )->text( text = '{QUANTITY}'
          )->text( text = '{MEINS}'
          )->text( text = '{PRICE}' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_set_data.

    mt_table = VALUE #(
        ( selkz = abap_false rowid = '1' product = 'table'    createdate = `01.01.2023` createby = `Olaf` storagelocation = `AREA_001` quantity = 400  meins = 'PC' price = '1000.50' waers = 'EUR' )
        ( selkz = abap_false rowid = '2' product = 'chair'    createdate = `01.01.2022` createby = `Karlo` storagelocation = `AREA_001` quantity = 123   meins = 'PC' price = '2000.55' waers = 'USD')
        ( selkz = abap_false rowid = '3' product = 'sofa'     createdate = `01.05.2021` createby = `Elin` storagelocation = `AREA_002` quantity = 700   meins = 'PC' price = '3000.11' waers = 'CNY' )
        ( selkz = abap_false rowid = '4' product = 'computer' createdate = `27.01.2023` createby = `Theo` storagelocation = `AREA_002` quantity = 200  meins = 'EA' price = '4000.88' waers = 'USD' )
        ( selkz = abap_false rowid = '5' product = 'printer'  createdate = `01.01.2023` createby = `Renate` storagelocation = `AREA_003` quantity = 90   meins = 'PC' price = '5000.47' waers = 'EUR')
        ( selkz = abap_false rowid = '6' product = 'table2'   createdate = `01.01.2023` createby = `Angela` storagelocation = `AREA_003` quantity = 1110  meins = 'PC' price = '6000.33' waers = 'GBP' )
    ).

    mt_column_config = VALUE #(
      ( label = 'Index'    property = 'ROWID'           type = 'String' )
      ( label = 'Product'  property = 'PRODUCT'         type = 'String' )
      ( label = 'Date'     property = 'CREATEDATE'      type = 'String' )
      ( label = 'Name'     property = 'CREATEBY'        type = 'String' )
      ( label = 'Location' property = 'STORAGELOCATION' type = 'String' )
      ( label = 'Quantity' property = 'QUANTITY'        type = 'Number' delimiter = abap_true )
      ( label = 'Unit'     property = 'MEINS'           type = 'String' )
      ( label = 'Price'    property = 'PRICE'           type = 'Currency' unit_property = 'WAERS' width = 14 scale = 2 ) ).

    mv_column_config =  /ui2/cl_json=>serialize(
                          data             = mt_column_config
                          compress         = abap_true
                          pretty_name      = 'X' ).

  ENDMETHOD.
ENDCLASS.
