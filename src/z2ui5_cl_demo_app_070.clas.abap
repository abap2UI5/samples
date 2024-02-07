CLASS z2ui5_cl_demo_app_070 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        selkz            TYPE abap_bool,
        row_id           TYPE string,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
        meins            TYPE meins,
        price            TYPE p LENGTH 10 DECIMALS 2,
        waers            TYPE waers,
        selected         TYPE abap_bool,
        process          TYPE string,
        process_state    TYPE string,
      END OF ty_s_tab .
    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_s_filter_pop,
        option TYPE string,
        low    TYPE string,
        high   TYPE string,
        key    TYPE string,
      END OF ty_s_filter_pop .

    DATA mt_mapping TYPE z2ui5_if_types=>ty_t_name_value .
    DATA mv_search_value TYPE string .
    DATA mt_table TYPE ty_t_table .
    DATA lv_selkz TYPE abap_bool .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_set_search.
    METHODS z2ui5_set_data.

  PRIVATE SECTION.

    METHODS set_selkz
      IMPORTING
        iv_selkz TYPE abap_bool.

ENDCLASS.



CLASS z2ui5_cl_demo_app_070 IMPLEMENTATION.


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
      z2ui5_on_init( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'BUTTON_SEARCH' OR 'BUTTON_START'.
        client->message_toast_display( 'Search Entries' ).
        z2ui5_set_data( ).
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

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page1) = view->page( id = `page_main`
            title          = 'abap2UI5 - sap.ui.table.Table Features'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            class = 'sapUiContentPadding' ).

    page1->header_content(
          )->link(
              text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
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
        type = `Emphasized` ).

    DATA(cont) = page->content( ns = 'f' ).

    DATA(tab) = cont->ui_table( rows = client->_bind( val = mt_table )
                                editable = abap_false
                                alternaterowcolors = abap_true
                                rowactioncount = '2'
                                enablegrouping = abap_false
                                fixedcolumncount = '1'
                                selectionmode = 'None'
                                sort = client->_event( 'SORT' )
                                filter = client->_event( 'FILTER' )
                                customfilter =  client->_event( 'CUSTOMFILTER' ) ).
    tab->ui_extension( )->overflow_toolbar( )->title( text = 'Products' ).
    DATA(lo_columns) = tab->ui_columns( ).
    lo_columns->ui_column( width = '4rem' )->checkbox( selected = client->_bind_edit( lv_selkz ) enabled = abap_true select = client->_event( val = `SELKZ` ) )->ui_template( )->checkbox( selected = `{SELKZ}`  ).
    lo_columns->ui_column( width = '5rem' sortproperty = 'ROW_ID'
                                          filterproperty = 'ROW_ID' )->text( text = `Index` )->ui_template( )->text(   text = `{ROW_ID}` ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'PROCESS' filterproperty = 'PROCESS' )->text( text = `Process Indicator`
    )->ui_template( )->progress_indicator( class = 'sapUiSmallMarginBottom' percentvalue = `{PROCESS}` displayvalue = '{PROCESS} %'  showvalue = 'true' state = '{PROCESS_STATE}' ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'PRODUCT'
                           filterproperty = 'PRODUCT' )->text( text = `Product` )->ui_template( )->input( value = `{PRODUCT}` editable = abap_false ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'CREATE_DATE' filterproperty = 'CREATE_DATE' )->text( text = `Date` )->ui_template( )->text(   text = `{CREATE_DATE}` ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'CREATE_BY' filterproperty = 'CREATE_BY')->text( text = `Name` )->ui_template( )->text( text = `{CREATE_BY}` ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'STORAGE_LOCATION'  filterproperty = 'STORAGE_LOCATION' )->text( text = `Location` )->ui_template( )->text( text = `{STORAGE_LOCATION}`).
    lo_columns->ui_column( width = '11rem' sortproperty = 'QUANTITY' filterproperty = 'QUANTITY' )->text( text = `Quantity` )->ui_template( )->text( text = `{QUANTITY}`).
    lo_columns->ui_column( width = '6rem' sortproperty = 'MEINS' filterproperty = 'MEINS' )->text( text = `Unit` )->ui_template( )->text( text = `{MEINS}`).
    lo_columns->ui_column( width = '11rem' sortproperty = 'PRICE' filterproperty = 'PRICE' )->text( text = `Price` )->ui_template( )->currency( value = `{PRICE}` currency = `{WAERS}` ).
    lo_columns->get_parent( )->ui_row_action_template( )->ui_row_action(
    )->ui_row_action_item( type = 'Navigation'
                           press = client->_event( val = 'ROW_ACTION_ITEM_NAVIGATION' t_arg = VALUE #( ( `${ROW_ID}`  ) ) )
                          )->get_parent( )->ui_row_action_item( icon = 'sap-icon://edit' text = 'Edit' press = client->_event( val = 'ROW_ACTION_ITEM_EDIT' t_arg = VALUE #( ( `${ROW_ID}`  ) ) ) ).
*
*
*
*    lo_columns->Ui_column( width = '4rem' )->text( )->ui_template( )->overflow_toolbar( )->overflow_toolbar_button(
*    icon = 'sap-icon://edit' type = 'Transparent' press = client->_event(
*    val = `ROWEDIT` t_arg = VALUE #( ( `${ROW_ID}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_set_data.

    mt_table = VALUE #(
        ( selkz = abap_false row_id = '1' product = 'table'    create_date = `01.01.2023` create_by = `Olaf` storage_location = `AREA_001` quantity = 400  meins = 'ST' price = '1000.50' waers = 'EUR' process = '10'  process_state = 'None' )
        ( selkz = abap_false row_id = '2' product = 'chair'    create_date = `01.01.2022` create_by = `Karlo` storage_location = `AREA_001` quantity = 123   meins = 'ST' price = '2000.55' waers = 'USD' process = '20' process_state = 'Warning' )
        ( selkz = abap_false row_id = '3' product = 'sofa'     create_date = `01.05.2021` create_by = `Elin` storage_location = `AREA_002` quantity = 700   meins = 'ST' price = '3000.11' waers = 'CNY' process = '30' process_state = 'Success' )
        ( selkz = abap_false row_id = '4' product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_002` quantity = 200  meins = 'ST' price = '4000.88' waers = 'USD' process = '40' process_state = 'Information' )
        ( selkz = abap_false row_id = '5' product = 'printer'  create_date = `01.01.2023` create_by = `Renate` storage_location = `AREA_003` quantity = 90   meins = 'ST' price = '5000.47' waers = 'EUR' process = '70' process_state = 'Warning' )
        ( selkz = abap_false row_id = '6' product = 'table2'   create_date = `01.01.2023` create_by = `Angela` storage_location = `AREA_003` quantity = 110  meins = 'ST' price = '6000.33' waers = 'GBP' process = '90'  process_state = 'Error' )
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
