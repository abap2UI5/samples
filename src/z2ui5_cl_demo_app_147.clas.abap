CLASS z2ui5_cl_demo_app_147 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA check_initialized TYPE abap_bool .
    DATA ms_chartjs_config_bar TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_bar2 TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_hbar TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_line TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_area TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_pie TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_bubble TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_polar TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_doughnut TYPE z2ui5_cl_cc_chartjs=>ty_chart.
  PROTECTED SECTION.

    METHODS z2ui5_on_rendering.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_init.

  PRIVATE SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_147 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).

      client->view_display( z2ui5_cl_xml_view=>factory( client
        )->_z2ui5( )->timer( finished = client->_event( `START` ) delayms = `0`
          )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>load_js( datalabels = abap_true
                                                                                                   autocolors = abap_true
                                                                                                   deferred   = abap_false
                                                                                                  )
        )->stringify( ) ).


    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'START'.
        z2ui5_on_rendering( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    DATA ls_dataset TYPE z2ui5_cl_cc_chartjs=>ty_dataset.

    ms_chartjs_config_bar-type = 'bar'.
    ms_chartjs_config_bar-data-labels = VALUE #( ( `Red` ) ( `Blue` ) ( `Yellow` ) ( `Green` ) ( `Purple` ) ( `Orange` ) ).

    ls_dataset-border_width = 1.
    ls_dataset-label = `# of Votes`.
    ls_dataset-rtl = abap_true.
    ls_dataset-data = VALUE #( ( `1` ) ( `12` ) ( `19` ) ( `3` ) ( `5` ) ( `2` ) ( `3` ) ).
    APPEND ls_dataset TO ms_chartjs_config_bar-data-datasets.

    ms_chartjs_config_bar-options-plugins-autocolors-mode = 'data'.
    ms_chartjs_config_bar-options-plugins-datalabels-text_align = `center`.
    ms_chartjs_config_bar-options-scales-y-begin_at_zero = abap_true.

    ms_chartjs_config_bar2-type = 'bar'.
    ms_chartjs_config_bar2-data-labels = VALUE #( ( `Jan` ) ( `Feb` ) ( `Mar` ) ( `Apr` ) ( `May` ) ( `Jun` ) ).

    CLEAR ls_dataset.
    ls_dataset-label = 'Fully Rounded'.
    ls_dataset-border_width = 2.
    ls_dataset-border_radius = 200.
    ls_dataset-border_skipped = abap_false.
    ls_dataset-data = VALUE #( ( `1` ) ( `-12` ) ( `19` ) ( `3` ) ( `5` ) ( `-2` ) ( `3` ) ).
    APPEND ls_dataset TO ms_chartjs_config_bar2-data-datasets.

    CLEAR ls_dataset.
    ls_dataset-label = 'Small Radius'.
    ls_dataset-border_width = 2.
    ls_dataset-border_radius = 5.
    ls_dataset-border_skipped = abap_false.
    ls_dataset-data = VALUE #( ( `11` ) ( `2` ) ( `-3` ) ( `13` ) ( `-9` ) ( `7` ) ( `-4` ) ).
    APPEND ls_dataset TO ms_chartjs_config_bar2-data-datasets.

    ms_chartjs_config_bar2-options-responsive = abap_true.
    ms_chartjs_config_bar2-options-plugins-legend-position = `top`.
    ms_chartjs_config_bar2-options-plugins-title-display = abap_true.
    ms_chartjs_config_bar2-options-plugins-title-text = `Bar Chart`.

    ms_chartjs_config_bar2-options-plugins-autocolors-offset = 11.
    ms_chartjs_config_bar2-options-plugins-autocolors-mode = 'dataset'.
    ms_chartjs_config_bar2-options-plugins-datalabels-text_align = `center`.
    ms_chartjs_config_bar2-options-plugins-datalabels-color = `white`.



    ms_chartjs_config_hbar-type = 'bar'.
    ms_chartjs_config_hbar-data-labels = VALUE #( ( `Jan` ) ( `Feb` ) ( `Mar` ) ( `Apr` ) ( `May` ) ( `Jun` ) ).

    CLEAR ls_dataset.
    ls_dataset-label = 'Dataset 1'.
    ls_dataset-background_color = `#ffb1c1`.
    ls_dataset-border_color = `#ff7894`.
    ls_dataset-data = VALUE #( ( `5` ) ( `-12` ) ( `19` ) ( `3` ) ( `5` ) ( `-2` ) ( `3` ) ).
    APPEND ls_dataset TO ms_chartjs_config_hbar-data-datasets.

    CLEAR ls_dataset.
    ls_dataset-label = 'Dataset 2'.
    ls_dataset-background_color = `#9ad0f5`.
    ls_dataset-border_color = `#40a6ec`.
    ls_dataset-data = VALUE #( ( `11` ) ( `2` ) ( `-3` ) ( `13` ) ( `-9` ) ( `7` ) ( `-4` ) ).
    APPEND ls_dataset TO ms_chartjs_config_hbar-data-datasets.

    ms_chartjs_config_hbar-options-responsive = abap_true.
    ms_chartjs_config_hbar-options-index_axis = `y`.
    ms_chartjs_config_hbar-options-elements-bar-border_width = 2.
    ms_chartjs_config_hbar-options-plugins-legend-position = `right`.
    ms_chartjs_config_hbar-options-plugins-title-display = abap_true.
    ms_chartjs_config_hbar-options-plugins-title-text = `Horizontal Bar Chart`.


    ms_chartjs_config_hbar-options-plugins-datalabels-text_align = `center`.
    ms_chartjs_config_hbar-options-plugins-datalabels-color = `white`.


    ms_chartjs_config_line-type = 'line'.
    ms_chartjs_config_line-data-labels = VALUE #( ( `Jan` ) ( `Feb` ) ( `Mar` ) ( `Apr` ) ( `May` ) ( `Jun` ) ).

    CLEAR ls_dataset.
    ls_dataset-label = 'Dataset 1'.
    ls_dataset-background_color = `#ffb1c1`.
    ls_dataset-border_color = `#ff7894`.
    ls_dataset-data = VALUE #( ( `5` ) ( `-12` ) ( `19` ) ( `3` ) ( `5` ) ( `-2` ) ( `3` ) ).
    APPEND ls_dataset TO ms_chartjs_config_line-data-datasets.

    CLEAR ls_dataset.
    ls_dataset-label = 'Dataset 2'.
    ls_dataset-point_style = 'circle'.
    ls_dataset-point_hover_radius = 10.
    ls_dataset-background_color = `#9ad0f5`.
    ls_dataset-border_color = `#40a6ec`.
    ls_dataset-data = VALUE #( ( `11` ) ( `2` ) ( `-3` ) ( `13` ) ( `-9` ) ( `7` ) ( `-4` ) ).
    APPEND ls_dataset TO ms_chartjs_config_line-data-datasets.

    ms_chartjs_config_line-options-responsive = abap_true.
    ms_chartjs_config_line-options-plugins-legend-position = `top`.
    ms_chartjs_config_line-options-plugins-title-display = abap_true.
    ms_chartjs_config_line-options-plugins-title-text = `Line Chart`.
    ms_chartjs_config_line-options-plugins-datalabels-font-size = `10`.
    ms_chartjs_config_line-options-plugins-datalabels-font-weight = `bold`.
    ms_chartjs_config_line-options-plugins-datalabels-text_align = 'start'.
    ms_chartjs_config_line-options-plugins-datalabels-offset = 90.
*    ms_chartjs_config_line-options-plugins-datalabels-offset = `6`.


    ms_chartjs_config_bubble-type = 'bubble'.

    CLEAR ls_dataset.
    ls_dataset-label = 'Dataset 1'.
    ls_dataset-data_x_y_r = VALUE #( ( x = `100` y = `0` r = `8` )
                                  ( x = `60`  y = `30` r = `15` )
                                  ( x = `40`  y = `60` r = `8` )
                                  ( x = `80`  y = `80` r = `23` )
                                  ( x = `20`  y = `30` r = `8` )
                                  ( x = `0`  y = `100` r = `9` )
                                ).
    ls_dataset-background_color = `#ffb1c1`.
    ls_dataset-border_color = `#ff7894`.
    APPEND ls_dataset TO ms_chartjs_config_bubble-data-datasets.

    CLEAR ls_dataset.
    ls_dataset-label = 'Dataset 2'.
    ls_dataset-background_color = `#9ad0f5`.
    ls_dataset-border_color = `#40a6ec`.
    ls_dataset-data_x_y_r = VALUE #( ( x = `0` y = `0` r = `8` )
                              ( x = `20`  y = `15` r = `15` )
                              ( x = `80`  y = `40` r = `8` )
                              ( x = `20`  y = `66` r = `23` )
                              ( x = `10`  y = `15` r = `8` )
                              ( x = `80`  y = `5` r = `9` )
                            ).
    APPEND ls_dataset TO ms_chartjs_config_bubble-data-datasets.

    ms_chartjs_config_bubble-options-responsive = abap_true.
    ms_chartjs_config_bubble-options-plugins-legend-position = `top`.
    ms_chartjs_config_bubble-options-plugins-title-display = '-'.
    ms_chartjs_config_bubble-options-plugins-title-text = `Bubble Chart`.
    ms_chartjs_config_bubble-options-plugins-datalabels-display = '-'.


    ms_chartjs_config_doughnut-type = 'doughnut'.
    ms_chartjs_config_doughnut-data-labels = VALUE #( ( `Red` ) ( `Blue` ) ( `Teal` ) ( `Green` ) ( `Purple` ) ( `Orange` ) ).

    CLEAR ls_dataset.
    ls_dataset-label = `Dataset 1`.
    ls_dataset-background_color_t = VALUE #( ( `red` ) ( `blue` ) ( `#118ab2` ) ( `green` ) ( `purple` ) ( `orange` ) ).
    ls_dataset-data = VALUE #( ( `1` ) ( `12` ) ( `19` ) ( `3` ) ( `5` ) ( `2` ) ).
    ls_dataset-hover_offset = 5.
    APPEND ls_dataset TO ms_chartjs_config_doughnut-data-datasets.

    ms_chartjs_config_doughnut-options-plugins-autocolors-enabled = '-'.
    ms_chartjs_config_doughnut-options-plugins-datalabels-text_align = 'center'.
    ms_chartjs_config_doughnut-options-plugins-datalabels-color = 'white'.
    ms_chartjs_config_doughnut-options-plugins-title-text = `Doughnut Chart`.
    ms_chartjs_config_doughnut-options-plugins-title-display = abap_true.
    ms_chartjs_config_doughnut-options-plugins-legend-position = 'right'.


    ms_chartjs_config_pie-type = 'pie'.
    ms_chartjs_config_pie-data-labels = VALUE #( ( `Red` ) ( `Blue` ) ( `Teal` ) ( `Green` ) ( `Purple` ) ( `Orange` ) ).

    CLEAR ls_dataset.
    ls_dataset-label = `Dataset 1'`.
    ls_dataset-background_color_t = VALUE #( ( `red` ) ( `blue` ) ( `#118ab2` ) ( `green` ) ( `purple` ) ( `orange` ) ).
    ls_dataset-data = VALUE #( ( `1` ) ( `12` ) ( `19` ) ( `3` ) ( `5` ) ( `2` ) ).
    ls_dataset-hover_offset = 5.
    APPEND ls_dataset TO ms_chartjs_config_pie-data-datasets.

    ms_chartjs_config_pie-options-plugins-autocolors-enabled = '-'.
    ms_chartjs_config_pie-options-plugins-datalabels-text_align = 'center'.
    ms_chartjs_config_pie-options-plugins-datalabels-color = 'white'.
    ms_chartjs_config_pie-options-plugins-title-text = `Pie Chart`.
    ms_chartjs_config_pie-options-plugins-title-display = abap_true.
    ms_chartjs_config_pie-options-plugins-legend-position = 'left'.


    ms_chartjs_config_polar-type = 'polarArea'.
    ms_chartjs_config_polar-data-labels = VALUE #( ( `Red` ) ( `Blue` ) ( `Teal` ) ( `Green` ) ( `Purple` ) ( `Orange` ) ).

    CLEAR ls_dataset.
    ls_dataset-label = `Dataset 1`.
    ls_dataset-background_color_t = VALUE #( ( `red` ) ( `blue` ) ( `#118ab2` ) ( `green` ) ( `purple` ) ( `orange` ) ).
    ls_dataset-data = VALUE #( ( `10` ) ( `12` ) ( `19` ) ( `8` ) ( `5` ) ( `9` ) ).
    APPEND ls_dataset TO ms_chartjs_config_polar-data-datasets.

    ms_chartjs_config_polar-options-plugins-autocolors-enabled = '-'.
    ms_chartjs_config_polar-options-plugins-datalabels-text_align = 'center'.
    ms_chartjs_config_polar-options-plugins-datalabels-color = 'white'.
    ms_chartjs_config_polar-options-plugins-title-text = `Polar Area Chart`.
    ms_chartjs_config_polar-options-plugins-title-display = abap_true.
    ms_chartjs_config_polar-options-plugins-legend-position = 'left'.

  ENDMETHOD.


  METHOD z2ui5_on_rendering.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
         )->page(
          showheader       = xsdbool( abap_false = client->get( )-check_launchpad_active )
            title          = 'abap2UI5 - ChartJS demo'
            navbuttonpress = client->_event( 'BACK' )
            enablescrolling = abap_false
              shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
         )->get_parent( ).


