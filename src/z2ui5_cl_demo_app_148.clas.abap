CLASS z2ui5_cl_demo_app_148 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA ls_dataset TYPE z2ui5_cl_cc_chartjs=>ty_dataset.
    DATA check_initialized TYPE abap_bool .

    "bar charts
    DATA ms_chartjs_config_bar TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_bar2 TYPE z2ui5_cl_cc_chartjs=>ty_chart .
    DATA ms_chartjs_config_hbar TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "venn chart - plugin
    DATA ms_chartjs_config_venn TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "wordCloud
    DATA ms_chartjs_config_wordcloud TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "line charts
    DATA ms_chartjs_config_line TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "area charts
    DATA ms_chartjs_config_area TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "pie charts
    DATA ms_chartjs_config_pie TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "bubble charts
    DATA ms_chartjs_config_bubble TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "polar charts
    DATA ms_chartjs_config_polar TYPE z2ui5_cl_cc_chartjs=>ty_chart .

    "doughnut charts
    DATA ms_chartjs_config_doughnut TYPE z2ui5_cl_cc_chartjs=>ty_chart .


  PROTECTED SECTION.

    METHODS z2ui5_on_rendering.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_init.

  PRIVATE SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_148 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).

      client->view_display( z2ui5_cl_xml_view=>factory( client
        )->_z2ui5( )->timer( finished = client->_event( `START` ) delayms = `0`
           )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>load_js( datalabels = abap_true
                                                                                                    autocolors = abap_false
                                                                                                    venn       = abap_true
                                                                                                    wordcloud  = abap_true
                                                                                                    annotation = abap_true
           ) )->get_parent(
           )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>load_cc( )
        )->stringify( ) ).

    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'UPDATE_CHART'.
        READ TABLE ms_chartjs_config_bar-data-datasets ASSIGNING FIELD-SYMBOL(<fs_bar>) INDEX 1.
        <fs_bar>-data = VALUE #( ( `11` ) ( `1` ) ( `1` ) ( `13` ) ( `15` ) ( `12` ) ( `13` ) ).

        ms_chartjs_config_bar2-options-plugins-legend-position = `left`.

        ms_chartjs_config_venn-data-labels = VALUE #( ( `Reading` )
                                                      ( `Maths` )
                                                      ( `GPS` )
                                                      ( `Reading ∩ Maths` )
                                                      ( `GPS ∩ Reading` )
                                                      ( `Maths ∩ GPS` )
                                                      ( `Reading ∩ Maths ∩ GPS` ) ).

        CLEAR ls_dataset.
        ls_dataset-label = `At or Above Expected`.
        ls_dataset-background_color = `rgba(75, 192, 192, 0.2)`.
        ls_dataset-border_color = `rgba(75, 192, 192, 1)`.
        ls_dataset-data_venn = VALUE #(
                                        ( sets = VALUE #( ( `Reading` ) )                       value = `15%` )
                                        ( sets = VALUE #( ( `Maths` ) )                         value = `3%` )
                                        ( sets = VALUE #( ( `GPS` ) )                           value = `3%` )
                                        ( sets = VALUE #( ( `Reading` ) ( `Maths` ) )           value = `3%` )
                                        ( sets = VALUE #( ( `GPS` ) ( `Reading` ) )             value = `21%` )
                                        ( sets = VALUE #( ( `Maths` ) ( `GPS` ) )               value = `0%` )
                                        ( sets = VALUE #( ( `Reading` ) ( `Maths` ) ( `GPS` ) ) value = `13%` )
                                      ).
        CLEAR ms_chartjs_config_venn-data-datasets.
        APPEND ls_dataset TO ms_chartjs_config_venn-data-datasets.


        ms_chartjs_config_wordcloud-options-plugins-datalabels-display = '-'.

        client->view_model_update( ).

      WHEN 'START'.
        z2ui5_on_rendering( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    "bar

    ms_chartjs_config_bar-type = 'bar'.
    ms_chartjs_config_bar-data-labels = VALUE #( ( `Red` ) ( `Blue` ) ( `Yellow` ) ( `Green` ) ( `Purple` ) ( `Orange` ) ( `Black` ) ).

    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-type = 'line'.
    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-border_color = 'black'.
    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-border_width = '5'.
    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-label-background_color = 'red'.
    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-label-content = 'Test Label'.
    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-label-display = abap_true.
    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-scaleid = 'y'.
    ms_chartjs_config_bar-options-plugins-annotation-annotations-shape1-value = '14'.

    ls_dataset-border_width = 1.
    ls_dataset-label = `# of Votes`.
    ls_dataset-rtl = abap_true.
    ls_dataset-data = VALUE #( ( `1` ) ( `12` ) ( `19` ) ( `3` ) ( `5` ) ( `2` ) ( `3` ) ).
    APPEND ls_dataset TO ms_chartjs_config_bar-data-datasets.

*    ms_chartjs_config_bar-options-plugins-autocolors-mode = 'data'.
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


    "venn
    ms_chartjs_config_venn-type = 'venn'.
    ms_chartjs_config_venn-data-labels = VALUE #( ( `Soccer` )
                                                  ( `Tennis` )
                                                  ( `Volleyball` )
                                                  ( `Soccer ∩ Tennis` )
                                                  ( `Soccer ∩ Volleyball` )
                                                  ( `Tennis ∩ Volleyball` )
                                                  ( `Soccer ∩ Tennis ∩ Volleyball` ) ).

    CLEAR ls_dataset.
    ls_dataset-label = `Sports`.
    ls_dataset-data_venn = VALUE #(
                                    ( sets = VALUE #( ( `Soccer` ) )                               value = `2` )
                                    ( sets = VALUE #( ( `Tennis` ) )                               value = `0` )
                                    ( sets = VALUE #( ( `Volleyball` ) )                           value = `1` )
                                    ( sets = VALUE #( ( `Soccer` ) ( `Tennis` ) )                  value = `1` )
                                    ( sets = VALUE #( ( `Soccer` ) ( `Volleyball` ) )              value = `0` )
                                    ( sets = VALUE #( ( `Tennis` ) ( `Volleyball` ) )              value = `1` )
                                    ( sets = VALUE #( ( `Soccer` ) ( `Tennis` ) ( `Volleyball` ) ) value = `1` )
                                  ).

    APPEND ls_dataset TO ms_chartjs_config_venn-data-datasets.

    "wordcloud

    ms_chartjs_config_wordcloud-type = `wordCloud`.
    ms_chartjs_config_wordcloud-data-labels = VALUE #(
                                                      ( `Hello` )
                                                      ( `world` )
                                                      ( `normally` )
                                                      ( `you` )
                                                      ( `want` )
                                                      ( `more` )
                                                      ( `words` )
                                                      ( `than` )
                                                      ( `this` )
                                                     ).
    CLEAR ls_dataset.
    ls_dataset-label = `DS`.
    ls_dataset-data = VALUE #(
                               ( `90` )
                               ( `80` )
                               ( `70` )
                               ( `60` )
                               ( `50` )
                               ( `40` )
                               ( `30` )
                               ( `20` )
                               ( `10` )
                             ).

    APPEND ls_dataset TO ms_chartjs_config_wordcloud-data-datasets.

    "disable datalabels
    ms_chartjs_config_wordcloud-options-plugins-datalabels-display = '-'.

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
             )->button( text = 'Update Chart' press = client->_event( 'UPDATE_CHART' )
         )->get_parent( ).


*    DATA(vbox) = page->vbox( justifycontent = `Center`  ).
    DATA(car) = page->carousel( class = `sapUiContentPadding` ).
    DATA(vl1) = car->vertical_layout( width = `100%` ).
    DATA(fb1) = vl1->flex_box( width = `100%` height = `50%` justifycontent = `SpaceAround` ).
    DATA(fb2) = vl1->flex_box( width = `100%` height = `50%` justifycontent = `SpaceAround` ).
    fb1->vbox( justifycontent = `Center`
      )->_z2ui5( )->chartjs( canvas_id = `bar`
                             height = `300`
                             width = `400`
                             config = client->_bind_edit( val = ms_chartjs_config_bar pretty_name = 'X' compress = client->cs_compress_mode-full )
                          ).
    fb1->vbox( justifycontent = `Center`
      )->_z2ui5( )->chartjs( canvas_id = `bar2`
                             height = `300`
                             width = `600`
                             config = client->_bind_edit( val = ms_chartjs_config_bar2 pretty_name = 'X' compress = client->cs_compress_mode-full )
                          ).
    fb2->vbox( justifycontent = `Center`
      )->_z2ui5( )->chartjs( canvas_id = `venn`
                             height = `300`
                             width = `600`
                             config = client->_bind_edit( val = ms_chartjs_config_venn pretty_name = 'X' compress = client->cs_compress_mode-full )
                          ).
    fb2->vbox( justifycontent = `Center`
      )->_z2ui5( )->chartjs( canvas_id = `wordCloud`
                             height = `300`
                             width = `600`
                             config = client->_bind_edit( val = ms_chartjs_config_wordcloud pretty_name = 'X' compress = client->cs_compress_mode-full )
                          ).


    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
