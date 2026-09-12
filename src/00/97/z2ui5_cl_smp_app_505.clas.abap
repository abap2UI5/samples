" @keywords grid table sort column prevent default expression prevent_default_expr backend sort client sort per column
" @summary One sort wire, two behaviours: the date column is sorted in the backend because its display text cannot be sorted by the client, every other column keeps the built-in client sort.
"! A sap.ui.table.Table sorts on the client when a column header is
"! pressed. That is right for most columns and wrong for one: the date
"! column shows `15.01.2026`, a text the client can only sort as text.
"!
"! s_ctrl-check_prevent_default would cancel the client sort for EVERY
"! firing of the wire. s_ctrl-prevent_default_expr is the same veto decided
"! PER FIRING: a client expression evaluated when the event fires, here
"! `${$parameters&gt;/column}.getId().indexOf('COL_DATE') &gt;= 0`. So one wire
"! lets the client sort the product and the stock and cancels the default
"! only for the date column, where the backend sorts by the real date and
"! re-renders with the sort indicator set. The event reaches the backend in
"! every case - the veto decides what the CONTROL does, not whether the
"! backend hears about it.
CLASS z2ui5_cl_smp_app_505 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        product      TYPE string,
        stock        TYPE i,
        created      TYPE d,
        created_text TYPE string,
      END OF ty_s_row.
    DATA t_row TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    DATA last_sort TYPE string.

  PROTECTED SECTION.
    DATA client     TYPE REF TO z2ui5_if_client.
    DATA sort_order TYPE string.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_505 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    " the display text is what the column shows - day first, which sorts
    " wrong as text; the real date next to it is what the backend sorts by
    t_row = VALUE #(
      ( product = `Notebook 15"` stock = 12 created = `20260115` )
      ( product = `Monitor 27"`  stock = 5  created = `20251203` )
      ( product = `USB-C Dock`   stock = 40 created = `20260302` )
      ( product = `Keyboard`     stock = 71 created = `20250928` )
      ( product = `Headset`      stock = 9  created = `20260107` ) ).

    LOOP AT t_row REFERENCE INTO DATA(row).
      DATA(created) = CONV string( row->created ).
      row->created_text = |{ created+6(2) }.{ created+4(2) }.{ created(4) }|.
    ENDLOOP.

    last_sort = `not sorted yet`.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `SORT` ).

      " the same event for every column: the sort property and the order
      " the user asked for ride as arguments
      DATA(property) = client->get_event_arg( 1 ).
      sort_order     = client->get_event_arg( 2 ).

      IF property = `CREATED_TEXT`.
        " the veto held on the client, so nothing is sorted yet: sort the
        " ABAP table by the real date, then re-render so the column shows
        " the indicator the client sort would have set
        IF sort_order = `Descending`.
          SORT t_row BY created DESCENDING.
        ELSE.
          SORT t_row BY created ASCENDING.
        ENDIF.

        last_sort = |Date { sort_order } - sorted in the BACKEND by the real date, the client sort was cancelled|.
        view_display( ).

      ELSE.
        " the client sorted already; the backend only takes note. Nothing
        " is re-rendered, the bound text below reaches the view on its own
        last_sort = |{ property } { sort_order } - sorted by the CLIENT, the default ran|.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:table`  v = `sap.ui.table` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Event - Prevent Default per Column`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Press the column headers. Product and Stock sort on the client, as a grid table does. ` &&
                   `The Date column shows a text the client cannot sort correctly, so its client sort is ` &&
                   `cancelled by s_ctrl-prevent_default_expr - one expression on the one sort wire - and ` &&
                   `the backend sorts by the real date instead.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(tab) = page->ele( n = `Table` ns = `table`
        )->a( n = `rows`               v = client->_bind( t_row )
        )->a( n = `selectionMode`      v = `None`
        )->a( n = `visibleRowCount`    v = `5`
        )->a( n = `alternateRowColors` b = abap_true
        " the veto is evaluated on the client for EACH firing: only a column
        " whose id contains COL_DATE loses its built-in sort. Every firing
        " still rounds trips with the sort property and the requested order
        )->a( n = `sort`               v = client->_event( val    = `SORT`
                                                            t_arg  = VALUE #( ( `${$parameters>/column}.getSortProperty()` )
                                                                              ( `${$parameters>/sortOrder}` ) )
                                                            s_ctrl = VALUE #( prevent_default_expr = `${$parameters>/column}.getId().indexOf('COL_DATE') >= 0` ) ) ).

    tab->ele( n = `extension` ns = `table`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Products` ).

    DATA(columns) = tab->ele( n = `columns` ns = `table` ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `id`           v = `COL_PRODUCT`
        )->a( n = `sortProperty` v = `PRODUCT`
        )->tag( `Text`
            )->a( n = `text` v = `Product (client sort)`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{PRODUCT}` ).

    columns->ele( n = `Column` ns = `table`
        )->a( n = `id`           v = `COL_STOCK`
        )->a( n = `sortProperty` v = `STOCK`
        )->a( n = `hAlign`       v = `End`
        )->tag( `Text`
            )->a( n = `text` v = `Stock (client sort)`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{STOCK}` ).

    DATA(col_date) = columns->ele( n = `Column` ns = `table`
        )->a( n = `id`           v = `COL_DATE`
        )->a( n = `sortProperty` v = `CREATED_TEXT` ).

    " the indicator the client sort would have set - the backend sets it
    " itself when it did the sorting, and the builder writes only a valid
    " enum value, so the two attributes go under the IF
    IF sort_order IS NOT INITIAL AND last_sort CS `BACKEND`.
      col_date->a( n = `sorted`    b = abap_true
          )->a( n = `sortOrder` v = sort_order ).
    ENDIF.

    col_date->tag( `Text`
        )->a( n = `text` v = `Created (backend sort)`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{CREATED_TEXT}` ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = client->_bind( last_sort )
        )->a( n = `type`     v = `Success`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
