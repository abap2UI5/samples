CLASS z2ui5_cl_smp_app_197 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
      END OF ty_s_tab.
    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    DATA mt_table TYPE ty_t_table.
    DATA mt_table_full TYPE ty_t_table.
    DATA mt_table_products TYPE ty_t_table.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event_filter.
    METHODS view_display.
    METHODS data_read.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_197 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( `RESET` ).
      mt_table = mt_table_full.
    ELSEIF client->check_on_event( `FILTER` ).
      on_event_filter( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    data_read( ).
    view_display( ).

  ENDMETHOD.


  METHOD on_event_filter.

    " listClose hands over selectedItems - an ARRAY OF CONTROLS
    " (sap.m.FacetFilterItem). The framework marshals every control-valued
    " event argument into a flat JSON object carrying its ID plus the values
    " of its metadata properties, so a property is read as /<index>/<property>
    " - there is no mProperties level in the payload.
    DATA t_range TYPE RANGE OF string.

    TRY.
        DATA(json) = z2ui5_cl_ajson=>parse( client->get_event_arg( ) ).
        DATA(t_members) = json->members( `/` ).

        LOOP AT t_members INTO DATA(member).
          APPEND VALUE #( sign   = `I`
                          option = `EQ`
                          low    = json->get( |/{ member }/key| ) ) TO t_range.
        ENDLOOP.

      CATCH cx_root.
    ENDTRY.

    " an empty selection is no filter at all - the list closed with every
    " item unchecked, which must show all rows again, not none of them
    mt_table = mt_table_full.

    IF t_range IS NOT INITIAL.
      DELETE mt_table WHERE product NOT IN t_range.
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( )->shell( ).

    DATA(page) = view->page( id = `page_main`
            title               = `abap2UI5 - List Report Features`
            navbuttonpress      = client->_event_nav_app_leave( )
            shownavbutton       = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `This sample shows a list-report table with a FacetFilter: selecting products ` &&
                   `filters the rows, and Reset restores the full list. The listClose event sends ` &&
                   `the selected FacetFilterItem controls as event arguments - the framework ` &&
                   `marshals each one into a JSON object of its properties.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->facet_filter( id                  = `idFacetFilter`
                        type                = `Light`
                        showpersonalization = abap_true
                        showreset           = abap_true
                        reset               = client->_event( `RESET` )
      )->facet_filter_list( title     = `Products`
                            mode      = `MultiSelect`
                            items     = client->_bind( mt_table_products )
                            listclose = client->_event( val   = `FILTER`
                                                        t_arg = VALUE #( ( `$event.mParameters.selectedItems` ) ) )
        )->facet_filter_item(
            key  = `{PRODUCT}`
            text = `{PRODUCT}` ).

    DATA(tab) = page->table( id    = `tab`
                             items = client->_bind( val = mt_table ) ).

    DATA(lo_columns) = tab->columns( ).
    lo_columns->column( )->text( `Product` ).
    lo_columns->column( )->text( `Date` ).
    lo_columns->column( )->text( `Name` ).
    lo_columns->column( )->text( `Location` ).
    lo_columns->column( )->text( `Quantity` ).

    DATA(lo_cells) = tab->items( )->column_list_item( ).
    lo_cells->text( `{PRODUCT}` ).
    lo_cells->text( `{CREATE_DATE}` ).
    lo_cells->text( `{CREATE_BY}` ).
    lo_cells->text( `{STORAGE_LOCATION}` ).
    lo_cells->text( `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD data_read.

    mt_table = VALUE #(
        ( product = `table` create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `chair` create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa` create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = `printer` create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2` create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
        ( product = `table` create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `chair` create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa` create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = `printer` create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2` create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
        ( product = `table` create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `chair` create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa` create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = `printer` create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2` create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
        ( product = `table` create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `chair` create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa` create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = `printer` create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2` create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
        ( product = `table` create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `chair` create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa` create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = `printer` create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2` create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
        ( product = `table` create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `chair` create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa` create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = `printer` create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2` create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
        ( product = `table` create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `chair` create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa` create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = `printer` create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2` create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
        ( product = `table` create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `chair` create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa` create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = `printer` create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2` create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 ) ).

    SORT mt_table BY product.
    mt_table_full = mt_table.

    mt_table_products = mt_table.
    DELETE ADJACENT DUPLICATES FROM mt_table_products COMPARING product.

  ENDMETHOD.

ENDCLASS.
