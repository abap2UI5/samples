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
    TYPES ty_t_orders TYPE STANDARD TABLE OF ty_s_order WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_finding,
        title       TYPE string,
        description TYPE string,
        icon        TYPE string,
      END OF ty_s_finding.
    TYPES ty_t_findings TYPE STANDARD TABLE OF ty_s_finding WITH DEFAULT KEY.

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
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    DATA temp1 TYPE z2ui5_cl_smp_app_541=>ty_t_orders.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 LIKE LINE OF t_orders.
    DATA order LIKE REF TO temp3.
      DATA temp4 TYPE z2ui5_cl_smp_app_541=>ty_s_order-state.
    CLEAR temp1.
    
    temp2-id = `4711`.
    temp2-customer = `Bike Corner`.
    temp2-region = `North`.
    temp2-status = `Delivered`.
    temp2-amount = 1200.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `4712`.
    temp2-customer = `City Cycles`.
    temp2-region = `South`.
    temp2-status = `Open`.
    temp2-amount = 860.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `4713`.
    temp2-customer = `Mountain Outfit`.
    temp2-region = `North`.
    temp2-status = `Overdue`.
    temp2-amount = 2400.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `4714`.
    temp2-customer = `Velo Point`.
    temp2-region = `West`.
    temp2-status = `Delivered`.
    temp2-amount = 640.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `4715`.
    temp2-customer = `Bike Corner`.
    temp2-region = `North`.
    temp2-status = `Open`.
    temp2-amount = 1500.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `4716`.
    temp2-customer = `Urban Wheels`.
    temp2-region = `East`.
    temp2-status = `Delivered`.
    temp2-amount = 9800.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `4717`.
    temp2-customer = `City Cycles`.
    temp2-region = `South`.
    temp2-status = `Overdue`.
    temp2-amount = 720.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `4718`.
    temp2-customer = `Trail Masters`.
    temp2-region = `West`.
    temp2-status = `Delivered`.
    temp2-amount = 1900.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `4719`.
    temp2-customer = `Velo Point`.
    temp2-region = `West`.
    temp2-status = `Open`.
    temp2-amount = 1100.
    INSERT temp2 INTO TABLE temp1.
    temp2-id = `4720`.
    temp2-customer = `Mountain Outfit`.
    temp2-region = `North`.
    temp2-status = `Delivered`.
    temp2-amount = 1350.
    INSERT temp2 INTO TABLE temp1.
    t_orders = temp1.

    
    
    LOOP AT t_orders REFERENCE INTO order.
      
      CASE order->status.
        WHEN `Delivered`.
          temp4 = `Success`.
        WHEN `Overdue`.
          temp4 = `Error`.
        WHEN OTHERS.
          temp4 = `Warning`.
      ENDCASE.
      order->state = temp4.
    ENDLOOP.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp5 TYPE z2ui5_cl_smp_app_541=>ty_t_findings.
        DATA temp6 TYPE string_table.

    CASE client->get_event( ).

      WHEN `EXPLAIN`.
        " open the panel busy at once; the timer asks for the explanation in
        " a second roundtrip - with a real LLM that is where the seconds go.
        " The 800 ms only stand in for that time: drop them to 0 then.
        panel_visible = abap_true.
        busy          = abap_true.
        headline      = `Reading the rows...`.
        
        CLEAR temp5.
        t_findings    = temp5.
        
        CLEAR temp6.
        INSERT `SUMMARIZE` INTO TABLE temp6.
        INSERT `800` INTO TABLE temp6.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-start_timer
                                  t_arg = temp6 ).

      WHEN `SUMMARIZE`.
        on_event_summarize( ).

      WHEN `CLOSE`.
        panel_visible = abap_false.

    ENDCASE.

  ENDMETHOD.


  METHOD on_event_summarize.

    " the selection was written back before this handler runs - explain the
    " selected rows, or all of them when nothing is selected
    DATA t_scope LIKE t_orders.
    t_scope = t_orders.
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
    " bring along. The same idea against a real model - a table whose rows
    " go to the model as context, its summary back into a panel - is
    " Z2UI5_CL_SMPS_APP_015 in abap2UI5/samples-stack, package 10 (AI / LLM):
    " https://github.com/abap2UI5/samples-stack/tree/main/src/10
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
      DATA temp8 TYPE z2ui5_cl_smp_app_541=>ty_t_findings.
      DATA temp9 LIKE LINE OF temp8.
    DATA largest LIKE LINE OF t_rows.
    FIELD-SYMBOLS <temp1> LIKE LINE OF t_rows.
    DATA temp2 LIKE sy-tabix.
    DATA smallest LIKE LINE OF t_rows.
    FIELD-SYMBOLS <temp3> LIKE LINE OF t_rows.
    DATA temp4 LIKE sy-tabix.
    DATA row LIKE LINE OF t_rows.
      FIELD-SYMBOLS <region> TYPE ty_s_region.
        DATA temp10 TYPE ty_s_region.
    DATA count TYPE i.
    DATA average TYPE i.
    DATA strongest LIKE LINE OF t_regions.
    FIELD-SYMBOLS <temp5> LIKE LINE OF t_regions.
    DATA temp6 LIKE sy-tabix.
    DATA region LIKE LINE OF t_regions.
    DATA strongest_share TYPE ty_s_region-amount.
    DATA threshold TYPE i.
        DATA temp11 TYPE string.
    DATA temp12 TYPE z2ui5_cl_smp_app_541=>ty_t_findings.
    DATA temp13 LIKE LINE OF temp12.
    DATA temp7 TYPE z2ui5_cl_smp_app_541=>ty_s_finding-description.
    DATA temp14 TYPE z2ui5_cl_smp_app_541=>ty_s_finding-icon.
    DATA temp15 TYPE z2ui5_cl_smp_app_541=>ty_s_finding-description.

    IF t_rows IS INITIAL.
      
      CLEAR temp8.
      
      temp9-title = `Nothing to explain`.
      temp9-description = `The table holds no rows.`.
      temp9-icon = `sap-icon://hint`.
      INSERT temp9 INTO TABLE temp8.
      result = temp8.
      RETURN.
    ENDIF.

    
    
    
    temp2 = sy-tabix.
    READ TABLE t_rows INDEX 1 ASSIGNING <temp1>.
    sy-tabix = temp2.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    largest = <temp1>.
    
    
    
    temp4 = sy-tabix.
    READ TABLE t_rows INDEX 1 ASSIGNING <temp3>.
    sy-tabix = temp4.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    smallest = <temp3>.

    
    LOOP AT t_rows INTO row.

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

      
      READ TABLE t_regions ASSIGNING <region> WITH TABLE KEY region = row-region.
      IF sy-subrc = 0.
        <region>-amount = <region>-amount + row-amount.
      ELSE.
        
        CLEAR temp10.
        temp10-region = row-region.
        temp10-amount = row-amount.
        INSERT temp10 INTO TABLE t_regions.
      ENDIF.
    ENDLOOP.

    
    count   = lines( t_rows ).
    
    average = total / count.

    
    
    
    temp6 = sy-tabix.
    READ TABLE t_regions INDEX 1 ASSIGNING <temp5>.
    sy-tabix = temp6.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    strongest = <temp5>.
    
    LOOP AT t_regions INTO region.
      IF region-amount > strongest-amount.
        strongest = region.
      ENDIF.
    ENDLOOP.
    " an integer variable, not arithmetic inside the template: the transpiled
    " runtime (playground, node backend) formats such an expression as a float
    
    strongest_share = strongest-amount * 100 / total.

    
    threshold = 2 * average.
    LOOP AT t_rows INTO row.
      IF row-amount > threshold.
        
        IF outliers IS INITIAL.
          temp11 = row-id.
        ELSE.
          temp11 = |{ outliers }, { row-id }|.
        ENDIF.
        outliers = temp11.
      ENDIF.
    ENDLOOP.

    
    CLEAR temp12.
    
    temp13-title = `Volume`.
    temp13-description = |{ count } orders worth { total } EUR, { average } EUR per order on average.|.
    temp13-icon = `sap-icon://sales-order`.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Extremes`.
    temp13-description = |Largest: { largest-id } of { largest-customer } with { largest-amount } EUR. | &&
|Smallest: { smallest-id } of { smallest-customer } with { smallest-amount } EUR.|.
    temp13-icon = `sap-icon://trend-up`.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Regions`.
    temp13-description = |{ strongest-region } brings the most: { strongest-amount } EUR, | &&
