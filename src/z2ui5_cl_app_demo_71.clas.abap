CLASS z2ui5_cl_app_demo_71 DEFINITION
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
    TYPES:
      BEGIN OF ty_s_filter_pop,
        option TYPE string,
        low    TYPE string,
        high   TYPE string,
        key    TYPE string,
      END OF ty_s_filter_pop .

    DATA mt_mapping TYPE z2ui5_if_client=>ty_t_name_value .
    DATA mv_search_value TYPE string .
    DATA mt_table TYPE ty_t_table .
    DATA lv_selkz TYPE abap_bool .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool VALUE abap_false.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_set_search.
    METHODS z2ui5_set_data.

  PRIVATE SECTION.

    METHODS set_selkz
      IMPORTING
        iv_selkz TYPE abap_bool.

ENDCLASS.



CLASS z2ui5_cl_app_demo_71 IMPLEMENTATION.


  METHOD set_selkz.

    FIELD-SYMBOLS: <ls_table> TYPE ty_s_tab.

    LOOP AT mt_table ASSIGNING <ls_table>.
      <ls_table>-selkz = iv_selkz.
    ENDLOOP.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      z2ui5_set_data( ).

      client->view_display( z2ui5_cl_xml_view=>factory( client
        )->cc_export_spreadsheet_get_js( columnconfig = mv_column_config
        )->stringify( ) ).

      client->timer_set( event_finished = client->_event( `START` ) interval_ms = `0` ).


      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'START'.
*        z2ui5_set_data( ).
        z2ui5_on_init( ).
      WHEN 'BUTTON_SEARCH' OR 'BUTTON_START'.
