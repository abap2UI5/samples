" @keywords table edit refused cell conversion error t_model_skipped valuestate packed price integer nested row_parent
" @summary What happens to a table cell the user fills with text that does not fit its ABAP type: the cell is skipped, t_model_skipped names it, and the app shows the user why.
"! A table cell whose value will not convert - `abc` into a packed price,
"! `seven` into an integer stock - is never raised on: the framework skips
"! that ONE cell, applies every other one, and records the skip in
"! client-&gt;get( )-t_model_skipped. The browser still shows what the user
"! typed, because the client model was updated before the roundtrip, so an
"! app that stays silent reports a success the model does not carry.
"!
"! This sample reads the trace at the top of main( ), on EVERY roundtrip,
"! marks each refused cell with a ValueState that quotes the raw text, and
"! keeps the row in edit mode. The components list inside a row is a nested
"! table, so a refused quantity arrives with row_parent set - the second
"! half of the trace.
CLASS z2ui5_cl_smp_app_504 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_item,
        name      TYPE string,
        qty       TYPE i,
        qty_state TYPE string,
        qty_text  TYPE string,
      END OF ty_s_item.
    TYPES:
      BEGIN OF ty_s_row,
        product     TYPE string,
        price       TYPE p LENGTH 9 DECIMALS 2,
        price_state TYPE string,
        price_text  TYPE string,
        currency    TYPE c LENGTH 3,
        stock       TYPE i,
        stock_state TYPE string,
        stock_text  TYPE string,
        t_item      TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY,
      END OF ty_s_row.
    DATA t_row TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    DATA report      TYPE string.
    DATA report_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS refused_apply.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_504 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    " the trace is per roundtrip and travels with WHATEVER request follows
    " the edit - a press, a growing, a sort - so it is read before the app
    " decides which event it is interested in, never inside the Save branch
    refused_apply( ).

    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_row = VALUE #(
      ( product = `Notebook 15"` price = '1299.00' currency = `EUR` stock = 12 price_state = `None` stock_state = `None`
        t_item = VALUE #( ( name = `SSD 1 TB`  qty = 1 qty_state = `None` )
                          ( name = `RAM 16 GB` qty = 2 qty_state = `None` ) ) )
      ( product = `Monitor 27"`  price = '349.90'  currency = `EUR` stock = 5  price_state = `None` stock_state = `None`
        t_item = VALUE #( ( name = `HDMI cable` qty = 1 qty_state = `None` ) ) )
      ( product = `USB-C Dock`   price = '189.00'  currency = `EUR` stock = 40 price_state = `None` stock_state = `None`
        t_item = VALUE #( ( name = `Power supply` qty = 1 qty_state = `None` ) ) ) ).

    view_display( ).

  ENDMETHOD.


  METHOD refused_apply.

    FIELD-SYMBOLS <s_row>  TYPE ty_s_row.
    FIELD-SYMBOLS <s_item> TYPE ty_s_item.

    " every roundtrip starts clean: a cell the user has corrected since is
    " not in this roundtrip's trace any more, so its state goes back to None
    LOOP AT t_row ASSIGNING <s_row>.
      <s_row>-price_state = `None`.
      <s_row>-stock_state = `None`.
      <s_row>-price_text  = ``.
      <s_row>-stock_text  = ``.
      LOOP AT <s_row>-t_item ASSIGNING <s_item>.
        <s_item>-qty_state = `None`.
        <s_item>-qty_text  = ``.
      ENDLOOP.
    ENDLOOP.

    DATA(t_skipped) = client->get( )-t_model_skipped.
    report = ``.
    LOOP AT t_skipped INTO DATA(s_skipped).

      " name is the bound attribute as the class declares it - T_ROW for a
      " top-level cell, T_ROW-T_ITEM for a cell of the nested table; row is
      " the 1-based index in THAT table, row_parent the owning row above it
      CASE s_skipped-name.

        WHEN `T_ROW`.
          READ TABLE t_row ASSIGNING <s_row> INDEX s_skipped-row.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

          CASE s_skipped-field.
            WHEN `PRICE`.
              <s_row>-price_state = `Error`.
              <s_row>-price_text  = |'{ s_skipped-value }' is not a valid price - the stored value { <s_row>-price } stands|.
            WHEN `STOCK`.
              <s_row>-stock_state = `Error`.
              <s_row>-stock_text  = |'{ s_skipped-value }' is not a whole number - the stored value { <s_row>-stock } stands|.
          ENDCASE.

        WHEN `T_ROW-T_ITEM`.
          READ TABLE t_row ASSIGNING <s_row> INDEX s_skipped-row_parent.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

          READ TABLE <s_row>-t_item ASSIGNING <s_item> INDEX s_skipped-row.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

          <s_item>-qty_state = `Error`.
          <s_item>-qty_text  = |'{ s_skipped-value }' is not a quantity - the stored value { <s_item>-qty } stands|.

      ENDCASE.

      report = |{ report }{ s_skipped-name } row { s_skipped-row } field { s_skipped-field }: '{ s_skipped-value }' refused. |.
    ENDLOOP.

    report_text = COND #( WHEN report IS INITIAL
                          THEN `Every cell of the last roundtrip converted.`
                          ELSE report ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SAVE`.
        " a save that would silently drop the refused cells is the failure
        " this trace exists for - so a roundtrip with a trace is no save
        IF report IS INITIAL.
          client->message_toast_display( `saved - every cell converted` ).
        ELSE.
          client->message_box_display( text = |Not saved. { report }|
                                       type = `error` ).
        ENDIF.

      WHEN `RESET`.
        " reading the trace pushes no model: the browser goes on showing
        " the refused text until the app writes something. A re-render
        " with the seed data is that write
        on_init( ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Table - Refused Cell Values (t_model_skipped)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Type text into a price, a stock or a component quantity - 'abc', '12,50 EUR', 'seven' - ` &&
                   `and press Save. The cell that does not fit its ABAP type is skipped, not raised on: ` &&
                   `get( )-t_model_skipped names table, row and field, and the app marks the cell instead ` &&
                   `of reporting a success the model does not carry.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(tab) = page->ele( `Table`
        )->a( n = `items` v = client->_bind( t_row )
        )->a( n = `class` v = `sapUiSmallMargin` ).

    tab->ele( `headerToolbar`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Products - every cell editable`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `text`  v = `Reset`
                )->a( n = `press` v = client->_event( `RESET` )
            )->tag( `Button`
                )->a( n = `text`  v = `Save`
                )->a( n = `type`  v = `Emphasized`
                )->a( n = `press` v = client->_event( `SAVE` ) ).

    tab->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Product`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Price (packed)`
        )->end(
        )->ele( `Column`
            )->a( n = `width` v = `6rem`
            )->tag( `Text`
                )->a( n = `text` v = `Currency`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Stock (integer)`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Components (nested table)`
        )->end( ).

    DATA(cells) = tab->ele( `items`
        )->ele( `ColumnListItem`
            )->a( n = `vAlign` v = `Top` ).

    cells->tag( `Text`
        )->a( n = `text` v = `{PRODUCT}` ).
    cells->tag( `Input`
        )->a( n = `value`          v = `{PRICE}`
        )->a( n = `valueState`     v = `{PRICE_STATE}`
        )->a( n = `valueStateText` v = `{PRICE_TEXT}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{CURRENCY}` ).
    cells->tag( `Input`
        )->a( n = `value`          v = `{STOCK}`
        )->a( n = `valueState`     v = `{STOCK_STATE}`
        )->a( n = `valueStateText` v = `{STOCK_TEXT}` ).

    " the nested table: a list bound RELATIVELY to the row's T_ITEM, so a
    " refused quantity is traced as T_ROW-T_ITEM with row_parent set
    cells->ele( `List`
        )->a( n = `items`          v = `{T_ITEM}`
        )->a( n = `showSeparators` v = `None`
        )->ele( `CustomListItem`
            )->ele( `HBox`
                )->a( n = `alignItems` v = `Center`
                )->tag( `Text`
                    )->a( n = `text`  v = `{NAME}`
                    )->a( n = `width` v = `8rem`
                )->tag( `Input`
                    )->a( n = `value`          v = `{QTY}`
                    )->a( n = `width`          v = `5rem`
                    )->a( n = `valueState`     v = `{QTY_STATE}`
                    )->a( n = `valueStateText` v = `{QTY_TEXT}` ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = client->_bind( report_text )
        )->a( n = `type`     v = `Warning`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
