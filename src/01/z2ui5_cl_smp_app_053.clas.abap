" @keywords search go enter server side where
" @summary A SearchField that searches in the backend on Go or Enter, rather than filtering what was already sent.
" @docs https://abap2ui5.github.io/docs/cookbook/model/tables
CLASS z2ui5_cl_smp_app_053 DEFINITION PUBLIC.

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

    DATA mv_search_value TYPE string.
    DATA mt_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS set_search.
    METHODS set_data.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_053 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      set_data( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `BUTTON_SEARCH` OR `BUTTON_START`.
        set_data( ).
        set_search( ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA vbox TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_columns TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_cells TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Table - Search in the Backend (SearchField)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `id`             v = `page_main` ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A search field triggers a backend filter on Enter or via the Go button; the matching ` &&
                   `rows are computed server-side and the table is refreshed.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    vbox = page->ele( `VBox` ).

    vbox->ele( `HBox`
        )->tag( `SearchField`
            )->a( n = `width`       v = `17.5rem`
            )->a( n = `search`      v = client->_event( `BUTTON_SEARCH` )
            )->a( n = `value`       v = client->_bind( mv_search_value )
            )->a( n = `id`          v = `SEARCH`
            )->a( n = `placeholder` v = `Search products`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `BUTTON_START` )
            )->a( n = `text`  v = `Go`
            )->a( n = `type`  v = `Emphasized` ).

    
    tab = vbox->ele( `Table`
        )->a( n = `items` v = client->_bind( val = mt_table ) ).

    
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


  METHOD set_data.

    DATA temp1 LIKE mt_table.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-product = `table`.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Peter`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 400.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `chair`.
    temp2-create_date = `01.01.2022`.
    temp2-create_by = `James`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 123.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `sofa`.
    temp2-create_date = `01.05.2021`.
    temp2-create_by = `Simone`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 700.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `computer`.
    temp2-create_date = `27.01.2023`.
    temp2-create_by = `Theo`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 200.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `printer`.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Hannah`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 90.
    INSERT temp2 INTO TABLE temp1.
    temp2-product = `table2`.
    temp2-create_date = `01.01.2023`.
    temp2-create_by = `Julia`.
    temp2-storage_location = `AREA_001`.
    temp2-quantity = 110.
    INSERT temp2 INTO TABLE temp1.
    mt_table = temp1.

  ENDMETHOD.


  METHOD set_search.

    " a typed contains-search over the columns the table shows - the search
    " string is compared uppercase against uppercase, so it matches whatever
    " the user typed
    DATA lv_search TYPE string.
    DATA lt_all LIKE mt_table.
    DATA ls_row LIKE LINE OF lt_all.
    lv_search = to_upper( mv_search_value ).
    IF lv_search IS INITIAL.
      RETURN.
    ENDIF.

    
    lt_all = mt_table.
    CLEAR mt_table.

    
    LOOP AT lt_all INTO ls_row.
      IF to_upper( ls_row-product )          CS lv_search
      OR to_upper( ls_row-create_date )      CS lv_search
      OR to_upper( ls_row-create_by )        CS lv_search
      OR to_upper( ls_row-storage_location ) CS lv_search
      OR |{ ls_row-quantity }|               CS lv_search.
        INSERT ls_row INTO TABLE mt_table.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
