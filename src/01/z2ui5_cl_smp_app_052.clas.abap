" @keywords list report dynamicpage row link details table
" @summary Opens a Popover from a table row - which row was pressed, and how its record reaches the popover.
" @docs https://abap2ui5.github.io/docs/cookbook/popup_popover/popover
CLASS z2ui5_cl_smp_app_052 DEFINITION PUBLIC.

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
    DATA mt_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY.

    DATA mv_check_popover TYPE abap_bool.
    DATA mv_product TYPE string.

    METHODS  set_data.
    METHODS view_display.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_052 IMPLEMENTATION.

  METHOD popover_display.

    DATA lo_popover TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA popover TYPE REF TO z2ui5_cl_ui5_view_builder.
    lo_popover = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns:f`    v = `sap.f`
            )->a( n = `xmlns:form` v = `sap.ui.layout.form` ).

    
    popover = lo_popover->ele( `Popover`
        )->a( n = `title`        v = |abap2UI5 - Popover - { mv_product }|
        )->a( n = `placement`    v = `Right`
        )->a( n = `contentWidth` v = `20rem` ).

    popover->ele( n = `SimpleForm` ns = `form`
        )->a( n = `layout`   v = `ColumnLayout`
        )->a( n = `editable` b = abap_false
        )->ele( n = `content` ns = `form`
            )->tag( `Label`
                )->a( n = `text` v = `Product`
            )->tag( `Text`
                )->a( n = `text` v = mv_product
            )->tag( `Label`
                )->a( n = `text` v = `info2`
            )->tag( `Text`
                )->a( n = `text` v = `this is a text`
            )->tag( `Label`
                )->a( n = `text` v = `info3`
            )->tag( `Text`
                )->a( n = `text` v = `this is a text`
            )->tag( `Text`
                )->a( n = `text` v = `this is a text` ).

    popover->ele( `footer`
        )->ele( `OverflowToolbar`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `BUTTON_DETAILS` )
                )->a( n = `text`  v = `details`
                )->a( n = `type`  v = `Emphasized` ).

    client->popover_display( xml = lo_popover->stringify( ) by_id = id ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA cont TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_columns TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_cells TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:f`      v = `sap.f`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Popover - Open from a Table Row`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `id`             v = `page_main` ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `List report layout: a dynamic page with a table whose product links open a popover ` &&
                   `showing details for the selected row.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page = page->ele( n = `DynamicPage` ns = `f`
        )->a( n = `headerExpanded` b = abap_true ).

    
    cont = page->ele( n = `content` ns = `f` ).
    
    tab = cont->ele( `Table`
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
    
    CLEAR temp1.
    INSERT `${$source>/id}` INTO TABLE temp1.
    INSERT `${PRODUCT}` INTO TABLE temp1.
    lo_cells->tag( `Link`
        )->a( n = `text`  v = `{PRODUCT}`
        )->a( n = `press` v = client->_event( val = `POPOVER_DETAIL` t_arg = temp1 )
        )->a( n = `id`    v = `link` ).
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


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      view_display( ).
      set_data( ).
      RETURN.
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

    CASE client->get_event( ).

      WHEN `BUTTON_DETAILS`.
        client->popover_destroy( ).

      WHEN `POPOVER_DETAIL`.
        mv_check_popover = abap_true.
        mv_product       = client->get_event_arg( 2 ).
        popover_display( client->get_event_arg( ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD set_data.

    DATA temp3 LIKE mt_table.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-product = `table`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `chair`.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `sofa`.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `computer`.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `printer`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table2`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `chair`.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `sofa`.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `computer`.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `printer`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table2`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `chair`.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `sofa`.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `computer`.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `printer`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table2`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `chair`.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `sofa`.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `computer`.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `printer`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table2`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `chair`.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `sofa`.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `computer`.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `printer`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table2`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `chair`.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `sofa`.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `computer`.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `printer`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table2`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `chair`.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `sofa`.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `computer`.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `printer`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table2`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Peter`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 400.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `chair`.
    temp4-create_date = `01.01.2022`.
    temp4-create_by = `James`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 123.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `sofa`.
    temp4-create_date = `01.05.2021`.
    temp4-create_by = `Simone`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 700.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `computer`.
    temp4-create_date = `27.01.2023`.
    temp4-create_by = `Theo`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 200.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `printer`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Hannah`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 90.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `table2`.
    temp4-create_date = `01.01.2023`.
    temp4-create_by = `Julia`.
    temp4-storage_location = `AREA_001`.
    temp4-quantity = 110.
    INSERT temp4 INTO TABLE temp3.
    mt_table = temp3.

  ENDMETHOD.

ENDCLASS.
