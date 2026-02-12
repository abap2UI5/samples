CLASS z2ui5_cl_demo_app_016 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_sel1 TYPE abap_bool.
    DATA mv_sel2 TYPE abap_bool.
    DATA mv_sel3 TYPE abap_bool.

    DATA mv_tab_bar_active TYPE abap_bool.

    METHODS render_tab_bar.

    DATA mo_client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_016 IMPLEMENTATION.

  METHOD render_tab_bar.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_container) = lo_view->shell(
        )->page(
             showheader    = xsdbool( abap_false = mo_client->get( )-check_launchpad_active )
            title          = `abap2UI5 - Visualization`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( )
        )->tab_container( ).

    DATA(lo_grid) = lo_container->tab(
            text     = `Bar Chart`
            selected = mo_client->_bind( mv_tab_bar_active )
        )->grid( `XL6 L6 M6 S12` ).

    lo_grid->link(
            text   = `Go to the SAP Demos for Interactive bar Charts here...`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/#/entity/sap.suite.ui.microchart.InteractiveBarChart/sample/sap.suite.ui.microchart.sample.InteractiveBarChart`
        )->text(
                text  = `Absolute and Percentage value`
                class = `sapUiSmallMargin`
            )->get( )->layout_data(
                )->grid_data( `XL12 L12 M12 S12` ).

    DATA(lo_bar) = lo_grid->flex_box(
            width      = `22rem`
            height     = `13rem`
            alignitems = `Center`
            class      = `sapUiSmallMargin`
        )->items( )->interact_bar_chart(
                selectionchanged = mo_client->_event( `BAR_CHANGED` )
                press            = mo_client->_event( `BAR_CHANGED` )
                labelwidth       = `25%`
                displayedbars    = `4`
            )->bars( ).
    lo_bar->interact_bar_chart_bar( selected = mo_client->_bind( mv_sel1 )
                                 label    = `Product 1`
                                 value    = `10` ).
    lo_bar->interact_bar_chart_bar( selected = mo_client->_bind( mv_sel2 )
                                 label    = `Product 2`
                                 value    = `20` ).
    lo_bar->interact_bar_chart_bar( selected = mo_client->_bind( mv_sel3 )
                                 label    = `Product 3`
                                 value    = `70` ).

    lo_bar = lo_grid->flex_box(
            width      = `22rem`
            height     = `13rem`
            alignitems = `Center`
            class      = `sapUiSmallMargin`
        )->items( )->interact_bar_chart(
                selectionchanged = mo_client->_event( `BAR_CHANGED` )
            )->bars( ).
    lo_bar->interact_bar_chart_bar( label          = `Product 1`
                                 value          = `10`
                                 displayedvalue = `10%` ).
    lo_bar->interact_bar_chart_bar( label          = `Product 2`
                                 value          = `20`
                                 displayedvalue = `20%` ).
    lo_bar->interact_bar_chart_bar( label          = `Product 3`
                                 value          = `70`
                                 displayedvalue = `70%` ).

    lo_bar = lo_grid->vertical_layout(
        )->layout_data( `layout`
            )->grid_data( `XL12 L12 M12 S12`
        )->get_parent(
        )->text(
            text  = `Positive and Negative values`
            class = `sapUiSmallMargin`
        )->flex_box(
            width      = `20rem`
            height     = `10rem`
            alignitems = `Center`
            class      = `sapUiSmallMargin`
        )->items( )->interact_bar_chart(
                selectionchanged = mo_client->_event( `BAR_CHANGED` )
                press            = mo_client->_event( `BAR_PRESS` )
                labelwidth       = `25%`
            )->bars( ).
    lo_bar->interact_bar_chart_bar( label = `Product 1`
                                 value = `25` ).
    lo_bar->interact_bar_chart_bar( label = `Product 2`
                                 value = `-50` ).
    lo_bar->interact_bar_chart_bar( label = `Product 3`
                                 value = `-100` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      render_tab_bar( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
