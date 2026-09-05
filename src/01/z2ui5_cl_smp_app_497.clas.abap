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
    DATA rows TYPE STANDARD TABLE OF ty_s_flight WITH DEFAULT KEY.

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

    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      set_view( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      set_view( ).
    ENDIF.

  ENDMETHOD.

  METHOD set_view.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).

    
    page = view->ele( `Shell`
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
    render_any( parent = page tab = rows ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD render_any.

    DATA temp1 TYPE REF TO cl_abap_structdescr.
    DATA temp2 TYPE REF TO cl_abap_tabledescr.
    DATA comps TYPE abap_component_tab.
    DATA ui_table TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA columns TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA comp LIKE LINE OF comps.
    DATA cells TYPE REF TO z2ui5_cl_ui5_view_builder.
    temp2 ?= cl_abap_typedescr=>describe_by_data( tab ).
    temp1 ?= temp2->get_table_line_type( ).
    
    comps = temp1->get_components( ).

    
    ui_table = parent->ele( `Table`
        )->a( n = `items`      v = client->_bind( tab )
        )->a( n = `headerText` v = |{ lines( tab ) } rows, { lines( comps ) } columns| ).

    " one column per component - discovered, not declared
    
    columns = ui_table->ele( `columns` ).
    
    LOOP AT comps INTO comp.
      columns->ele( `Column`
          )->ele( `header`
              )->tag( `Text`
                  )->a( n = `text` v = comp-name ).
    ENDLOOP.

    " one cell per component, bound by field name
    
    cells = ui_table->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells` ).
    LOOP AT comps INTO comp.
      cells->tag( `Text`
          )->a( n = `text` v = |\{{ comp-name }\}| ).
    ENDLOOP.

  ENDMETHOD.

  METHOD model_init.

    " fill it however you like - a SELECT, a function module, an EML read
    DATA temp2 LIKE rows.
    DATA temp3 LIKE LINE OF temp2.
    CLEAR temp2.
    
    temp3-carrid = 'LH'.
    temp3-connid = '0400'.
    temp3-fldate = '20260825'.
    temp3-price = '899.00'.
    temp3-currency = 'EUR'.
    INSERT temp3 INTO TABLE temp2.
    temp3-carrid = 'LH'.
    temp3-connid = '0402'.
    temp3-fldate = '20260826'.
    temp3-price = '915.00'.
    temp3-currency = 'EUR'.
    INSERT temp3 INTO TABLE temp2.
    temp3-carrid = 'AA'.
    temp3-connid = '0017'.
    temp3-fldate = '20260827'.
    temp3-price = '422.50'.
    temp3-currency = 'USD'.
    INSERT temp3 INTO TABLE temp2.
    temp3-carrid = 'UA'.
    temp3-connid = '0941'.
    temp3-fldate = '20260828'.
    temp3-price = '780.00'.
    temp3-currency = 'USD'.
    INSERT temp3 INTO TABLE temp2.
    rows = temp2.

  ENDMETHOD.

ENDCLASS.
