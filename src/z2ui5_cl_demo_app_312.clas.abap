class Z2UI5_CL_DEMO_APP_312 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  types:
    BEGIN OF ts_data_chart,
        week    TYPE string,
        revenue TYPE string,
        cost    TYPE string,
      END OF ts_data_chart .
  types:
    tt_data_chart TYPE STANDARD TABLE OF ts_data_chart WITH DEFAULT KEY .
  types:
    BEGIN OF ts_combobox,
        key  TYPE stringval,
        text TYPE stringval,
      END OF ts_combobox .
  types:
    tt_combobox TYPE STANDARD TABLE OF ts_combobox WITH KEY key .
  types:
    BEGIN OF ts_screen,
             viztype    TYPE string,
             viztypesel TYPE string,
           END OF ts_screen .

  data MS_SCREEN type TS_SCREEN .
  data MT_DATA_CHART type TT_DATA_CHART .
  data MV_PROP type STRING .
  data:
    mt_feed_values TYPE TABLE OF string .
  data CHECK_INITIALIZED type ABAP_BOOL .
  data MT_VIZTYPES type TT_COMBOBOX .
protected section.

  data CLIENT type ref to Z2UI5_IF_CLIENT .

  methods ON_RENDERING .
  methods ON_EVENT .
  methods ON_INIT .
private section.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_312 IMPLEMENTATION.


  METHOD ON_EVENT.
    DATA: lt_param   TYPE string_table,
          lv_message TYPE string.

* ---------- Get event parameter ------------------------------------------------------------------
    lt_param = client->get( )-t_event_arg.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).

      WHEN 'EVT_DATA_SELECT'.
        READ TABLE lt_param INTO lv_message INDEX 1.
        client->message_toast_display( text = lv_message ).

      WHEN 'EVT_VIZTYPE_CHANGE'.

        me->ms_screen-viztype = me->ms_screen-viztypesel.
        me->on_rendering( ).
    ENDCASE.

  ENDMETHOD.


  METHOD ON_INIT.
* ---------- Set vizframe chart data --------------------------------------------------------------
    me->mt_data_chart = VALUE #( ( week = 'Week 1 - 4'
                               revenue = '431000.22'
                               cost = '230000.00' )
                              ( week = 'Week 5 - 8'
                               revenue = '494000.30'
                               cost = '238000.00' )
                               ( week = 'Week 9 - 12'
                               revenue = '491000.17'
                               cost = '221000.00' )
                               ( week = 'Week 13 - 16'
                               revenue = '536000.34'
                               cost = '280000.00' )
                               ).
* ---------- Set vizframe properties (optional) ---------------------------------------------------
    me->mv_prop = `{` && |\n|  &&
    `"plotArea": {` && |\n|  &&
        `"dataLabel": {` && |\n|  &&
            `"formatString": "",` && |\n|  &&
            `"visible": true` && |\n|  &&
        `}` && |\n|  &&
    `},` && |\n|  &&
    `"valueAxis": {` && |\n|  &&
        `"label": {` && |\n|  &&
            `"formatString": ""` && |\n|  &&
        `},` && |\n|  &&
        `"title": {` && |\n|  &&
            `"visible": true` && |\n|  &&
        `}` && |\n|  &&
    `},` && |\n|  &&
    `"categoryAxis": {` && |\n|  &&
        `"title": {` && |\n|  &&
            `"visible": true` && |\n|  &&
        `}` && |\n|  &&
    `},` && |\n|  &&
    `"title": {` && |\n|  &&
        `"visible": true,` && |\n|  &&
        `"text": "Vizframe Charts for 2UI5"` && |\n|  &&
    `}` && |\n|  &&
`}`.

* ---------- Set vizframe feed item values for value axis -----------------------------------------
    me->mt_feed_values = VALUE #( ( `Revenue` )
                                  ( `Cost` ) ) .

* ---------- Set viz type default -----------------------------------------------------------------
    me->ms_screen-viztype = 'column'.
    me->ms_screen-viztypesel = 'column'.

* ---------- Set VizFrame types -------------------------------------------------------------------
    me->mt_viztypes = VALUE #(
    ( key = 'column'
    text = 'column' )
*    ( key = 'dual_column'
*    text = 'dual_column' )
    ( key = 'bar'
    text = 'bar' )
