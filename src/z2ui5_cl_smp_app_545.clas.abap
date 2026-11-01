" @keywords tree table treetable subtotal grand total group sum currency hierarchy collapse expand arraynames expandtolevel collapseall control_by_id rowsettings
" @summary Subtotals as a hierarchy in a sap.ui.table.TreeTable - a grand total per currency, a node per region and country carrying its sum, the sales as leaves - collapsible in the browser.
CLASS z2ui5_cl_smp_app_545 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_sale,
        region   TYPE string,
        country  TYPE string,
        product  TYPE string,
        quantity TYPE i,
        amount   TYPE p LENGTH 15 DECIMALS 2,
        currency TYPE string,
      END OF ty_s_sale.
    TYPES ty_t_sales TYPE STANDARD TABLE OF ty_s_sale WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_node,
        name     TYPE string,
        quantity TYPE i,
        amount   TYPE p LENGTH 15 DECIMALS 2,
        currency TYPE string,
        "! what the node is: a sale (empty), a subtotal or a grand total, see cs_kind
        kind     TYPE string,
      END OF ty_s_node.
    TYPES BEGIN OF ty_s_country.
        INCLUDE TYPE ty_s_node.
    TYPES:
        nodes TYPE STANDARD TABLE OF ty_s_node WITH DEFAULT KEY,
      END OF ty_s_country.
    TYPES BEGIN OF ty_s_region.
        INCLUDE TYPE ty_s_node.
    TYPES:
        nodes TYPE STANDARD TABLE OF ty_s_country WITH DEFAULT KEY,
      END OF ty_s_region.
    TYPES BEGIN OF ty_s_total.
        INCLUDE TYPE ty_s_node.
    TYPES:
        nodes TYPE STANDARD TABLE OF ty_s_region WITH DEFAULT KEY,
      END OF ty_s_total.
    TYPES ty_t_tree TYPE STANDARD TABLE OF ty_s_total WITH DEFAULT KEY.

    CONSTANTS:
      BEGIN OF cs_kind,
        subtotal TYPE string VALUE `S`,
        total    TYPE string VALUE `T`,
      END OF cs_kind.

    DATA t_tree       TYPE ty_t_tree.
    DATA visible_rows TYPE i.

    "! Builds the hierarchy grand total - region - country - sale. Amounts
    "! only add up within one currency, so the root is one grand total per
    "! currency: a region that sells in two currencies sits under both. Every
    "! node carries the sums of the sales below it; regions, countries and
    "! sales keep the order of their first sale within a currency.
    "! @parameter t_sales | the sales, in any order
    "! @parameter result  | one grand total node per currency, in alphabetical order
    METHODS tree_build
      IMPORTING
        t_sales       TYPE ty_t_sales
      RETURNING
        VALUE(result) TYPE ty_t_tree.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_545 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp10 TYPE string_table.
      DATA temp12 TYPE string_table.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( `EXPAND` ) IS NOT INITIAL.
      " three levels below the grand totals: regions, countries, sales
      
      CLEAR temp10.
      INSERT `tree` INTO TABLE temp10.
      INSERT `expandToLevel` INTO TABLE temp10.
      INSERT `3` INTO TABLE temp10.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp10 ).
    ELSEIF client->check_on_event( `COLLAPSE` ) IS NOT INITIAL.
      
      CLEAR temp12.
      INSERT `tree` INTO TABLE temp12.
      INSERT `collapseAll` INTO TABLE temp12.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp12 ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    DATA temp14 TYPE ty_t_sales.
    DATA temp15 LIKE LINE OF temp14.
    DATA t_sales LIKE temp14.
    DATA s_total LIKE LINE OF t_tree.
      DATA s_region LIKE LINE OF s_total-nodes.
    CLEAR temp14.
    
    temp15-region = `EMEA`.
    temp15-country = `Germany`.
    temp15-product = `Notebook`.
    temp15-quantity = 10.
    temp15-amount = `12000.00`.
    temp15-currency = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `APAC`.
    temp15-country = `Japan`.
    temp15-product = `Antivirus`.
    temp15-quantity = 50.
    temp15-amount = `2500.00`.
    temp15-currency = `USD`.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `EMEA`.
    temp15-country = `Switzerland`.
    temp15-product = `Monitor`.
    temp15-quantity = 8.
    temp15-amount = `2400.00`.
    temp15-currency = `CHF`.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `Americas`.
    temp15-country = `USA`.
    temp15-product = `Server`.
    temp15-quantity = 2.
    temp15-amount = `18000.00`.
    temp15-currency = `USD`.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `EMEA`.
    temp15-country = `Germany`.
    temp15-product = `Office Suite`.
    temp15-quantity = 25.
    temp15-amount = `4500.00`.
    temp15-currency = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `Americas`.
    temp15-country = `Canada`.
    temp15-product = `Monitor`.
    temp15-quantity = 5.
    temp15-amount = `1500.00`.
    temp15-currency = `CAD`.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `EMEA`.
    temp15-country = `France`.
    temp15-product = `Notebook`.
    temp15-quantity = 6.
    temp15-amount = `7200.00`.
    temp15-currency = `EUR`.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `APAC`.
    temp15-country = `Australia`.
    temp15-product = `Training`.
    temp15-quantity = 2.
    temp15-amount = `3000.00`.
    temp15-currency = `USD`.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `EMEA`.
    temp15-country = `Switzerland`.
    temp15-product = `Installation`.
    temp15-quantity = 3.
    temp15-amount = `1350.00`.
    temp15-currency = `CHF`.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `Americas`.
    temp15-country = `USA`.
    temp15-product = `Support Contract`.
    temp15-quantity = 12.
    temp15-amount = `6000.00`.
    temp15-currency = `USD`.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `APAC`.
    temp15-country = `Japan`.
    temp15-product = `Notebook`.
    temp15-quantity = 4.
    temp15-amount = `4800.00`.
    temp15-currency = `USD`.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `Americas`.
    temp15-country = `Canada`.
    temp15-product = `Office Suite`.
    temp15-quantity = 40.
    temp15-amount = `7600.00`.
    temp15-currency = `CAD`.
    INSERT temp15 INTO TABLE temp14.
    
    t_sales = temp14.

    t_tree = tree_build( t_sales ).

    " room for every node, so expanding all scrolls nothing out of sight
    visible_rows = lines( t_sales ).
    
    LOOP AT t_tree INTO s_total.
      visible_rows = visible_rows + 1.
      
      LOOP AT s_total-nodes INTO s_region.
        visible_rows = visible_rows + 1 + lines( s_region-nodes ).
      ENDLOOP.
    ENDLOOP.

    view_display( ).

  ENDMETHOD.


  METHOD tree_build.

    DATA t_sorted TYPE ty_t_sales.
    FIELD-SYMBOLS <total>   TYPE ty_s_total.
    FIELD-SYMBOLS <region>  TYPE ty_s_region.
    FIELD-SYMBOLS <country> TYPE ty_s_country.
    DATA s_sale LIKE LINE OF t_sorted.
        DATA temp16 TYPE z2ui5_cl_smp_app_545=>ty_s_total.
        DATA temp17 TYPE z2ui5_cl_smp_app_545=>ty_s_region.
        DATA temp18 TYPE z2ui5_cl_smp_app_545=>ty_s_country.
      DATA temp19 TYPE z2ui5_cl_smp_app_545=>ty_s_node.

    t_sorted = t_sales.
    SORT t_sorted STABLE BY currency.

    
    LOOP AT t_sorted INTO s_sale.

      READ TABLE result ASSIGNING <total> WITH KEY currency = s_sale-currency.
      IF sy-subrc <> 0.
        
        CLEAR temp16.
        temp16-name = `Grand Total`.
        temp16-currency = s_sale-currency.
        temp16-kind = cs_kind-total.
        APPEND temp16 TO result ASSIGNING <total>.
      ENDIF.
      <total>-quantity = <total>-quantity + s_sale-quantity.
      <total>-amount   = <total>-amount + s_sale-amount.

      READ TABLE <total>-nodes ASSIGNING <region> WITH KEY name = s_sale-region.
      IF sy-subrc <> 0.
        
        CLEAR temp17.
        temp17-name = s_sale-region.
        temp17-currency = s_sale-currency.
        temp17-kind = cs_kind-subtotal.
        APPEND temp17 TO <total>-nodes ASSIGNING <region>.
      ENDIF.
      <region>-quantity = <region>-quantity + s_sale-quantity.
      <region>-amount   = <region>-amount + s_sale-amount.

      READ TABLE <region>-nodes ASSIGNING <country> WITH KEY name = s_sale-country.
      IF sy-subrc <> 0.
        
        CLEAR temp18.
        temp18-name = s_sale-country.
        temp18-currency = s_sale-currency.
        temp18-kind = cs_kind-subtotal.
        APPEND temp18 TO <region>-nodes ASSIGNING <country>.
      ENDIF.
      <country>-quantity = <country>-quantity + s_sale-quantity.
      <country>-amount   = <country>-amount + s_sale-amount.

      
      CLEAR temp19.
      temp19-name = s_sale-product.
      temp19-quantity = s_sale-quantity.
      temp19-amount = s_sale-amount.
      temp19-currency = s_sale-currency.
      temp19-kind = ``.
      APPEND temp19 TO <country>-nodes.

    ENDLOOP.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA table TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA columns TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:table`  v = `sap.ui.table` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Grid Table - Collapsible Subtotals in a TreeTable`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The backend nests the sales into a hierarchy - a grand total per currency, then region, ` &&
                   `country and the sale - and every node carries the sums below it. The TreeTable reads the children ` &&
                   `from the NODES arrays and expands and collapses them in the browser; the two buttons call ` &&
                   `expandToLevel and collapseAll on it by ID.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " arrayNames tells the JSON model which component holds the children;
    " the first level - the grand totals - starts expanded
    
    table = page->ele( n = `TreeTable` ns = `table`
        )->a( n = `id`              v = `tree`
        )->a( n = `rows`            v = |\{ path: '{ client->_bind( val = t_tree path = abap_true ) }', | &&
                                        |parameters: \{ arrayNames: ['NODES'], numberOfExpandedLevels: 1 \} \}|
        )->a( n = `selectionMode`   v = `None`
        )->a( n = `visibleRowCount` v = client->_bind( visible_rows )
        )->a( n = `class`           v = `sapUiSmallMarginBeginEnd` ).

    table->ele( n = `extension` ns = `table`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Sales`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `text`  v = `Expand All`
                )->a( n = `icon`  v = `sap-icon://expand-group`
                )->a( n = `press` v = client->_event( `EXPAND` )
            )->tag( `Button`
                )->a( n = `text`  v = `Collapse All`
                )->a( n = `icon`  v = `sap-icon://collapse-group`
                )->a( n = `press` v = client->_event( `COLLAPSE` ) ).

    " the bar at the start of the row tells the totals from the sales
    table->ele( n = `rowSettingsTemplate` ns = `table`
        )->tag( n = `RowSettings` ns = `table`
            )->a( n = `highlight` v = |\{= $\{KIND\} === '{ cs_kind-total }' ? 'Warning' : $\{KIND\} === '{ cs_kind-subtotal }' ? 'Information' : 'None' \}| ).

    " no sortProperty and no filterProperty: the sums belong to the tree as
    " the backend built it
    
    columns = table->ele( n = `columns` ns = `table` ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `width` v = `18rem`
        )->tag( `Label`
            )->a( n = `text` v = `Region / Country / Product`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text`     v = `{NAME}`
                )->a( n = `wrapping` b = abap_false ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `width`  v = `8rem`
        )->a( n = `hAlign` v = `End`
        )->tag( `Label`
            )->a( n = `text` v = `Quantity`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{QUANTITY}` ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `width`  v = `10rem`
        )->a( n = `hAlign` v = `End`
        )->tag( `Label`
            )->a( n = `text` v = `Amount`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{ parts: ['AMOUNT', 'CURRENCY'], type: 'sap.ui.model.type.Currency', formatOptions: { showMeasure: false } }` ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `width` v = `6rem`
        )->tag( `Label`
            )->a( n = `text` v = `Currency`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{CURRENCY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
