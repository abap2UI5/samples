" @keywords large table window windowed window_bind_tab ty_s_window_request r_event_data cs_window_reason link grid table scrolling lazy loading skip top odata server sort server filter column menu sortproperty filterproperty 10000 rows
" @summary 10,000 orders in a sap.ui.table.Table with window_bind_tab( ): the app loads 100 rows at a time as the user scrolls, the newest first, and sorts and filters itself when the column menu asks - like an OData service.
CLASS z2ui5_cl_smp_app_547 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_order,
        id       TYPE i,
        customer TYPE string,
        city     TYPE string,
        status   TYPE string,
        amount   TYPE p LENGTH 10 DECIMALS 2,
        created  TYPE d,
      END OF ty_s_order.
    TYPES ty_t_order TYPE STANDARD TABLE OF ty_s_order WITH EMPTY KEY.

    "! the rows loaded so far - exactly what the grid shows
    DATA t_order TYPE ty_t_order.
    "! how many rows the filter lets through - the length of the scrollbar
    DATA total TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    "! the "database": 10,000 rows - in a real app a SELECT reads windows of a table
    DATA t_db TYPE ty_t_order.
    "! the order and the filter of the column menu - the app's own order first
    DATA t_sort TYPE z2ui5_if_client=>ty_t_bind_tab_sort.
    DATA t_filter TYPE z2ui5_if_client=>ty_t_bind_tab_filter.

    METHODS view_display.
    METHODS on_open.
    METHODS on_rows.
    METHODS model_init.
    "! rows skip + 1 to skip + top in the order and the filter asked for -
    "! a SELECT ... WHERE ... ORDER BY ... OFFSET skip UP TO top ROWS
    METHODS load
      IMPORTING
        skip TYPE i
        top  TYPE i.
    "! the conditions of one group ORed, the groups ANDed - the way the
    "! column menu combines them
    METHODS check_match
      IMPORTING
        s_order       TYPE ty_s_order
      RETURNING
        VALUE(result) TYPE abap_bool.
    METHODS check_condition
      IMPORTING
        s_order       TYPE ty_s_order
        s_filter      TYPE z2ui5_if_client=>ty_s_bind_tab_filter
      RETURNING
        VALUE(result) TYPE abap_bool.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_547 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      model_init( ).
      " the app's own order: the newest first
      t_sort = VALUE #( ( path = `CREATED` descending = abap_true ) ).
      load( skip = 0
            top  = 100 ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( `ROWS` ).
      on_rows( ).
    ELSEIF client->check_on_event( `OPEN` ).
      on_open( ).
    ENDIF.

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
            )->a( n = `title`          v = `abap2UI5 - Grid Table - 10,000 Rows, Column Sort and Filter on Server`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The table is bound with window_bind_tab( val = t_order total = total event = 'ROWS' ` &&
                   `window = 100 ): the app loads 100 of the 10,000 orders, the newest first, and says how many there ` &&
                   `are. Scroll down, or sort or filter a column from its menu, and the event ROWS arrives with the ` &&
                   `request in get( )-r_event_data: the app loads the next rows, or the first rows in the new order - ` &&
                   `like an OData service answering $skip, $top, $orderby and $filter. An order number opens the ` &&
                   `order the grid shows there: the row of t_order with that index.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(table) = page->ele( n = `Table` ns = `table`
        )->a( n = `rows`            v = client->window_bind_tab( val    = t_order
                                                                 total  = total
                                                                 event  = `ROWS`
                                                                 window = 100 )
        )->a( n = `selectionMode`   v = `None`
        )->a( n = `visibleRowCount` v = `15`
        )->a( n = `class`           v = `sapUiSmallMarginBeginEnd` ).

    table->ele( n = `extension` ns = `table`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Orders`
            )->tag( `ObjectNumber`
                )->a( n = `number` v = client->_bind( total )
                )->a( n = `unit`   v = `rows` ).

    " sortProperty and filterProperty switch the column menu on - the
    " binding sends what the user picks to the app (event ROWS)
    DATA(columns) = table->ele( n = `columns` ns = `table` ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `width`          v = `6rem`
        )->a( n = `sortProperty`   v = `ID`
        )->a( n = `filterProperty` v = `ID`
        )->tag( `Label`
            )->a( n = `text` v = `Order`
        )->ele( n = `template` ns = `table`
            )->tag( `Link`
                )->a( n = `text`  v = `{ID}`
                )->a( n = `press` v = client->_event( val = `OPEN`
                                                      arg = `$event.getSource().getBindingContext().getPath().split('/').pop()` ) ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `sortProperty`   v = `CUSTOMER`
        )->a( n = `filterProperty` v = `CUSTOMER`
        )->tag( `Label`
            )->a( n = `text` v = `Customer`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text`     v = `{CUSTOMER}`
                )->a( n = `wrapping` b = abap_false ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `sortProperty`   v = `CITY`
        )->a( n = `filterProperty` v = `CITY`
        )->tag( `Label`
            )->a( n = `text` v = `City`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{CITY}` ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `sortProperty`   v = `STATUS`
        )->a( n = `filterProperty` v = `STATUS`
        )->tag( `Label`
            )->a( n = `text` v = `Status`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{STATUS}` ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `hAlign`       v = `End`
        )->a( n = `sortProperty` v = `AMOUNT`
        )->tag( `Label`
            )->a( n = `text` v = `Amount (EUR)`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{AMOUNT}` ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `sortProperty` v = `CREATED`
        )->tag( `Label`
            )->a( n = `text` v = `Created`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{CREATED}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_rows.

    " the request of the list binding: more rows as the user scrolls, or
    " the first rows of a new sort or filter - SORT and FILTER carry the
    " whole state of the column menu
    FIELD-SYMBOLS <request> TYPE z2ui5_if_client=>ty_s_window_request.
    DATA(r_request) = client->get( )-r_event_data.
    ASSIGN r_request->* TO <request>.

    IF <request>-reason = z2ui5_if_client=>cs_window_reason-more.
      load( skip = lines( t_order )
            top  = <request>-top ).
      RETURN.
    ENDIF.

    t_sort   = <request>-t_sort.
    t_filter = <request>-t_filter.
    load( skip = 0
          top  = <request>-top ).

  ENDMETHOD.


  METHOD load.

    DATA t_hit TYPE ty_t_order.

    " WHERE: the filter of the column menu
    LOOP AT t_db INTO DATA(s_db).
      IF check_match( s_db ) = abap_true.
        INSERT s_db INTO TABLE t_hit.
      ENDIF.
    ENDLOOP.
    total = lines( t_hit ).

    " ORDER BY: the column sorted last
    DATA(s_sort) = VALUE #( t_sort[ 1 ] OPTIONAL ).
    IF s_sort-path IS NOT INITIAL.
      IF s_sort-descending = abap_true.
        SORT t_hit BY (s_sort-path) DESCENDING.
      ELSE.
        SORT t_hit BY (s_sort-path) ASCENDING.
      ENDIF.
    ENDIF.

    " OFFSET skip UP TO top ROWS
    IF skip = 0.
      CLEAR t_order.
    ENDIF.
    LOOP AT t_hit INTO s_db FROM skip + 1.
      IF lines( t_order ) >= skip + top.
        EXIT.
      ENDIF.
      INSERT s_db INTO TABLE t_order.
    ENDLOOP.

  ENDMETHOD.


  METHOD check_match.

    DATA group TYPE i.
    DATA hit TYPE abap_bool.

    result = abap_true.
    LOOP AT t_filter INTO DATA(s_filter).
      IF s_filter-group <> group.
        IF group IS NOT INITIAL AND hit = abap_false.
          result = abap_false.
          RETURN.
        ENDIF.
        group = s_filter-group.
        hit = abap_false.
      ENDIF.
      IF hit = abap_false.
        hit = check_condition( s_order  = s_order
                               s_filter = s_filter ).
      ENDIF.
    ENDLOOP.
    IF group IS NOT INITIAL AND hit = abap_false.
      result = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD check_condition.

    FIELD-SYMBOLS <cell> TYPE any.

    ASSIGN COMPONENT s_filter-path OF STRUCTURE s_order TO <cell>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    " the column menu sends text: compared as the grid shows it, without
    " regard to case
    DATA(text) = to_upper( |{ <cell> }| ).
    DATA(value) = to_upper( s_filter-value1 ).
    CASE s_filter-operator.
      WHEN `Contains`.
        result = xsdbool( text CS value ).
      WHEN `StartsWith`.
        result = xsdbool( text CP |{ value }*| ).
      WHEN `EndsWith`.
        result = xsdbool( text CP |*{ value }| ).
      WHEN `EQ`.
        result = xsdbool( text = value ).
      WHEN `NE`.
        result = xsdbool( text <> value ).
      WHEN OTHERS.
        " an operator this sample does not offer lets the row through
        result = abap_true.
    ENDCASE.

  ENDMETHOD.


  METHOD on_open.

    " the link names the row as the grid shows it - and t_order IS what
    " the grid shows, so the position is the row
    DATA(position) = CONV i( client->get_event_arg( ) ) + 1.
    IF position > lines( t_order ).
      RETURN.
    ENDIF.

    DATA(s_order) = t_order[ position ].
    client->message_box_display( |Order { s_order-id }: { s_order-customer }, { s_order-city }, | &&
                                 |{ s_order-status }, { s_order-amount } EUR.| ).

  ENDMETHOD.


  METHOD model_init.

    DATA(t_customer) = VALUE string_table( ( `Adler GmbH` ) ( `Berger AG` ) ( `Calder Ltd` ) ( `Dumont SA` ) ( `Eriksen AB` )
                                           ( `Ferrari Srl` ) ( `Garcia SL` ) ( `Hansen A/S` ) ( `Ivanov OOO` ) ( `Jansen BV` ) ).
    DATA(t_city) = VALUE string_table( ( `Berlin` ) ( `Zurich` ) ( `London` ) ( `Paris` ) ( `Stockholm` )
                                       ( `Milan` ) ( `Madrid` ) ( `Copenhagen` ) ( `Vienna` ) ( `Amsterdam` ) ).
    DATA(t_status) = VALUE string_table( ( `New` ) ( `In Process` ) ( `Shipped` ) ( `Delivered` ) ).
    DATA(start) = CONV d( `20250101` ).

    DO 10000 TIMES.
      DATA(index) = sy-index.
      INSERT VALUE #( id       = index
                      customer = t_customer[ ( ( index * 7 ) MOD 10 ) + 1 ]
                      city     = t_city[ ( ( index * 3 ) MOD 10 ) + 1 ]
                      status   = t_status[ ( index MOD 4 ) + 1 ]
                      amount   = ( ( index * 6151 ) MOD 500000 ) / 100
                      created  = start + ( ( index * 13 ) MOD 365 ) ) INTO TABLE t_db.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
