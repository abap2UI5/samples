" @keywords live search parallel requests busy queue typing
" @summary Two SearchFields that round-trip on every keystroke on purpose - to show what that does: requests overtaking each other, the busy queue, the value lagging behind fast typing.
" @docs https://abap2ui5.github.io/docs/cookbook/model/tables
CLASS z2ui5_cl_smp_app_059 DEFINITION PUBLIC.

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
    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY.

    DATA mt_table TYPE ty_t_table.
    DATA mv_field TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS set_data.
    METHODS set_search.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_059 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
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

    IF client->check_on_event( `BUTTON_SEARCH` ) IS NOT INITIAL.

      set_data( ).
      set_search( ).

    ENDIF.

  ENDMETHOD.


  METHOD set_search.

    " a typed contains-search over the columns the table shows - the search
    " string is compared uppercase against uppercase, so it matches whatever
    " the user typed
    DATA lv_search TYPE string.
    DATA lt_all LIKE mt_table.
    DATA ls_row LIKE LINE OF lt_all.
    lv_search = to_upper( mv_field ).
    IF lv_search IS INITIAL.
      RETURN.
    ENDIF.

    
    lt_all = mt_table.
    CLEAR mt_table.

    
    LOOP AT lt_all INTO ls_row.
      IF to_upper( ls_row-product )          CS lv_search
      OR to_upper( ls_row-create_date )      CS lv_search
      OR to_upper( ls_row-create_by )        CS lv_search
      OR to_upper( ls_row-storage_location ) CS lv_search OR |{ ls_row-quantity }| CS lv_search.
        INSERT ls_row INTO TABLE mt_table.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD set_data.

    DATA temp1 TYPE z2ui5_cl_smp_app_059=>ty_t_table.
      DATA temp2 TYPE ty_t_table.
      DATA temp3 LIKE LINE OF temp2.
    CLEAR temp1.
    mt_table = temp1.
    DO 1000 TIMES.
      
      CLEAR temp2.
      
      temp3-product = `table`.
      temp3-create_date = `01.01.2023`.
      temp3-create_by = `Peter`.
      temp3-storage_location = `AREA_001`.
      temp3-quantity = 400.
      INSERT temp3 INTO TABLE temp2.
      temp3-product = `chair`.
      temp3-create_date = `01.01.2022`.
      temp3-create_by = `James`.
      temp3-storage_location = `AREA_001`.
      temp3-quantity = 123.
      INSERT temp3 INTO TABLE temp2.
      temp3-product = `sofa`.
      temp3-create_date = `01.05.2021`.
      temp3-create_by = `Simone`.
      temp3-storage_location = `AREA_001`.
      temp3-quantity = 700.
      INSERT temp3 INTO TABLE temp2.
      temp3-product = `computer`.
      temp3-create_date = `27.01.2023`.
      temp3-create_by = `Theo`.
      temp3-storage_location = `AREA_001`.
      temp3-quantity = 200.
      INSERT temp3 INTO TABLE temp2.
      temp3-product = `printer`.
      temp3-create_date = `01.01.2023`.
      temp3-create_by = `Hannah`.
      temp3-storage_location = `AREA_001`.
      temp3-quantity = 90.
      INSERT temp3 INTO TABLE temp2.
      temp3-product = `table2`.
      temp3-create_date = `01.01.2023`.
      temp3-create_by = `Julia`.
      temp3-storage_location = `AREA_001`.
      temp3-quantity = 110.
      INSERT temp3 INTO TABLE temp2.
      INSERT LINES OF temp2 INTO TABLE mt_table.

    ENDDO.

  ENDMETHOD.


  METHOD view_display.

    " Both SearchFields below round-trip on every keystroke on purpose: this
    " sample EXISTS to show what that does - requests overtaking each other,
    " the busy queue, the value lagging behind fast typing.
    " abap2ui5lint-disable live-event-roundtrip

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page1 TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_box TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp4 TYPE z2ui5_if_client=>ty_s_event_control.
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

    
    page1 = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Table - Live Search with Parallel Requests`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `id`             v = `page_main` ).

    page1->tag( `MessageStrip`
        )->a( n = `text`     v = `By default abap2UI5 handles only one backend request at a time - the app is set busy and further ` &&
                   `requests are ignored until the running one is finished. A live search needs the opposite: only the ` &&
                   `newest request matters and older ones can be dropped. Set check_allow_multi_req on the event to ` &&
                   `allow that - type in both fields and compare.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    lo_box = page1->ele( `HBox`
        )->a( n = `class` v = `sapUiSmallMarginBegin` ).

    lo_box->ele( `VBox`
        )->tag( `Text`
            )->a( n = `text` v = `Search disabled parallel (default)`
        )->tag( `SearchField`
            )->a( n = `width`       v = `17.5rem`
            )->a( n = `value`       v = client->_bind( mv_field )
            )->a( n = `placeholder` v = `Search products`
            )->a( n = `liveChange`  v = client->_event( `BUTTON_SEARCH` ) ).

    
    CLEAR temp4.
    temp4-check_allow_multi_req = abap_true.
    lo_box->ele( `VBox`
        )->tag( `Text`
            )->a( n = `text` v = `Search parallel`
        )->tag( `SearchField`
            )->a( n = `width`       v = `17.5rem`
            )->a( n = `value`       v = client->_bind( mv_field )
            )->a( n = `placeholder` v = `Search products`
            )->a( n = `liveChange`  v = client->_event(
                val    = `BUTTON_SEARCH`
                s_ctrl = temp4 ) ).

    
    tab = page1->ele( `Table`
        )->a( n = `items` v = client->_bind( mt_table ) ).
    
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

    " abap2ui5lint-enable live-event-roundtrip

  ENDMETHOD.
ENDCLASS.
