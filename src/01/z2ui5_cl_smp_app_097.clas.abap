" @keywords fcl master detail list report two column split
" @summary Master and detail in a FlexibleColumnLayout: a list on the left, its record on the right, each in its own nested view.
" @docs https://abap2ui5.github.io/docs/cookbook/view/nested_views
CLASS z2ui5_cl_smp_app_097 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        uuid     TYPE string,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        selected TYPE abap_bool,
        checkbox TYPE abap_bool,
      END OF ty_s_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.
    DATA t_tab2 TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.
    DATA mv_layout TYPE string.
    " public, so it survives the roundtrip - the detail rows need a key that
    " stays unique after a row was deleted, and lines( t_tab2 ) would not
    DATA mv_row_id TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display_master.
    METHODS view_display_detail.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_097 IMPLEMENTATION.

  METHOD view_display_detail.

    DATA lo_view_nested TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lo_columns TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    lo_view_nested = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:f`      v = `sap.f`
            )->a( n = `xmlns:table`  v = `sap.ui.table` ).

    
    page = lo_view_nested->ele( `Page`
        )->a( n = `title` v = `Nested View` ).

    
    tab = page->ele( n = `Table` ns = `table`
        )->a( n = `rows`               v = client->_bind( val = t_tab2 )
        )->a( n = `alternateRowColors` b = abap_true
        )->a( n = `fixedColumnCount`   v = `1`
        )->a( n = `rowActionCount`     v = `1`
        )->a( n = `selectionMode`      v = `None`
        " abap2ui5lint-disable-next-line event-without-handler -- sap.ui.table fires it; the roundtrip re-renders and that is the point
        )->a( n = `filter`             v = client->_event( `FILTER` )
        " abap2ui5lint-disable-next-line event-without-handler -- sap.ui.table fires it; the roundtrip re-renders and that is the point
        )->a( n = `sort`               v = client->_event( `SORT` )
        " abap2ui5lint-disable-next-line event-without-handler -- sap.ui.table fires it; the roundtrip re-renders and that is the point
        )->a( n = `customFilter`       v = client->_event( `CUSTOMFILTER` ) ).
    tab->ele( n = `extension` ns = `table`
        )->ele( `OverflowToolbar`
            )->tag( `Title`
                )->a( n = `text` v = `Products` ).
    
    lo_columns = tab->ele( n = `columns` ns = `table` ).

    lo_columns->ele( n = `Column` ns = `table`
        )->a( n = `sortProperty`   v = `TITLE`
        )->a( n = `filterProperty` v = `TITLE`
        )->tag( `Text`
            )->a( n = `text` v = `Index`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{TITLE}` ).
    lo_columns->ele( n = `Column` ns = `table`
        )->a( n = `sortProperty`   v = `DESCR`
        )->a( n = `filterProperty` v = `DESCR`
        )->tag( `Text`
            )->a( n = `text` v = `DESCR`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{DESCR}` ).
    lo_columns->ele( n = `Column` ns = `table`
        )->a( n = `sortProperty`   v = `INFO`
        )->a( n = `filterProperty` v = `INFO`
        )->tag( `Text`
            )->a( n = `text` v = `INFO`
        )->ele( n = `template` ns = `table`
            )->tag( `Text`
                )->a( n = `text` v = `{INFO}` ).
    
    CLEAR temp1.
    INSERT `${UUID}` INTO TABLE temp1.
    lo_columns->end(
        )->ele( n = `rowActionTemplate` ns = `table`
            )->ele( n = `RowAction` ns = `table`
                )->ele( n = `RowActionItem` ns = `table`
                    )->a( n = `icon`  v = `sap-icon://delete`
                    )->a( n = `press` v = client->_event( val = `ROW_DELETE` t_arg = temp1 ) ).

    client->nest_view_display(
      val            = lo_view_nested->stringify( )
      id             = `test`
      method_insert  = `addMidColumnPage`
      method_destroy = `removeAllMidColumnPages` ).

  ENDMETHOD.


  METHOD view_display_master.

    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA col_layout TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lr_master TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA lr_list TYPE REF TO z2ui5_cl_ui5_view_builder.
    page = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:f`      v = `sap.f`
            )->a( n = `xmlns:table`  v = `sap.ui.table`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `abap2UI5 - Nested View - Master-Detail with FlexibleColumnLayout`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A master-detail screen built with FlexibleColumnLayout: select a list row and its ` &&
                   `detail opens in a second column as a nested view with a table.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    col_layout = page->ele( n = `FlexibleColumnLayout` ns = `f`
        )->a( n = `layout` v = client->_bind( mv_layout )
        )->a( n = `id`     v = `test` ).

    
    lr_master = col_layout->ele( n = `beginColumnPages` ns = `f` ).

    
    lr_list = lr_master->ele( `List`
        )->a( n = `headerText`      v = `List Output`
        )->a( n = `items`           v = client->_bind( val = t_tab )
        )->a( n = `mode`            v = `SingleSelectMaster`
        )->a( n = `selectionChange` v = client->_event( `SELCHANGE` )
        )->tag( `StandardListItem`
            )->a( n = `title`       v = `{TITLE}`
            )->a( n = `description` v = `{DESCR}`
            )->a( n = `icon`        v = `{ICON}`
            )->a( n = `info`        v = `{INFO}`
            " abap2ui5lint-disable-next-line event-without-handler -- item press; the master-detail wiring below is what this sample shows
            )->a( n = `press`       v = client->_event( `TEST` )
            )->a( n = `selected`    v = `{SELECTED}` ).

    client->view_display( lr_list->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
      DATA temp3 LIKE t_tab.
      DATA temp4 LIKE LINE OF temp3.
        DATA lt_sel LIKE t_tab.
        DATA ls_sel TYPE z2ui5_cl_smp_app_097=>ty_s_row.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      
      CLEAR temp3.
      
      temp4-title = `row_01`.
      temp4-info = `completed`.
      temp4-descr = `this is a description`.
      temp4-icon = `sap-icon://account`.
      INSERT temp4 INTO TABLE temp3.
      temp4-title = `row_02`.
      temp4-info = `incompleted`.
      temp4-descr = `this is a description`.
      temp4-icon = `sap-icon://account`.
      INSERT temp4 INTO TABLE temp3.
      temp4-title = `row_03`.
      temp4-info = `working`.
      temp4-descr = `this is a description`.
      temp4-icon = `sap-icon://account`.
      INSERT temp4 INTO TABLE temp3.
      temp4-title = `row_04`.
      temp4-info = `working`.
      temp4-descr = `this is a description`.
      temp4-icon = `sap-icon://account`.
      INSERT temp4 INTO TABLE temp3.
      temp4-title = `row_05`.
      temp4-info = `completed`.
      temp4-descr = `this is a description`.
      temp4-icon = `sap-icon://account`.
      INSERT temp4 INTO TABLE temp3.
      temp4-title = `row_06`.
      temp4-info = `completed`.
      temp4-descr = `this is a description`.
      temp4-icon = `sap-icon://account`.
      INSERT temp4 INTO TABLE temp3.
      t_tab = temp3.

      mv_layout = `OneColumn`.

      view_display_master( ).
      view_display_detail( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display_master( ).

    ENDIF.

    CASE client->get_event( ).

      WHEN `ROW_DELETE`.

        DELETE t_tab2 WHERE uuid = client->get_event_arg( ).

      WHEN `SELCHANGE`.
        
        lt_sel = t_tab.
        DELETE lt_sel WHERE selected = abap_false.

        
        READ TABLE lt_sel INTO ls_sel INDEX 1.

        IF sy-subrc = 0.
          mv_row_id = mv_row_id + 1.
          ls_sel-uuid = |{ mv_row_id }|.
          INSERT ls_sel INTO TABLE t_tab2.
        ENDIF.

        mv_layout = `TwoColumnsMidExpanded`.

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