*    ( key = 'dual_bar'
*    text = 'dual_bar' )
    ( key = 'stacked_bar'
    text = 'stacked_bar' )
    ( key = 'stacked_column'
    text = 'stacked_column' )
    ( key = 'line'
    text = 'line' )
*    ( key = 'dual_line'
*    text = 'dual_line' )
    ( key = 'combination'
    text = 'combination' )
    ( key = 'bullet'
    text = 'bullet' )
*    ( key = 'time_bullet'
*    text = 'time_bullet' )
*    ( key = 'bubble'
*    text = 'bubble' )
*    ( key = 'time_bubble'
*    text = 'time_bubble' )
*    ( key = 'pie'
*    text = 'pie' )
*    ( key = 'donut'
*    text = 'donut' )
*    ( key = 'timeseries_column'
*    text = 'timeseries_column' )
*    ( key = 'timeseries_line'
*    text = 'timeseries_line' )
*    ( key = 'timeseries_scatter'
*    text = 'timeseries_scatter' )
*    ( key = 'timeseries_bubble'
*    text = 'timeseries_bubble' )
*    ( key = 'timeseries_stacked_column'
*    text = 'timeseries_stacked_column' )
*    ( key = 'timeseries_100_stacked_column'
*    text = 'timeseries_100_stacked_column' )
*    ( key = 'timeseries_bullet'
*    text = 'timeseries_bullet' )
*    ( key = 'timeseries_waterfall'
*    text = 'timeseries_waterfall' )
*    ( key = 'timeseries_stacked_combination scatter'
*    text = 'timeseries_stacked_combination scatter' )
    ( key = 'vertical_bullet'
    text = 'vertical_bullet' )
*    ( key = 'dual_stacked_bar'
*    text = 'dual_stacked_bar' )
    ( key = '100_stacked_bar'
    text = '100_stacked_bar' )
*    ( key = '100_dual_stacked_bar'
*    text = '100_dual_stacked_bar' )
*    ( key = 'dual_stacked_column'
*    text = 'dual_stacked_column' )
    ( key = '100_stacked_column'
    text = '100_stacked_column' )
*    ( key = '100_dual_stacked_column'
*    text = '100_dual_stacked_column' )
    ( key = 'stacked_combination'
    text = 'stacked_combination' )
    ( key = 'horizontal_stacked_combination'
    text = 'horizontal_stacked_combination' )
*    ( key = 'dual_stacked_combination'
*    text = 'dual_stacked_combination' )
*    ( key = 'dual_horizontal_stacked_combination'
*    text = 'dual_horizontal_stacked_combination' )
*    ( key = 'heatmap'
*    text = 'heatmap' )
*    ( key = 'treemap'
*    text = 'treemap' )
    ( key = 'waterfall'
    text = 'waterfall' )
    ( key = 'horizontal_waterfall'
    text = 'horizontal_waterfall' )
    ( key = 'area'
    text = 'area' )
    ( key = 'radar'
    text = 'radar' )
    ).

  ENDMETHOD.


  METHOD ON_RENDERING.

    DATA(lr_view) = z2ui5_cl_xml_view=>factory( ).

* ---------- Set dynamic page ---------------------------------------------------------------------
    DATA(lr_dyn_page) =  lr_view->dynamic_page( showfooter = abap_false ).

* ---------- Get header title ---------------------------------------------------------------------
    DATA(lr_header_title) = lr_dyn_page->title( ns = 'f' )->get( )->dynamic_page_title( ).

* ---------- Set header title text ----------------------------------------------------------------
    lr_header_title->heading( ns = 'f' )->title( 'abap2UI5 - VizFrame Charts' ).

* ---------- Get page header area ----------------------------------------------------------------
    DATA(lr_header) = lr_dyn_page->header( ns = 'f' )->dynamic_page_header( pinnable = abap_true )->content( ns = 'f' ).

* ---------- Set Filter bar -----------------------------------------------------------------------
    DATA(lr_filter_bar) = lr_header->filter_bar( usetoolbar = 'false' )->filter_group_items( ).

