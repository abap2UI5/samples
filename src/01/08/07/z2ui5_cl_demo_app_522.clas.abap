"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.cssgrid.CSSGrid/sample/sap.ui.layout.sample.NestedGrids
"! CSSGrid example nested grids.
CLASS z2ui5_cl_demo_app_522 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA slider_value TYPE i.
    DATA panel_width TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_522 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      slider_value = 100.
      panel_width  = `100%`.

      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( `SLIDER_MOVED` ).

      panel_width = |{ slider_value }%|.
      client->view_model_update( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
            title          = `abap2UI5 - Sample: Nested Example`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.cssgrid.CSSGrid/sample/sap.ui.layout.sample.NestedGrids` ).

    page->slider(
        value      = client->_bind_edit( slider_value )
        livechange = client->_event( `SLIDER_MOVED` )
        class      = `sapUiSmallMarginBottom` ).

    DATA(panel) = page->panel(
        id     = `panelCSSGrid`
        width  = client->_bind( panel_width )
        height = `100%` ).
    panel->header_toolbar(
        )->overflow_toolbar( height = `3rem`
        )->title( `CSS Grid Nested grids example` ).

    DATA(grid) = panel->_generic(
        name   = `CSSGrid`
        ns     = `grid`
        t_prop = VALUE #( ( n = `id`                  v = `grid1` )
                          ( n = `gridTemplateColumns` v = `repeat(2,minmax(250px, 1fr))` )
                          ( n = `gridTemplateRows`    v = `1fr 3fr` )
                          ( n = `gridGap`             v = `1rem` ) ) ).

    " The custom css classes demoBox and demoInnerBox of the original sample are not available here
    grid->vbox( `demoBox`
        )->title(
            text     = `A Box`
            wrapping = abap_true
        )->text(
            text     = `A Box subtitle`
            wrapping = abap_true ).
    grid->vbox( `demoBox`
        )->title(
            text     = `B Box`
            wrapping = abap_true
        )->text(
            text     = `B Box subtitle`
            wrapping = abap_true ).
    grid->vbox( `demoBox`
        )->title(
            text     = `C Box`
            wrapping = abap_true
        )->text(
            text     = `C Box subtitle`
            wrapping = abap_true ).

    DATA(nested_grid) = grid->vbox( `demoBox`
        )->_generic(
            name   = `CSSGrid`
            ns     = `grid`
            t_prop = VALUE #( ( n = `gridTemplateColumns` v = `repeat(2,minmax(120px, 1fr))` )
                              ( n = `gridGap`             v = `0.5rem` ) ) ).

    nested_grid->vbox( `sapUiSmallMarginTop sapUiSmallMarginBegin sapUiSmallMarginEnd demoInnerBox`
        )->layout_data(
        )->_generic( name   = `GridItemLayoutData`
                     ns     = `grid`
                     t_prop = VALUE #( ( n = `gridColumn` v = `1 / 3` )
                                       ( n = `gridRow`    v = `1` ) ) )->get_parent( )->get_parent(
        )->title(
            text     = `E Box`
            wrapping = abap_true
        )->text(
            text     = `E Box subtitle`
            wrapping = abap_true ).

    nested_grid->vbox( `sapUiSmallMarginBegin demoInnerBox`
        )->layout_data(
        )->_generic( name   = `GridItemLayoutData`
                     ns     = `grid`
                     t_prop = VALUE #( ( n = `gridColumn` v = `1` )
                                       ( n = `gridRow`    v = `2` ) ) )->get_parent( )->get_parent(
        )->title(
            text     = `F Box`
            wrapping = abap_true
        )->text(
            text     = `F Box subtitle`
            wrapping = abap_true ).

    nested_grid->vbox( `sapUiSmallMarginEnd demoInnerBox`
        )->layout_data(
        )->_generic( name   = `GridItemLayoutData`
                     ns     = `grid`
                     t_prop = VALUE #( ( n = `gridColumn` v = `2` )
                                       ( n = `gridRow`    v = `2` ) ) )->get_parent( )->get_parent(
        )->title(
            text     = `G Box`
            wrapping = abap_true
        )->text(
            text     = `G Box subtitle`
            wrapping = abap_true ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
