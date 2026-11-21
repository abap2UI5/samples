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
    TYPES ty_t_order TYPE STANDARD TABLE OF ty_s_order WITH DEFAULT KEY.

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
      DATA temp1 TYPE z2ui5_if_client=>ty_t_bind_tab_sort.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      " the app's own order: the newest first
      
      CLEAR temp1.
      
      temp2-path = `CREATED`.
      temp2-descending = abap_true.
      INSERT temp2 INTO TABLE temp1.
      t_sort = temp1.
      load( skip = 0
            top  = 100 ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( `ROWS` ) IS NOT INITIAL.
      on_rows( ).
    ELSEIF client->check_on_event( `OPEN` ) IS NOT INITIAL.
      on_open( ).
    ENDIF.

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

    
    table = page->ele( n = `Table` ns = `table`
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
    
    columns = table->ele( n = `columns` ns = `table` ).

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
    DATA r_request TYPE REF TO data.
    r_request = client->get( )-r_event_data.
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
    DATA s_db LIKE LINE OF t_db.
    DATA temp3 TYPE z2ui5_if_client=>ty_s_bind_tab_sort.
    DATA temp4 TYPE z2ui5_if_client=>ty_s_bind_tab_sort.
    DATA s_sort LIKE temp3.
    LOOP AT t_db INTO s_db.
      IF check_match( s_db ) = abap_true.
        APPEND s_db TO t_hit.
      ENDIF.
    ENDLOOP.
    total = lines( t_hit ).

    " ORDER BY: the column sorted last
    
    CLEAR temp3.
    
    READ TABLE t_sort INTO temp4 INDEX 1.
    IF sy-subrc = 0.
      temp3 = temp4.
    ENDIF.
    
    s_sort = temp3.
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
      APPEND s_db TO t_order.
    ENDLOOP.

  ENDMETHOD.


  METHOD check_match.

    DATA group TYPE i.
    DATA hit TYPE abap_bool.
    DATA s_filter LIKE LINE OF t_filter.

    result = abap_true.
    
    LOOP AT t_filter INTO s_filter.
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
    DATA text TYPE string.
    DATA value TYPE string.
        DATA temp1 TYPE xsdboolean.
        DATA temp2 TYPE xsdboolean.
        DATA temp3 TYPE xsdboolean.
        DATA temp4 TYPE xsdboolean.
        DATA temp5 TYPE xsdboolean.

    ASSIGN COMPONENT s_filter-path OF STRUCTURE s_order TO <cell>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    " the column menu sends text: compared as the grid shows it, without
    " regard to case
    
    text = to_upper( |{ <cell> }| ).
    
    value = to_upper( s_filter-value1 ).
    CASE s_filter-operator.
      WHEN `Contains`.
        
        temp1 = boolc( text CS value ).
        result = temp1.
      WHEN `StartsWith`.
        
        temp2 = boolc( text CP |{ value }*| ).
        result = temp2.
      WHEN `EndsWith`.
        
        temp3 = boolc( text CP |*{ value }| ).
        result = temp3.
      WHEN `EQ`.
        
        temp4 = boolc( text = value ).
        result = temp4.
      WHEN `NE`.
        
        temp5 = boolc( text <> value ).
        result = temp5.
      WHEN OTHERS.
        " an operator this sample does not offer lets the row through
        result = abap_true.
    ENDCASE.

  ENDMETHOD.


  METHOD on_open.

    " the link names the row as the grid shows it - and t_order IS what
    " the grid shows, so the position is the row
    DATA temp5 TYPE i.
    DATA position TYPE i.
    DATA s_order LIKE LINE OF t_order.
    FIELD-SYMBOLS <temp1> LIKE LINE OF t_order.
    DATA temp2 LIKE sy-tabix.
    temp5 = client->get_event_arg( ).
    
    position = temp5 + 1.
    IF position > lines( t_order ).
      RETURN.
    ENDIF.

    
    
    
    temp2 = sy-tabix.
    READ TABLE t_order INDEX position ASSIGNING <temp1>.
    sy-tabix = temp2.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    s_order = <temp1>.
    client->message_box_display( |Order { s_order-id }: { s_order-customer }, { s_order-city }, | &&
                                 |{ s_order-status }, { s_order-amount } EUR.| ).

  ENDMETHOD.


  METHOD model_init.

    DATA temp6 TYPE string_table.
    DATA t_customer LIKE temp6.
    DATA temp8 TYPE string_table.
    DATA t_city LIKE temp8.
    DATA temp10 TYPE string_table.
    DATA t_status LIKE temp10.
    DATA temp12 TYPE d.
    DATA start LIKE temp12.
      DATA index LIKE sy-index.
      DATA temp13 TYPE z2ui5_cl_smp_app_547=>ty_s_order.
      FIELD-SYMBOLS <temp3> LIKE LINE OF t_customer.
      DATA temp4 LIKE sy-tabix.
      FIELD-SYMBOLS <temp5> LIKE LINE OF t_city.
      DATA temp7 LIKE sy-tabix.
      FIELD-SYMBOLS <temp8> LIKE LINE OF t_status.
      DATA temp9 LIKE sy-tabix.
    CLEAR temp6.
    INSERT `Adler GmbH` INTO TABLE temp6.
    INSERT `Berger AG` INTO TABLE temp6.
    INSERT `Calder Ltd` INTO TABLE temp6.
    INSERT `Dumont SA` INTO TABLE temp6.
    INSERT `Eriksen AB` INTO TABLE temp6.
    INSERT `Ferrari Srl` INTO TABLE temp6.
    INSERT `Garcia SL` INTO TABLE temp6.
    INSERT `Hansen A/S` INTO TABLE temp6.
    INSERT `Ivanov OOO` INTO TABLE temp6.
    INSERT `Jansen BV` INTO TABLE temp6.
    
    t_customer = temp6.
    
    CLEAR temp8.
    INSERT `Berlin` INTO TABLE temp8.
    INSERT `Zurich` INTO TABLE temp8.
    INSERT `London` INTO TABLE temp8.
    INSERT `Paris` INTO TABLE temp8.
    INSERT `Stockholm` INTO TABLE temp8.
    INSERT `Milan` INTO TABLE temp8.
    INSERT `Madrid` INTO TABLE temp8.
    INSERT `Copenhagen` INTO TABLE temp8.
    INSERT `Vienna` INTO TABLE temp8.
    INSERT `Amsterdam` INTO TABLE temp8.
    
    t_city = temp8.
    
    CLEAR temp10.
    INSERT `New` INTO TABLE temp10.
    INSERT `In Process` INTO TABLE temp10.
    INSERT `Shipped` INTO TABLE temp10.
    INSERT `Delivered` INTO TABLE temp10.
    
    t_status = temp10.
    
    temp12 = `20250101`.
    
    start = temp12.

    DO 10000 TIMES.
      
      index = sy-index.
      
      CLEAR temp13.
      temp13-id = index.
      
      
      temp4 = sy-tabix.
      READ TABLE t_customer INDEX ( ( index * 7 ) MOD 10 ) + 1 ASSIGNING <temp3>.
      sy-tabix = temp4.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      temp13-customer = <temp3>.
      
      
      temp7 = sy-tabix.
      READ TABLE t_city INDEX ( ( index * 3 ) MOD 10 ) + 1 ASSIGNING <temp5>.
      sy-tabix = temp7.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      temp13-city = <temp5>.
      
      
      temp9 = sy-tabix.
      READ TABLE t_status INDEX ( index MOD 4 ) + 1 ASSIGNING <temp8>.
      sy-tabix = temp9.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      temp13-status = <temp8>.
      temp13-amount = ( ( index * 6151 ) MOD 500000 ) / 100.
      temp13-created = start + ( ( index * 13 ) MOD 365 ).
      APPEND temp13 TO t_db.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
