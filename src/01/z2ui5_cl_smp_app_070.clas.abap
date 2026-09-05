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

    " the operator shorthands, name and value
    TYPES:
      BEGIN OF ty_s_mapping,
        n TYPE string,
        v TYPE string,
      END OF ty_s_mapping.

    DATA mt_mapping TYPE STANDARD TABLE OF ty_s_mapping WITH DEFAULT KEY.
    DATA mv_search_value TYPE string.
    DATA mt_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY.
    DATA lv_selkz TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS set_search.
    METHODS set_data.

    METHODS set_selkz
      IMPORTING
        iv_selkz TYPE abap_bool.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_070 IMPLEMENTATION.


  METHOD set_selkz.

    FIELD-SYMBOLS <ls_table> TYPE ty_s_tab.

    LOOP AT mt_table ASSIGNING <ls_table>.
      <ls_table>-selkz = iv_selkz.
    ENDLOOP.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      on_init( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA lt_arg TYPE string_table.
        DATA ls_arg TYPE string.

    CASE client->get_event( ).
      WHEN `BUTTON_SEARCH` OR `BUTTON_START`.
        client->message_toast_display( `Search Entries` ).
        set_data( ).
        set_search( ).
      WHEN `SORT`.
        
        lt_arg = client->get( )-t_event_arg.
        client->message_toast_display( `Event SORT` ).
      WHEN `FILTER`.
        lt_arg = client->get( )-t_event_arg.
        client->message_toast_display( `Event FILTER` ).
      WHEN `SELKZ`.
        client->message_toast_display( |'Event SELKZ' { lv_selkz } | ).
        set_selkz( lv_selkz ).
      WHEN `CUSTOMFILTER`.
        lt_arg = client->get( )-t_event_arg.
        client->message_toast_display( `Event CUSTOMFILTER` ).
      WHEN `ROWEDIT`.
        lt_arg = client->get( )-t_event_arg.
        
        READ TABLE lt_arg INTO ls_arg INDEX 1.

        IF sy-subrc = 0.
          client->message_toast_display( |Event ROWEDIT Row Index { ls_arg } | ).
        ENDIF.
      WHEN `ROW_ACTION_ITEM_NAVIGATION`.
        lt_arg = client->get( )-t_event_arg.
        READ TABLE lt_arg INTO ls_arg INDEX 1.

        IF sy-subrc = 0.
          client->message_toast_display( |Event ROW_ACTION_ITEM_NAVIGATION Row Index { ls_arg } | ).
        ENDIF.
      WHEN `ROW_ACTION_ITEM_EDIT`.
        lt_arg = client->get( )-t_event_arg.
        READ TABLE lt_arg INTO ls_arg INDEX 1.

        IF sy-subrc = 0.
          client->message_toast_display( |Event ROW_ACTION_ITEM_EDIT Row Index { ls_arg } | ).
        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD on_init.

    DATA temp1 LIKE mt_mapping.
    DATA temp2 LIKE LINE OF temp1.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page1 TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA header_title TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_box TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA cont TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_columns TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    CLEAR temp1.
    
    temp2-n = `EQ`.
    temp2-v = `={LOW}`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `LT`.
    temp2-v = `<{LOW}`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `LE`.
    temp2-v = `<={LOW}`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `GT`.
    temp2-v = `>{LOW}`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `GE`.
    temp2-v = `>={LOW}`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `CP`.
    temp2-v = `*{LOW}*`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `BT`.
    temp2-v = `{LOW}...{HIGH}`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `NE`.
    temp2-v = `!(={LOW})`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `!<leer>`.
    temp2-v = `!(<leer>)`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `<leer>`.
    temp2-v = `<leer>`.
    INSERT temp2 INTO TABLE temp1.
    mt_mapping = temp1.

    
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
                   `progress-indicator and currency cells, plus backend-driven search, sort and filter events.`
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

    
    tab = cont->ele( n = `Table` ns = `table`
        )->a( n = `rows`               v = client->_bind( val = mt_table )
        )->a( n = `alternateRowColors` b = abap_true
        )->a( n = `fixedColumnCount`   v = `1`
        )->a( n = `rowActionCount`     v = `2`
        )->a( n = `selectionMode`      v = `None`
        )->a( n = `filter`             v = client->_event( `FILTER` )
        )->a( n = `sort`               v = client->_event( `SORT` )
        )->a( n = `customFilter`       v = client->_event( `CUSTOMFILTER` ) ).
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
    
    CLEAR temp3.
    INSERT `${ROW_ID}` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `${ROW_ID}` INTO TABLE temp4.
    lo_columns->end(
        )->ele( n = `rowActionTemplate` ns = `table`
            )->ele( n = `RowAction` ns = `table`
                )->ele( n = `RowActionItem` ns = `table`
                    )->a( n = `type`  v = `Navigation`
                    )->a( n = `press` v = client->_event( val = `ROW_ACTION_ITEM_NAVIGATION` t_arg = temp3 )
                )->end(
                )->ele( n = `RowActionItem` ns = `table`
                    )->a( n = `icon`  v = `sap-icon://edit`
                    )->a( n = `text`  v = `Edit`
                    )->a( n = `press` v = client->_event( val = `ROW_ACTION_ITEM_EDIT` t_arg = temp4 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD set_data.

    DATA temp5 LIKE mt_table.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp5.
    
    temp6-selkz = abap_false.
    temp6-row_id = `1`.
    temp6-product = `table`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Olaf`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 400.
    temp6-meins = `ST`.
    temp6-price = `1000.50`.
    temp6-waers = `EUR`.
    temp6-process = `10`.
    temp6-process_state = `None`.
    INSERT temp6 INTO TABLE temp5.
    temp6-selkz = abap_false.
    temp6-row_id = `2`.
    temp6-product = `chair`.
    temp6-create_date = `01.01.2022`.
    temp6-create_by = `Karlo`.
    temp6-storage_location = `AREA_001`.
    temp6-quantity = 123.
    temp6-meins = `ST`.
    temp6-price = `2000.55`.
    temp6-waers = `USD`.
    temp6-process = `20`.
    temp6-process_state = `Warning`.
    INSERT temp6 INTO TABLE temp5.
    temp6-selkz = abap_false.
    temp6-row_id = `3`.
    temp6-product = `sofa`.
    temp6-create_date = `01.05.2021`.
    temp6-create_by = `Elin`.
    temp6-storage_location = `AREA_002`.
    temp6-quantity = 700.
    temp6-meins = `ST`.
    temp6-price = `3000.11`.
    temp6-waers = `CNY`.
    temp6-process = `30`.
    temp6-process_state = `Success`.
    INSERT temp6 INTO TABLE temp5.
    temp6-selkz = abap_false.
    temp6-row_id = `4`.
    temp6-product = `computer`.
    temp6-create_date = `27.01.2023`.
    temp6-create_by = `Theo`.
    temp6-storage_location = `AREA_002`.
    temp6-quantity = 200.
    temp6-meins = `ST`.
    temp6-price = `4000.88`.
    temp6-waers = `USD`.
    temp6-process = `40`.
    temp6-process_state = `Information`.
    INSERT temp6 INTO TABLE temp5.
    temp6-selkz = abap_false.
    temp6-row_id = `5`.
    temp6-product = `printer`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Renate`.
    temp6-storage_location = `AREA_003`.
    temp6-quantity = 90.
    temp6-meins = `ST`.
    temp6-price = `5000.47`.
    temp6-waers = `EUR`.
    temp6-process = `70`.
    temp6-process_state = `Warning`.
    INSERT temp6 INTO TABLE temp5.
    temp6-selkz = abap_false.
    temp6-row_id = `6`.
    temp6-product = `table2`.
    temp6-create_date = `01.01.2023`.
    temp6-create_by = `Angela`.
    temp6-storage_location = `AREA_003`.
    temp6-quantity = 110.
    temp6-meins = `ST`.
    temp6-price = `6000.33`.
    temp6-waers = `GBP`.
    temp6-process = `90`.
    temp6-process_state = `Error`.
    INSERT temp6 INTO TABLE temp5.
    mt_table = temp5.

  ENDMETHOD.


  METHOD set_search.
      DATA lt_all LIKE mt_table.
      DATA temp7 LIKE LINE OF lt_all.
      DATA lr_row LIKE REF TO temp7.
        DATA lv_row TYPE string.
        DATA lv_index TYPE i.
          FIELD-SYMBOLS <field> TYPE any.

    IF mv_search_value IS NOT INITIAL.

      " Collected rather than deleted in place: DELETE ... INDEX sy-tabix
      " inside a LOOP over the same table shifts the rows under the loop's own
      " cursor - a system silently SKIPS the row after each deletion (so the
      " search returns wrong rows) and the transpiled backend raises
      " TABLE_INVALID_INDEX. The DO loop above the DELETE can leave sy-tabix
      " pointing elsewhere as well. Found 2026-08-17.
      
      lt_all = mt_table.
      CLEAR mt_table.

      
      
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

        IF lv_row CS mv_search_value.
          APPEND lr_row->* TO mt_table.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
