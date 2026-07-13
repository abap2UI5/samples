"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.RangeSlider/sample/sap.m.sample.RangeSlider
"! With the RangeSlider a user can specify range from a numerical interval.
CLASS z2ui5_cl_demo_app_472 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA rs1_value TYPE string.
    DATA rs1_value2 TYPE string.
    DATA rs2_value TYPE string.
    DATA rs2_value2 TYPE string.
    DATA rs3_value TYPE string.
    DATA rs3_value2 TYPE string.
    DATA rs4_value TYPE string.
    DATA rs4_value2 TYPE string.
    DATA rs5_value TYPE string.
    DATA rs5_value2 TYPE string.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_472 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: RangeSlider`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.RangeSlider/sample/sap.m.sample.RangeSlider` ).

    DATA(layout) = page->vertical_layout(
        class = `sapUiContentPadding`
        width = `100%` ).

    " property showAdvancedTooltip is set via a generic property - not part of the typed range_slider method
    layout->text(
        text  = `RangeSlider with text fields`
        class = `sapUiSmallMarginBottom` ).

    layout->range_slider(
        value  = client->_bind_edit( rs1_value )
        value2 = client->_bind_edit( rs1_value2 )
        min    = `0`
        max    = `100`
        width  = `80%`
        class  = `sapUiMediumMarginBottom`
        )->get( )->_generic_property( VALUE #( n = `showAdvancedTooltip` v = `true` ) ).

    layout->range_slider(
        value  = client->_bind_edit( rs2_value )
        value2 = client->_bind_edit( rs2_value2 )
        min    = `-50`
        max    = `50`
        width  = `10rem`
        class  = `sapUiMediumMarginBottom`
        )->get( )->_generic_property( VALUE #( n = `showAdvancedTooltip` v = `true` ) ).

    layout->range_slider(
        value  = client->_bind_edit( rs3_value )
        value2 = client->_bind_edit( rs3_value2 )
        min    = `0`
        max    = `100`
        width  = `10rem`
        class  = `sapUiMediumMarginBottom`
        )->get( )->_generic_property( VALUE #( n = `showAdvancedTooltip` v = `true` ) ).

    layout->range_slider(
        value  = client->_bind_edit( rs4_value )
        value2 = client->_bind_edit( rs4_value2 )
        min    = `-1000`
        max    = `1000`
        width  = `100%`
        class  = `sapUiMediumMarginBottom`
        )->get( )->_generic_property( VALUE #( n = `showAdvancedTooltip` v = `true` ) ).

    layout->range_slider(
        value  = client->_bind_edit( rs5_value )
        value2 = client->_bind_edit( rs5_value2 )
        min    = `0`
        max    = `500`
        width  = `100%`
        class  = `sapUiLargeMarginBottom`
        )->get( )->_generic_property( VALUE #( n = `showAdvancedTooltip` v = `true` ) ).

    layout->text(
        text  = `RangeSlider with inputs`
        class = `sapUiSmallMarginBottom` ).

    layout->range_slider(
        value  = `0`
        value2 = `100`
        min    = `0`
        max    = `500`
        width  = `100%`
        class  = `sapUiLargeMarginBottom`
        )->get( )->_generic_property( VALUE #( n = `showAdvancedTooltip` v = `true` )
        )->_generic_property( VALUE #( n = `showHandleTooltip` v = `false` )
        )->_generic_property( VALUE #( n = `inputsAsTooltips` v = `true` ) ).

    layout->text(
        text  = `RangeSlider with tickmarks`
        class = `sapUiSmallMarginBottom` ).

    layout->range_slider(
        showtickmarks = abap_true
        value         = `0`
        value2        = `10`
        min           = `0`
        max           = `10`
        class         = `sapUiMediumMarginBottom`
        )->get( )->_generic_property( VALUE #( n = `showAdvancedTooltip` v = `true` ) ).

    layout->range_slider(
        showtickmarks = abap_true
        class         = `sapUiMediumMarginBottom`
        )->get( )->_generic_property( VALUE #( n = `showAdvancedTooltip` v = `true` ) ).

    layout->text(
        text  = `RangeSlider with tickmarks and step '5'`
        class = `sapUiSmallMarginBottom` ).

    layout->range_slider(
        showtickmarks = abap_true
        min           = `-100`
        max           = `100`
        step          = `5`
        class         = `sapUiLargeMarginBottom`
        )->get( )->_generic_property( VALUE #( n = `showAdvancedTooltip` v = `true` ) ).

    layout->text(
        text  = `RangeSlider with tickmarks and labels`
        class = `sapUiSmallMarginBottom` ).

    layout->range_slider(
        showtickmarks = abap_true
        value         = `5`
        value2        = `20`
        min           = `0`
        max           = `30`
        class         = `sapUiSmallMarginBottom`
        )->get( )->_generic_property( VALUE #( n = `showAdvancedTooltip` v = `true` )
        )->responsive_scale( tickmarksbetweenlabels = `3` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      rs1_value  = `0`.
      rs1_value2 = `100`.
      rs2_value  = `-50`.
      rs2_value2 = `50`.
      rs3_value  = `20`.
      rs3_value2 = `80`.
      rs4_value  = `-500`.
      rs4_value2 = `500`.
      rs5_value  = `0`.
      rs5_value2 = `500`.

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
