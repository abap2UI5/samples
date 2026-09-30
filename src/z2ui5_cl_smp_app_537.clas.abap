" @keywords argument expression formatter object literal row context t_arg require
" @summary What an event argument can compute in the browser before it is sent - an expression over the pressed row, a formatter's result, a comparison, an object literal - and what each one arrives as in ABAP.
CLASS z2ui5_cl_smp_app_537 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        product  TYPE string,
        category TYPE string,
        quantity TYPE i,
        delivery TYPE string,
      END OF ty_s_row.

    DATA t_products TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event_row.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_537 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      t_products = VALUE #(
        ( product = `Notebook Basic 15` category = `Laptop`      quantity = 3  delivery = `20260720` )
        ( product = `Flat Basic`        category = `Monitor`     quantity = 12 delivery = `20260805` )
        ( product = `Ergo Mousepad`     category = `Accessories` quantity = 40 delivery = `20261102` ) ).
      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( `ROW` ).
      on_event_row( ).
    ELSEIF client->check_on_event( `LITERAL` ).
      client->message_box_display( |The object literal arrives as its JSON text:\n\n{ client->get_event_arg( ) }| ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event_row.

    " every argument arrives as a string: the number the expression computed
    " as its digits, the result of the comparison as abap_true or empty -
    " so it is compared like an abap_bool, never asked IS INITIAL
    DATA(is_laptop) = COND string( WHEN client->get_event_arg( 3 ) = abap_true THEN `yes` ELSE `no` ).

    client->message_box_display( |Product: { client->get_event_arg( 1 ) }\n| &&
                                 |Quantity * 10: { client->get_event_arg( 2 ) }\n| &&
                                 |Is a laptop: { is_laptop }\n| &&
                                 |Delivery (formatted in the browser): { client->get_event_arg( 4 ) }| ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    " the formatter module required into the view is in scope for the event
    " arguments too - UI5 resolves Formatter.xxx there the way it does in a
    " property binding
    view->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Event - Expressions, Formatters and Literals in t_arg`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     t = `An argument that starts with $ or { is evaluated in the browser when the event fires, ` &&
                   `with the full expression binding syntax: a field of the pressed row, arithmetic and ` &&
                   `comparisons over it, a formatter, an object literal. Only the result travels to ABAP.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->tag( `Link`
        )->a( n = `text`   v = `UI5 documentation: Handling Events in XML Views`
        )->a( n = `target` v = `_blank`
        )->a( n = `href`   v = `https://sdk.openui5.org/topic/b0fb4de7364f4bcbb053a99aa645affe`
        )->a( n = `class`  v = `sapUiSmallMarginBegin` ).

    DATA(tab) = page->ele( `Table`
        )->a( n = `headerText` v = `Each row's button sends four values computed from that row`
        )->a( n = `items`      v = client->_bind( t_products ) ).

    DATA(columns) = tab->ele( `columns` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Product` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Category` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Quantity` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Delivery` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Event` ).

    " the relative paths resolve against the row the pressed button sits in -
    " no row index, no key lookup in the backend
    DATA(cells) = tab->ele( `items`
        )->ele( `ColumnListItem` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{PRODUCT}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{CATEGORY}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{QUANTITY}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{DELIVERY}` ).
    cells->tag( `Button`
        )->a( n = `text`  v = `Send Row`
        )->a( n = `press` v = client->_event( val   = `ROW`
                                              t_arg = VALUE #( ( `${PRODUCT}` )
                                                               ( `${QUANTITY} * 10` )
                                                               ( `${CATEGORY} === 'Laptop'` )
                                                               ( `${path: 'DELIVERY', formatter: 'Formatter.DateAbapDateToDateObject'}.toDateString()` ) ) ) ).

    " a raw argument has to start with $ or { - an object literal does, and it
    " carries numbers, booleans and arrays as what they are; a bare 5.5 or
    " ['a','b'] would be quoted and sent as text
    page->tag( `Button`
        )->a( n = `text`  v = `Send an Object Literal`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->a( n = `press` v = client->_event( val = `LITERAL`
                                              arg = `{ product: 'Notebook', quantity: 3, express: true, tags: ['new', 'sale'] }` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
