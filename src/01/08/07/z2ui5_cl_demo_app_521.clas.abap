"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.cssgrid.CSSGrid/sample/sap.ui.layout.sample.CSSGrid
"! CSSGrid example for page layout.
CLASS z2ui5_cl_demo_app_521 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA slider_value TYPE i.
    DATA panel_width TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_521 IMPLEMENTATION.

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

    " Inlined replacement for the custom css class stylePageLayout of the original sample
    DATA(item_style) = `background-color:#3b6f9a;color:#ffffff;border-radius:10px;display:flex;align-items:center;justify-content:center;`.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
            title          = `abap2UI5 - Sample: CSSGrid`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.cssgrid.CSSGrid/sample/sap.ui.layout.sample.CSSGrid` ).

    page->slider(
        value      = client->_bind_edit( slider_value )
        livechange = client->_event( `SLIDER_MOVED` )
        class      = `sapUiSmallMarginBottom` ).

    DATA(panel) = page->panel(
        id     = `gridLayout`
        width  = client->_bind( panel_width )
        height = `100%` ).
    panel->header_toolbar(
        )->overflow_toolbar( height = `3rem`
        )->title( ` CssGrid Layout example` ).

    DATA(grid) = panel->_generic(
        name   = `CSSGrid`
        ns     = `grid`
        t_prop = VALUE #( ( n = `id`                  v = `grid1` )
                          ( n = `gridTemplateColumns` v = `1fr 2fr 1fr` )
                          ( n = `gridTemplateRows`    v = `50px 200px 50px` )
                          ( n = `gridGap`             v = `1rem` ) ) ).
    grid->html( |<header style="{ item_style }">Header</header>|
        )->layout_data( `core`
        )->_generic( name   = `GridItemLayoutData`
                     ns     = `grid`
                     t_prop = VALUE #( ( n = `gridColumn` v = `1 / 4` ) ) ).
    grid->html( |<aside style="{ item_style }">Navigation</aside>| ).
    grid->html( |<article style="{ item_style }">Main Content</article>| ).
    grid->html( |<aside style="{ item_style }">Related Links</aside>| ).
    grid->html( |<footer style="{ item_style }">Footer</footer>|
        )->layout_data( `core`
        )->_generic( name   = `GridItemLayoutData`
                     ns     = `grid`
                     t_prop = VALUE #( ( n = `gridColumn` v = `1 / 4` ) ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
