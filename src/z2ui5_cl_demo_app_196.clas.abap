CLASS z2ui5_cl_demo_app_196 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_initialized TYPE abap_bool .
    DATA mv_slider_value TYPE i .

    TYPES: BEGIN OF ty_shape,
       id TYPE string,
      END OF ty_shape.

    DATA mt_shapes TYPE TABLE OF ty_shape.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client .

    METHODS initialize .
    METHODS render_screen .
ENDCLASS.

CLASS z2ui5_cl_demo_app_196 IMPLEMENTATION.

  METHOD initialize.

    mv_slider_value = 0.

    mt_shapes = VALUE #(
                        ( id = `arrow_down` )
                        ( id = `arrow_left` )
                        ( id = `arrow_right` )
                        ( id = `arrow_up` )
                        ( id = `attention_1` )
                        ( id = `attention_2` )
                        ( id = `building` )
                        ( id = `bulb` )
                        ( id = `bull` )
                        ( id = `calendar` )
                        ( id = `car` )
                        ( id = `cart` )
                        ( id = `cereals` )
                        ( id = `circle` )
                        ( id = `clock` )
                        ( id = `cloud` )
                        ( id = `conveyor` )
                        ( id = `desk` )
                        ( id = `document` )
                        ( id = `documents` )
                        ( id = `dollar` )
                        ( id = `donut` )
                        ( id = `drop` )
                        ( id = `envelope` )
                        ( id = `euro` )
                        ( id = `factory` )
                        ( id = `female` )
                        ( id = `fish` )
                        ( id = `flag` )
                        ( id = `folder_1` )
                        ( id = `folder_2` )
                        ( id = `gear` )
                        ( id = `heart` )
                        ( id = `honey` )
                        ( id = `house` )
                        ( id = `information` )
                        ( id = `letter` )
                        ( id = `lung` )
                        ( id = `machine` )
                        ( id = `male` )
                        ( id = `pen` )
                        ( id = `person` )
                        ( id = `pin` )
                        ( id = `plane` )
                        ( id = `printer` )
                        ( id = `progress` )
                        ( id = `question` )
                        ( id = `robot` )
                        ( id = `sandclock` )
                        ( id = `speed` )
                        ( id = `stomach` )
                        ( id = `success` )
                        ( id = `tank_diesel` )
                        ( id = `tank_lpg` )
                        ( id = `thermo` )
                        ( id = `tool` )
                        ( id = `transfusion` )
                        ( id = `travel` )
                        ( id = `turnip` )
                        ( id = `vehicle_construction` )
                        ( id = `vehicle_tank` )
                        ( id = `vehicle_tractor` )
                        ( id = `vehicle_truck_1` )
                        ( id = `vehicle_truck_2` )
                        ( id = `vehicle_truck_3` )
                        ( id = `warehouse` ) ).
  ENDMETHOD.

  METHOD render_screen.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->_generic( ns   = `html`
                    name = `style` )->_cc_plain_xml( `.SICursorStyle:hover {` &&
                                                                 `  cursor: pointer;` &&
                                                                 `}` &&
                                                                 `.SIBorderStyle {` &&
                                                                 `  border: 1px solid #cccccc;` &&
                                                                 `}` &&
                                                                 `.SIPanelStyle .sapMPanelContent{` &&
                                                                 `  overflow: visible;` &&
                                                                 `}` ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            showheader     = xsdbool( abap_false = mo_client->get( )-check_launchpad_active )
            title          = `abap2UI5 - Status Indicators Library`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    DATA(lo_panel) = lo_page->panel( class = `sapUiResponsiveMargin SIPanelStyle`
                               width = `95%` ).
    lo_panel->text( text = `Use the slider for adjusting the fill` ).
    lo_panel->slider( class           = `sapUiLargeMarginBottom`
                   enabletickmarks = abap_true
               value               = mo_client->_bind_edit( mv_slider_value ) )->get(
       )->responsive_scale( tickmarksbetweenlabels = `10` ).

    DATA(fb) = lo_panel->flex_box( wrap  = `Wrap`
                                items = mo_client->_bind( mt_shapes ) ).
    fb->items(
      )->flex_box( direction = `Column`
                   class     = `sapUiTinyMargin SIBorderStyle`
        )->items(
          )->status_indicator( value  = mo_client->_bind_edit( mv_slider_value )
                               width  = `120px`
                               height = `120px`
                               class  = `sapUiTinyMargin SICursorStyle`
            )->property_thresholds(
              )->property_threshold( fillcolor = `Error`
                                     tovalue   = `25` )->get_parent(
              )->property_threshold( fillcolor = `Critical`
                                     tovalue   = `60` )->get_parent(
              )->property_threshold( fillcolor = `Good`
                                     tovalue   = `100` )->get_parent(
               )->get_parent(
             )->shape_group(
              )->library_shape( shapeid = `{ID}` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mv_initialized = abap_false.

      initialize( ).
      render_screen( ).
      mv_initialized = abap_true.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
