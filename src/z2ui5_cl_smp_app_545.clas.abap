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
    TYPES ty_t_sales TYPE STANDARD TABLE OF ty_s_sale WITH EMPTY KEY.
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
        nodes TYPE STANDARD TABLE OF ty_s_node WITH EMPTY KEY,
      END OF ty_s_country.
    TYPES BEGIN OF ty_s_region.
        INCLUDE TYPE ty_s_node.
    TYPES:
        nodes TYPE STANDARD TABLE OF ty_s_country WITH EMPTY KEY,
      END OF ty_s_region.
    TYPES BEGIN OF ty_s_total.
        INCLUDE TYPE ty_s_node.
    TYPES:
        nodes TYPE STANDARD TABLE OF ty_s_region WITH EMPTY KEY,
      END OF ty_s_total.
    TYPES ty_t_tree TYPE STANDARD TABLE OF ty_s_total WITH EMPTY KEY.

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

    me->client = client.

    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( `EXPAND` ).
      " three levels below the grand totals: regions, countries, sales
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = VALUE #( ( `tree` ) ( `expandToLevel` ) ( `3` ) ) ).
    ELSEIF client->check_on_event( `COLLAPSE` ).
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = VALUE #( ( `tree` ) ( `collapseAll` ) ) ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    DATA(t_sales) = VALUE ty_t_sales(
        ( region = `EMEA`     country = `Germany`     product = `Notebook`         quantity = 10 amount = `12000.00` currency = `EUR` )
        ( region = `APAC`     country = `Japan`       product = `Antivirus`        quantity = 50 amount = `2500.00`  currency = `USD` )
        ( region = `EMEA`     country = `Switzerland` product = `Monitor`          quantity = 8  amount = `2400.00`  currency = `CHF` )
        ( region = `Americas` country = `USA`         product = `Server`           quantity = 2  amount = `18000.00` currency = `USD` )
        ( region = `EMEA`     country = `Germany`     product = `Office Suite`     quantity = 25 amount = `4500.00`  currency = `EUR` )
        ( region = `Americas` country = `Canada`      product = `Monitor`          quantity = 5  amount = `1500.00`  currency = `CAD` )
        ( region = `EMEA`     country = `France`      product = `Notebook`         quantity = 6  amount = `7200.00`  currency = `EUR` )
        ( region = `APAC`     country = `Australia`   product = `Training`         quantity = 2  amount = `3000.00`  currency = `USD` )
        ( region = `EMEA`     country = `Switzerland` product = `Installation`     quantity = 3  amount = `1350.00`  currency = `CHF` )
        ( region = `Americas` country = `USA`         product = `Support Contract` quantity = 12 amount = `6000.00`  currency = `USD` )
        ( region = `APAC`     country = `Japan`       product = `Notebook`         quantity = 4  amount = `4800.00`  currency = `USD` )
        ( region = `Americas` country = `Canada`      product = `Office Suite`     quantity = 40 amount = `7600.00`  currency = `CAD` ) ).

    t_tree = tree_build( t_sales ).

    " room for every node, so expanding all scrolls nothing out of sight
    visible_rows = lines( t_sales ).
    LOOP AT t_tree INTO DATA(s_total).
      visible_rows = visible_rows + 1.
      LOOP AT s_total-nodes INTO DATA(s_region).
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

    t_sorted = t_sales.
    SORT t_sorted STABLE BY currency.

    LOOP AT t_sorted INTO DATA(s_sale).

      READ TABLE result ASSIGNING <total> WITH KEY currency = s_sale-currency.
      IF sy-subrc <> 0.
        APPEND VALUE #( name = `Grand Total` currency = s_sale-currency kind = cs_kind-total ) TO result ASSIGNING <total>.
      ENDIF.
      <total>-quantity = <total>-quantity + s_sale-quantity.
      <total>-amount   = <total>-amount + s_sale-amount.

      READ TABLE <total>-nodes ASSIGNING <region> WITH KEY name = s_sale-region.
      IF sy-subrc <> 0.
        APPEND VALUE #( name = s_sale-region currency = s_sale-currency kind = cs_kind-subtotal ) TO <total>-nodes ASSIGNING <region>.
      ENDIF.
      <region>-quantity = <region>-quantity + s_sale-quantity.
      <region>-amount   = <region>-amount + s_sale-amount.

      READ TABLE <region>-nodes ASSIGNING <country> WITH KEY name = s_sale-country.
      IF sy-subrc <> 0.
        APPEND VALUE #( name = s_sale-country currency = s_sale-currency kind = cs_kind-subtotal ) TO <region>-nodes ASSIGNING <country>.
      ENDIF.
      <country>-quantity = <country>-quantity + s_sale-quantity.
      <country>-amount   = <country>-amount + s_sale-amount.

      APPEND VALUE #( name     = s_sale-product
                      quantity = s_sale-quantity
                      amount   = s_sale-amount
                      currency = s_sale-currency
                      kind     = `` ) TO <country>-nodes.

    ENDLOOP.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:table`  v = `sap.ui.table` ).
    DATA(page) = view->ele( `Shell`
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
    DATA(table) = page->ele( n = `TreeTable` ns = `table`
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
    DATA(columns) = table->ele( n = `columns` ns = `table` ).

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
