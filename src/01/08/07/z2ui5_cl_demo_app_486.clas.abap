"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Toolbar/sample/sap.m.sample.ToolbarShrinkable
"! Toolbar items can shrink/expand when the toolbar is resized. This behavior is enabled/disabled via
"! the ToolbarLayoutData layout. It is also possible to set min/max width for shrinkable items.
CLASS z2ui5_cl_demo_app_486 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA toolbar_width TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_486 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      toolbar_width = `100%`.
      view_display( ).

    ELSEIF client->check_on_event( `SLIDER_CHANGE` ).

      toolbar_width = |{ client->get_event_arg( 1 ) }%|.
      client->view_model_update( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Toolbar - Shrinkable items`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Toolbar/sample/sap.m.sample.ToolbarShrinkable` ).

    page->slider(
        livechange = client->_event( val   = `SLIDER_CHANGE`
                                     t_arg = VALUE #( ( `${$parameters>/value}` ) ) )
        step       = `20`
        value      = `100` ).

    page->message_strip(
        text  = `By default, Toolbar items are shrinkable if they have percent-based width (e.g. Input, Slider)` &&
                ` or implement the IShrinkable interface (e.g. Text, Label).`
        class = `sapUiTinyMargin` ).

    " the toolbar style class is not part of the typed view API - added via the generic property helper
    page->toolbar(
            id    = `toolbar1`
            width = client->_bind( toolbar_width )
            )->_generic_property( VALUE #( n = `class` v = `sapUiMediumMarginTop` )
            )->label( `I am a text control, so I will shrink whenever the toolbar overflows.`
            )->toolbar_spacer(
            )->button( text = `Non-shrinkable button`
            )->toolbar_spacer(
            )->search_field(
                width       = `100%`
                placeholder = `My width is 100%, so I should shrink.` ).

    page->message_strip(
        text  = `You can configure the item's shrinking-related properties by providing ToolbarLayoutData.`
        class = `sapUiTinyMargin` ).

    page->toolbar(
            id    = `toolbar2`
            width = client->_bind( toolbar_width )
            )->_generic_property( VALUE #( n = `class` v = `sapUiMediumMarginTop` )
            )->label( `I am a non-shrinkable text.`
            )->get(
                )->layout_data( ``
                    )->toolbar_layout_data( shrinkable = abap_false
                    )->get_parent(
                )->get_parent(
            )->get_parent(
            )->toolbar_spacer(
            )->button( text = `I am a shrinkable button, so I will shrink whenever the toolbar overflows.`
            )->get(
                )->layout_data( ``
                    )->toolbar_layout_data( shrinkable = abap_true
                    )->get_parent(
                )->get_parent(
            )->get_parent(
            )->toolbar_spacer(
            )->search_field(
                width       = `200px`
                placeholder = `I have a fixed width (200px), so I cannot shrink.` ).

    page->message_strip(
        text  = `You can determine to what extent an item shrinks by setting minWidth/maxWidth via ToolbarLayoutData.` &&
                ` By default, minWidth is 48px in the Blue Crystal theme.`
        class = `sapUiTinyMargin` ).

    page->toolbar(
            id    = `toolbar3`
            width = client->_bind( toolbar_width )
            )->_generic_property( VALUE #( n = `class` v = `sapUiMediumMarginTop` )
            )->label( `I should not shrink by more than 200px, because I am an important text.`
            )->get(
                )->layout_data( ``
                    )->toolbar_layout_data(
                        shrinkable = abap_true
                        minwidth   = `200px`
                    )->get_parent(
                )->get_parent(
            )->get_parent(
            )->toolbar_spacer(
            )->button( text = `I cannot be wider than 400px, but I can shrink up to the theme's default minimum width.`
            )->get(
                )->layout_data( ``
                    )->toolbar_layout_data(
                        shrinkable = abap_true
                        maxwidth   = `400px`
                    )->get_parent(
                )->get_parent(
            )->get_parent( ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
