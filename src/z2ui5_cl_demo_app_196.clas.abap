CLASS z2ui5_cl_demo_app_196 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA is_initialized TYPE boolean .
    DATA mv_slider_value TYPE i .

    TYPES: BEGIN OF ty_shape,
       id TYPE string,
      END OF ty_shape.

    DATA mt_shapes TYPE TABLE OF ty_shape.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA client TYPE REF TO z2ui5_if_client .

    METHODS initialize .
    METHODS on_event .
    METHODS render_screen .
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_196 IMPLEMENTATION.


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
                        ( id = `warehouse` )
                      ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.


  METHOD render_screen.

    DATA lv_script TYPE string.


    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->_generic( ns = `html` name = `style` )->_cc_plain_xml( `.SICursorStyle:hover {` &&
                                                                 `  cursor: pointer;` &&
                                                                 `}` &&
                                                                 `.SIBorderStyle {` &&
                                                                 `  border: 1px solid #cccccc;` &&
                                                                 `}` &&
                                                                 `.SIPanelStyle .sapMPanelContent{` &&
                                                                 `  overflow: visible;` &&
                                                                 `}` ).
    DATA(page) = view->shell(
         )->page(
            showheader       = xsdbool( abap_false = client->get( )-check_launchpad_active )
            title          = 'abap2UI5 - Status Indicators Library'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            ).

    DATA(panel) = page->panel( class = `sapUiResponsiveMargin SIPanelStyle` width = `95%` ).
    panel->text( text = `Use the slider for adjusting the fill` ).
    panel->slider( class = `sapUiLargeMarginBottom` enabletickmarks = abap_true
               value = client->_bind_edit( mv_slider_value ) )->get(
       )->responsive_scale( tickmarksbetweenlabels = `10` ).

    DATA(fb) = panel->flex_box( wrap = `Wrap` items = client->_bind( mt_shapes ) ).
    fb->items(
      )->flex_box( direction = `Column` class = `sapUiTinyMargin SIBorderStyle`
        )->items(
          )->status_indicator( value = client->_bind_edit( mv_slider_value ) width = `120px` height = `120px` class = `sapUiTinyMargin SICursorStyle`
            )->property_thresholds(
              )->property_threshold( fillcolor = `Error` tovalue = `25` )->get_parent(
              )->property_threshold( fillcolor = `Critical` tovalue = `60` )->get_parent(
              )->property_threshold( fillcolor = `Good` tovalue = `100` )->get_parent(
               )->get_parent(
             )->shape_group(
              )->library_shape( shapeid = `{ID}` ).


    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF is_initialized = abap_false.

      initialize( ).
      render_screen( ).
      is_initialized = abap_true.

    ENDIF.

    on_event( ).

  ENDMETHOD.
ENDCLASS.
