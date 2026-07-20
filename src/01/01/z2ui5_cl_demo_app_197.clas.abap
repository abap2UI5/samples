CLASS z2ui5_cl_demo_app_197 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        selkz            TYPE abap_bool,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
      END OF ty_s_tab.
    TYPES
      ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY.

    DATA mt_table TYPE ty_t_table.
    DATA mt_table_full TYPE ty_t_table.
    DATA mt_table_products TYPE ty_t_table.
    DATA mv_check_popover TYPE abap_bool.
    DATA mv_product TYPE string.

    METHODS set_data.
    METHODS view_display.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_197 IMPLEMENTATION.

  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE string_table.
    DATA facet TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_columns TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_cells TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( )->shell( ).

    
    page = view->page( id = `page_main`
            title               = `abap2UI5 - List Report Features`
            navbuttonpress      = client->_event_nav_app_leave( )
            shownavbutton       = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `This sample shows a list-report table with a FacetFilter: selecting products ` &&
                   `filters the rows, and Reset restores the full list.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    
    CLEAR temp1.
    INSERT `$event.mParameters.selectedItems` INTO TABLE temp1.
    
    facet = page->facet_filter( id                  = `idFacetFilter`
                                      type                = `Light`
                                      showpersonalization = abap_true
                                      showreset           = abap_true
                                      reset               = client->_event( `RESET` )
      )->facet_filter_list( title     = `Products`
                            mode      = `MultiSelect`
                            items     = client->_bind( mt_table_products )
                            listclose = client->_event( val   = `FILTER`
                                                        t_arg = temp1 )
        )->facet_filter_item( text = `{PRODUCT}` ).

    
    tab = page->table( id    = `tab`
                             items = client->_bind( val = mt_table ) ).

    
    lo_columns = tab->columns( ).
    lo_columns->column( )->text( `Product` ).
    lo_columns->column( )->text( `Date` ).
    lo_columns->column( )->text( `Name` ).
    lo_columns->column( )->text( `Location` ).
    lo_columns->column( )->text( `Quantity` ).

    
    lo_cells = tab->items( )->column_list_item( ).
    lo_cells->text( `{PRODUCT}` ).
    lo_cells->text( `{CREATE_DATE}` ).
    lo_cells->text( `{CREATE_BY}` ).
    lo_cells->text( `{STORAGE_LOCATION}` ).
    lo_cells->text( `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    DATA lt_range TYPE RANGE OF string.
        DATA lt_arg TYPE string_table.
        DATA lv_json LIKE LINE OF lt_arg.
        DATA temp1 LIKE LINE OF lt_arg.
        DATA temp2 LIKE sy-tabix.
            DATA lo_json TYPE REF TO z2ui5_cl_ajson.
            DATA l_members TYPE string_table.
            DATA l_member LIKE LINE OF l_members.
              DATA lv_val TYPE string.
              DATA temp3 LIKE LINE OF lt_range.
        DATA ls_tab LIKE LINE OF mt_table.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      view_display( ).
      set_data( ).
      RETURN.
    ENDIF.

    CASE client->get( )-event.
      WHEN `RESET`.
        mt_table = mt_table_full.
        client->view_model_update( ).
      WHEN `FILTER`.

        
        lt_arg = client->get( )-t_event_arg.
        
        
        
        temp2 = sy-tabix.
        READ TABLE lt_arg INDEX 1 INTO temp1.
        sy-tabix = temp2.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        lv_json = temp1.
        TRY.
            
            lo_json = z2ui5_cl_ajson=>parse( lv_json ).

            
            l_members = lo_json->members( `/` ).

            
            LOOP AT l_members INTO l_member.
              
              lv_val = lo_json->get( `/` && l_member && `/mProperties/text` ).

              
              CLEAR temp3.
              temp3-sign = `I`.
              temp3-option = `EQ`.
              temp3-low = lv_val.
              APPEND temp3 TO lt_range.

            ENDLOOP.

          CATCH cx_root.
        ENDTRY.

        mt_table = mt_table_full.

        
        LOOP AT mt_table INTO ls_tab.
          IF ls_tab-product NOT IN lt_range.
            DELETE mt_table.
          ENDIF.
        ENDLOOP.

        client->view_model_update( ).
    ENDCASE.

  ENDMETHOD.


  METHOD set_data.

    DATA temp4 TYPE z2ui5_cl_demo_app_197=>ty_t_table.
    DATA temp5 LIKE LINE OF temp4.
    CLEAR temp4.
    
    temp5-product = `table`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Peter`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 400.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `chair`.
    temp5-create_date = `01.01.2022`.
    temp5-create_by = `James`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 123.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `sofa`.
    temp5-create_date = `01.05.2021`.
    temp5-create_by = `Simone`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 700.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `computer`.
    temp5-create_date = `27.01.2023`.
    temp5-create_by = `Theo`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 200.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `printer`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Hannah`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 90.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table2`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Julia`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 110.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Peter`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 400.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `chair`.
    temp5-create_date = `01.01.2022`.
    temp5-create_by = `James`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 123.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `sofa`.
    temp5-create_date = `01.05.2021`.
    temp5-create_by = `Simone`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 700.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `computer`.
    temp5-create_date = `27.01.2023`.
    temp5-create_by = `Theo`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 200.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `printer`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Hannah`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 90.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table2`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Julia`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 110.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Peter`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 400.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `chair`.
    temp5-create_date = `01.01.2022`.
    temp5-create_by = `James`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 123.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `sofa`.
    temp5-create_date = `01.05.2021`.
    temp5-create_by = `Simone`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 700.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `computer`.
    temp5-create_date = `27.01.2023`.
    temp5-create_by = `Theo`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 200.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `printer`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Hannah`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 90.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table2`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Julia`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 110.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Peter`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 400.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `chair`.
    temp5-create_date = `01.01.2022`.
    temp5-create_by = `James`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 123.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `sofa`.
    temp5-create_date = `01.05.2021`.
    temp5-create_by = `Simone`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 700.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `computer`.
    temp5-create_date = `27.01.2023`.
    temp5-create_by = `Theo`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 200.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `printer`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Hannah`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 90.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table2`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Julia`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 110.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Peter`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 400.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `chair`.
    temp5-create_date = `01.01.2022`.
    temp5-create_by = `James`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 123.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `sofa`.
    temp5-create_date = `01.05.2021`.
    temp5-create_by = `Simone`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 700.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `computer`.
    temp5-create_date = `27.01.2023`.
    temp5-create_by = `Theo`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 200.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `printer`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Hannah`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 90.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table2`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Julia`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 110.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Peter`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 400.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `chair`.
    temp5-create_date = `01.01.2022`.
    temp5-create_by = `James`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 123.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `sofa`.
    temp5-create_date = `01.05.2021`.
    temp5-create_by = `Simone`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 700.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `computer`.
    temp5-create_date = `27.01.2023`.
    temp5-create_by = `Theo`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 200.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `printer`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Hannah`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 90.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table2`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Julia`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 110.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Peter`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 400.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `chair`.
    temp5-create_date = `01.01.2022`.
    temp5-create_by = `James`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 123.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `sofa`.
    temp5-create_date = `01.05.2021`.
    temp5-create_by = `Simone`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 700.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `computer`.
    temp5-create_date = `27.01.2023`.
    temp5-create_by = `Theo`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 200.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `printer`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Hannah`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 90.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table2`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Julia`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 110.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Peter`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 400.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `chair`.
    temp5-create_date = `01.01.2022`.
    temp5-create_by = `James`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 123.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `sofa`.
    temp5-create_date = `01.05.2021`.
    temp5-create_by = `Simone`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 700.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `computer`.
    temp5-create_date = `27.01.2023`.
    temp5-create_by = `Theo`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 200.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `printer`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Hannah`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 90.
    INSERT temp5 INTO TABLE temp4.
    temp5-product = `table2`.
    temp5-create_date = `01.01.2023`.
    temp5-create_by = `Julia`.
    temp5-storage_location = `AREA_001`.
    temp5-quantity = 110.
    INSERT temp5 INTO TABLE temp4.
    mt_table = temp4.

    SORT mt_table BY product.
    mt_table_full = mt_table.

    mt_table_products = mt_table.

    DELETE ADJACENT DUPLICATES FROM mt_table_products COMPARING product.

  ENDMETHOD.

ENDCLASS.
