" @keywords large table window windowed window_bind_tab t_sort window_get_row _bind_path link grid table scrolling lazy loading server sort server filter column menu sortproperty filterproperty big data 10000 rows performance
" @summary 10,000 orders in a sap.ui.table.Table with window_bind_tab( ): the newest first, the browser holds 100 rows and fetches more as the user scrolls, and the column menu sorts and filters all rows on the server.
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

    "! all 10,000 rows - they stay here, the browser gets a window of them
    DATA t_order TYPE ty_t_order.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_open.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_547 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( `OPEN` ) IS NOT INITIAL.
      on_open( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA total TYPE string.
    DATA temp1 TYPE z2ui5_if_client=>ty_t_bind_tab_sort.
    DATA temp2 LIKE LINE OF temp1.
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
        )->a( n = `text`     v = `The table is bound with window_bind_tab( val = t_order window = 100 ): the 10,000 orders stay in ` &&
                   `the app and the browser holds 100 of them, the newest first - the order the app passes in ` &&
                   `t_sort. Scroll down and the binding fetches the next ` &&
                   `window from the server - without calling the app. Sort or filter a column from its menu: the ` &&
                   `server sorts and filters all 10,000 rows and sends the first window of the result. An order number ` &&
                   `opens the order the grid shows there - window_get_row( ) finds it in the table.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " the window state the server sends along: the rows the filter lets through
    
    total = |\{/__WINDOW{ client->_bind_path( t_order ) }/TOTAL\}|.

    " t_sort: the app's own order, the newest first - the column menu sorts
    " anew on the server, and a render with the same t_sort keeps that
    
    CLEAR temp1.
    
    temp2-path = `CREATED`.
    temp2-descending = abap_true.
    INSERT temp2 INTO TABLE temp1.
    
    table = page->ele( n = `Table` ns = `table`
        )->a( n = `rows`            v = client->window_bind_tab( val    = t_order
                                                                 window = 100
                                                                 t_sort = temp1 )
        )->a( n = `selectionMode`   v = `None`
        )->a( n = `visibleRowCount` v = `15`
        )->a( n = `class`           v = `sapUiSmallMarginBeginEnd` ).

    table->ele( n = `extension` ns = `table`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Orders`
            )->tag( `ObjectNumber`
                " abap2ui5lint-disable-next-line unknown-binding-path -- /__WINDOW is the window state the framework sends next to a table bound with window_bind_tab( )
                )->a( n = `number` v = total
                )->a( n = `unit`   v = `rows` ).

    " sortProperty and filterProperty switch the column menu on - the
    " binding sends what the user picks to the server
    
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


  METHOD on_open.

    " the link names the row as the grid shows it - sorted and filtered by
    " the server, so a position, not a row of t_order: window_get_row( )
    " answers which row it is
    DATA temp3 TYPE i.
    DATA row TYPE i.
    DATA s_order LIKE LINE OF t_order.
    FIELD-SYMBOLS <temp1> LIKE LINE OF t_order.
    DATA temp2 LIKE sy-tabix.
    temp3 = client->get_event_arg( ).
    
    row = client->window_get_row( val = t_order
                                        row = temp3 + 1 ).
    IF row = 0.
      RETURN.
    ENDIF.

    
    
    
    temp2 = sy-tabix.
    READ TABLE t_order INDEX row ASSIGNING <temp1>.
    sy-tabix = temp2.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    s_order = <temp1>.
    client->message_box_display( |Order { s_order-id }: { s_order-customer }, { s_order-city }, | &&
                                 |{ s_order-status }, { s_order-amount } EUR.| ).

  ENDMETHOD.


  METHOD model_init.

    DATA temp4 TYPE string_table.
    DATA t_customer LIKE temp4.
    DATA temp6 TYPE string_table.
    DATA t_city LIKE temp6.
    DATA temp8 TYPE string_table.
    DATA t_status LIKE temp8.
    DATA temp10 TYPE d.
    DATA start LIKE temp10.
      DATA index LIKE sy-index.
      DATA temp11 TYPE z2ui5_cl_smp_app_547=>ty_s_order.
      FIELD-SYMBOLS <temp3> LIKE LINE OF t_customer.
      DATA temp5 LIKE sy-tabix.
      FIELD-SYMBOLS <temp6> LIKE LINE OF t_city.
      DATA temp7 LIKE sy-tabix.
      FIELD-SYMBOLS <temp8> LIKE LINE OF t_status.
      DATA temp9 LIKE sy-tabix.
    CLEAR temp4.
    INSERT `Adler GmbH` INTO TABLE temp4.
    INSERT `Berger AG` INTO TABLE temp4.
    INSERT `Calder Ltd` INTO TABLE temp4.
    INSERT `Dumont SA` INTO TABLE temp4.
    INSERT `Eriksen AB` INTO TABLE temp4.
    INSERT `Ferrari Srl` INTO TABLE temp4.
    INSERT `Garcia SL` INTO TABLE temp4.
    INSERT `Hansen A/S` INTO TABLE temp4.
    INSERT `Ivanov OOO` INTO TABLE temp4.
    INSERT `Jansen BV` INTO TABLE temp4.
    
    t_customer = temp4.
    
    CLEAR temp6.
    INSERT `Berlin` INTO TABLE temp6.
    INSERT `Zurich` INTO TABLE temp6.
    INSERT `London` INTO TABLE temp6.
    INSERT `Paris` INTO TABLE temp6.
    INSERT `Stockholm` INTO TABLE temp6.
    INSERT `Milan` INTO TABLE temp6.
    INSERT `Madrid` INTO TABLE temp6.
    INSERT `Copenhagen` INTO TABLE temp6.
    INSERT `Vienna` INTO TABLE temp6.
    INSERT `Amsterdam` INTO TABLE temp6.
    
    t_city = temp6.
    
    CLEAR temp8.
    INSERT `New` INTO TABLE temp8.
    INSERT `In Process` INTO TABLE temp8.
    INSERT `Shipped` INTO TABLE temp8.
    INSERT `Delivered` INTO TABLE temp8.
    
    t_status = temp8.
    
    temp10 = `20250101`.
    
    start = temp10.

    DO 10000 TIMES.
      
      index = sy-index.
      
      CLEAR temp11.
      temp11-id = index.
      
      
      temp5 = sy-tabix.
      READ TABLE t_customer INDEX ( ( index * 7 ) MOD 10 ) + 1 ASSIGNING <temp3>.
      sy-tabix = temp5.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      temp11-customer = <temp3>.
      
      
      temp7 = sy-tabix.
      READ TABLE t_city INDEX ( ( index * 3 ) MOD 10 ) + 1 ASSIGNING <temp6>.
      sy-tabix = temp7.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      temp11-city = <temp6>.
      
      
      temp9 = sy-tabix.
      READ TABLE t_status INDEX ( index MOD 4 ) + 1 ASSIGNING <temp8>.
      sy-tabix = temp9.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      temp11-status = <temp8>.
      temp11-amount = ( ( index * 6151 ) MOD 500000 ) / 100.
      temp11-created = start + ( ( index * 13 ) MOD 365 ).
      APPEND temp11 TO t_order.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
