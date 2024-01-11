class Z2UI5_CL_DEMO_APP_148 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  data MS_CHARTJS_CONFIG_BAR type Z2UI5_CL_CC_CHARTJS=>TY_CHART .
  data MS_CHARTJS_CONFIG_BAR_t type TABLE OF Z2UI5_CL_CC_CHARTJS=>TY_CHART .
  data MS_CHARTJS_CONFIG_BAR2 type Z2UI5_CL_CC_CHARTJS=>TY_CHART .
  data MS_CHARTJS_CONFIG_HBAR type Z2UI5_CL_CC_CHARTJS=>TY_CHART .
  data MS_CHARTJS_CONFIG_LINE type Z2UI5_CL_CC_CHARTJS=>TY_CHART .
  data MS_CHARTJS_CONFIG_AREA type Z2UI5_CL_CC_CHARTJS=>TY_CHART .
  data MS_CHARTJS_CONFIG_PIE type Z2UI5_CL_CC_CHARTJS=>TY_CHART .
  data MS_CHARTJS_CONFIG_BUBBLE type Z2UI5_CL_CC_CHARTJS=>TY_CHART .
  data MS_CHARTJS_CONFIG_POLAR type Z2UI5_CL_CC_CHARTJS=>TY_CHART .
  data MS_CHARTJS_CONFIG_DOUGHNUT type Z2UI5_CL_CC_CHARTJS=>TY_CHART .
  PROTECTED SECTION.

    METHODS z2ui5_on_rendering.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_init.

  PRIVATE SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_148 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Z2UI5_CL_DEMO_APP_147TEST->Z2UI5_IF_APP~MAIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] CLIENT                         TYPE REF TO Z2UI5_IF_CLIENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).

      client->view_display( z2ui5_cl_xml_view=>factory( client
        )->_z2ui5( )->timer( finished = client->_event( `START` ) delayms = `0`
           )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>load_js( datalabels = abap_false
                                                                                                    autocolors = abap_false
                                                                                                   ) )->get_parent(
           )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>load_cc( )

        )->stringify( ) ).


    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_DEMO_APP_147TEST->Z2UI5_ON_EVENT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD Z2UI5_ON_EVENT.

    CASE client->get( )-event.
      WHEN 'UPDATE_CHART'.
*        READ TABLE ms_chartjs_config_bar-data-datasets ASSIGNING FIELD-SYMBOL(<fs_bar>) INDEX 1.
*        <fs_bar>-data = VALUE #( ( `11` ) ( `1` ) ( `1` ) ( `13` ) ( `15` ) ( `12` ) ( `13` ) ).

        ms_chartjs_config_bar-options-plugins-autocolors-mode = 'dataset'.

      WHEN 'START'.
        z2ui5_on_rendering( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_DEMO_APP_147TEST->Z2UI5_ON_INIT
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD Z2UI5_ON_INIT.

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

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_DEMO_APP_147TEST->Z2UI5_ON_RENDERING
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD Z2UI5_ON_RENDERING.

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
                             config = client->_bind( val = ms_chartjs_config_bar pretty_name = 'X' compress = abap_true )
                          ).
*    fb1->vbox( justifycontent = `Center`
*      )->_z2ui5( )->chartjs( canvas_id = `bar2`
*                             height = `300`
*                             width = `400`
*                             config = client->_bind_edit( val = ms_chartjs_config_bar2 pretty_name = 'X' compress = abap_true )
*                          ).


    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
