CLASS Z2UI5_CL_DEMO_APP_016 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    DATA check_initialized TYPE abap_bool.

    DATA mv_sel1 TYPE abap_bool.
    DATA mv_sel2 TYPE abap_bool.
    DATA mv_sel3 TYPE abap_bool.

    DATA mv_tab_bar_active TYPE abap_bool.

    METHODS render_tab_bar.

    DATA client TYPE REF TO Z2UI5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_016 IMPLEMENTATION.


  METHOD render_tab_bar.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(container) = view->shell(
        )->page(
             showheader       = xsdbool( abap_false = client->get( )-check_launchpad_active )
            title = 'abap2UI5 - Visualization'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = abap_true
            )->header_content(
                )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1639191954285113344`
                )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->get_parent(
        )->tab_container( ).

    DATA(grid) = container->tab(
            text     = 'Bar Chart'
            selected = client->_bind( mv_tab_bar_active )
        )->grid( 'XL6 L6 M6 S12' ).

    grid->link(
            text = 'Go to the SAP Demos for Interactive bar Charts here...' target = '_blank'
            href = 'https://sapui5.hana.ondemand.com/#/entity/sap.suite.ui.microchart.InteractiveBarChart/sample/sap.suite.ui.microchart.sample.InteractiveBarChart'
        )->text(
                text  = 'Absolute and Percentage value'
                class = 'sapUiSmallMargin'
            )->get( )->layout_data(
                )->grid_data( 'XL12 L12 M12 S12' ).

    DATA(bar) = grid->flex_box(
            width      = '22rem'
            height     = '13rem'
            alignitems = 'Center'
            class      = 'sapUiSmallMargin'
        )->items( )->interact_bar_chart(
                selectionchanged = client->_event( 'BAR_CHANGED' )
                press            = client->_event( 'BAR_CHANGED' )
            )->bars( ).
    bar->interact_bar_chart_bar( selected = client->_bind( mv_sel1 ) label = 'Product 1' value = '10' ).
    bar->interact_bar_chart_bar( selected = client->_bind( mv_sel2 ) label = 'Product 2' value = '20' ).
    bar->interact_bar_chart_bar( selected = client->_bind( mv_sel3 ) label = 'Product 3' value = '70' ).

    bar = grid->flex_box(
            width      = '22rem'
            height     = '13rem'
            alignitems = 'Center'
            class      = 'sapUiSmallMargin'
        )->items( )->interact_bar_chart(
                selectionchanged = client->_event( 'BAR_CHANGED' )
            )->bars( ).
    bar->interact_bar_chart_bar( label = 'Product 1' value = '10' displayedvalue = '10%' ).
    bar->interact_bar_chart_bar( label = 'Product 2' value = '20' displayedvalue = '20%' ).
    bar->interact_bar_chart_bar( label = 'Product 3' value = '70' displayedvalue = '70%' ).

    bar = grid->vertical_layout(
        )->layout_data( 'layout'
            )->grid_data( 'XL12 L12 M12 S12'
        )->get_parent(
        )->text(
            text  = 'Positive and Negative values'
            class = 'sapUiSmallMargin'
        )->flex_box(
            width      = '20rem'
            height     = '10rem'
            alignitems = 'Center'
            class      = 'sapUiSmallMargin'
        )->items( )->interact_bar_chart(
                selectionchanged = client->_event( 'BAR_CHANGED' )
                press            = client->_event( 'BAR_PRESS' )
                labelwidth       = '25%'
            )->bars( ).
    bar->interact_bar_chart_bar( label = 'Product 1' value = '25' ).
    bar->interact_bar_chart_bar( label = 'Product 2' value = '-50' ).
    bar->interact_bar_chart_bar( label = 'Product 3' value = '-100' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

*      DATA(lv_version) = to_upper( client->get( )-s_config-version ).
*      IF lv_version CS `OPEN`.
*        client->message_box_display( text = `Charts are not available with OpenUI5, change your UI5 library first` type = `error` ).
*        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
*        return.
*      ENDIF.

      render_tab_bar( ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
