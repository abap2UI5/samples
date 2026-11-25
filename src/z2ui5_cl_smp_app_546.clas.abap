" @keywords large table window windowed window_bind_tab ty_s_window_request r_event_data _bind_path row press details growing paging lazy loading skip top odata server sort server filter search binding_call follow_up_action 10000 rows selection
" @summary 10,000 products in a growing sap.m.Table with window_bind_tab( ): the app loads 200 rows at a time, and searches and sorts itself when the binding asks - like an OData service.
CLASS z2ui5_cl_smp_app_546 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        id       TYPE i,
        name     TYPE string,
        category TYPE string,
        price    TYPE p LENGTH 10 DECIMALS 2,
        stock    TYPE i,
        selected TYPE abap_bool,
      END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    "! the rows loaded so far - exactly what the browser shows
    DATA t_product TYPE ty_t_product.
    "! how many rows the search lets through - the length the table shows
    DATA total TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    "! the "database": 10,000 rows - in a real app a SELECT reads windows of a table
    DATA t_db TYPE ty_t_product.
    "! the order and the search the binding asked for last
    DATA t_sort TYPE z2ui5_if_client=>ty_t_bind_tab_sort.
    DATA t_filter TYPE z2ui5_if_client=>ty_t_bind_tab_filter.

    METHODS view_display.
    METHODS on_order.
    METHODS on_details.
    METHODS on_rows.
    METHODS model_init.
    "! rows skip + 1 to skip + top in the order and the search asked for -
    "! a SELECT ... ORDER BY ... WHERE ... OFFSET skip UP TO top ROWS
    METHODS load
      IMPORTING
        skip TYPE i
        top  TYPE i.
    "! the ticked checkboxes of the loaded rows back into the database rows
    METHODS selection_save.
    METHODS check_match
      IMPORTING
        s_product     TYPE ty_s_product
      RETURNING
        VALUE(result) TYPE abap_bool.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_546 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      model_init( ).
      load( skip = 0
            top  = 200 ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( `ROWS` ).
      on_rows( ).
    ELSEIF client->check_on_event( `ORDER` ).
      on_order( ).
    ELSEIF client->check_on_event( `DETAILS` ).
      on_details( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).
    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Table - 10,000 Rows in Windows, Server Search and Sort`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The table is bound with window_bind_tab( val = t_product total = total event = 'ROWS' ` &&
                   `window = 200 ): the app loads 200 of the 10,000 products and says how many there are. When More ` &&
                   `reaches the end, or the search or a sort button changes the binding, the event ROWS arrives with ` &&
                   `the request in get( )-r_event_data - the app loads the next rows, or the first rows of the new ` &&
                   `order, like an OData service answering $skip, $top, $orderby and $filter. A pressed row is the ` &&
                   `row of t_product with that index. Tick some products and order them.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(table) = page->ele( `Table`
        )->a( n = `id`               v = `products`
        )->a( n = `items`            v = client->window_bind_tab( val    = t_product
                                                                  total  = total
                                                                  event  = `ROWS`
                                                                  window = 200 )
        )->a( n = `growing`          v = `true`
        )->a( n = `growingThreshold` v = `50`
        )->a( n = `class`            v = `sapUiSmallMarginBeginEnd` ).

    table->ele( `headerToolbar`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Products`
            )->tag( `ObjectNumber`
                )->a( n = `number` v = client->_bind( total )
                )->a( n = `unit`   v = `rows`
            )->tag( `ToolbarSpacer`
            )->tag( `SearchField`
                )->a( n = `width`       v = `16rem`
                )->a( n = `placeholder` v = `Search the name`
                )->a( n = `search`      v = client->follow_up_action( val   = client->cs_event-binding_call
                                                                      t_arg = VALUE #( ( `products` )
                                                                                       ( `items` )
                                                                                       ( `filter` )
                                                                                       ( `NAME` )
                                                                                       ( `Contains` )
                                                                                       ( `${$parameters>/query}` ) ) )
            )->tag( `Button`
                )->a( n = `text`  v = `Cheapest First`
                )->a( n = `icon`  v = `sap-icon://sort-ascending`
                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-binding_call
                                                                t_arg = VALUE #( ( `products` )
                                                                                 ( `items` )
                                                                                 ( `sort` )
                                                                                 ( `PRICE` ) ) )
            )->tag( `Button`
                )->a( n = `text`  v = `Most Expensive First`
                )->a( n = `icon`  v = `sap-icon://sort-descending`
                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-binding_call
                                                                t_arg = VALUE #( ( `products` )
                                                                                 ( `items` )
                                                                                 ( `sort` )
                                                                                 ( `PRICE` )
                                                                                 ( `X` ) ) ) ).

    table->ele( `columns`
        )->ele( `Column`
            )->a( n = `width` v = `4rem`
            )->tag( `Text`
                )->a( n = `text` v = `Order`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Product`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Category`
        )->end(
        )->ele( `Column`
            )->a( n = `hAlign` v = `End`
            )->tag( `Text`
                )->a( n = `text` v = `Price`
        )->end(
        )->ele( `Column`
            )->a( n = `hAlign` v = `End`
            )->tag( `Text`
                )->a( n = `text` v = `Stock` ).

    table->ele( `items`
        )->ele( `ColumnListItem`
            )->a( n = `type`  v = `Active`
            )->a( n = `press` v = client->_event( val = `DETAILS`
                                                  arg = `$event.getSource().getBindingContext().getPath().split('/').pop()` )
            )->ele( `cells`
                )->tag( `CheckBox`
                    )->a( n = `selected` v = `{SELECTED}`
                )->tag( `Text`
                    )->a( n = `text` v = `{NAME}`
                )->tag( `Text`
                    )->a( n = `text` v = `{CATEGORY}`
                )->tag( `ObjectNumber`
                    )->a( n = `number` v = `{PRICE}`
                    )->a( n = `unit`   v = `EUR`
                )->tag( `Text`
                    )->a( n = `text` v = `{STOCK}` ).

    page->ele( `footer`
        )->ele( `OverflowToolbar`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `text`  v = `Order Ticked Products`
                )->a( n = `type`  v = `Emphasized`
                )->a( n = `press` v = client->_event( `ORDER` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_rows.

    " the request of the list binding: more rows, or the first rows of a
    " new search or sort - SORT and FILTER carry the whole state of both
    FIELD-SYMBOLS <request> TYPE z2ui5_if_client=>ty_s_window_request.
    DATA(r_request) = client->get( )-r_event_data.
    ASSIGN r_request->* TO <request>.

    selection_save( ).
    IF <request>-reason = z2ui5_if_client=>cs_window_reason-more.
      load( skip = lines( t_product )
            top  = <request>-top ).
      RETURN.
    ENDIF.

    t_sort   = <request>-t_sort.
    t_filter = <request>-t_filter.
    load( skip = 0
          top  = <request>-top ).

  ENDMETHOD.


  METHOD load.

    DATA t_hit TYPE ty_t_product.

    " WHERE: the search
    LOOP AT t_db INTO DATA(s_db).
      IF check_match( s_db ) = abap_true.
        INSERT s_db INTO TABLE t_hit.
      ENDIF.
    ENDLOOP.
    total = lines( t_hit ).

    " ORDER BY: the sort button pressed last
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
      CLEAR t_product.
    ENDIF.
    LOOP AT t_hit INTO s_db FROM skip + 1.
      IF lines( t_product ) >= skip + top.
        EXIT.
      ENDIF.
      INSERT s_db INTO TABLE t_product.
    ENDLOOP.

  ENDMETHOD.


  METHOD check_match.

    " the search field sends one condition: NAME Contains the query
    result = abap_true.
    LOOP AT t_filter INTO DATA(s_filter) WHERE path = `NAME` AND value1 IS NOT INITIAL.
      IF to_upper( s_product-name ) NS to_upper( s_filter-value1 ).
        result = abap_false.
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD selection_save.

    " the database row of a product is its id - the rows were built that way
    LOOP AT t_product INTO DATA(s_product).
      t_db[ s_product-id ]-selected = s_product-selected.
    ENDLOOP.

  ENDMETHOD.


  METHOD on_details.

    " the event names the row as the browser shows it - and t_product IS
    " what the browser shows, so the position is the row
    DATA(position) = CONV i( client->get_event_arg( ) ) + 1.
    IF position > lines( t_product ).
      RETURN.
    ENDIF.

    DATA(s_product) = t_product[ position ].
    client->message_box_display( |{ s_product-name } - row { position } of the list: | &&
                                 |{ s_product-category }, { s_product-price } EUR, { s_product-stock } in stock.| ).

  ENDMETHOD.


  METHOD on_order.

    " the checkboxes of the loaded rows are saved into the database rows
    " each time the app loads others - so the order runs over every row
    " the user ticked, whatever the search and the sort showed since
    DATA count TYPE i.
    DATA amount TYPE p LENGTH 15 DECIMALS 2.
    selection_save( ).
    LOOP AT t_db INTO DATA(s_product) WHERE selected = abap_true.
      count = count + 1.
      amount = amount + s_product-price.
    ENDLOOP.

    IF count = 0.
      client->message_toast_display( `Tick a product first.` ).
      RETURN.
    ENDIF.
    client->message_box_display( |{ count } product(s) ordered, { amount } EUR in total.| ).

  ENDMETHOD.


  METHOD model_init.

    DATA(t_adjective) = VALUE string_table( ( `Compact` ) ( `Classic` ) ( `Smart` ) ( `Ultra` ) ( `Eco` )
                                            ( `Pro` ) ( `Mini` ) ( `Rugged` ) ( `Silent` ) ( `Wireless` ) ).
    DATA(t_noun) = VALUE string_table( ( `Notebook` ) ( `Monitor` ) ( `Keyboard` ) ( `Mouse` ) ( `Printer` )
                                       ( `Headset` ) ( `Router` ) ( `Webcam` ) ( `Speaker` ) ( `Docking Station` ) ).
    DATA(t_category) = VALUE string_table( ( `Computers` ) ( `Displays` ) ( `Accessories` ) ( `Office` ) ( `Network` ) ).

    DO 10000 TIMES.
      DATA(index) = sy-index.
      INSERT VALUE #(
          id       = index
          name     = |{ t_adjective[ ( index MOD 10 ) + 1 ] } { t_noun[ ( ( index DIV 10 ) MOD 10 ) + 1 ] } { index }|
          category = t_category[ ( index MOD 5 ) + 1 ]
          price    = ( ( index * 7919 ) MOD 100000 ) / 100
          stock    = ( index * 31 ) MOD 500 ) INTO TABLE t_db.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
