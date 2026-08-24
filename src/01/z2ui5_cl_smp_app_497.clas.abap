" @keywords rtti generic view runtime columns get_components describe_by_data no field name itab structure column cell binding
" @summary The view names no field: RTTI reads the components of the internal table and derives every column and every cell binding from them, so changing the structure changes the screen with no view code touched.
CLASS z2ui5_cl_smp_app_497 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_flight,
        carrid   TYPE c LENGTH 3,
        connid   TYPE n LENGTH 4,
        fldate   TYPE d,
        price    TYPE p LENGTH 9 DECIMALS 2,
        currency TYPE c LENGTH 5,
      END OF ty_s_flight.

    " the only place in this app that names a field - add one here and it
    " appears on the screen, because the view below is derived from this type
    DATA rows TYPE STANDARD TABLE OF ty_s_flight WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS set_view.
    METHODS render_any
      IMPORTING
        parent TYPE REF TO z2ui5_cl_ui5_view_builder
        tab    TYPE STANDARD TABLE.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_497 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      model_init( ).
      set_view( ).
    ELSEIF client->check_on_navigated( ).
      set_view( ).
    ENDIF.

  ENDMETHOD.

  METHOD set_view.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Binding - A View Built From RTTI`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Not one field name appears in the view code. RTTI reads the ` &&
                                 `components of the internal table, and every column header and ` &&
                                 `cell binding below is derived from them.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " the renderer only ever sees TYPE STANDARD TABLE - the same shape
    " cl_salv_table=>factory( ) has taken since forever
    render_any( parent = page
                tab    = rows ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD render_any.

    DATA(comps) = CAST cl_abap_structdescr(
                      CAST cl_abap_tabledescr(
                          cl_abap_typedescr=>describe_by_data( tab )
                        )->get_table_line_type( ) )->get_components( ).

    DATA(ui_table) = parent->ele( `Table`
        )->a( n = `items`      v = client->_bind( tab )
        )->a( n = `headerText` v = |{ lines( tab ) } rows, { lines( comps ) } columns| ).

    " one column per component - discovered, not declared
    DATA(columns) = ui_table->ele( `columns` ).
    LOOP AT comps INTO DATA(comp).
      columns->ele( `Column`
          )->ele( `header`
              )->tag( `Text`
                  )->a( n = `text` v = comp-name ).
    ENDLOOP.

    " one cell per component, bound by field name
    DATA(cells) = ui_table->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells` ).
    LOOP AT comps INTO comp.
      cells->tag( `Text`
          )->a( n = `text` v = |\{{ comp-name }\}| ).
    ENDLOOP.

  ENDMETHOD.

  METHOD model_init.

    " fill it however you like - a SELECT, a function module, an EML read
    rows = VALUE #(
        ( carrid = 'LH' connid = '0400' fldate = '20260825' price = '899.00' currency = 'EUR' )
        ( carrid = 'LH' connid = '0402' fldate = '20260826' price = '915.00' currency = 'EUR' )
        ( carrid = 'AA' connid = '0017' fldate = '20260827' price = '422.50' currency = 'USD' )
        ( carrid = 'UA' connid = '0941' fldate = '20260828' price = '780.00' currency = 'USD' ) ).

  ENDMETHOD.

ENDCLASS.