|{ strongest_share }% of the total across { lines( t_regions ) } regions.|.
    temp13-icon = `sap-icon://map`.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Overdue`.
    
    IF overdue_count = 0.
      temp7 = `No order is overdue.`.
    ELSE.
      temp7 = |{ overdue_count } of { count } orders are overdue, { overdue_amount } EUR in total.|.
    ENDIF.
    temp13-description = temp7.
    
    IF overdue_count = 0.
      temp14 = `sap-icon://accept`.
    ELSE.
      temp14 = `sap-icon://warning`.
    ENDIF.
    temp13-icon = temp14.
    INSERT temp13 INTO TABLE temp12.
    temp13-title = `Outliers`.
    
    IF outliers IS INITIAL.
      temp15 = `No order is more than twice the average.`.
    ELSE.
      temp15 = |More than twice the average: { outliers }. Worth a second look.|.
    ENDIF.
    temp13-description = temp15.
    temp13-icon = `sap-icon://alert`.
    INSERT temp13 INTO TABLE temp12.
    result = temp12.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA side_content TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA columns TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA cells TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA panel TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:layout` v = `sap.ui.layout` ).

    
    page = view->ele( `Shell`
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
    
    side_content = page->ele( n = `DynamicSideContent` ns = `layout`
        )->a( n = `showSideContent`       v = client->_bind( panel_visible )
        )->a( n = `sideContentVisibility` v = `AlwaysShow`
        )->a( n = `sideContentFallDown`   v = `BelowM`
        )->a( n = `containerQuery`        b = abap_true ).

    
    tab = side_content->ele( n = `mainContent` ns = `layout`
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

    
    columns = tab->ele( `columns` ).
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

    
    cells = tab->ele( `items`
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

    
    panel = side_content->ele( n = `sideContent` ns = `layout`
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
