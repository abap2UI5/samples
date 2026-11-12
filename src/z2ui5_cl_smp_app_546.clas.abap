" @keywords large table window windowed window_bind_tab window_get_row _bind_path row press details growing paging lazy loading server sort server filter search binding_call follow_up_action big data 10000 rows performance selection
" @summary 10,000 products in a growing sap.m.Table with window_bind_tab( ): 200 rows at a time in the browser, search and sort on the server over all rows, the selection back in its own row.
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
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    "! all 10,000 rows - they stay here, the browser gets a window of them
    DATA t_product TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_order.
    METHODS on_details.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_546 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( `ORDER` ) IS NOT INITIAL.
      on_order( ).
    ELSEIF client->check_on_event( `DETAILS` ) IS NOT INITIAL.
      on_details( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA total TYPE string.
    DATA table TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Table - 10,000 Rows in Windows, Server Search and Sort`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The table is bound with window_bind_tab( val = t_product window = 200 ): the 10,000 rows stay in ` &&
                   `the app, the browser gets 200 of them and asks the server for the next 200 when More reaches ` &&
                   `the end - without calling the app. The search and the two sort buttons are binding calls, and ` &&
                   `the binding hands them to the server, which sorts and filters all rows. Press a row: the app ` &&
                   `finds it in its own table with window_get_row( ). Tick some products and order them.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " the window state the server sends along: the rows the search lets through
    
    total = |\{/__WINDOW{ client->_bind_path( t_product ) }/TOTAL\}|.

    
    table = page->ele( `Table`
        )->a( n = `id`               v = `products`
        )->a( n = `items`            v = client->window_bind_tab( val    = t_product
                                                                  window = 200 )
        )->a( n = `growing`          v = `true`
        )->a( n = `growingThreshold` v = `50`
        )->a( n = `class`            v = `sapUiSmallMarginBeginEnd` ).

    
    CLEAR temp1.
    INSERT `products` INTO TABLE temp1.
    INSERT `items` INTO TABLE temp1.
    INSERT `filter` INTO TABLE temp1.
    INSERT `NAME` INTO TABLE temp1.
    INSERT `Contains` INTO TABLE temp1.
    INSERT `${$parameters>/query}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `products` INTO TABLE temp2.
    INSERT `items` INTO TABLE temp2.
    INSERT `sort` INTO TABLE temp2.
    INSERT `PRICE` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `products` INTO TABLE temp3.
    INSERT `items` INTO TABLE temp3.
    INSERT `sort` INTO TABLE temp3.
    INSERT `PRICE` INTO TABLE temp3.
    INSERT `X` INTO TABLE temp3.
    table->ele( `headerToolbar`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Products`
            )->tag( `ObjectNumber`
                " abap2ui5lint-disable-next-line unknown-binding-path -- /__WINDOW is the window state the framework sends next to a table bound with window_bind_tab( )
                )->a( n = `number` v = total
                )->a( n = `unit`   v = `rows`
            )->tag( `ToolbarSpacer`
            )->tag( `SearchField`
                )->a( n = `width`       v = `16rem`
                )->a( n = `placeholder` v = `Search the name`
                )->a( n = `search`      v = client->follow_up_action( val   = client->cs_event-binding_call
                                                                      t_arg = temp1 )
            )->tag( `Button`
                )->a( n = `text`  v = `Cheapest First`
                )->a( n = `icon`  v = `sap-icon://sort-ascending`
                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-binding_call
                                                                t_arg = temp2 )
            )->tag( `Button`
                )->a( n = `text`  v = `Most Expensive First`
                )->a( n = `icon`  v = `sap-icon://sort-descending`
                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-binding_call
                                                                t_arg = temp3 ) ).

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


  METHOD on_details.

    " the event names the row as the browser shows it - after a search or
    " a sort that is a position in the server's order, not a row of
    " t_product. window_get_row( ) answers which row it is
    DATA temp3 TYPE i.
    DATA position TYPE i.
    DATA row TYPE i.
    DATA s_product LIKE LINE OF t_product.
    FIELD-SYMBOLS <temp4> LIKE LINE OF t_product.
    DATA temp5 LIKE sy-tabix.
    temp3 = client->get_event_arg( ).
    
    position = temp3 + 1.
    
    row = client->window_get_row( val = t_product
                                        row = position ).
    IF row = 0.
      RETURN.
    ENDIF.

    
    
    
    temp5 = sy-tabix.
    READ TABLE t_product INDEX row ASSIGNING <temp4>.
    sy-tabix = temp5.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    s_product = <temp4>.
    client->message_box_display( |{ s_product-name } - row { row } of the table, shown as row { position }: | &&
                                 |{ s_product-category }, { s_product-price } EUR, { s_product-stock } in stock.| ).

  ENDMETHOD.


  METHOD on_order.

    " the checkboxes the user ticked arrive in the rows they were ticked
    " in - whatever the search and the sort showed - so the order runs
    " over all 10,000 rows, the ones the browser never held included
    DATA count TYPE i.
    DATA total TYPE p LENGTH 15 DECIMALS 2.
    DATA s_product LIKE LINE OF t_product.
    LOOP AT t_product INTO s_product WHERE selected = abap_true.
      count = count + 1.
      total = total + s_product-price.
    ENDLOOP.

    IF count = 0.
      client->message_toast_display( `Tick a product first.` ).
      RETURN.
    ENDIF.
    client->message_box_display( |{ count } product(s) ordered, { total } EUR in total.| ).

  ENDMETHOD.


  METHOD model_init.

    DATA temp4 TYPE string_table.
    DATA t_adjective LIKE temp4.
    DATA temp6 TYPE string_table.
    DATA t_noun LIKE temp6.
    DATA temp8 TYPE string_table.
    DATA t_category LIKE temp8.
      DATA index LIKE sy-index.
      DATA temp10 TYPE z2ui5_cl_smp_app_546=>ty_s_product.
      FIELD-SYMBOLS <temp6> LIKE LINE OF t_adjective.
      DATA temp7 LIKE sy-tabix.
      FIELD-SYMBOLS <temp5> LIKE LINE OF t_noun.
      DATA temp11 LIKE sy-tabix.
      FIELD-SYMBOLS <temp8> LIKE LINE OF t_category.
      DATA temp9 LIKE sy-tabix.
    CLEAR temp4.
    INSERT `Compact` INTO TABLE temp4.
    INSERT `Classic` INTO TABLE temp4.
    INSERT `Smart` INTO TABLE temp4.
    INSERT `Ultra` INTO TABLE temp4.
    INSERT `Eco` INTO TABLE temp4.
    INSERT `Pro` INTO TABLE temp4.
    INSERT `Mini` INTO TABLE temp4.
    INSERT `Rugged` INTO TABLE temp4.
    INSERT `Silent` INTO TABLE temp4.
    INSERT `Wireless` INTO TABLE temp4.
    
    t_adjective = temp4.
    
    CLEAR temp6.
    INSERT `Notebook` INTO TABLE temp6.
    INSERT `Monitor` INTO TABLE temp6.
    INSERT `Keyboard` INTO TABLE temp6.
    INSERT `Mouse` INTO TABLE temp6.
    INSERT `Printer` INTO TABLE temp6.
    INSERT `Headset` INTO TABLE temp6.
    INSERT `Router` INTO TABLE temp6.
    INSERT `Webcam` INTO TABLE temp6.
    INSERT `Speaker` INTO TABLE temp6.
    INSERT `Docking Station` INTO TABLE temp6.
    
    t_noun = temp6.
    
    CLEAR temp8.
    INSERT `Computers` INTO TABLE temp8.
    INSERT `Displays` INTO TABLE temp8.
    INSERT `Accessories` INTO TABLE temp8.
    INSERT `Office` INTO TABLE temp8.
    INSERT `Network` INTO TABLE temp8.
    
    t_category = temp8.

    DO 10000 TIMES.
      
      index = sy-index.
      
      CLEAR temp10.
      temp10-id = index.
      
      
      temp7 = sy-tabix.
      READ TABLE t_adjective INDEX ( index MOD 10 ) + 1 ASSIGNING <temp6>.
      sy-tabix = temp7.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      
      
      temp11 = sy-tabix.
      READ TABLE t_noun INDEX ( ( index DIV 10 ) MOD 10 ) + 1 ASSIGNING <temp5>.
      sy-tabix = temp11.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      temp10-name = |{ <temp6> } { <temp5> } { index }|.
      
      
      temp9 = sy-tabix.
      READ TABLE t_category INDEX ( index MOD 5 ) + 1 ASSIGNING <temp8>.
      sy-tabix = temp9.
      IF sy-subrc <> 0.
        ASSERT 1 = 0.
      ENDIF.
      temp10-category = <temp8>.
      temp10-price = ( ( index * 7919 ) MOD 100000 ) / 100.
      temp10-stock = ( index * 31 ) MOD 500.
      APPEND temp10 TO t_product.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