*        client->message_toast_display( 'Search Entries' ).
*        z2ui5_set_data( ).
        z2ui5_set_search( ).
        client->view_model_update( ).
      WHEN 'SORT'.
        DATA(lt_arg) = client->get( )-t_event_arg.
        client->message_toast_display( 'Event SORT' ).
      WHEN 'FILTER'.
        lt_arg = client->get( )-t_event_arg.
        client->message_toast_display( 'Event FILTER' ).
      WHEN 'SELKZ'.
        client->message_toast_display( |'Event SELKZ' { lv_selkz } | ).
        set_selkz( lv_selkz ).
        client->view_model_update( ).
      WHEN 'CUSTOMFILTER'.
        lt_arg = client->get( )-t_event_arg.
        client->message_toast_display( 'Event CUSTOMFILTER' ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
      WHEN 'ROWEDIT'.
        lt_arg = client->get( )-t_event_arg.
        READ TABLE lt_arg INTO DATA(ls_arg) INDEX 1.
        IF sy-subrc = 0.
          client->message_toast_display( |Event ROWEDIT Row Index { ls_arg } | ).
        ENDIF.

      WHEN 'ROW_ACTION_ITEM_NAVIGATION'.
        lt_arg = client->get( )-t_event_arg.
        READ TABLE lt_arg INTO ls_arg INDEX 1.
        IF sy-subrc = 0.
          client->message_toast_display( |Event ROW_ACTION_ITEM_NAVIGATION Row Index { ls_arg } | ).
        ENDIF.

      WHEN 'ROW_ACTION_ITEM_EDIT'.
        lt_arg = client->get( )-t_event_arg.
        READ TABLE lt_arg INTO ls_arg INDEX 1.
        IF sy-subrc = 0.
          client->message_toast_display( |Event ROW_ACTION_ITEM_EDIT Row Index { ls_arg } | ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    mt_mapping = VALUE #(
    (   n = `EQ`     v = `={LOW}`    )
    (   n = `LT`     v = `<{LOW}`   )
    (   n = `LE`     v = `<={LOW}`  )
    (   n = `GT`     v = `>{LOW}`   )
    (   n = `GE`     v = `>={LOW}`  )
    (   n = `CP`     v = `*{LOW}*`  )
    (   n = `BT`     v = `{LOW}...{HIGH}` )
    (   n = `NE`     v = `!(={LOW})`    )
    (   n = `NE`     v = `!(<leer>)`    )
    (   n = `<leer>` v = `<leer>`    )
    ).

    DATA(view) = z2ui5_cl_xml_view=>factory( client ).

    DATA(page1) = view->page( id = `page_main`
            title          = 'abap2UI5 - sap.ui.table.Table Features'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = abap_true
            class = 'sapUiContentPadding' ).

    page1->header_content(
          )->link(
              text = 'Source_Code' target = '_blank' href = view->hlp_get_source_code_url(  )
     ).

    DATA(page) = page1->dynamic_page( headerexpanded = abap_true headerpinned = abap_true ).

    DATA(header_title) = page->title( ns = 'f'  )->get( )->dynamic_page_title( ).
    header_title->heading( ns = 'f' )->hbox( )->title( `Search Field` ).
    header_title->expanded_content( 'f' ).
    header_title->snapped_content( ns = 'f' ).

    DATA(lo_box) = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween` )->flex_box( alignitems = `Start` ).

    lo_box->vbox( )->text( `Search` )->search_field(
         value  = client->_bind_edit( mv_search_value )
         search = client->_event( 'BUTTON_SEARCH' )
         change = client->_event( 'BUTTON_SEARCH' )
*         livechange = client->__event( 'BUTTON_SEARCH' )
         width  = `17.5rem`
         id     = `SEARCH` ).

    lo_box->get_parent( )->hbox( justifycontent = `End` )->button(
        text = `Go`
        press = client->_event( `BUTTON_START` )
        type = `Emphasized`
        ).

    DATA(cont) = page->content( ns = 'f' ).

    DATA(tab) = cont->ui_table( rows = client->_bind( val = mt_table )
                                editable = abap_false
                                id = 'exportTable'
                                alternaterowcolors = abap_true
                                enablegrouping = abap_false
                                fixedcolumncount = '1'
                                rowactioncount = '2'
                                selectionmode = 'None'
                                sort = client->_event( 'SORT' )
                                filter = client->_event( 'FILTER' )
                                customfilter =  client->_event( 'CUSTOMFILTER' ) ).
    tab->ui_extension( )->overflow_toolbar( )->title( text = 'Products' )->toolbar_spacer( )->cc_export_spreadsheet( tableid = 'exportTable' icon = 'sap-icon://excel-attachment' type = 'Emphasized' ).
    DATA(lo_columns) = tab->ui_columns( ).
    lo_columns->ui_column( width = '4rem' )->checkbox( selected = client->_bind_edit( lv_selkz ) enabled = abap_true select = client->_event( val = `SELKZ` ) )->ui_template( )->checkbox( selected = `{SELKZ}`  ).
    lo_columns->ui_column( width = '5rem' sortproperty = 'ROWID'
                                          filterproperty = 'ROWID' )->text( text = `Index` )->ui_template( )->text(   text = `{ROWID}` ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'PRODUCT'
                           filterproperty = 'PRODUCT' )->text( text = `Product` )->ui_template( )->input( value = `{PRODUCT}` editable = abap_false ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'CREATEDATE' filterproperty = 'CREATEDATE' )->text( text = `Date` )->ui_template( )->text(  '{CREATEDATE}' ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'CREATEBY' filterproperty = 'CREATEBY')->text( text = `Name` )->ui_template( )->text( text = `{CREATEBY}` ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'STORAGELOCATION'  filterproperty = 'STORAGELOCATION' )->text( text = `Location` )->ui_template( )->text( text = `{STORAGELOCATION}`).
    lo_columns->ui_column( width = '11rem' sortproperty = 'QUANTITY' filterproperty = 'QUANTITY' )->text( text = `Quantity` )->ui_template( )->text( text = `{QUANTITY}`).
    lo_columns->ui_column( width = '6rem' sortproperty = 'MEINS' filterproperty = 'MEINS' )->text( text = `Unit` )->ui_template( )->text( text = `{MEINS}`).
    lo_columns->ui_column( width = '11rem' sortproperty = 'PRICE' filterproperty = 'PRICE' )->text( text = `Price` )->ui_template( )->currency( value = `{PRICE}` currency = `{WAERS}` ).
*    lo_columns->Ui_column( width = '4rem' )->text( )->ui_template( )->overflow_toolbar( )->overflow_toolbar_button( icon = 'sap-icon://edit' type = 'Transparent' press = client->_event( val = `ROWEDIT` t_arg = VALUE #( ( `${ROW_ID}` ) ) ) ).

    lo_columns->get_parent( )->ui_row_action_template( )->ui_row_action(
    )->ui_row_action_item( type = 'Navigation'
                           press = client->_event( val = 'ROW_ACTION_ITEM_NAVIGATION' t_arg = VALUE #( ( `${ROWID}`  ) ) )
                          )->get_parent( )->ui_row_action_item( icon = 'sap-icon://edit' text = 'Edit' press = client->_event( val = 'ROW_ACTION_ITEM_EDIT' t_arg = VALUE #( ( `${ROWID}`  ) ) ) ).

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
      ( label = 'Price'    property = 'PRICE'           type = 'Currency' unit_property = 'WAERS' width = 14 scale = 2 )
    ).

    mv_column_config =  /ui2/cl_json=>serialize(
                          data             = mt_column_config
                          compress         = abap_true
                          pretty_name      = 'X' "camel_case
                        ).

  ENDMETHOD.


  METHOD z2ui5_set_search.

    IF mv_search_value IS NOT INITIAL.

      LOOP AT mt_table REFERENCE INTO DATA(lr_row).
        DATA(lv_row) = ``.
        DATA(lv_index) = 1.
        DO.
          ASSIGN COMPONENT lv_index OF STRUCTURE lr_row->* TO FIELD-SYMBOL(<field>).
          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
          lv_row = lv_row && <field>.
          lv_index = lv_index + 1.
        ENDDO.

        IF lv_row NS mv_search_value.
          DELETE mt_table.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
