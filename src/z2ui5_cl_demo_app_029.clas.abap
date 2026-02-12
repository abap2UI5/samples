CLASS z2ui5_cl_demo_app_029 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_tab_radial_active TYPE abap_bool.

    METHODS render_tab_radial.

    DATA mo_client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_029 IMPLEMENTATION.

  METHOD render_tab_radial.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_container) = lo_view->shell(
        )->page(
            title          = `abap2UI5 - Visualization`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( )
        )->tab_container( ).

    DATA(lo_grid) = lo_container->tab(
            text     = `Radial Chart`
            selected = mo_client->_bind( mv_tab_radial_active )
        )->grid( `XL12 L12 M12 S12` ).

    lo_grid->link(
        text   = `Go to the SAP Demos for Radial Charts here...`
        target = `_blank`
        href   = `https://sapui5.hana.ondemand.com/#/entity/sap.suite.ui.microchart.RadialMicroChart/sample/sap.suite.ui.microchart.sample.RadialMicroChart` ).

    lo_grid->vertical_layout(
        )->horizontal_layout(
            )->radial_micro_chart(
                size       = `M`
                percentage = `45`
                press      = mo_client->_event( `RADIAL_PRESS` )
            )->radial_micro_chart(
                size       = `S`
                percentage = `45`
                press      = mo_client->_event( `RADIAL_PRESS` )
        )->get_parent(
        )->horizontal_layout(
            )->radial_micro_chart(
                size       = `M`
                percentage = `99.9`
                press      = mo_client->_event( `RADIAL_PRESS` )
                valuecolor = `Good`
            )->radial_micro_chart(
                size       = `S`
                percentage = `99.9`
                press      = mo_client->_event( `RADIAL_PRESS` )
                valuecolor = `Good`
        )->get_parent(
        )->horizontal_layout(
            )->radial_micro_chart(
                size       = `M`
                percentage = `0`
                press      = mo_client->_event( `RADIAL_PRESS` )
                valuecolor = `Error`
            )->radial_micro_chart(
                size       = `S`
                percentage = `0`
                press      = mo_client->_event( `RADIAL_PRESS` )
                valuecolor = `Error`
        )->get_parent(
        )->horizontal_layout(
            )->radial_micro_chart(
                size       = `M`
                percentage = `0.1`
                press      = mo_client->_event( `RADIAL_PRESS` )
                valuecolor = `Critical`
            )->radial_micro_chart(
                size       = `S`
                percentage = `0.1`
                press      = mo_client->_event( `RADIAL_PRESS` )
                valuecolor = `Critical` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      render_tab_radial( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
