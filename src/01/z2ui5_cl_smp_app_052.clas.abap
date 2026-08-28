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
    DATA mt_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

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

    DATA(lo_popover) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns:f`    v = `sap.f`
            )->a( n = `xmlns:form` v = `sap.ui.layout.form` ).

    DATA(popover) = lo_popover->ele( `Popover`
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

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:f`      v = `sap.f`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    DATA(page) = view->ele( `Shell`
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

    DATA(cont) = page->ele( n = `content` ns = `f` ).
    DATA(tab) = cont->ele( `Table`
        )->a( n = `items` v = client->_bind( val = mt_table )
        )->a( n = `id`    v = `tab` ).

    DATA(lo_columns) = tab->ele( `columns` ).
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

    DATA(lo_cells) = tab->ele( `items`
        )->ele( `ColumnListItem` ).
    lo_cells->tag( `Link`
        )->a( n = `text`  v = `{PRODUCT}`
        )->a( n = `press` v = client->_event( val = `POPOVER_DETAIL` t_arg = VALUE #( ( `${$source>/id}` ) ( `${PRODUCT}` ) ) )
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

    IF client->check_on_init( ).

      view_display( ).
      set_data( ).
      RETURN.
    ELSEIF client->check_on_navigated( ).
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

    mt_table = VALUE #(
        ( product = `table`    create_date = `01.01.2023` create_by = `Peter`  storage_location = `AREA_001` quantity = 400 )
        ( product = `chair`    create_date = `01.01.2022` create_by = `James`  storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa`     create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo`   storage_location = `AREA_001` quantity = 200 )
        ( product = `printer`  create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2`   create_date = `01.01.2023` create_by = `Julia`  storage_location = `AREA_001` quantity = 110 )
        ( product = `table`    create_date = `01.01.2023` create_by = `Peter`  storage_location = `AREA_001` quantity = 400 )
        ( product = `chair`    create_date = `01.01.2022` create_by = `James`  storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa`     create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo`   storage_location = `AREA_001` quantity = 200 )
        ( product = `printer`  create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2`   create_date = `01.01.2023` create_by = `Julia`  storage_location = `AREA_001` quantity = 110 )
        ( product = `table`    create_date = `01.01.2023` create_by = `Peter`  storage_location = `AREA_001` quantity = 400 )
        ( product = `chair`    create_date = `01.01.2022` create_by = `James`  storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa`     create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo`   storage_location = `AREA_001` quantity = 200 )
        ( product = `printer`  create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2`   create_date = `01.01.2023` create_by = `Julia`  storage_location = `AREA_001` quantity = 110 )
        ( product = `table`    create_date = `01.01.2023` create_by = `Peter`  storage_location = `AREA_001` quantity = 400 )
        ( product = `chair`    create_date = `01.01.2022` create_by = `James`  storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa`     create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo`   storage_location = `AREA_001` quantity = 200 )
        ( product = `printer`  create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2`   create_date = `01.01.2023` create_by = `Julia`  storage_location = `AREA_001` quantity = 110 )
        ( product = `table`    create_date = `01.01.2023` create_by = `Peter`  storage_location = `AREA_001` quantity = 400 )
        ( product = `chair`    create_date = `01.01.2022` create_by = `James`  storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa`     create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo`   storage_location = `AREA_001` quantity = 200 )
        ( product = `printer`  create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2`   create_date = `01.01.2023` create_by = `Julia`  storage_location = `AREA_001` quantity = 110 )
        ( product = `table`    create_date = `01.01.2023` create_by = `Peter`  storage_location = `AREA_001` quantity = 400 )
        ( product = `chair`    create_date = `01.01.2022` create_by = `James`  storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa`     create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo`   storage_location = `AREA_001` quantity = 200 )
        ( product = `printer`  create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2`   create_date = `01.01.2023` create_by = `Julia`  storage_location = `AREA_001` quantity = 110 )
        ( product = `table`    create_date = `01.01.2023` create_by = `Peter`  storage_location = `AREA_001` quantity = 400 )
        ( product = `chair`    create_date = `01.01.2022` create_by = `James`  storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa`     create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo`   storage_location = `AREA_001` quantity = 200 )
        ( product = `printer`  create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2`   create_date = `01.01.2023` create_by = `Julia`  storage_location = `AREA_001` quantity = 110 )
        ( product = `table`    create_date = `01.01.2023` create_by = `Peter`  storage_location = `AREA_001` quantity = 400 )
        ( product = `chair`    create_date = `01.01.2022` create_by = `James`  storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa`     create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo`   storage_location = `AREA_001` quantity = 200 )
        ( product = `printer`  create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2`   create_date = `01.01.2023` create_by = `Julia`  storage_location = `AREA_001` quantity = 110 ) ).

  ENDMETHOD.

ENDCLASS.
