"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.BlockLayout/sample/sap.ui.layout.sample.BlockLayoutDefault
"! The BlockLayout is intended to be used with rows and cells. The cells have predefined width, the
"! rows have predefined rendering modes - scrollable/vertical/horizontal.
CLASS z2ui5_cl_demo_app_512 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id     TYPE string,
        name           TYPE string,
        supplier_name  TYPE string,
        width          TYPE string,
        depth          TYPE string,
        height         TYPE string,
        dim_unit       TYPE string,
        weight_measure TYPE string,
        weight_unit    TYPE string,
        price          TYPE string,
        currency_code  TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA slider_value TYPE string.
    DATA selected_background TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_512 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    slider_value        = `100`.
    selected_background = `Default`.

    " the original loads the demo kit mock data sap/ui/demo/mock/products.json - a subset is hardcoded here
    t_products = VALUE #(
      ( product_id     = `HT-1000`
        name           = `Notebook Basic 15`
        supplier_name  = `Very Best Screens`
        width          = `30`
        depth          = `18`
        height         = `3`
        dim_unit       = `cm`
        weight_measure = `4.2`
        weight_unit    = `KG`
        price          = `956`
        currency_code  = `EUR` )
      ( product_id     = `HT-1001`
        name           = `Notebook Basic 17`
        supplier_name  = `Very Best Screens`
        width          = `29`
        depth          = `17`
        height         = `3.1`
        dim_unit       = `cm`
        weight_measure = `4.5`
        weight_unit    = `KG`
        price          = `1249`
        currency_code  = `EUR` )
      ( product_id     = `HT-1002`
        name           = `Notebook Basic 18`
        supplier_name  = `Very Best Screens`
        width          = `28`
        depth          = `19`
        height         = `2.5`
        dim_unit       = `cm`
        weight_measure = `4.2`
        weight_unit    = `KG`
        price          = `1570`
        currency_code  = `EUR` )
      ( product_id     = `HT-1003`
        name           = `Notebook Basic 19`
        supplier_name  = `Smartcards`
        width          = `32`
        depth          = `21`
        height         = `4`
        dim_unit       = `cm`
        weight_measure = `4.2`
        weight_unit    = `KG`
        price          = `1650`
        currency_code  = `EUR` )
      ( product_id     = `HT-1007`
        name           = `ITelO Vault`
        supplier_name  = `Technocom`
        width          = `32`
        depth          = `22`
        height         = `3`
        dim_unit       = `cm`
        weight_measure = `0.2`
        weight_unit    = `KG`
        price          = `299`
        currency_code  = `EUR` )
      ( product_id     = `HT-1010`
        name           = `Notebook Professional 15`
        supplier_name  = `Very Best Screens`
        width          = `33`
        depth          = `20`
        height         = `3`
        dim_unit       = `cm`
        weight_measure = `4.3`
        weight_unit    = `KG`
        price          = `1999`
        currency_code  = `EUR` )
      ( product_id     = `HT-1011`
        name           = `Notebook Professional 17`
        supplier_name  = `Very Best Screens`
        width          = `33`
        depth          = `23`
        height         = `2`
        dim_unit       = `cm`
        weight_measure = `4.1`
        weight_unit    = `KG`
        price          = `2299`
        currency_code  = `EUR` )
      ( product_id     = `HT-1020`
        name           = `ITelO Vault Net`
        supplier_name  = `Technocom`
        width          = `10`
        depth          = `1.8`
        height         = `17`
        dim_unit       = `cm`
        weight_measure = `0.16`
        weight_unit    = `KG`
        price          = `459`
        currency_code  = `EUR` ) ).
    " the items binding of the original sorts by name - the table is sorted in ABAP instead
    SORT t_products BY name.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(lorem) = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, ` &&
      `sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est ` &&
      `Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr.`.

    DATA(lorem_short) = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, ` &&
      `sed diam voluptua.`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Block Layout`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.BlockLayout/sample/sap.ui.layout.sample.BlockLayoutDefault` ).

    DATA(form_content) = page->simple_form(
        editable         = abap_true
        backgrounddesign = `Transparent`
        layout           = `ColumnLayout`
        )->content( `form` ).

    form_content->label( `Parent width` ).
    form_content->slider( value = client->_bind_edit( slider_value ) ).
    form_content->label( `Background` ).

    " the ariaDescribedBy and ariaLabelledBy associations of the original are omitted
    form_content->segmented_button( client->_bind_edit( selected_background )
        )->items(
            )->segmented_button_item(
                key  = `Default`
                text = `Default`
            )->segmented_button_item(
                key  = `Light`
                text = `Light`
            )->segmented_button_item(
                key  = `Accent`
                text = `Accent`
            )->segmented_button_item(
                key  = `Dashboard`
                text = `Dashboard` ).

    " the original sets the container width in the onSliderMoved liveChange handler - an expression binding is used instead
    DATA(layout) = page->vertical_layout(
        id    = `containerLayout`
        width = `{= $` && client->_bind_edit( slider_value ) && ` + '%' }` ).

    DATA(block_layout) = layout->block_layout(
        id         = `BlockLayout`
        background = client->_bind_edit( selected_background ) ).

    DATA(row_accent1) = block_layout->block_layout_row( ).
    row_accent1->_generic_property( VALUE #( n = `accentCells`
                                             v = `Accent1` ) ).

    DATA(cell_accent1) = row_accent1->block_layout_cell(
        id    = `Accent1`
        width = `2`
        title = `Left aligned heading` ).

    cell_accent1->text( lorem ).

    DATA(radio_group) = cell_accent1->radio_button_group(
        columns       = `2`
        selectedindex = `2`
        class         = `sapUiMediumMarginTop` ).

    radio_group->radio_button(
        id   = `RB2-1`
        text = `Option 1` ).
    radio_group->radio_button(
        id       = `RB2-2`
        text     = `Option 2`
        editable = abap_false ).
    radio_group->radio_button(
        id   = `RB2-3`
        text = `Option 3` ).

    row_accent1->block_layout_cell( title = `25% width cell`
        )->text( lorem ).

    row_accent1->block_layout_cell(
        titlealignment = `End`
        title          = `End aligned heading`
        )->text( lorem_short ).

    DATA(row_two_cells) = block_layout->block_layout_row( ).

    row_two_cells->block_layout_cell( title = `50% width cell`
        )->text( lorem ).

    DATA(cell_feed) = row_two_cells->block_layout_cell( title = `50% width cell` ).

    cell_feed->feed_input( showicon = abap_true ).
    cell_feed->feed_input( showicon = abap_true ).

    DATA(row_scrollable) = block_layout->block_layout_row( ).
    row_scrollable->_generic_property( VALUE #( n = `scrollable`
                                                v = `true` ) ).

    row_scrollable->block_layout_cell(
        width = `50`
        title = `Cell inside scrollable row`
        )->text( lorem ).

    row_scrollable->block_layout_cell(
        width          = `100`
        title          = `Centered Heading`
        titlealignment = `Center`
        )->text( `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore` ).

    row_scrollable->block_layout_cell(
        )->text( lorem ).

    row_scrollable->block_layout_cell( width = `90`
        )->text( lorem ).

    row_scrollable->block_layout_cell(
        )->text( lorem ).

    row_scrollable->block_layout_cell(
        )->text( lorem ).

    DATA(row_form) = block_layout->block_layout_row( ).

    DATA(cell_form) = row_form->block_layout_cell(
        title = `75% width cell`
        width = `3` ).

    cell_form->simple_form(
        editable         = abap_true
        backgrounddesign = `Transparent`
        layout           = `ResponsiveGridLayout`
        )->content( `form`
        )->label( `Name on card`
        )->input(
        )->label( `Card number`
        )->input(
        )->label( `Security code`
        )->input(
        )->label( `Expiration date`
        )->date_picker( ).

    cell_form->text( lorem ).

    row_form->block_layout_cell( title = `25% width cell`
        )->text( lorem ).

    DATA(row_quarters) = block_layout->block_layout_row( ).

    DO 4 TIMES.

      row_quarters->block_layout_cell( title = `25% width cell`
          )->text( lorem ).

    ENDDO.

    DO 3 TIMES.

      block_layout->block_layout_row(
          )->block_layout_cell(
          )->text( lorem ).

    ENDDO.

    DATA(row_accent2) = block_layout->block_layout_row( ).
    row_accent2->_generic_property( VALUE #( n = `accentCells`
                                             v = `Accent2` ) ).

    DATA(cell_accent2) = row_accent2->block_layout_cell( id = `Accent2` ).

    cell_accent2->message_strip( `You can use the cells with 100% width, if you set the vertical property of the row to true` ).
    cell_accent2->text( lorem ).

    DATA(row_accent3) = block_layout->block_layout_row( ).
    row_accent3->_generic_property( VALUE #( n = `accentCells`
                                             v = `Accent3` ) ).

    DATA(table) = row_accent3->block_layout_cell( id = `Accent3`
        )->table(
            id    = `idProductsTable`
            inset = abap_false
            items = client->_bind( t_products ) ).

    DATA(columns) = table->columns( ).

    columns->column( `12em`
        )->text( `Product` ).
    columns->column(
        minscreenwidth = `Tablet`
        demandpopin    = abap_true
        )->text( `Supplier` ).
    columns->column(
        minscreenwidth = `Tablet`
        demandpopin    = abap_true
        halign         = `Right`
        )->text( `Dimensions` ).
    columns->column(
        minscreenwidth = `Tablet`
        demandpopin    = abap_true
        halign         = `Center`
        )->text( `Weight` ).
    columns->column( halign = `Right`
        )->text( `Price` ).

    DATA(cells) = table->items(
        )->column_list_item(
        )->cells( ).

    cells->object_identifier(
        title = `{NAME}`
        text  = `{PRODUCT_ID}` ).
    cells->text( `{SUPPLIER_NAME}` ).
    cells->text( `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}` ).
    cells->object_number(
        number = `{WEIGHT_MEASURE}`
        unit   = `{WEIGHT_UNIT}` ).
    cells->object_number(
        number = `{ parts:[{path:'PRICE'},{path:'CURRENCY_CODE'}], type: 'sap.ui.model.type.Currency' }`
        unit   = `{CURRENCY_CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
