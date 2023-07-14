class Z2UI5_CL_APP_DEMO_70 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  types:
    BEGIN OF ty_s_tab,
        selkz            type abap_bool,
        row_id           TYPE string,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
        meins            TYPE meins,
        price            TYPE float,
        waers            TYPE waers,
        selected         TYPE abap_bool,
      END OF ty_s_tab .
  types:
    ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY .
  types:
    BEGIN OF ty_S_filter_pop,
        option TYPE string,
        low    TYPE string,
        high   TYPE string,
        key    TYPE string,
      END OF ty_S_filter_pop .

  data:
    mt_filter TYPE STANDARD TABLE OF ty_S_filter_pop WITH EMPTY KEY .
  data MT_MAPPING type Z2UI5_IF_CLIENT=>TY_T_NAME_VALUE .
  data MV_SEARCH_VALUE type STRING .
  data MT_TABLE type TY_T_TABLE .
  data SELECTEDINDEX type STRING .
  data LV_SELETED_INDEX type INTEGER .
  data LV_SELKZ type ABAP_BOOL .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_set_search.
    METHODS z2ui5_set_data.

private section.

  methods SET_SELKZ
    importing
      !IV_SELKZ type ABAP_BOOLEAN .
ENDCLASS.



CLASS Z2UI5_CL_APP_DEMO_70 IMPLEMENTATION.


  method set_selkz.
    FIELD-SYMBOLS: <ls_table> type ty_s_tab.

    loop at mt_table ASSIGNING <ls_table>.
      <ls_table>-selkz = iv_selkz.
      modify mt_table from <ls_table>.
    endloop.
  endmethod.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  method Z2UI5_ON_EVENT.

    case client->get( )-event.
      when 'BUTTON_SEARCH' or 'BUTTON_START'.
        client->message_toast_display( 'Search Entries' ).
        z2ui5_set_data( ).
        z2ui5_set_search( ).
        client->view_model_update( ).
      when 'SORT'.
        data(lt_arg) = client->get( )-t_event_arg.
        client->message_toast_display( 'Event SORT' ).
      when 'FILTER'.
        lt_arg = client->get( )-t_event_arg.
        client->message_toast_display( 'Event FILTER' ).
      when 'SELKZ'.
        client->message_toast_display( |'Event SELKZ' { lv_selkz } | ).
        set_selkz( lv_selkz ).
        client->view_model_update( ).
      when 'CUSTOMFILTER'.
        lt_arg = client->get( )-t_event_arg.
        client->message_toast_display( 'Event CUSTOMFILTER' ).
      when 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
      when 'ROWEDIT'.
        lt_arg = client->get( )-t_event_arg.
        read table lt_arg into data(ls_arg) index 1.
        if sy-subrc = 0.
          client->message_toast_display( |Event ROWEDIT Row Index { ls_arg } | ).
        endif.
    endcase.

  endmethod.


  method Z2UI5_ON_INIT.

    mt_mapping = value #(
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



    data(view) = z2ui5_cl_xml_view=>factory( client ).

    data(page1) = view->page( id = `page_main`
            title          = 'abap2UI5 - Ui Table Features'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = abap_true
            class = 'sapUiContentPadding' ).

    page1->header_content(
          )->link(
              text = 'Source_Code' target = '_blank' href = view->hlp_get_source_code_url(  )
     ).

    data(page) = page1->dynamic_page( headerexpanded = abap_true headerpinned = abap_true ).

    data(header_title) = page->title( ns = 'f'  )->get( )->dynamic_page_title( ).
    header_title->heading( ns = 'f' )->hbox( )->title( `Search Field` ).
    header_title->expanded_content( 'f' ).
    header_title->snapped_content( ns = 'f' ).

    data(lo_box) = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween` )->flex_box( alignItems = `Start` ).

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

    data(cont) = page->content( ns = 'f' ).

    data(tab) = cont->ui_table( rows = client->_bind( val = mt_table )
                                editable = abap_false
                                alternaterowcolors = abap_true
                                enablegrouping = abap_false
                                fixedcolumncount = '1'
                                selectionmode = 'None'
                                sort = client->_event( 'SORT' )
                                filter = client->_event( 'FILTER' )
                                customFilter =  client->_event( 'CUSTOMFILTER' ) ).
    tab->ui_extension( )->overflow_toolbar( )->title( text = 'Products' ).
    data(lo_columns) = tab->ui_columns( ).
    lo_columns->ui_column( width = '4rem' )->checkbox( selected = client->_bind_edit( lv_selkz ) enabled = abap_true select = client->_event( val = `SELKZ` ) )->ui_template( )->checkbox( selected = `{SELKZ}`  ).
    lo_columns->ui_column( width = '5rem' sortproperty = 'ROW_ID'
                                          filterproperty = 'ROW_ID' )->text( text = `Index` )->ui_template( )->text(   text = `{ROW_ID}` ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'PRODUCT'
                           filterproperty = 'PRODUCT' )->text( text = `Product` )->ui_template( )->input( value = `{PRODUCT}` editable = abap_false ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'CREATE_DATE' filterproperty = 'CREATE_DATE' )->text( text = `Date` )->ui_template( )->text(   text = `{CREATE_DATE}` ).
    lo_columns->Ui_column( width = '11rem' sortproperty = 'CREATE_BY' filterproperty = 'CREATE_BY')->text( text = `Name` )->ui_template( )->text( text = `{CREATE_BY}` ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'STORAGE_LOCATION'  filterproperty = 'STORAGE_LOCATION' )->text( text = `Location` )->ui_template( )->text( text = `{STORAGE_LOCATION}`).
    lo_columns->Ui_column( width = '11rem' sortproperty = 'QUANTITY' filterproperty = 'QUANTITY' )->text( text = `Quantity` )->ui_template( )->text( text = `{QUANTITY}`).
    lo_columns->Ui_column( width = '6rem' sortproperty = 'MEINS' filterproperty = 'MEINS' )->text( text = `Unit` )->ui_template( )->text( text = `{MEINS}`).
    lo_columns->Ui_column( width = '11rem' sortproperty = 'PRICE' filterproperty = 'PRICE' )->text( text = `Price` )->ui_template( )->currency( value = `{PRICE}` currency = `{WAERS}` ).
    lo_columns->Ui_column( width = '4rem' )->text( )->ui_template( )->overflow_toolbar( )->overflow_toolbar_button(
    icon = 'sap-icon://edit' type = 'Transparent' press = client->_event(
    val = `ROWEDIT` t_arg = value #( ( `${ROW_ID}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  endmethod.


  METHOD Z2UI5_SET_DATA.

    mt_table = VALUE #(
        ( selkz = abap_false row_id = '1' product = 'table' create_date = `01.01.2023` create_by = `Olaf` storage_location = `AREA_001` quantity = 400  meins = 'ST' price = '1000.50' waers = 'EUR' )
        ( selkz = abap_false row_id = '2' product = 'chair' create_date = `01.01.2022` create_by = `Karlo` storage_location = `AREA_001` quantity = 123   meins = 'ST' price = '2000.55' waers = 'USD')
        ( selkz = abap_false row_id = '3' product = 'sofa' create_date = `01.05.2021` create_by = `Elin` storage_location = `AREA_002` quantity = 700   meins = 'ST' price = '3000.11' waers = 'CNY' )
        ( selkz = abap_false row_id = '4' product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_002` quantity = 200  meins = 'ST' price = '4000.88' waers = 'USD' )
        ( selkz = abap_false row_id = '5' product = 'printer' create_date = `01.01.2023` create_by = `Renate` storage_location = `AREA_003` quantity = 90   meins = 'ST' price = '5000.47' waers = 'EUR')
        ( selkz = abap_false row_id = '6' product = 'table2' create_date = `01.01.2023` create_by = `Angela` storage_location = `AREA_003` quantity = 110  meins = 'ST' price = '6000.33' waers = 'GBP' )
    ).


  ENDMETHOD.


  METHOD Z2UI5_SET_SEARCH.

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
