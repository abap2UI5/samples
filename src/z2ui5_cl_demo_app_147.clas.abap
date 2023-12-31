class Z2UI5_CL_DEMO_APP_147 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  data MS_CHARTJS_CONFIG type Z2UI5_CL_CC_CHARTJS=>TY_CHART .
  PROTECTED SECTION.

    METHODS z2ui5_on_rendering.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_init.

  PRIVATE SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_147 IMPLEMENTATION.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).

      client->view_display( z2ui5_cl_xml_view=>factory( client
        )->_z2ui5( )->timer(  client->_event( `START` )
        )->_generic( ns = `html` name = `script` t_prop = VALUE #( ( n = `src` v = z2ui5_cl_cc_chartjs=>get_js_url( ) )
        ) )->get_parent(
        )->stringify( ) ).

    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD Z2UI5_ON_EVENT.

    CASE client->get( )-event.
      WHEN 'START'.
        z2ui5_on_rendering( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_ON_INIT.

    DATA ls_dataset TYPE z2ui5_cl_cc_chartjs=>ty_dataset.

    ms_chartjs_config-type = 'bar'.
    ms_chartjs_config-data-labels = VALUE #( ( `Red` ) ( `Blue` ) ( `Yellow` ) ( `Green` ) ( `Purple` ) ( `Orange` ) ).

    ls_dataset-border_width = 1.
    ls_dataset-label = `# of Votes`.
    ls_dataset-data = VALUE #( ( `1` ) ( `12` ) ( `19` ) ( `3` ) ( `5` ) ( `2` ) ( `3` ) ).
    APPEND ls_dataset TO ms_chartjs_config-data-datasets.

    ms_chartjs_config-options-plugins-colors-force_override = abap_true.
    ms_chartjs_config-options-plugins-colors-enabled = abap_true.


    ms_chartjs_config-options-scales-y-begin_at_zero = abap_true.

  ENDMETHOD.


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
         )->get_parent( ).


    DATA(vbox) = page->vbox( justifycontent = `Center`  ).
    vbox->html_canvas( id = `myChart` ).

    vbox->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'myChart'
                                                                                                      is_config = ms_chartjs_config
                                                                                                      view = client->cs_view-main ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
