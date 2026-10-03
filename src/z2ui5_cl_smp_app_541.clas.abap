" @keywords ai llm assistant chat explain summary insight outlier table selection dynamicsidecontent
" @summary An explain-this-data button over a table - a side panel summarises the selected rows (counts, totals, extremes, outliers) through a deterministic provider that one method turns into an LLM call.
CLASS z2ui5_cl_smp_app_541 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_order,
        selected TYPE abap_bool,
        id       TYPE string,
        customer TYPE string,
        region   TYPE string,
        status   TYPE string,
        state    TYPE string,
        amount   TYPE i,
      END OF ty_s_order.
    TYPES ty_t_orders TYPE STANDARD TABLE OF ty_s_order WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_finding,
        title       TYPE string,
        description TYPE string,
        icon        TYPE string,
      END OF ty_s_finding.
    TYPES ty_t_findings TYPE STANDARD TABLE OF ty_s_finding WITH EMPTY KEY.

    DATA t_orders      TYPE ty_t_orders.
    DATA t_findings    TYPE ty_t_findings.
    DATA headline      TYPE string.
    DATA panel_visible TYPE abap_bool.
    DATA busy          TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS on_event_summarize.
    METHODS view_display.

    "! The provider seam: the rows in, the explanation out.
    "! @parameter t_rows | the rows to explain
    "! @parameter result | one finding per line of the explanation
    METHODS get_summary
      IMPORTING
        t_rows        TYPE ty_t_orders
      RETURNING
        VALUE(result) TYPE ty_t_findings.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_541 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_orders = VALUE #(
      ( id = `4711` customer = `Bike Corner`     region = `North` status = `Delivered` amount = 1200 )
      ( id = `4712` customer = `City Cycles`     region = `South` status = `Open`      amount = 860 )
      ( id = `4713` customer = `Mountain Outfit` region = `North` status = `Overdue`   amount = 2400 )
      ( id = `4714` customer = `Velo Point`      region = `West`  status = `Delivered` amount = 640 )
      ( id = `4715` customer = `Bike Corner`     region = `North` status = `Open`      amount = 1500 )
      ( id = `4716` customer = `Urban Wheels`    region = `East`  status = `Delivered` amount = 9800 )
      ( id = `4717` customer = `City Cycles`     region = `South` status = `Overdue`   amount = 720 )
      ( id = `4718` customer = `Trail Masters`   region = `West`  status = `Delivered` amount = 1900 )
      ( id = `4719` customer = `Velo Point`      region = `West`  status = `Open`      amount = 1100 )
      ( id = `4720` customer = `Mountain Outfit` region = `North` status = `Delivered` amount = 1350 ) ).

    LOOP AT t_orders REFERENCE INTO DATA(order).
      order->state = SWITCH #( order->status WHEN `Delivered` THEN `Success`
                                             WHEN `Overdue`   THEN `Error`
                                             ELSE `Warning` ).
    ENDLOOP.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `EXPLAIN`.
        " open the panel busy at once; the timer asks for the explanation in
        " a second roundtrip - with a real LLM that is where the seconds go.
        " The 800 ms only stand in for that time: drop them to 0 then.
        panel_visible = abap_true.
        busy          = abap_true.
        headline      = `Reading the rows...`.
        t_findings    = VALUE #( ).
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-start_timer
                                  t_arg = VALUE #( ( `SUMMARIZE` ) ( `800` ) ) ).

      WHEN `SUMMARIZE`.
        on_event_summarize( ).

      WHEN `CLOSE`.
        panel_visible = abap_false.

    ENDCASE.

  ENDMETHOD.


  METHOD on_event_summarize.

    " the selection was written back before this handler runs - explain the
    " selected rows, or all of them when nothing is selected
    DATA(t_scope) = t_orders.
    DELETE t_scope WHERE selected = abap_false.

    IF t_scope IS INITIAL.

      t_scope  = t_orders.
      headline = |All { lines( t_scope ) } orders. Select rows to explain only those.|.

    ELSE.
      headline = |The { lines( t_scope ) } selected orders.|.
    ENDIF.

    t_findings = get_summary( t_scope ).
    busy       = abap_false.

  ENDMETHOD.


  METHOD get_summary.

    " ---------------------------------------------------------------------
    " Plug a real LLM in HERE, and nowhere else: serialize t_rows to JSON,
    " send it with an instruction such as "explain this data in at most five
    " short findings", and map the reply to result. The button, the busy
    " panel and the selection handling stay as they are.
    "
    " Calling an endpoint needs an HTTP destination or a communication
    " arrangement on the system, which a sample in this repository cannot
    " bring along - the samples that call a real model live in
    " abap2UI5/samples-stack: https://github.com/abap2UI5/samples-stack
    "
    " Until then this deterministic provider explains the rows: totals,
    " extremes, the strongest region, the overdue share and the outliers.
    " ---------------------------------------------------------------------
    TYPES:
      BEGIN OF ty_s_region,
        region TYPE string,
        amount TYPE i,
      END OF ty_s_region.
    DATA t_regions TYPE SORTED TABLE OF ty_s_region WITH UNIQUE KEY region.
    DATA total TYPE i.
    DATA overdue_count TYPE i.
    DATA overdue_amount TYPE i.
    DATA outliers TYPE string.

    IF t_rows IS INITIAL.
      result = VALUE #( ( title = `Nothing to explain` description = `The table holds no rows.` icon = `sap-icon://hint` ) ).
      RETURN.
    ENDIF.

    DATA(largest)  = t_rows[ 1 ].
    DATA(smallest) = t_rows[ 1 ].

    LOOP AT t_rows INTO DATA(row).

      total = total + row-amount.
      IF row-amount > largest-amount.
        largest = row.
      ENDIF.

      IF row-amount < smallest-amount.
        smallest = row.
      ENDIF.

      IF row-status = `Overdue`.
        overdue_count  = overdue_count + 1.
        overdue_amount = overdue_amount + row-amount.
      ENDIF.

      READ TABLE t_regions ASSIGNING FIELD-SYMBOL(<region>) WITH TABLE KEY region = row-region.
      IF sy-subrc = 0.
        <region>-amount = <region>-amount + row-amount.
      ELSE.
        INSERT VALUE #( region = row-region amount = row-amount ) INTO TABLE t_regions.
      ENDIF.
    ENDLOOP.

    DATA(count)   = lines( t_rows ).
    DATA(average) = total / count.

    DATA(strongest) = t_regions[ 1 ].
    LOOP AT t_regions INTO DATA(region).
      IF region-amount > strongest-amount.
        strongest = region.
      ENDIF.
    ENDLOOP.
    " an integer variable, not arithmetic inside the template: the transpiled
    " runtime (playground, node backend) formats such an expression as a float
    DATA(strongest_share) = strongest-amount * 100 / total.

    DATA(threshold) = 2 * average.
    LOOP AT t_rows INTO row.
      IF row-amount > threshold.
        outliers = COND #( WHEN outliers IS INITIAL THEN row-id ELSE |{ outliers }, { row-id }| ).
      ENDIF.
    ENDLOOP.

    result = VALUE #(
      ( title       = `Volume`
        description = |{ count } orders worth { total } EUR, { average } EUR per order on average.|
        icon        = `sap-icon://sales-order` )
      ( title       = `Extremes`
        description = |Largest: { largest-id } of { largest-customer } with { largest-amount } EUR. | &&
                      |Smallest: { smallest-id } of { smallest-customer } with { smallest-amount } EUR.|
        icon        = `sap-icon://trend-up` )
      ( title       = `Regions`
        description = |{ strongest-region } brings the most: { strongest-amount } EUR, | &&
                      |{ strongest_share }% of the total across { lines( t_regions ) } regions.|
        icon        = `sap-icon://map` )
      ( title       = `Overdue`
        description = COND #( WHEN overdue_count = 0
                              THEN `No order is overdue.`
                              ELSE |{ overdue_count } of { count } orders are overdue, { overdue_amount } EUR in total.| )
        icon        = COND #( WHEN overdue_count = 0 THEN `sap-icon://accept` ELSE `sap-icon://warning` ) )
      ( title       = `Outliers`
        description = COND #( WHEN outliers IS INITIAL
                              THEN `No order is more than twice the average.`
                              ELSE |More than twice the average: { outliers }. Worth a second look.| )
        icon        = `sap-icon://alert` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - AI - Explain This Data in a DynamicSideContent Panel`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Explain This Data opens a panel beside the table and fills it with a short explanation ` &&
                   `of the selected rows, or of all of them. One method turns rows into findings - here a deterministic ` &&
                   `summary, in a real app the call to your language model.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " on a narrow screen the panel falls below the table instead of hiding
    DATA(side_content) = page->ele( n = `DynamicSideContent` ns = `layout`
        )->a( n = `showSideContent`       v = client->_bind( panel_visible )
        )->a( n = `sideContentVisibility` v = `AlwaysShow`
        )->a( n = `sideContentFallDown`   v = `BelowM`
        )->a( n = `containerQuery`        b = abap_true ).

    DATA(tab) = side_content->ele( n = `mainContent` ns = `layout`
        )->ele( `Table`
            )->a( n = `items` v = client->_bind( t_orders )
            )->a( n = `mode`  v = `MultiSelect` ).

    tab->ele( `headerToolbar`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Sales Orders`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `text`  v = `Explain This Data`
                )->a( n = `icon`  v = `sap-icon://hint`
                )->a( n = `type`  v = `Emphasized`
                )->a( n = `press` v = client->_event( `EXPLAIN` ) ).

    DATA(columns) = tab->ele( `columns` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Order` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Customer` ).
    columns->ele( `Column`
        )->a( n = `minScreenWidth` v = `Tablet`
        )->a( n = `demandPopin`    b = abap_true
        )->tag( `Text`
            )->a( n = `text` v = `Region` ).
    columns->ele( `Column`
        )->a( n = `minScreenWidth` v = `Tablet`
        )->a( n = `demandPopin`    b = abap_true
        )->tag( `Text`
            )->a( n = `text` v = `Status` ).
    columns->ele( `Column`
        )->a( n = `hAlign` v = `End`
        )->tag( `Text`
            )->a( n = `text` v = `Amount` ).

    DATA(cells) = tab->ele( `items`
        )->ele( `ColumnListItem`
            )->a( n = `selected` v = `{SELECTED}`
            )->ele( `cells` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{ID}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{CUSTOMER}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{REGION}` ).
    cells->tag( `ObjectStatus`
        )->a( n = `text`  v = `{STATUS}`
        )->a( n = `state` v = `{STATE}` ).
    cells->tag( `ObjectNumber`
        )->a( n = `number` v = `{AMOUNT}`
        )->a( n = `unit`   v = `EUR` ).

    DATA(panel) = side_content->ele( n = `sideContent` ns = `layout`
        )->ele( `VBox`
            )->a( n = `busy`               v = client->_bind( busy )
            )->a( n = `busyIndicatorDelay` v = `0`
            )->a( n = `class`              v = `sapUiSmallMarginBeginEnd` ).

    panel->ele( `Toolbar`
        )->a( n = `style` v = `Clear`
        )->tag( `Title`
            )->a( n = `text` v = `Explanation`
        )->tag( `ToolbarSpacer`
        )->tag( `Button`
            )->a( n = `icon`    v = `sap-icon://decline`
            )->a( n = `tooltip` v = `Close`
            )->a( n = `type`    v = `Transparent`
            )->a( n = `press`   v = client->_event( `CLOSE` ) ).

    panel->tag( `Text`
        )->a( n = `text`  v = client->_bind( headline )
        )->a( n = `class` v = `sapUiTinyMarginBottom` ).

    panel->ele( `List`
        )->a( n = `items`          v = client->_bind( t_findings )
        )->a( n = `showSeparators` v = `Inner`
        )->a( n = `noDataText`     v = `The explanation is on its way.`
        )->ele( `items`
            )->tag( `StandardListItem`
                )->a( n = `title`       v = `{TITLE}`
                )->a( n = `description` v = `{DESCRIPTION}`
                )->a( n = `icon`        v = `{ICON}`
                )->a( n = `wrapping`    b = abap_true ).

    panel->tag( `Text`
        )->a( n = `text`  v = `Written by the built-in rule-based provider - no language model involved.`
        )->a( n = `class` v = `sapUiTinyMarginTop` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
