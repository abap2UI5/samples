CLASS z2ui5_cl_demo_app_147 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA check_initialized TYPE abap_bool .
    DATA ms_chartjs_config TYPE z2ui5_cl_cc_chartjs=>ty_chart .
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

    ms_chartjs_config-type = 'bar'.
    ms_chartjs_config-data-labels = VALUE #( ( `Red` ) ( `Blue` ) ( `Yellow` ) ( `Green` ) ( `Purple` ) ( `Orange` ) ).

    ls_dataset-border_width = 1.
    ls_dataset-label = `# of Votes`.
    ls_dataset-data = VALUE #( ( `1` ) ( `12` ) ( `19` ) ( `3` ) ( `5` ) ( `2` ) ( `3` ) ).
    APPEND ls_dataset TO ms_chartjs_config-data-datasets.

    ms_chartjs_config-options-plugins-autocolors-mode = 'data'.

    ms_chartjs_config-plugins = VALUE #( ( `ChartDataLabels` ) ( `autocolors` ) ).

    ms_chartjs_config-options-scales-y-begin_at_zero = abap_true.

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


    DATA(vbox) = page->vbox( justifycontent = `Center`  ).
    vbox->html_canvas( id = `myChart` ).

    vbox->_generic( name = `script` ns = `html` )->_cc_plain_xml( z2ui5_cl_cc_chartjs=>set_js_config( canvas_id = 'myChart'
                                                                                                      is_config = ms_chartjs_config
                                                                                                      view = client->cs_view-main ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
