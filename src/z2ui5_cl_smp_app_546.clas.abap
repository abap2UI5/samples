" @keywords large table window windowed _bind_tab _bind_path growing paging lazy loading server sort server filter search binding_call follow_up_action big data 10000 rows performance selection
" @summary 10,000 products in a growing sap.m.Table with _bind_tab( ): 200 rows at a time in the browser, search and sort on the server over all rows, the selection back in its own row.
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

    "! all 10,000 rows - they stay here, the browser gets a window of them
    DATA t_product TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_order.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_546 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( `ORDER` ).
      on_order( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    DATA(t_adjective) = VALUE string_table( ( `Compact` ) ( `Classic` ) ( `Smart` ) ( `Ultra` ) ( `Eco` )
                                            ( `Pro` ) ( `Mini` ) ( `Rugged` ) ( `Silent` ) ( `Wireless` ) ).
    DATA(t_noun) = VALUE string_table( ( `Notebook` ) ( `Monitor` ) ( `Keyboard` ) ( `Mouse` ) ( `Printer` )
                                       ( `Headset` ) ( `Router` ) ( `Webcam` ) ( `Speaker` ) ( `Docking Station` ) ).
    DATA(t_category) = VALUE string_table( ( `Computers` ) ( `Displays` ) ( `Accessories` ) ( `Office` ) ( `Network` ) ).

    DO 10000 TIMES.
      DATA(index) = sy-index.
      APPEND VALUE #(
          id       = index
          name     = |{ t_adjective[ ( index MOD 10 ) + 1 ] } { t_noun[ ( ( index DIV 10 ) MOD 10 ) + 1 ] } { index }|
          category = t_category[ ( index MOD 5 ) + 1 ]
          price    = ( ( index * 7919 ) MOD 100000 ) / 100
          stock    = ( index * 31 ) MOD 500 ) TO t_product.
    ENDDO.

    view_display( ).

  ENDMETHOD.


  METHOD on_order.

    " the checkboxes the user ticked arrive in the rows they were ticked
    " in - whatever the search and the sort showed - so the order runs
    " over all 10,000 rows, the ones the browser never held included
    DATA count TYPE i.
    DATA total TYPE p LENGTH 15 DECIMALS 2.
    LOOP AT t_product INTO DATA(s_product) WHERE selected = abap_true.
      count = count + 1.
      total = total + s_product-price.
    ENDLOOP.

    IF count = 0.
      client->message_toast_display( `Tick a product first.` ).
      RETURN.
    ENDIF.
    client->message_box_display( |{ count } product(s) ordered, { total } EUR in total.| ).

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
        )->a( n = `text`     v = `The table is bound with _bind_tab( val = t_product window = 200 ): the 10,000 rows stay in ` &&
                   `the app, the browser gets 200 of them and asks the server for the next 200 when More reaches ` &&
                   `the end - without calling the app. The search and the two sort buttons are binding calls, and ` &&
                   `the binding hands them to the server, which sorts and filters all rows. Tick some products and ` &&
                   `order them: the app finds them in its own table.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " the window state the server sends along: the rows the search lets through
    DATA(total) = |\{/__WINDOW{ client->_bind_path( t_product ) }/TOTAL\}|.

    DATA(table) = page->ele( `Table`
        )->a( n = `id`               v = `products`
        )->a( n = `items`            v = client->_bind_tab( val    = t_product
                                                            window = 200 )
        )->a( n = `growing`          v = `true`
        )->a( n = `growingThreshold` v = `50`
        )->a( n = `class`            v = `sapUiSmallMarginBeginEnd` ).

    table->ele( `headerToolbar`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Products`
            )->tag( `ObjectNumber`
                " abap2ui5lint-disable-next-line unknown-binding-path -- /__WINDOW is the window state the framework sends next to a table bound with _bind_tab( )
                )->a( n = `number` v = total
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

ENDCLASS.