*    DATA(vbox) = page->vbox( justifycontent = `Center`  ).
    DATA(car) = page->carousel( class = `sapUiContentPadding` ).
    DATA(vl1) = car->vertical_layout( width = `100%` ).
    DATA(fb1) = vl1->flex_box( width = `100%` height = `50%` justifycontent = `SpaceAround` ).
    DATA(fb2) = vl1->flex_box( width = `100%` height = `50%` justifycontent = `SpaceAround` ).
    fb1->vbox( justifycontent = `Center` )->html_canvas( id = `bar`  height = `300` width = `400` ).
    fb1->vbox( justifycontent = `Center` )->html_canvas( id = `bar2` height = `300` width = `400` ).
    fb2->vbox( justifycontent = `Center` )->html_canvas( id = `hbar` height = `300` width = `400` ).
    fb2->vbox( justifycontent = `Center` )->html_canvas( id = `line`  height = `300` width = `400` ).

    DATA(vl2) = car->vertical_layout( width = `100%` ).
    DATA(fb3) = vl2->flex_box( width = `100%` height = `50%` justifycontent = `SpaceAround` ).
    DATA(fb4) = vl2->flex_box( width = `100%` height = `50%` justifycontent = `SpaceAround` ).
    fb3->vbox( justifycontent = `Center` )->html_canvas( id = `bubble`  height = `300` width = `315 ` ).
    fb3->vbox( justifycontent = `Center` )->html_canvas( id = `doughnut`  height = `300` width = `315` ).
    fb4->vbox( justifycontent = `Center` )->html_canvas( id = `pie`  height = `300` width = `315` ).
    fb4->vbox( justifycontent = `Center` )->html_canvas( id = `polar`  height = `300` width = `315` ).


*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'bar'
*                                                                                                      is_config = ms_chartjs_config_bar
*                                                                                                      view = client->cs_view-main ) ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'bar2'
*                                                                                                      is_config = ms_chartjs_config_bar2
*                                                                                                      view = client->cs_view-main ) ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'hbar'
*                                                                                                      is_config = ms_chartjs_config_hbar
*                                                                                                      view = client->cs_view-main ) ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'line'
*                                                                                                      is_config = ms_chartjs_config_line
*                                                                                                      view = client->cs_view-main ) ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'bubble'
*                                                                                                      is_config = ms_chartjs_config_bubble
*                                                                                                      view = client->cs_view-main ) ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'doughnut'
*                                                                                                      is_config = ms_chartjs_config_doughnut
*                                                                                                      view = client->cs_view-main ) ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'pie'
*                                                                                                      is_config = ms_chartjs_config_pie
*                                                                                                      view = client->cs_view-main ) ).
*    view->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'polar'
*                                                                                                      is_config = ms_chartjs_config_polar
*                                                                                                      view = client->cs_view-main ) ).
    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
