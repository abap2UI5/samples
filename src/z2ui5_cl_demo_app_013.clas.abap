CLASS z2ui5_cl_demo_app_013 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA check_initialized TYPE abap_bool.








    DATA mv_sel4 TYPE abap_bool.
    DATA mv_sel5 TYPE abap_bool.
    DATA mv_sel6 TYPE abap_bool.








    DATA mv_tab_donut_active TYPE abap_bool.




    METHODS render_tab_donut.


    DATA client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_cl_demo_app_013 IMPLEMENTATION.


  METHOD render_tab_donut.

    DATA(view) = z2ui5_cl_xml_view=>factory( client ).

    DATA(container) = view->shell(
        )->page(
            title = 'abap2UI5 - Visualization'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = abap_true
            )->header_content(
                )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1639191954285113344`
                )->link( text = 'Source_Code' target = '_blank' href = view->hlp_get_source_code_url( )
        )->get_parent(
        )->tab_container( ).

    DATA(grid) = container->tab(
            text     = 'Donut Chart'
            selected = client->_bind( mv_tab_donut_active )
        )->grid( 'XL6 L6 M6 S12' ).

    grid->link(
         text = 'Go to the SAP Demos for Interactive Donut Charts here...' target = '_blank'
         href = 'https://sapui5.hana.ondemand.com/#/entity/sap.suite.ui.microchart.InteractiveDonutChart/sample/sap.suite.ui.microchart.sample.InteractiveDonutChart'
        )->text(
                text  = 'Three segments'
                class = 'sapUiSmallMargin'
            )->get( )->layout_data(
                )->grid_data( 'XL12 L12 M12 S12' ).

    DATA(seg) = grid->flex_box(
            width          = '22rem'
            height         = '13rem'
            alignitems     = 'Start'
            justifycontent = 'SpaceBetween'
                )->items(
                    )->interact_donut_chart(
                            selectionchanged = client->_event( 'DONUT_CHANGED' )
                    )->segments( ).
    seg->interact_donut_chart_segment( selected = client->_bind( mv_sel4 ) label = 'Impl. Phase'  value = '40.0' displayedvalue = '40.0%' ).
    seg->interact_donut_chart_segment( selected = client->_bind( mv_sel5 ) label = 'Design Phase' value = '21.5' displayedvalue = '21.5%' ).
    seg->interact_donut_chart_segment( selected = client->_bind( mv_sel6 ) label = 'Test Phase'   value = '38.5' displayedvalue = '38.5%' ).

    grid->text(
            text  = 'Four segments'
            class = 'sapUiSmallMargin'
        )->get( )->layout_data(
            )->grid_data( 'XL12 L12 M12 S12' ).

    seg = grid->flex_box(
            width          = '22rem'
            height         = '13rem'
            alignitems     = 'Start'
            justifycontent = 'SpaceBetween'
         )->items( )->interact_donut_chart(
                selectionchanged  = client->_event( 'DONUT_CHANGED' )
                press             = client->_event( 'DONUT_PRESS' )
                displayedsegments = '4'
            )->segments( ).
    seg->interact_donut_chart_segment( label = 'Design Phase'         value = '32.0' displayedvalue = '32.0%' ).
    seg->interact_donut_chart_segment( label = 'Implementation Phase' value = '28'   displayedvalue = '28%' ).
    seg->interact_donut_chart_segment( label = 'Test Phase'           value = '25'   displayedvalue = '25%' ).
    seg->interact_donut_chart_segment( label = 'Launch Phase'         value = '15'   displayedvalue = '15%' ).

    grid->text(
            text  = 'Error Messages'
            class = 'sapUiSmallMargin'
        )->get( )->layout_data(
            )->grid_data( 'XL12 L12 M12 S12' ).

    seg = grid->flex_box(
            width          = '22rem'
            height         = '13rem'
            alignitems     = 'Start'
            justifycontent = 'SpaceBetween'
        )->items( )->interact_donut_chart(
                selectionchanged  = client->_event( 'DONUT_CHANGED' )
                showerror         = abap_true
                errormessagetitle = 'No data'
                errormessage      = 'Currently no data is available'
            )->segments( ).
    seg->interact_donut_chart_segment( label = 'Implementation Phase' value = '40.0' displayedvalue = '40.0%' ).
    seg->interact_donut_chart_segment( label = 'Design Phase'         value = '21.5' displayedvalue = '21.5%' ).
    seg->interact_donut_chart_segment( label = 'Test Phase'           value = '38.5' displayedvalue = '38.5%' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      DATA(lv_version) = to_upper( client->get( )-s_config-version ).
      IF lv_version CS `OPEN`.
        client->message_box_display( text = `Charts are not avalaible with OpenUI5, change your UI5 library first` type = `error` ).
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
      ENDIF.

      render_tab_donut( ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
