CLASS Z2UI5_CL_DEMO_APP_100 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app .

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

    DATA mt_table TYPE ty_t_table .
    DATA lv_selkz TYPE abap_bool .

  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS Z2UI5_set_data.
    METHODS Z2UI5_view_display.
    METHODS Z2UI5_view_vm_popup.
    METHODS Z2UI5_on_event.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_100 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      Z2UI5_set_data( ).

      Z2UI5_view_display( ).
      RETURN.
    ENDIF.

    Z2UI5_on_event( ).

  ENDMETHOD.


  METHOD Z2UI5_on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_set_data.

    mt_table = VALUE #(
        ( selkz = abap_false row_id = '1' product = 'table'    create_date = `01.01.2023` create_by = `Olaf` storage_location = `AREA_001` quantity = 400  meins = 'ST' price = '1000.50' waers = 'EUR' process = '10'  process_state = 'None' )
        ( selkz = abap_false row_id = '2' product = 'chair'    create_date = `01.01.2022` create_by = `Karlo` storage_location = `AREA_001` quantity = 123   meins = 'ST' price = '2000.55' waers = 'USD' process = '20' process_state = 'Warning' )
        ( selkz = abap_false row_id = '3' product = 'sofa'     create_date = `01.05.2021` create_by = `Elin` storage_location = `AREA_002` quantity = 700   meins = 'ST' price = '3000.11' waers = 'CNY' process = '30' process_state = 'Success' )
        ( selkz = abap_false row_id = '4' product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_002` quantity = 200  meins = 'ST' price = '4000.88' waers = 'USD' process = '40' process_state = 'Information' )
        ( selkz = abap_false row_id = '5' product = 'printer'  create_date = `01.01.2023` create_by = `Renate` storage_location = `AREA_003` quantity = 90   meins = 'ST' price = '5000.47' waers = 'EUR' process = '70' process_state = 'Warning' )
        ( selkz = abap_false row_id = '6' product = 'table2'   create_date = `01.01.2023` create_by = `Angela` storage_location = `AREA_003` quantity = 110  meins = 'ST' price = '6000.33' waers = 'GBP' process = '90'  process_state = 'Error' )
    ).


  ENDMETHOD.


  METHOD Z2UI5_view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = 'abap2UI5 - List'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true
            )->header_content(
                )->link(
                    text = 'Source_Code'  target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
            )->get_parent( ).


    DATA(tab) = page->ui_table( rows = client->_bind( val = mt_table )
                                    id = `persoTable`
                                    editable = abap_false
                                    alternaterowcolors = abap_true
                                    rowactioncount = '2'
                                    enablegrouping = abap_false
                                    fixedcolumncount = '1'
                                    selectionmode = 'None'
                                    sort = client->_event( 'SORT' )
                                    filter = client->_event( 'FILTER' )
                                    customfilter =  client->_event( 'CUSTOMFILTER' ) ).
    tab->ui_extension( )->overflow_toolbar( )->title( text = 'Products' )->toolbar_spacer(
      )->variant_management( showExecuteOnSelection = abap_true
        )->variant_items(
          )->variant_item( key = `{KEY}` text = `{TEXT}` executeonselection = abap_true )->get_parent( ).
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

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_view_vm_popup.

    DATA(popup_sort) = Z2UI5_cl_xml_view=>factory_popup( ).
    client->popup_display( popup_sort->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
