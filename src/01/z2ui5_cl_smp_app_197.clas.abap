" @keywords facetfilter filter object marshalling selected items
" @summary Passes whole control objects to the backend in t_arg: a FacetFilter's selected items arrive as data instead of being reconstructed by hand.
" @docs https://abap2ui5.github.io/docs/cookbook/event_navigation/backend
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
    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY.

    DATA mt_table TYPE ty_t_table.
    DATA mt_table_full TYPE ty_t_table.
    DATA mt_table_products TYPE ty_t_table.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event_filter.
    METHODS view_display.
    METHODS data_read.
    METHODS json_get_values
      IMPORTING
        json          TYPE string
        name          TYPE string
      RETURNING
        VALUE(result) TYPE string_table.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_197 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( `RESET` ) IS NOT INITIAL.
      mt_table = mt_table_full.
    ELSEIF client->check_on_event( `FILTER` ) IS NOT INITIAL.
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

    DATA temp1 TYPE string_table.
    DATA lv_key LIKE LINE OF temp1.
      DATA temp2 LIKE LINE OF t_range.
    temp1 = json_get_values( json = client->get_event_arg( ) name = `key` ).
    
    LOOP AT temp1 INTO lv_key.
      
      CLEAR temp2.
      temp2-sign = `I`.
      temp2-option = `EQ`.
      temp2-low = lv_key.
      APPEND temp2 TO t_range.
    ENDLOOP.

    " an empty selection is no filter at all - the list closed with every
    " item unchecked, which must show all rows again, not none of them
    mt_table = mt_table_full.

    IF t_range IS NOT INITIAL.
      DELETE mt_table WHERE product NOT IN t_range.
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_columns TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_cells TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->ele( `Shell` ).

    
    page = view->ele( `Page`
        )->a( n = `title`          v = `abap2UI5 - Event - Control Objects in t_arg (FacetFilter)`
        )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
        )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
        )->a( n = `id`             v = `page_main` ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample shows a list-report table with a FacetFilter: selecting products ` &&
                   `filters the rows, and Reset restores the full list. The listClose event sends ` &&
                   `the selected FacetFilterItem controls as event arguments - the framework ` &&
                   `marshals each one into a JSON object of its properties.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    CLEAR temp3.
    INSERT `$event.mParameters.selectedItems` INTO TABLE temp3.
    page->ele( `FacetFilter`
        )->a( n = `id`                  v = `idFacetFilter`
        )->a( n = `showPersonalization` b = abap_true
        )->a( n = `showReset`           b = abap_true
        )->a( n = `type`                v = `Light`
        )->a( n = `reset`               v = client->_event( `RESET` )
        )->ele( `FacetFilterList`
            )->a( n = `mode`      v = `MultiSelect`
            )->a( n = `title`     v = `Products`
            )->a( n = `listClose` v = client->_event( val   = `FILTER`
                                                          t_arg = temp3 )
            )->a( n = `items`     v = client->_bind( mt_table_products )
            )->ele( `FacetFilterItem`
                )->a( n = `key`  v = `{PRODUCT}`
                )->a( n = `text` v = `{PRODUCT}` ).

    
    tab = page->ele( `Table`
        )->a( n = `items` v = client->_bind( val = mt_table )
        )->a( n = `id`    v = `tab` ).

    
    lo_columns = tab->ele( `columns` ).
    lo_columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Product` ).
    lo_columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Date` ).
    lo_columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Name` ).
    lo_columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Location` ).
    lo_columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Quantity` ).

    
    lo_cells = tab->ele( `items`
        )->ele( `ColumnListItem` ).
    lo_cells->tag( `Text`
        )->a( n = `text` v = `{PRODUCT}` ).
    lo_cells->tag( `Text`
        )->a( n = `text` v = `{CREATE_DATE}` ).
    lo_cells->tag( `Text`
        )->a( n = `text` v = `{CREATE_BY}` ).
    lo_cells->tag( `Text`
        )->a( n = `text` v = `{STORAGE_LOCATION}` ).
    lo_cells->tag( `Text`
        )->a( n = `text` v = `{QUANTITY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD json_get_values.

    " A minimal reader for one string property of a JSON array of objects:
    " walk every `"<name>":"` and take what stands up to the next quote. That
    " is all this payload needs - a flat projection of the selected controls,
    " written by the framework and never nested. An app parsing arbitrary JSON
    " wants a real parser instead.
    DATA lv_marker TYPE string.
    DATA lv_rest LIKE json.
      DATA lv_off TYPE i.
    lv_marker = |"{ name }":"|.
    
    lv_rest = json.

    DO.
      
      lv_off = find( val  = lv_rest
                           sub  = lv_marker
                           case = abap_false ).
      IF lv_off < 0.
        EXIT.
      ENDIF.

      lv_rest = substring( val = lv_rest
                           off = lv_off + strlen( lv_marker ) ).
      INSERT substring_before( val = lv_rest
                               sub = `"` ) INTO TABLE result.
    ENDDO.

  ENDMETHOD.


  METHOD data_read.

    DATA temp5 TYPE z2ui5_cl_smp_app_197=>ty_t_table.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp5.
    
    temp6-product = `table`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `chair`.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `sofa`.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `computer`.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `printer`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table2`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `chair`.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `sofa`.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `computer`.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `printer`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table2`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `chair`.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `sofa`.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `computer`.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `printer`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table2`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `chair`.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `sofa`.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `computer`.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `printer`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table2`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `chair`.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `sofa`.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `computer`.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `printer`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table2`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `chair`.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `sofa`.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `computer`.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `printer`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table2`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `chair`.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `sofa`.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `computer`.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `printer`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table2`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Peter`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `chair`.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `James`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `sofa`.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Simone`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 700.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `computer`.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 200.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `printer`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Hannah`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 90.
    INSERT temp6 INTO TABLE temp5.
    temp6-product = `table2`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Julia`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 110.
    INSERT temp6 INTO TABLE temp5.
    mt_table = temp5.

    SORT mt_table BY product.
    mt_table_full = mt_table.

    mt_table_products = mt_table.
    DELETE ADJACENT DUPLICATES FROM mt_table_products COMPARING product.

  ENDMETHOD.

ENDCLASS.
