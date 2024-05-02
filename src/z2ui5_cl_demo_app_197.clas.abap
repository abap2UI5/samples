CLASS z2ui5_cl_demo_app_197 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_s_tab,
        selkz            TYPE abap_bool,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
      END OF ty_s_tab .
    TYPES:
      ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY .

    DATA mt_table TYPE ty_t_table .
    DATA mt_table_products TYPE ty_t_table .
    DATA check_initialized TYPE abap_bool .
    DATA client TYPE REF TO z2ui5_if_client .
    DATA mv_check_popover TYPE abap_bool .
    DATA mv_product TYPE string .

    METHODS z2ui5_set_data .
    METHODS z2ui5_display_view .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_197 IMPLEMENTATION.


  METHOD z2ui5_display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->page( id = `page_main`
            title          = 'abap2UI5 - List Report Features'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(facet) = page->facet_filter( id = `idFacetFilter` type = `Light` showpersonalization = abap_true showreset = abap_true "lists = client->_bind( mt_table_products )
      )->facet_filter_list( title = `Products` mode = `MultiSelect` items = client->_bind( mt_table_products ) listclose = client->_event( val = `FILTER`
*                                                                           t_arg = VALUE #( ( `${$parameters>/selectedAll}` ) ) )
                                                                           t_arg = VALUE #( ( `$event}` ) ) )
        )->facet_filter_item( text = `{PRODUCT}` ).

    DATA(tab) = page->table( id = `tab` items = client->_bind_edit( val = mt_table ) ).

    DATA(lo_columns) = tab->columns( ).
    lo_columns->column( )->text( text = `Product` ).
    lo_columns->column( )->text( text = `Date` ).
    lo_columns->column( )->text( text = `Name` ).
    lo_columns->column( )->text( text = `Location` ).
    lo_columns->column( )->text( text = `Quantity` ).

    DATA(lo_cells) = tab->items(  )->column_list_item( ).
    lo_cells->link( id = `link` text = '{PRODUCT}' press = client->_event( val = `POPOVER_DETAIL` ) ).
    lo_cells->text( `{CREATE_DATE}` ).
    lo_cells->text( `{CREATE_BY}` ).
    lo_cells->text( `{STORAGE_LOCATION}` ).
    lo_cells->text( `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_display_view( ).
      z2ui5_set_data( ).
      RETURN.
    ENDIF.

    CASE client->get( )-event.
      WHEN 'FILTER'.

        DATA(lt_arg) = client->get( )-t_event_arg.
        DATA(lt3) = lt_arg.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_set_data.

    mt_table = VALUE #(
        ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
        ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
        ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
        ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
        ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
        ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
        ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
        ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
    ).

    mt_table_products = mt_table.

    SORT mt_table_products BY product.

    DELETE ADJACENT DUPLICATES FROM mt_table_products COMPARING product.

  ENDMETHOD.
ENDCLASS.
