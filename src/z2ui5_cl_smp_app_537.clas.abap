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

    DATA t_products TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event_row.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_537 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_products.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      
      CLEAR temp1.
      
      temp2-product = `Notebook Basic 15`.
      temp2-category = `Laptop`.
      temp2-quantity = 3.
      temp2-delivery = `20260720`.
      INSERT temp2 INTO TABLE temp1.
      temp2-product = `Flat Basic`.
      temp2-category = `Monitor`.
      temp2-quantity = 12.
      temp2-delivery = `20260805`.
      INSERT temp2 INTO TABLE temp1.
      temp2-product = `Ergo Mousepad`.
      temp2-category = `Accessories`.
      temp2-quantity = 40.
      temp2-delivery = `20261102`.
      INSERT temp2 INTO TABLE temp1.
      t_products = temp1.
      view_display( ).

    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( `ROW` ) IS NOT INITIAL.
      on_event_row( ).
    ELSEIF client->check_on_event( `LITERAL` ) IS NOT INITIAL.
      client->message_box_display( |The object literal arrives as its JSON text:\n\n{ client->get_event_arg( ) }| ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event_row.

    " every argument arrives as a string: the number the expression computed
    " as its digits, the result of the comparison as abap_true or empty -
    " so it is compared like an abap_bool, never asked IS INITIAL
    DATA temp3 TYPE string.
    DATA is_laptop LIKE temp3.
    IF client->get_event_arg( 3 ) = abap_true.
      temp3 = `yes`.
    ELSE.
      temp3 = `no`.
    ENDIF.
    
    is_laptop = temp3.

    client->message_box_display( |Product: { client->get_event_arg( 1 ) }\n| &&
                                 |Quantity * 10: { client->get_event_arg( 2 ) }\n| &&
                                 |Is a laptop: { is_laptop }\n| &&
                                 |Delivery (formatted in the browser): { client->get_event_arg( 4 ) }| ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA columns TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA cells TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp4 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory(
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

    
    page = view->ele( `Shell`
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

    
    tab = page->ele( `Table`
        )->a( n = `headerText` v = `Each row's button sends four values computed from that row`
        )->a( n = `items`      v = client->_bind( t_products ) ).

    
    columns = tab->ele( `columns` ).
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
    
    cells = tab->ele( `items`
        )->ele( `ColumnListItem` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{PRODUCT}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{CATEGORY}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{QUANTITY}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{DELIVERY}` ).
    
    CLEAR temp4.
    INSERT `${PRODUCT}` INTO TABLE temp4.
    INSERT `${QUANTITY} * 10` INTO TABLE temp4.
    INSERT `${CATEGORY} === 'Laptop'` INTO TABLE temp4.
    INSERT `${path: 'DELIVERY', formatter: 'Formatter.DateAbapDateToDateObject'}.toDateString()` INTO TABLE temp4.
    cells->tag( `Button`
        )->a( n = `text`  v = `Send Row`
        )->a( n = `press` v = client->_event( val   = `ROW`
                                              t_arg = temp4 ) ).

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