* ---------- Set filter ---------------------------------------------------------------------------
    DATA(lr_filter) = lr_filter_bar->filter_group_item(  name  = 'VizFrameType'
                                                         label = 'VizFrame type'
                                                         groupname = |GroupVizFrameType|
                                                         visibleinfilterbar = 'true'
                                                         )->filter_control( ).

* ---------- Set combo box input field ------------------------------------------------------------
    lr_filter->combobox( selectedkey    = client->_bind_edit( me->ms_screen-viztypesel )
                         change         = client->_event( val = 'EVT_VIZTYPE_CHANGE' )
                         showclearicon  = abap_true
                         items          = client->_bind( me->mt_viztypes )
                              )->item(
                                  key = '{KEY}'
                                  text = '{TEXT}' ).

* ---------- Get page content area ----------------------------------------------------------------
    DATA(lr_content) = lr_dyn_page->content( ns = 'f' ).

* ---------- Set vizframe chart -------------------------------------------------------------------
    DATA(lr_vizframe) = lr_content->viz_frame(
                          id                = 'idVizFrame'
*                      legendvisible     =
*                      vizcustomizations =
                      vizproperties     = me->mv_prop
*                      vizscales         =
                          viztype           = client->_bind( me->ms_screen-viztype )
                          height            = '500px'
                          width             = '100%'
*                      uiconfig          = `{applicationSet:'fiori'}`
*                      visible           =
                          selectdata    = client->_event( val = 'EVT_DATA_SELECT'
                                                           t_arg = value #( ( `${$parameters>/data/0/data/}` ) ) ) ).

* ---------- Set vizframe dataset -----------------------------------------------------------------
    DATA(lr_dataset) = lr_vizframe->viz_dataset( ).

* ---------- Set vizframe flattened dataset --------------------------------------------------------
    DATA(lr_flatteneddataset) = lr_dataset->viz_flattened_dataset( data = client->_bind( me->mt_data_chart ) ).

* ---------- Set vizframe dimensions ---------------------------------------------------------------
    DATA(lr_dimensions) = lr_flatteneddataset->viz_dimensions( ).

* ---------- Set vizframe dimension ----------------------------------------------------------------
    DATA(lr_dimensions_def) = lr_dimensions->viz_dimension_definition(
*                            axis         =
*                            datatype     =
*                            displayvalue =
*                            identity     =
                                name         = 'Week'
*                            sorter       =
                                value        = '{WEEK}' ).

* ---------- Set vizframe measures ----------------------------------------------------------------
    DATA(lr_measures) = lr_flatteneddataset->viz_measures( ).

* ---------- Set vizframe measure definition 1 ----------------------------------------------------
    DATA(lr_measures_def1) = lr_measures->viz_measure_definition(
*                              format   =
*                              group    =
*                              identity =
                               name     = 'Revenue'
*                              range    =
*                              unit     =
                               value    = '{REVENUE}' ).

* ---------- Set vizframe measure definition 2 ----------------------------------------------------
    DATA(lr_measures_def2) = lr_measures->viz_measure_definition(
*                              format   =
*                              group    =
*                              identity =
                               name     = 'Cost'
*                              range    =
*                              unit     =
                               value    = '{COST}' ).


* ---------- Set vizframe feeds -------------------------------------------------------------------
    DATA(lr_feeds) = lr_vizframe->viz_feeds( ).

* ---------- Set vizframe feed for value axis -----------------------------------------------------
    DATA(lr_lr_feed_item1) = lr_feeds->viz_feed_item(
                               id     = 'valueAxisFeed'
                               uid    = 'valueAxis'
                               type   = 'Measure'
                               values = client->_bind( me->mt_feed_values ) ).

* ---------- Set vizframe feed for category axis --------------------------------------------------
    DATA(lr_lr_feed_item2) = lr_feeds->viz_feed_item(
                               id     = 'categoryAxisFeed'
                               uid    = 'categoryAxis'
                               type   = 'Dimension'
                               values = 'Week' ).


    client->view_display( lr_view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

* ---------- ON INIT ------------------------------------------------------------------------------
      me->on_init( ).

* ---------- ON RENDERING -------------------------------------------------------------------------
      me->on_rendering( ).
      RETURN.

    ENDIF.

* ---------- ON EVENT -----------------------------------------------------------------------------
    me->on_event( ).

  ENDMETHOD.
ENDCLASS.
