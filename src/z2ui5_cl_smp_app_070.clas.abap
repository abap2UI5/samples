" @keywords grid alv dynamicpage column row action currency search sort filter
" @summary The full sap.ui.table example: a DynamicPage with search, sort, filter, currency columns and row actions - the closest thing here to a finished ALV.
" @docs https://abap2ui5.github.io/docs/cookbook/model/tables https://abap2ui5.github.io/docs/tutorials/walkthrough/step-9 https://abap2ui5.github.io/docs/tutorials/walkthrough/step-10
CLASS z2ui5_cl_smp_app_070 DEFINITION PUBLIC.

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
      END OF ty_s_tab.

    DATA mv_search_value TYPE string.
    DATA mt_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY.
    DATA lv_selkz TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.
    METHODS set_search.
    METHODS set_data.
    METHODS set_sort.
    METHODS set_filter.

    METHODS set_selkz
      IMPORTING
        iv_selkz TYPE abap_bool.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_070 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client     = client.
    IF client->check_on_init( ) IS NOT INITIAL.

      set_data( ).
      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `BUTTON_SEARCH` OR `BUTTON_START`.
        client->message_toast_display( `Search Entries` ).
        set_data( ).
        set_search( ).
      WHEN `SORT`.
        set_sort( ).
      WHEN `FILTER`.
        set_filter( ).
      WHEN `SELKZ`.
        client->message_toast_display( |'Event SELKZ' { lv_selkz } | ).
        set_selkz( lv_selkz ).
      WHEN `ROW_ACTION_ITEM_NAVIGATION`.
        client->message_toast_display( |Event ROW_ACTION_ITEM_NAVIGATION Row Index { client->get_event_arg( ) } | ).
      WHEN `ROW_ACTION_ITEM_EDIT`.
        client->message_toast_display( |Event ROW_ACTION_ITEM_EDIT Row Index { client->get_event_arg( ) } | ).
    ENDCASE.

  ENDMETHOD.


  METHOD set_selkz.

    DATA temp1 LIKE LINE OF mt_table.
    DATA lr_row LIKE REF TO temp1.
    LOOP AT mt_table REFERENCE INTO lr_row.
      lr_row->selkz = iv_selkz.
    ENDLOOP.

  ENDMETHOD.


  METHOD set_sort.

    " the sort event carries the column's sortProperty and the requested
    " order - the client sorts its binding too, so both agree, and the
    " backend order is the one the next model push would restore
    DATA property TYPE string.
    DATA sort_order TYPE string.
    property   = client->get_event_arg( 1 ).
    
    sort_order = client->get_event_arg( 2 ).

    IF sort_order = `Descending`.
      SORT mt_table BY (property) DESCENDING.
    ELSE.
      SORT mt_table BY (property) ASCENDING.
    ENDIF.
    client->message_toast_display( |Event SORT { property } { sort_order }| ).

  ENDMETHOD.


  METHOD set_filter.

    " the filter event carries the column's filterProperty and the typed
    " value: a contains-filter over that one component, on the full data
    DATA property TYPE string.
    DATA value TYPE string.
    DATA lt_all LIKE mt_table.
    DATA temp2 LIKE mt_table.
    DATA temp3 LIKE LINE OF lt_all.
    DATA lr_row LIKE REF TO temp3.
      FIELD-SYMBOLS <field> TYPE any.
    property = client->get_event_arg( 1 ).
    
    value    = to_upper( client->get_event_arg( 2 ) ).

    set_data( ).
    set_search( ).

    IF value IS INITIAL.
      client->message_toast_display( |Event FILTER { property } cleared| ).
      RETURN.
    ENDIF.

    
    lt_all = mt_table.
    
    CLEAR temp2.
    mt_table = temp2.

    
    
    LOOP AT lt_all REFERENCE INTO lr_row.
      
      ASSIGN COMPONENT property OF STRUCTURE lr_row->* TO <field>.

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF to_upper( |{ <field> }| ) CS value.
        INSERT lr_row->* INTO TABLE mt_table.
      ENDIF.
    ENDLOOP.
    client->message_toast_display( |Event FILTER { property } { value }| ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page1 TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA header_title TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_box TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA cont TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp4 TYPE string_table.
    DATA temp1 TYPE string_table.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_columns TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:f`      v = `sap.f`
            )->a( n = `xmlns:table`  v = `sap.ui.table`
            )->a( n = `xmlns:u`      v = `sap.ui.unified` ).

    
    page1 = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Grid Table - Full Example with sap.ui.table`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `class`          v = `sapUiContentPadding`
            )->a( n = `id`             v = `page_main` ).

    page1->tag( `MessageStrip`
        )->a( n = `text`     v = `A full sap.ui.table.Table inside a DynamicPage: fixed column, row-action buttons, ` &&
                   `progress-indicator and currency cells, plus search, sort and filter events that are answered ` &&
                   `in the backend: the search rebuilds the rows, the column sort and the column filter sort and ` &&
                   `filter the internal table with the property the event carries.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    page = page1->ele( n = `DynamicPage` ns = `f`
        )->a( n = `headerExpanded` b = abap_true ).

    
    header_title = page->ele( n = `title` ns = `f`
        )->ele( n = `DynamicPageTitle` ns = `f` ).
    header_title->ele( n = `heading` ns = `f`
        )->ele( `HBox`
            )->tag( `Title`
                )->a( n = `text` v = `Search Field` ).
    header_title->ele( n = `expandedContent` ns = `f` ).
    header_title->ele( n = `snappedContent` ns = `f` ).

    " ns = `f` like every other DynamicPage aggregation here: without it the
    " tag renders as <header xmlns="sap.m"/>, and UI5 looks for a DEFAULT
    " aggregation on sap.f.DynamicPage - which has none - so the view dies with
    " "Cannot add direct child without default aggregation defined"
    
    lo_box = page->ele( n = `header` ns = `f`
        )->ele( n = `DynamicPageHeader` ns = `f`
            )->a( n = `pinnable` b = abap_true
            )->ele( `FlexBox`
                )->a( n = `alignItems`     v = `Start`
                )->a( n = `justifyContent` v = `SpaceBetween`
                )->ele( `FlexBox`
                    )->a( n = `alignItems` v = `Start` ).

    lo_box->ele( `VBox`
        )->tag( `Text`
            )->a( n = `text` v = `Search`
        )->tag( `SearchField`
            )->a( n = `width`       v = `17.5rem`
            )->a( n = `search`      v = client->_event( `BUTTON_SEARCH` )
            )->a( n = `value`       v = client->_bind( mv_search_value )
            )->a( n = `id`          v = `SEARCH`
            )->a( n = `placeholder` v = `Search products` ).

    lo_box->end(
        )->ele( `HBox`
            )->a( n = `justifyContent` v = `End`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `BUTTON_START` )
                )->a( n = `text`  v = `Go`
                )->a( n = `type`  v = `Emphasized` ).

    
    cont = page->ele( n = `content` ns = `f` ).

    
    CLEAR temp4.
    INSERT `${$parameters>/column}.getFilterProperty()` INTO TABLE temp4.
    INSERT `${$parameters>/value}` INTO TABLE temp4.
    
    CLEAR temp1.
    INSERT `${$parameters>/column}.getSortProperty()` INTO TABLE temp1.
    INSERT `${$parameters>/sortOrder}` INTO TABLE temp1.
    
    tab = cont->ele( n = `Table` ns = `table`
        )->a( n = `rows`               v = client->_bind( mt_table )
        )->a( n = `alternateRowColors` b = abap_true
        )->a( n = `fixedColumnCount`   v = `1`
        )->a( n = `rowActionCount`     v = `2`
        )->a( n = `selectionMode`      v = `None`
        )->a( n = `filter`             v = client->_event( val   = `FILTER`
                                                            t_arg = temp4 )
        )->a( n = `sort`               v = client->_event( val = `SORT`
                                                            t_arg = temp1 ) ).
    tab->ele( n = `extension` ns = `table`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Products` ).
    
    lo_columns = tab->ele( n = `columns` ns = `table` ).
    lo_columns->ele( n = `Column` ns = `table`
        )->a( n = `width` v = `4rem`
        )->tag( `CheckBox`
            )->a( n = `selected` v = client->_bind( lv_selkz )
            )->a( n = `enabled`  b = abap_true
            )->a( n = `select`   v = client->_event( `SELKZ` )
        )->ele( n = `template` ns = `table`
            )->tag( `CheckBox`
                )->a( n = `selected` v = `{SELKZ}` ).
    lo_columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `5rem`
        )->a( n = `sortProperty`   v = `ROW_ID`
        )->a( n = `filterProperty` v = `ROW_ID`
        )->tag( `Text`
            )->a( n = `text` v = `Index`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{ROW_ID}` ).
    lo_columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `11rem`
        )->a( n = `sortProperty`   v = `PROCESS`
        )->a( n = `filterProperty` v = `PROCESS`
        )->tag( `Text`
            )->a( n = `text` v = `Process Indicator`
        )->ele( n = `template` ns = `table`
            )->tag( `ProgressIndicator`
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `percentValue` v = `{PROCESS}`
                )->a( n = `displayValue` v = `{PROCESS} %`
                )->a( n = `showValue`    v = `true`
                )->a( n = `state`        v = `{PROCESS_STATE}` ).
    lo_columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `11rem`
        )->a( n = `sortProperty`   v = `PRODUCT`
        )->a( n = `filterProperty` v = `PRODUCT`
        )->tag( `Text`
            )->a( n = `text` v = `Product`
        )->ele( n = `template` ns = `table`
            )->tag( `Input`
                )->a( n = `editable` b = abap_false
                )->a( n = `value`    v = `{PRODUCT}` ).
    lo_columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `11rem`
        )->a( n = `sortProperty`   v = `CREATE_DATE`
        )->a( n = `filterProperty` v = `CREATE_DATE`
        )->tag( `Text`
            )->a( n = `text` v = `Date`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{CREATE_DATE}` ).
    lo_columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `11rem`
        )->a( n = `sortProperty`   v = `CREATE_BY`
        )->a( n = `filterProperty` v = `CREATE_BY`
        )->tag( `Text`
            )->a( n = `text` v = `Name`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{CREATE_BY}` ).
    lo_columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `11rem`
        )->a( n = `sortProperty`   v = `STORAGE_LOCATION`
        )->a( n = `filterProperty` v = `STORAGE_LOCATION`
        )->tag( `Text`
            )->a( n = `text` v = `Location`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{STORAGE_LOCATION}` ).
    lo_columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `11rem`
        )->a( n = `sortProperty`   v = `QUANTITY`
        )->a( n = `filterProperty` v = `QUANTITY`
        )->tag( `Text`
            )->a( n = `text` v = `Quantity`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{QUANTITY}` ).
    lo_columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `6rem`
        )->a( n = `sortProperty`   v = `MEINS`
        )->a( n = `filterProperty` v = `MEINS`
        )->tag( `Text`
            )->a( n = `text` v = `Unit`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{MEINS}` ).
    lo_columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `11rem`
        )->a( n = `sortProperty`   v = `PRICE`
        )->a( n = `filterProperty` v = `PRICE`
        )->tag( `Text`
            )->a( n = `text` v = `Price`
        )->ele( n = `template` ns = `table`
            )->ele( n = `Currency` ns = `u`
                )->a( n = `value`    v = `{PRICE}`
                )->a( n = `currency` v = `{WAERS}` ).
    lo_columns->end(
        )->ele( n = `rowActionTemplate` ns = `table`
            )->ele( n = `RowAction` ns = `table`
                )->ele( n = `RowActionItem` ns = `table`
                    )->a( n = `type`  v = `Navigation`
                    )->a( n = `press` v = client->_event( val = `ROW_ACTION_ITEM_NAVIGATION` arg = `${ROW_ID}` )
                )->end(
                )->ele( n = `RowActionItem` ns = `table`
                    )->a( n = `icon`  v = `sap-icon://edit`
                    )->a( n = `text`  v = `Edit`
                    )->a( n = `press` v = client->_event( val = `ROW_ACTION_ITEM_EDIT` arg = `${ROW_ID}` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD set_data.

    DATA temp6 LIKE mt_table.
    DATA temp7 LIKE LINE OF temp6.
    CLEAR temp6.
    
    temp7-selkz = abap_false.
    temp7-row_id = `1`.
    temp7-product = `table`.
    temp7-create_date = `01.01.2023`.
    temp7-create_by = `Olaf`.
    temp7-storage_location = `AREA_001`.
    temp7-quantity = 400.
    temp7-meins = `ST`.
    temp7-price = `1000.50`.
    temp7-waers = `EUR`.
    temp7-process = `10`.
    temp7-process_state = `None`.
    INSERT temp7 INTO TABLE temp6.
    temp7-selkz = abap_false.
    temp7-row_id = `2`.
    temp7-product = `chair`.
    temp7-create_date = `01.01.2022`.
    temp7-create_by = `Karlo`.
    temp7-storage_location = `AREA_001`.
    temp7-quantity = 123.
    temp7-meins = `ST`.
    temp7-price = `2000.55`.
    temp7-waers = `USD`.
    temp7-process = `20`.
    temp7-process_state = `Warning`.
    INSERT temp7 INTO TABLE temp6.
    temp7-selkz = abap_false.
    temp7-row_id = `3`.
    temp7-product = `sofa`.
    temp7-create_date = `01.05.2021`.
    temp7-create_by = `Elin`.
    temp7-storage_location = `AREA_002`.
    temp7-quantity = 700.
    temp7-meins = `ST`.
    temp7-price = `3000.11`.
    temp7-waers = `CNY`.
    temp7-process = `30`.
    temp7-process_state = `Success`.
    INSERT temp7 INTO TABLE temp6.
    temp7-selkz = abap_false.
    temp7-row_id = `4`.
    temp7-product = `computer`.
    temp7-create_date = `27.01.2023`.
    temp7-create_by = `Theo`.
    temp7-storage_location = `AREA_002`.
    temp7-quantity = 200.
    temp7-meins = `ST`.
    temp7-price = `4000.88`.
    temp7-waers = `USD`.
    temp7-process = `40`.
    temp7-process_state = `Information`.
    INSERT temp7 INTO TABLE temp6.
    temp7-selkz = abap_false.
    temp7-row_id = `5`.
    temp7-product = `printer`.
    temp7-create_date = `01.01.2023`.
    temp7-create_by = `Renate`.
    temp7-storage_location = `AREA_003`.
    temp7-quantity = 90.
    temp7-meins = `ST`.
    temp7-price = `5000.47`.
    temp7-waers = `EUR`.
    temp7-process = `70`.
    temp7-process_state = `Warning`.
    INSERT temp7 INTO TABLE temp6.
    temp7-selkz = abap_false.
    temp7-row_id = `6`.
    temp7-product = `table2`.
    temp7-create_date = `01.01.2023`.
    temp7-create_by = `Angela`.
    temp7-storage_location = `AREA_003`.
    temp7-quantity = 110.
    temp7-meins = `ST`.
    temp7-price = `6000.33`.
    temp7-waers = `GBP`.
    temp7-process = `90`.
    temp7-process_state = `Error`.
    INSERT temp7 INTO TABLE temp6.
    mt_table = temp6.

  ENDMETHOD.


  METHOD set_search.
      DATA lv_search TYPE string.
      DATA lt_all LIKE mt_table.
      DATA temp8 LIKE mt_table.
      DATA temp9 LIKE LINE OF lt_all.
      DATA lr_row LIKE REF TO temp9.
        DATA lv_row TYPE string.
        DATA lv_index TYPE i.
          FIELD-SYMBOLS <field> TYPE any.

    IF mv_search_value IS NOT INITIAL.

      " uppercase against uppercase, as the twins z2ui5_cl_smp_app_053 and
      " z2ui5_cl_smp_app_059 search - this copy compared case-sensitively
      
      lv_search = to_upper( mv_search_value ).

      " Collected rather than deleted in place: DELETE ... INDEX sy-tabix
      " inside a LOOP over the same table shifts the rows under the loop's own
      " cursor - a system silently SKIPS the row after each deletion (so the
      " search returns wrong rows) and the transpiled backend raises
      " TABLE_INVALID_INDEX. The DO loop above the DELETE can leave sy-tabix
      " pointing elsewhere as well. Found 2026-08-17.
      
      lt_all = mt_table.
      
      CLEAR temp8.
      mt_table = temp8.

      
      
      LOOP AT lt_all REFERENCE INTO lr_row.
        
        lv_row = ``.
        
        lv_index = 1.
        DO.
          
          ASSIGN COMPONENT lv_index OF STRUCTURE lr_row->* TO <field>.

          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
          lv_row   = lv_row && <field>.
          lv_index = lv_index + 1.
        ENDDO.

        IF to_upper( lv_row ) CS lv_search.
          APPEND lr_row->* TO mt_table.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
