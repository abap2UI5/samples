"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.DynamicPage/sample/sap.f.sample.DynamicPageFreeStyle
"! Dynamic Page freestyle example with a responsive sap.m.Table in the content area, showing that each
"! control can be placed in the title and the header content areas.
CLASS z2ui5_cl_demo_app_030 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name          TYPE string,
        product_id    TYPE string,
        supplier_name TYPE string,
        width         TYPE string,
        depth         TYPE string,
        height        TYPE string,
        dim_unit      TYPE string,
        price         TYPE string,
        currency_code TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    DATA show_footer TYPE abap_bool.
    DATA area_shrink_ratio TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_030 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    show_footer       = abap_true.
    area_shrink_ratio = `1:1.6:1.6`.
    t_products = VALUE #(
        ( name = `Notebook Basic 15`        product_id = `HT-1000` supplier_name = `Very Best Screens` width = `30`   depth = `18`  height = `3`   dim_unit = `cm` price = `956.00`   currency_code = `EUR` )
        ( name = `Notebook Basic 17`        product_id = `HT-1001` supplier_name = `Very Best Screens` width = `29`   depth = `17`  height = `3.1` dim_unit = `cm` price = `1,249.00` currency_code = `EUR` )
        ( name = `Notebook Basic 18`        product_id = `HT-1002` supplier_name = `Very Best Screens` width = `28`   depth = `19`  height = `2.5` dim_unit = `cm` price = `1,570.00` currency_code = `EUR` )
        ( name = `Notebook Basic 19`        product_id = `HT-1003` supplier_name = `Smartcards`        width = `32`   depth = `21`  height = `4`   dim_unit = `cm` price = `1,650.00` currency_code = `EUR` )
        ( name = `ITelO Vault`              product_id = `HT-1007` supplier_name = `Technocom`         width = `32`   depth = `22`  height = `3`   dim_unit = `cm` price = `299.00`   currency_code = `EUR` )
        ( name = `Notebook Professional 15` product_id = `HT-1010` supplier_name = `Very Best Screens` width = `33`   depth = `20`  height = `3`   dim_unit = `cm` price = `1,999.00` currency_code = `EUR` )
        ( name = `Notebook Professional 17` product_id = `HT-1011` supplier_name = `Very Best Screens` width = `33`   depth = `23`  height = `2`   dim_unit = `cm` price = `2,299.00` currency_code = `EUR` )
        ( name = `ITelO Vault Net`          product_id = `HT-1020` supplier_name = `Technocom`         width = `10`   depth = `1.8` height = `17`  dim_unit = `cm` price = `459.00`   currency_code = `EUR` )
        ( name = `ITelO Vault SAT`          product_id = `HT-1021` supplier_name = `Technocom`         width = `11`   depth = `1.7` height = `18`  dim_unit = `cm` price = `149.00`   currency_code = `EUR` )
        ( name = `Comfort Easy`             product_id = `HT-1022` supplier_name = `Technocom`         width = `84`   depth = `1.5` height = `14`  dim_unit = `cm` price = `1,679.00` currency_code = `EUR` )
        ( name = `Comfort Senior`           product_id = `HT-1023` supplier_name = `Technocom`         width = `80`   depth = `1.6` height = `13`  dim_unit = `cm` price = `512.00`   currency_code = `EUR` )
        ( name = `Ergo Screen E-I`          product_id = `HT-1030` supplier_name = `Very Best Screens` width = `37`   depth = `12`  height = `36`  dim_unit = `cm` price = `230.00`   currency_code = `EUR` )
        ( name = `Ergo Screen E-II`         product_id = `HT-1031` supplier_name = `Very Best Screens` width = `40.8` depth = `19`  height = `43`  dim_unit = `cm` price = `285.00`   currency_code = `EUR` )
        ( name = `Ergo Screen E-III`        product_id = `HT-1032` supplier_name = `Very Best Screens` width = `40.8` depth = `19`  height = `43`  dim_unit = `cm` price = `345.00`   currency_code = `EUR` )
        ( name = `Flat Basic`               product_id = `HT-1035` supplier_name = `Very Best Screens` width = `39`   depth = `20`  height = `41`  dim_unit = `cm` price = `399.00`   currency_code = `EUR` )
        ( name = `Flat Future`              product_id = `HT-1036` supplier_name = `Very Best Screens` width = `45`   depth = `26`  height = `46`  dim_unit = `cm` price = `430.00`   currency_code = `EUR` ) ).
    " the original sorts the ProductCollection by name via a model sorter - the data is sorted in ABAP instead
    SORT t_products BY name.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `TOGGLE_AREA_PRIORITY`.
        area_shrink_ratio = COND #( WHEN area_shrink_ratio = `1:1.6:1.6`
                                    THEN `1.6:1:1.6`
                                    ELSE `1:1.6:1.6` ).
        client->view_model_update( ).
      WHEN `TOGGLE_FOOTER`.
        show_footer = xsdbool( show_footer = abap_false ).
        client->view_model_update( ).
      WHEN `OPEN_POPOVER_TAG`.
        popover_display( `generic_tag_id` ).
      WHEN `OPEN_POPOVER_BUTTON`.
        popover_display( `button_layout_data_id` ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Dynamic Page Freestyle`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.f.DynamicPage/sample/sap.f.sample.DynamicPageFreeStyle` ).

    " headerExpanded and toggleHeaderOnTitleClick are bound to demo kit container settings in the original and default to true
    DATA(dynamic_page) = page->dynamic_page( showfooter = client->_bind( show_footer ) ).

    DATA(header_title) = dynamic_page->title( ns = `f` )->get( )->dynamic_page_title( ).
    header_title->_generic_property( VALUE #( n = `areaShrinkRatio` v = client->_bind( area_shrink_ratio ) ) ).

    header_title->heading( `f` )->title( `Header Title` ).

    header_title->_generic(
        name = `breadcrumbs`
        ns   = `f`
        )->breadcrumbs(
            )->link( text = `Home`
            )->link( text = `Page 1`
            )->link( text = `Page 2`
            )->link( text = `Page 3`
            )->link( text = `Page 4`
            )->link( text = `Page 5` ).

    header_title->expanded_content( `f`
        )->label( `This is a subheading` ).

    header_title->snapped_content( `f`
        )->label( `This is a subheading` ).

    " the typed snapped_title_on_mobile method renders the sap.uxap namespace - the aggregation is added generically instead
    header_title->_generic(
        name = `snappedTitleOnMobile`
        ns   = `f`
        )->title( `This is a subheading` ).

    header_title->content( `f`
        )->overflow_toolbar(
            )->generic_tag(
                id     = `generic_tag_id`
                text   = `SR`
                status = `Error`
                design = `StatusIconHidden`
                press  = client->_event( `OPEN_POPOVER_TAG` )
                )->object_number(
                    number     = `2`
                    unit       = `M`
                    emphasized = abap_false
                    state      = `Error` ).

    header_title->actions( `f`
        )->button(
            text  = `Edit`
            type  = `Emphasized`
            press = client->_event( `TOGGLE_AREA_PRIORITY` )
        )->button(
            text = `Delete`
            type = `Transparent`
        )->button(
            text = `Copy`
            type = `Transparent`
        )->button(
            text  = `Toggle Footer`
            type  = `Transparent`
            press = client->_event( `TOGGLE_FOOTER` )
        )->button(
            icon = `sap-icon://action`
            type = `Transparent`
        )->button(
            id    = `button_layout_data_id`
            text  = `Button with layoutData`
            type  = `Transparent`
            press = client->_event( `OPEN_POPOVER_BUTTON` )
        )->get( )->layout_data(
            )->overflow_toolbar_layout_data(
                priority                   = `AlwaysOverflow`
                closeoverflowoninteraction = abap_false ).

    header_title->navigation_actions(
        )->button(
            icon = `sap-icon://full-screen`
            type = `Transparent`
        )->button(
            icon = `sap-icon://decline`
            type = `Transparent` ).

    dynamic_page->header( )->dynamic_page_header( abap_true
        )->horizontal_layout( allowwrapping = abap_true
            )->vertical_layout( class = `sapUiMediumMarginEnd`
                )->object_attribute(
                    title = `Location`
                    text  = `Warehouse A`
                )->object_attribute(
                    title = `Halway`
                    text  = `23L`
                )->object_attribute(
                    title = `Rack`
                    text  = `34`
            )->get_parent(
            )->vertical_layout(
                )->object_attribute( title = `Availability`
                )->object_status(
                    text  = `In Stock`
                    state = `Success` ).

    dynamic_page->content( `f`
        )->table(
            id     = `idProductsTable`
            items  = client->_bind( t_products )
            sticky = `HeaderToolbar,ColumnHeaders`
            inset  = abap_false
            class  = `sapFDynamicPageAlignContent`
            width  = `auto`
            )->header_toolbar(
                )->toolbar(
                    )->title(
                        text  = `Products`
                        level = `H2`
            )->get_parent( )->get_parent(
            )->columns(
                )->column( `12em`
                    )->text( `Product`
                )->get_parent(
                )->column(
                    minscreenwidth = `Tablet`
                    demandpopin    = abap_true
                    )->text( `Supplier`
                )->get_parent(
                )->column(
                    minscreenwidth = `Tablet`
                    demandpopin    = abap_true
                    halign         = `End`
                    )->text( `Dimensions`
                )->get_parent(
                )->column( halign = `End`
                    )->text( `Price`
                )->get_parent( )->get_parent(
            )->column_list_item(
                )->object_identifier(
                    title = `{NAME}`
                    text  = `{PRODUCT_ID}` )->get_parent(
                )->text( `{SUPPLIER_NAME}`
                )->text( `{WIDTH} x {DEPTH} x {HEIGHT} {DIM_UNIT}`
                )->object_number(
                    number = `{PRICE}`
                    unit   = `{CURRENCY_CODE}` ).

    dynamic_page->footer( `f`
        )->overflow_toolbar(
            )->toolbar_spacer(
            )->button(
                type = `Accept`
                text = `Accept`
            )->button(
                type = `Reject`
                text = `Reject` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popover_display.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    " sap.f.cards.NumericHeader and its side indicators are added via the generic builder - the typed methods render a wrong namespace
    popup->popover(
        placement    = `Bottom`
        showheader   = abap_false
        contentwidth = `300px`
        )->card( width = `100%`
            )->header( `f`
                )->_generic(
                    name   = `NumericHeader`
                    ns     = `card`
                    t_prop = VALUE #( ( n = `title`             v = `Sales Revenue` )
                                      ( n = `subtitle`          v = `Sales revenue in the current quarter` )
                                      ( n = `unitOfMeasurement` v = `EUR` )
                                      ( n = `number`            v = `2.16` )
                                      ( n = `scale`             v = `M` )
                                      ( n = `trend`             v = `Down` )
                                      ( n = `state`             v = `Error` ) )
                    )->_generic(
                        name = `sideIndicators`
                        ns   = `card`
                        )->_generic(
                            name   = `NumericSideIndicator`
                            ns     = `card`
                            t_prop = VALUE #( ( n = `number` v = `4.74` )
                                              ( n = `unit`   v = `M` )
                                              ( n = `title`  v = `Target` ) )
                        )->get_parent(
                        )->_generic(
                            name   = `NumericSideIndicator`
                            ns     = `card`
                            t_prop = VALUE #( ( n = `number` v = `-54.49` )
                                              ( n = `unit`   v = `%` )
                                              ( n = `title`  v = `Deviation` ) ) ).

    client->popover_display(
      xml   = popup->stringify( )
      by_id = id ).

  ENDMETHOD.

ENDCLASS.
