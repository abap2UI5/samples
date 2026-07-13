"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.BlockLayout/sample/sap.ui.layout.sample.BlockLayoutLinkTitle
"! The BlockLayout Cells can have links as titles. The link text overwrites the title text.
CLASS z2ui5_cl_demo_app_513 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_background TYPE string.
    DATA slider_value TYPE string.
    DATA container_width TYPE string.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_513 IMPLEMENTATION.

  METHOD view_display.

    DATA(text_long) = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, ` &&
      `sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est ` &&
      `Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr.`.

    DATA(text_short) = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, ` &&
      `sed diam voluptua.`.

    DATA(strip_text) = `Note: Usage of Disabled, Emphasized or Subtle links as titles is not recommended. Dark background designs, for example Accent, ` &&
      `are not fully supported with regards to Accessibility when used with links as titles.`.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Block Layout with links as titles`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.BlockLayout/sample/sap.ui.layout.sample.BlockLayoutLinkTitle` ).

    DATA(form) = page->simple_form(
        editable         = abap_true
        backgrounddesign = `Transparent`
        layout           = `ResponsiveGridLayout`
        )->content( `form` ).

    form->label( `Parent width` ).
    form->slider(
        id         = `widthSlider`
        value      = client->_bind_edit( slider_value )
        livechange = client->_event( `SLIDER_MOVED` ) ).
    form->label(
        id   = `backgroundLabel`
        text = `Background` ).

    DATA(segmented_button) = form->segmented_button( client->_bind_edit( selected_background ) ).
    segmented_button->_generic_property( VALUE #( n = `ariaDescribedBy` v = `backgroundLabel` ) ).
    segmented_button->_generic_property( VALUE #( n = `ariaLabelledBy` v = `backgroundLabel` ) ).
    segmented_button->items(
        )->segmented_button_item(
            key  = `Default`
            text = `Default`
        )->segmented_button_item(
            key  = `Light`
            text = `Light`
        )->segmented_button_item(
            key  = `Dashboard`
            text = `Dashboard` ).

    page->message_strip(
        type  = `Warning`
        text  = strip_text
        class = `sapUiSmallMarginBeginEnd sapUiSmallMarginTop` ).

    DATA(block) = page->vertical_layout(
        id    = `containerLayout`
        width = client->_bind( container_width )
        )->block_layout(
            id         = `BlockLayout`
            background = client->_bind_edit( selected_background ) ).

    DATA(row_1) = block->block_layout_row( ).
    " the wrapper block_layout_row method does not support the accentCells property - generic property used
    row_1->_generic_property( VALUE #( n = `accentCells` v = `Accent1` ) ).

    row_1->block_layout_cell(
        id    = `Accent1`
        width = `2`
        title = `Left aligned heading`
        )->text( text_long
        )->_generic(
            name = `titleLink`
            ns   = `layout`
            )->link(
                text = `This is a title link`
                href = `https://sdk.openui5.org/` ).

    row_1->block_layout_cell( title = `This is just a title`
        )->text( text_long ).

    row_1->block_layout_cell(
        titlealignment = `End`
        title          = `End aligned heading`
        )->text( text_short
        )->_generic(
            name = `titleLink`
            ns   = `layout`
            )->link(
                text     = `This is a title link - wrapping true`
                href     = `https://sdk.openui5.org/`
                wrapping = abap_true ).

    DATA(row_2) = block->block_layout_row( ).

    row_2->block_layout_cell( title = `This is just a title`
        )->text( text_long ).

    row_2->block_layout_cell( title = `25% width cell`
        )->text( text_long
        )->_generic(
            name = `titleLink`
            ns   = `layout`
            )->link(
                text = `This is a title link`
                href = `https://sdk.openui5.org/` ).

    row_2->block_layout_cell( title = `25% width cell`
        )->text( text_long
        )->_generic(
            name = `titleLink`
            ns   = `layout`
            )->link(
                text   = `This is a title link - open in new window`
                href   = `https://sdk.openui5.org/`
                target = `_blank` ).

    row_2->block_layout_cell( title = `25% width cell`
        )->text( text_long
        )->_generic(
            name = `titleLink`
            ns   = `layout`
            )->link(
                text     = `This is a title link - wrapping true`
                href     = `https://sdk.openui5.org/`
                wrapping = abap_true ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      selected_background = `Default`.
      slider_value        = `100`.
      container_width     = `100%`.

      view_display( client ).

    ELSEIF client->check_on_event( `SLIDER_MOVED` ).

      container_width = |{ slider_value }%|.
      client->view_model_update( ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
