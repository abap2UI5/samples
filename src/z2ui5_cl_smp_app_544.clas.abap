" @keywords grid table subtotal grand total group sum currency rowsettings writetodom
" @summary Groups a sap.ui.table by the columns the user ticks - a subtotal row after each group, a grand total at the end, amounts summed per currency - and styles the total rows from their data.
CLASS z2ui5_cl_smp_app_544 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_sale,
        region   TYPE string,
        country  TYPE string,
        category TYPE string,
        product  TYPE string,
        quantity TYPE i,
        amount   TYPE p LENGTH 15 DECIMALS 2,
        currency TYPE string,
        "! what the row is: a sale (empty), a subtotal or a grand total, see cs_kind
        kind     TYPE string,
      END OF ty_s_sale.
    TYPES ty_t_sales TYPE STANDARD TABLE OF ty_s_sale WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_column,
        name     TYPE string,
        label    TYPE string,
        selected TYPE abap_bool,
      END OF ty_s_column.

    CONSTANTS:
      BEGIN OF cs_kind,
        subtotal TYPE string VALUE `S`,
        total    TYPE string VALUE `T`,
      END OF cs_kind.

    DATA t_rows       TYPE ty_t_sales.
    DATA t_columns    TYPE STANDARD TABLE OF ty_s_column WITH DEFAULT KEY.
    DATA visible_rows TYPE i.

    "! Sorts the rows by the grouping columns and inserts a subtotal row after
    "! each group and the grand total after the last row. Amounts only add up
    "! within one currency, so every unit column belongs to each group: a group
    "! in two currencies gets two subtotal rows, and so does the grand total.
    "! A subtotal row carries the values of its grouping columns, its units and
    "! the sums; everything else stays empty.
    "! @parameter group_by     | the grouping columns, outermost first; a name the rows do not have is ignored
    "! @parameter value_fields | the columns that are summed - amounts, quantities
    "! @parameter unit_fields  | the currency and unit columns
    "! @parameter kind_field   | the column that tells a subtotal or a total by cs_kind; optional
    "! @parameter rows         | a table of flat structures, sorted and extended in place
    METHODS subtotals_add
      IMPORTING
        group_by     TYPE string_table
        value_fields TYPE string_table
        unit_fields  TYPE string_table
        kind_field   TYPE string OPTIONAL
      CHANGING
        rows         TYPE STANDARD TABLE.

  PROTECTED SECTION.
    TYPES:
      BEGIN OF ty_s_sum,
        "! the number of grouping columns the sum is for; 0 is the grand total
        level TYPE i,
        row   TYPE REF TO data,
      END OF ty_s_sum.
    TYPES ty_t_sums TYPE STANDARD TABLE OF ty_s_sum WITH DEFAULT KEY.

    DATA client         TYPE REF TO z2ui5_if_client.
    DATA t_sales        TYPE ty_t_sales.
    DATA t_group_fields TYPE string_table.
    DATA t_value_fields TYPE string_table.
    DATA t_unit_fields  TYPE string_table.
    DATA kind_column    TYPE string.

    METHODS on_init.
    METHODS view_display.
    METHODS rows_group.

    "! Adds the row to the sum of its units on the given level
    METHODS sum_add
      IMPORTING
        row   TYPE any
        level TYPE i
      CHANGING
        sums  TYPE ty_t_sums.

    "! The number of leading grouping columns in which both rows agree
    METHODS groups_common
      IMPORTING
        left          TYPE any
        right         TYPE any
      RETURNING
        VALUE(result) TYPE i.

    METHODS fields_equal
      IMPORTING
        left          TYPE any
        right         TYPE any
        fields        TYPE string_table
      RETURNING
        VALUE(result) TYPE abap_bool.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_544 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( `GROUP` ) IS NOT INITIAL.
      rows_group( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    DATA temp28 TYPE z2ui5_cl_smp_app_544=>ty_t_sales.
    DATA temp29 LIKE LINE OF temp28.
    DATA temp30 LIKE t_columns.
    DATA temp31 LIKE LINE OF temp30.
    CLEAR temp28.
    
    temp29-region = `EMEA`.
    temp29-country = `Germany`.
    temp29-category = `Hardware`.
    temp29-product = `Notebook`.
    temp29-quantity = 10.
    temp29-amount = `12000.00`.
    temp29-currency = `EUR`.
    INSERT temp29 INTO TABLE temp28.
    temp29-region = `APAC`.
    temp29-country = `Japan`.
    temp29-category = `Software`.
    temp29-product = `Antivirus`.
    temp29-quantity = 50.
    temp29-amount = `2500.00`.
    temp29-currency = `USD`.
    INSERT temp29 INTO TABLE temp28.
    temp29-region = `EMEA`.
    temp29-country = `Switzerland`.
    temp29-category = `Hardware`.
    temp29-product = `Monitor`.
    temp29-quantity = 8.
    temp29-amount = `2400.00`.
    temp29-currency = `CHF`.
    INSERT temp29 INTO TABLE temp28.
    temp29-region = `Americas`.
    temp29-country = `USA`.
    temp29-category = `Hardware`.
    temp29-product = `Server`.
    temp29-quantity = 2.
    temp29-amount = `18000.00`.
    temp29-currency = `USD`.
    INSERT temp29 INTO TABLE temp28.
    temp29-region = `EMEA`.
    temp29-country = `Germany`.
    temp29-category = `Software`.
    temp29-product = `Office Suite`.
    temp29-quantity = 25.
    temp29-amount = `4500.00`.
    temp29-currency = `EUR`.
    INSERT temp29 INTO TABLE temp28.
    temp29-region = `Americas`.
    temp29-country = `Canada`.
    temp29-category = `Hardware`.
    temp29-product = `Monitor`.
    temp29-quantity = 5.
    temp29-amount = `1500.00`.
    temp29-currency = `CAD`.
    INSERT temp29 INTO TABLE temp28.
    temp29-region = `EMEA`.
    temp29-country = `France`.
    temp29-category = `Hardware`.
    temp29-product = `Notebook`.
    temp29-quantity = 6.
    temp29-amount = `7200.00`.
    temp29-currency = `EUR`.
    INSERT temp29 INTO TABLE temp28.
    temp29-region = `APAC`.
    temp29-country = `Australia`.
    temp29-category = `Services`.
    temp29-product = `Training`.
    temp29-quantity = 2.
    temp29-amount = `3000.00`.
    temp29-currency = `USD`.
    INSERT temp29 INTO TABLE temp28.
    temp29-region = `EMEA`.
    temp29-country = `Switzerland`.
    temp29-category = `Services`.
    temp29-product = `Installation`.
    temp29-quantity = 3.
    temp29-amount = `1350.00`.
    temp29-currency = `CHF`.
    INSERT temp29 INTO TABLE temp28.
    temp29-region = `Americas`.
    temp29-country = `USA`.
    temp29-category = `Services`.
    temp29-product = `Support Contract`.
    temp29-quantity = 12.
    temp29-amount = `6000.00`.
    temp29-currency = `USD`.
    INSERT temp29 INTO TABLE temp28.
    temp29-region = `APAC`.
    temp29-country = `Japan`.
    temp29-category = `Hardware`.
    temp29-product = `Notebook`.
    temp29-quantity = 4.
    temp29-amount = `4800.00`.
    temp29-currency = `USD`.
    INSERT temp29 INTO TABLE temp28.
    temp29-region = `Americas`.
    temp29-country = `Canada`.
    temp29-category = `Software`.
    temp29-product = `Office Suite`.
    temp29-quantity = 40.
    temp29-amount = `7600.00`.
    temp29-currency = `CAD`.
    INSERT temp29 INTO TABLE temp28.
    t_sales = temp28.

    " the order of this list is the order of the groups, the first ticked
    " column outermost
    
    CLEAR temp30.
    
    temp31-name = `REGION`.
    temp31-label = `Region`.
    temp31-selected = abap_true.
    INSERT temp31 INTO TABLE temp30.
    temp31-name = `COUNTRY`.
    temp31-label = `Country`.
    temp31-selected = abap_false.
    INSERT temp31 INTO TABLE temp30.
    temp31-name = `CATEGORY`.
    temp31-label = `Category`.
    temp31-selected = abap_false.
    INSERT temp31 INTO TABLE temp30.
    t_columns = temp30.

    rows_group( ).
    view_display( ).

  ENDMETHOD.


  METHOD rows_group.

    DATA t_group_by TYPE string_table.

    DATA s_column LIKE LINE OF t_columns.
    DATA temp32 TYPE string_table.
    DATA temp4 TYPE string_table.
    LOOP AT t_columns INTO s_column WHERE selected = abap_true.
      APPEND s_column-name TO t_group_by.
    ENDLOOP.

    t_rows = t_sales.
    
    CLEAR temp32.
    INSERT `AMOUNT` INTO TABLE temp32.
    INSERT `QUANTITY` INTO TABLE temp32.
    
    CLEAR temp4.
    INSERT `CURRENCY` INTO TABLE temp4.
    subtotals_add( EXPORTING group_by     = t_group_by
                             value_fields = temp32
                             unit_fields  = temp4
                             kind_field   = `KIND`
                   CHANGING  rows         = t_rows ).

    " every row on screen: a scrolled-away grand total is easy to miss
    visible_rows = lines( t_rows ).

  ENDMETHOD.


  METHOD subtotals_add.

    DATA t_order   TYPE abap_sortorder_tab.
    DATA t_sums    TYPE ty_t_sums.
    DATA grouped   TYPE REF TO data.
    DATA field     TYPE string.
    DATA levels    TYPE i.
    DATA level     TYPE i.
    DATA kept      TYPE i.
    DATA s_sum     TYPE ty_s_sum.
    FIELD-SYMBOLS <grouped> TYPE STANDARD TABLE.
    FIELD-SYMBOLS <row>     TYPE any.
    FIELD-SYMBOLS <next>    TYPE any.
    FIELD-SYMBOLS <sum>     TYPE any.
    FIELD-SYMBOLS <field>   TYPE any.

    DATA temp34 TYPE string_table.
    DATA temp35 TYPE string_table.
    DATA temp36 TYPE string_table.
      DATA temp37 LIKE sy-subrc.
      DATA temp38 LIKE sy-subrc.
      DATA temp39 LIKE sy-tabix.
      DATA temp40 LIKE sy-subrc.
      DATA temp41 LIKE sy-subrc.
      DATA temp42 LIKE sy-tabix.
      DATA temp43 TYPE abap_sortorder.
      DATA temp44 TYPE abap_sortorder.
      DATA index LIKE sy-tabix.
    CLEAR temp34.
    t_group_fields = temp34.
    
    CLEAR temp35.
    t_value_fields = temp35.
    
    CLEAR temp36.
    t_unit_fields  = temp36.
    kind_column    = to_upper( kind_field ).

    READ TABLE rows INDEX 1 ASSIGNING <row>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    " a column the rows do not have groups nothing; a grouping column keeps
    " its value and is not summed
    LOOP AT group_by INTO field.
      field = to_upper( field ).
      ASSIGN COMPONENT field OF STRUCTURE <row> TO <field>.
      
      
      
      temp38 = sy-subrc.
      temp39 = sy-tabix.
      READ TABLE t_group_fields WITH KEY table_line = field TRANSPORTING NO FIELDS.
      temp37 = sy-subrc.
      sy-subrc = temp38.
      sy-tabix = temp39.
      IF sy-subrc = 0 AND NOT temp37 = 0.
        APPEND field TO t_group_fields.
      ENDIF.
    ENDLOOP.
    IF t_group_fields IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT value_fields INTO field.
      field = to_upper( field ).
      ASSIGN COMPONENT field OF STRUCTURE <row> TO <field>.
      
      
      
      temp41 = sy-subrc.
      temp42 = sy-tabix.
      READ TABLE t_group_fields WITH KEY table_line = field TRANSPORTING NO FIELDS.
      temp40 = sy-subrc.
      sy-subrc = temp41.
      sy-tabix = temp42.
      IF sy-subrc = 0 AND NOT temp40 = 0.
        APPEND field TO t_value_fields.
      ENDIF.
    ENDLOOP.
    LOOP AT unit_fields INTO field.
      field = to_upper( field ).
      ASSIGN COMPONENT field OF STRUCTURE <row> TO <field>.
      IF sy-subrc = 0.
        APPEND field TO t_unit_fields.
      ENDIF.
    ENDLOOP.

    LOOP AT t_group_fields INTO field.
      
      CLEAR temp43.
      temp43-name = field.
      APPEND temp43 TO t_order.
    ENDLOOP.
    LOOP AT t_unit_fields INTO field.
      
      CLEAR temp44.
      temp44-name = field.
      APPEND temp44 TO t_order.
    ENDLOOP.
    SORT rows STABLE BY (t_order).

    CREATE DATA grouped LIKE rows.
    ASSIGN grouped->* TO <grouped>.
    IF <grouped> IS NOT ASSIGNED.
      RETURN.
    ENDIF.
    levels = lines( t_group_fields ).

    LOOP AT rows ASSIGNING <row>.
      
      index = sy-tabix.
      APPEND <row> TO <grouped>.
      DO levels + 1 TIMES.
        sum_add( EXPORTING row   = <row>
                           level = sy-index - 1
                 CHANGING  sums  = t_sums ).
      ENDDO.

      " the groups this row closes: every level deeper than the grouping
      " columns the next row still shares - after the last row all of them,
      " down to the grand total
      READ TABLE rows INDEX index + 1 ASSIGNING <next>.
      IF sy-subrc = 0.
        kept = groups_common( left = <row> right = <next> ).
      ELSE.
        kept = -1.
      ENDIF.

      level = levels.
      WHILE level > kept.
        LOOP AT t_sums INTO s_sum WHERE level = level.
          UNASSIGN <sum>.
          ASSIGN s_sum-row->* TO <sum>.
          IF <sum> IS ASSIGNED.
            APPEND <sum> TO <grouped>.
          ENDIF.
        ENDLOOP.
        DELETE t_sums WHERE level = level.
        level = level - 1.
      ENDWHILE.
    ENDLOOP.

    rows = <grouped>.

  ENDMETHOD.


  METHOD sum_add.

    DATA new_sum TYPE REF TO data.
    DATA s_sum   TYPE ty_s_sum.
    DATA t_keys  TYPE string_table.
    DATA field   TYPE string.
    FIELD-SYMBOLS <sum>    TYPE any.
    FIELD-SYMBOLS <source> TYPE any.
    FIELD-SYMBOLS <target> TYPE any.
          DATA temp45 TYPE string.
      DATA temp46 TYPE z2ui5_cl_smp_app_544=>ty_s_sum.

    LOOP AT sums INTO s_sum WHERE level = level.
      UNASSIGN <sum>.
      ASSIGN s_sum-row->* TO <sum>.
      IF <sum> IS ASSIGNED AND fields_equal( left = <sum> right = row fields = t_unit_fields ) = abap_true.
        EXIT.
      ENDIF.
      UNASSIGN <sum>.
    ENDLOOP.

    IF <sum> IS NOT ASSIGNED.

      CREATE DATA new_sum LIKE row.
      ASSIGN new_sum->* TO <sum>.
      IF <sum> IS NOT ASSIGNED.
        RETURN.
      ENDIF.

      " the units and the grouping columns of this level
      t_keys = t_unit_fields.
      LOOP AT t_group_fields INTO field TO level.
        APPEND field TO t_keys.
      ENDLOOP.
      LOOP AT t_keys INTO field.
        ASSIGN COMPONENT field OF STRUCTURE row TO <source>.
        IF sy-subrc = 0.
          ASSIGN COMPONENT field OF STRUCTURE <sum> TO <target>.
          IF sy-subrc = 0.
            <target> = <source>.
          ENDIF.
        ENDIF.
      ENDLOOP.

      IF kind_column IS NOT INITIAL.
        ASSIGN COMPONENT kind_column OF STRUCTURE <sum> TO <target>.
        IF sy-subrc = 0.
          
          IF level = 0.
            temp45 = cs_kind-total.
          ELSE.
            temp45 = cs_kind-subtotal.
          ENDIF.
          <target> = temp45.
        ENDIF.
      ENDIF.
      
      CLEAR temp46.
      temp46-level = level.
      temp46-row = new_sum.
      INSERT temp46 INTO TABLE sums.

    ENDIF.

    LOOP AT t_value_fields INTO field.
      ASSIGN COMPONENT field OF STRUCTURE row TO <source>.
      IF sy-subrc = 0.
        ASSIGN COMPONENT field OF STRUCTURE <sum> TO <target>.
        IF sy-subrc = 0.
          <target> = <target> + <source>.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD groups_common.

    DATA field TYPE string.
      DATA temp47 TYPE string_table.

    LOOP AT t_group_fields INTO field.
      
      CLEAR temp47.
      INSERT field INTO TABLE temp47.
      IF fields_equal( left = left right = right fields = temp47 ) = abap_false.
        RETURN.
      ENDIF.
      result = result + 1.
    ENDLOOP.

  ENDMETHOD.


  METHOD fields_equal.

    DATA field TYPE string.
    FIELD-SYMBOLS <left>  TYPE any.
    FIELD-SYMBOLS <right> TYPE any.

    LOOP AT fields INTO field.
      ASSIGN COMPONENT field OF STRUCTURE left TO <left>.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.
      ASSIGN COMPONENT field OF STRUCTURE right TO <right>.
      IF sy-subrc <> 0.
        RETURN.
      ENDIF.
      IF <left> <> <right>.
        RETURN.
      ENDIF.
    ENDLOOP.
    result = abap_true.

  ENDMETHOD.


  METHOD view_display.

    DATA t_layout TYPE STANDARD TABLE OF ty_s_column WITH DEFAULT KEY.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA table TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp49 LIKE t_layout.
    DATA temp50 LIKE LINE OF temp49.
    DATA columns TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA s_layout LIKE LINE OF t_layout.
      DATA text TYPE string.
      DATA align TYPE string.
      DATA column TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:table`  v = `sap.ui.table` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Grid Table - Subtotals and Grand Total per Currency`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Tick the columns to group by: the backend sorts the rows by them, inserts a subtotal row after ` &&
                   `each group and a grand total at the end. Amounts are summed per currency, so a group in two currencies ` &&
                   `gets two subtotal rows. Each cell writes its row kind into the DOM (CustomData writeToDom), and the ` &&
                   `style below colours the whole row from it.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " a grid table row takes no CSS class from its data, so every cell carries
    " the row kind as data-rowkind, and :has( ) lifts it to the row. The
    " theme parameters are CSS variables only on newer releases - the colour
    " after the comma is the fallback for the ones without
    page->tag( n = `HTML` ns = `core`
        )->a( n = `content` v = `<style>` && |\n| &&
                         `.sapUiTable tr:has([data-rowkind="S"]) > td \{ background-color: var(--sapInformationBackground, #f5faff); \}` && |\n| &&
                         `.sapUiTable tr:has([data-rowkind="T"]) > td \{ background-color: var(--sapWarningBackground, #fef7f1); \}` && |\n| &&
                         `[data-rowkind="S"], [data-rowkind="T"] \{ font-weight: bold; \}` && |\n| &&
                         `</style>` ).

    
    table = page->ele( n = `Table` ns = `table`
        )->a( n = `rows`            v = client->_bind( t_rows )
        )->a( n = `selectionMode`   v = `None`
        )->a( n = `visibleRowCount` v = client->_bind( visible_rows )
        )->a( n = `class`           v = `sapUiSmallMarginBeginEnd` ).

    table->ele( n = `extension` ns = `table`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Sales`
            )->tag( `ToolbarSpacer`
            )->tag( `Label`
                )->a( n = `text` v = `Group by:`
            )->ele( `HBox`
                )->a( n = `items` v = client->_bind( t_columns )
                )->tag( `CheckBox`
                    )->a( n = `text`     v = `{LABEL}`
                    )->a( n = `selected` v = `{SELECTED}`
                    )->a( n = `select`   v = client->_event( `GROUP` ) ).

    " the bar at the start of the row, in the colour of the row
    table->ele( n = `rowSettingsTemplate` ns = `table`
        )->tag( n = `RowSettings` ns = `table`
            )->a( n = `highlight` v = |\{= $\{KIND\} === '{ cs_kind-total }' ? 'Warning' : $\{KIND\} === '{ cs_kind-subtotal }' ? 'Information' : 'None' \}| ).

    " no sortProperty and no filterProperty: sorting in the browser would tear
    " the subtotals from their groups
    
    CLEAR temp49.
    
    temp50-name = `REGION`.
    temp50-label = `Region`.
    temp50-selected = abap_false.
    INSERT temp50 INTO TABLE temp49.
    temp50-name = `COUNTRY`.
    temp50-label = `Country`.
    temp50-selected = abap_false.
    INSERT temp50 INTO TABLE temp49.
    temp50-name = `CATEGORY`.
    temp50-label = `Category`.
    temp50-selected = abap_false.
    INSERT temp50 INTO TABLE temp49.
    temp50-name = `PRODUCT`.
    temp50-label = `Product`.
    temp50-selected = abap_false.
    INSERT temp50 INTO TABLE temp49.
    temp50-name = `QUANTITY`.
    temp50-label = `Quantity`.
    temp50-selected = abap_false.
    INSERT temp50 INTO TABLE temp49.
    temp50-name = `AMOUNT`.
    temp50-label = `Amount`.
    temp50-selected = abap_false.
    INSERT temp50 INTO TABLE temp49.
    temp50-name = `CURRENCY`.
    temp50-label = `Currency`.
    temp50-selected = abap_false.
    INSERT temp50 INTO TABLE temp49.
    t_layout = temp49.

    
    columns = table->ele( n = `columns` ns = `table` ).
    
    LOOP AT t_layout INTO s_layout.

      
      text = |\{{ s_layout-name }\}|.
      
      align = `Begin`.
      CASE s_layout-name.
        WHEN `PRODUCT`.
          text = |\{= $\{KIND\} === '{ cs_kind-total }' ? 'Total' : $\{KIND\} === '{ cs_kind-subtotal }' ? 'Subtotal' : $\{PRODUCT\} \}|.
        WHEN `QUANTITY`.
          align = `End`.
        WHEN `AMOUNT`.
          text  = `{ parts: ['AMOUNT', 'CURRENCY'], type: 'sap.ui.model.type.Currency', formatOptions: { showMeasure: false } }`.
          align = `End`.
      ENDCASE.

      
      column = columns->ele( n = `Column` ns = `table`
          )->a( n = `width` v = `10rem` ).
      column->tag( `Label` )->a( n = `text` t = s_layout-label ).

      " writeToDom renders data-rowkind="S" on the cell's own element. It only
      " writes a string, so the expression turns an empty kind into I, an item
      column->ele( n = `template` ns = `table`
          )->ele( `Text`
              )->a( n = `text`      v = text
              )->a( n = `textAlign` v = align
              )->a( n = `wrapping`  b = abap_false
              )->ele( `customData`
                  )->tag( n = `CustomData` ns = `core`
                      )->a( n = `key`        v = `rowkind`
                      )->a( n = `value`      v = |\{= $\{KIND\} === '{ cs_kind-total }' ? 'T' : $\{KIND\} === '{ cs_kind-subtotal }' ? 'S' : 'I' \}|
                      )->a( n = `writeToDom` b = abap_true ).

    ENDLOOP.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
