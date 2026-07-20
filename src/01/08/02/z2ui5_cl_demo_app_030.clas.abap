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
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
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
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.
    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.

    show_footer       = abap_true.
    area_shrink_ratio = `1:1.6:1.6`.
    
    CLEAR temp1.
    
    temp2-name = `Notebook Basic 15`.
    temp2-product_id = `HT-1000`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `30`.
    temp2-depth = `18`.
    temp2-height = `3`.
    temp2-dim_unit = `cm`.
    temp2-price = `956.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 17`.
    temp2-product_id = `HT-1001`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `29`.
    temp2-depth = `17`.
    temp2-height = `3.1`.
    temp2-dim_unit = `cm`.
    temp2-price = `1,249.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 18`.
    temp2-product_id = `HT-1002`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `28`.
    temp2-depth = `19`.
    temp2-height = `2.5`.
    temp2-dim_unit = `cm`.
    temp2-price = `1,570.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 19`.
    temp2-product_id = `HT-1003`.
    temp2-supplier_name = `Smartcards`.
    temp2-width = `32`.
    temp2-depth = `21`.
    temp2-height = `4`.
    temp2-dim_unit = `cm`.
    temp2-price = `1,650.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault`.
    temp2-product_id = `HT-1007`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `32`.
    temp2-depth = `22`.
    temp2-height = `3`.
    temp2-dim_unit = `cm`.
    temp2-price = `299.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 15`.
    temp2-product_id = `HT-1010`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `33`.
    temp2-depth = `20`.
    temp2-height = `3`.
    temp2-dim_unit = `cm`.
    temp2-price = `1,999.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 17`.
    temp2-product_id = `HT-1011`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `33`.
    temp2-depth = `23`.
    temp2-height = `2`.
    temp2-dim_unit = `cm`.
    temp2-price = `2,299.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault Net`.
    temp2-product_id = `HT-1020`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `10`.
    temp2-depth = `1.8`.
    temp2-height = `17`.
    temp2-dim_unit = `cm`.
    temp2-price = `459.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault SAT`.
    temp2-product_id = `HT-1021`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `11`.
    temp2-depth = `1.7`.
    temp2-height = `18`.
    temp2-dim_unit = `cm`.
    temp2-price = `149.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Easy`.
    temp2-product_id = `HT-1022`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `84`.
    temp2-depth = `1.5`.
    temp2-height = `14`.
    temp2-dim_unit = `cm`.
    temp2-price = `1,679.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Comfort Senior`.
    temp2-product_id = `HT-1023`.
    temp2-supplier_name = `Technocom`.
    temp2-width = `80`.
    temp2-depth = `1.6`.
    temp2-height = `13`.
    temp2-dim_unit = `cm`.
    temp2-price = `512.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-I`.
    temp2-product_id = `HT-1030`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `37`.
    temp2-depth = `12`.
    temp2-height = `36`.
    temp2-dim_unit = `cm`.
    temp2-price = `230.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-II`.
    temp2-product_id = `HT-1031`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `40.8`.
    temp2-depth = `19`.
    temp2-height = `43`.
    temp2-dim_unit = `cm`.
    temp2-price = `285.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Ergo Screen E-III`.
    temp2-product_id = `HT-1032`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `40.8`.
    temp2-depth = `19`.
    temp2-height = `43`.
    temp2-dim_unit = `cm`.
    temp2-price = `345.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Basic`.
    temp2-product_id = `HT-1035`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `39`.
    temp2-depth = `20`.
    temp2-height = `41`.
    temp2-dim_unit = `cm`.
    temp2-price = `399.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Flat Future`.
    temp2-product_id = `HT-1036`.
    temp2-supplier_name = `Very Best Screens`.
    temp2-width = `45`.
    temp2-depth = `26`.
    temp2-height = `46`.
    temp2-dim_unit = `cm`.
    temp2-price = `430.00`.
    temp2-currency_code = `EUR`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.
    " the original sorts the ProductCollection by name via a model sorter - the data is sorted in ABAP instead
    SORT t_products BY name.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE string.
        DATA temp1 TYPE xsdboolean.

    CASE client->get( )-event.
      WHEN `TOGGLE_AREA_PRIORITY`.
        
        IF area_shrink_ratio = `1:1.6:1.6`.
          temp3 = `1.6:1:1.6`.
        ELSE.
          temp3 = `1:1.6:1.6`.
        ENDIF.
        area_shrink_ratio = temp3.
        client->view_model_update( ).
      WHEN `TOGGLE_FOOTER`.
        
        temp1 = boolc( show_footer = abap_false ).
        show_footer = temp1.
        client->view_model_update( ).
      WHEN `OPEN_POPOVER`.
        " open the popover by the control that fired the event, exactly like
        " the original sample (oEvent.getSource) - the source control id is
        " passed as the first event argument
        popover_display( client->get_event_arg( ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA dynamic_page TYPE REF TO z2ui5_cl_xml_view.
    DATA header_title TYPE REF TO z2ui5_cl_xml_view.
    DATA temp4 TYPE z2ui5_if_types=>ty_s_name_value.
    DATA temp5 TYPE string_table.
    DATA temp7 TYPE string_table.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell(
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
    
    dynamic_page = page->dynamic_page( showfooter = client->_bind( show_footer ) ).

    
    header_title = dynamic_page->title( ns = `f` )->get( )->dynamic_page_title( ).
    
    CLEAR temp4.
    temp4-n = `areaShrinkRatio`.
    temp4-v = client->_bind( area_shrink_ratio ).
    header_title->_generic_property( temp4 ).

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

    
    CLEAR temp5.
    INSERT `${$source>/id}` INTO TABLE temp5.
    header_title->content( `f`
        )->overflow_toolbar(
            )->generic_tag(
                text   = `SR`
                status = `Error`
                design = `StatusIconHidden`
                press  = client->_event( val   = `OPEN_POPOVER`
                                         t_arg = temp5 )
                )->object_number(
                    number     = `2`
                    unit       = `M`
                    emphasized = abap_false
                    state      = `Error` ).

    
    CLEAR temp7.
    INSERT `${$source>/id}` INTO TABLE temp7.
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
            text  = `Button with layoutData`
            type  = `Transparent`
            press = client->_event( val   = `OPEN_POPOVER`
                                    t_arg = temp7 )
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

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    DATA temp9 TYPE z2ui5_if_types=>ty_t_name_value.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp1 TYPE z2ui5_if_types=>ty_t_name_value.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp3 TYPE z2ui5_if_types=>ty_t_name_value.
    DATA temp4 LIKE LINE OF temp3.
    popup = z2ui5_cl_xml_view=>factory_popup( ).

    " sap.f.cards.NumericHeader and its side indicators are added via the generic builder - the typed methods render a wrong namespace
    
    CLEAR temp9.
    
    temp10-n = `title`.
    temp10-v = `Sales Revenue`.
    INSERT temp10 INTO TABLE temp9.
    temp10-n = `subtitle`.
    temp10-v = `Sales revenue in the current quarter`.
    INSERT temp10 INTO TABLE temp9.
    temp10-n = `unitOfMeasurement`.
    temp10-v = `EUR`.
    INSERT temp10 INTO TABLE temp9.
    temp10-n = `number`.
    temp10-v = `2.16`.
    INSERT temp10 INTO TABLE temp9.
    temp10-n = `scale`.
    temp10-v = `M`.
    INSERT temp10 INTO TABLE temp9.
    temp10-n = `trend`.
    temp10-v = `Down`.
    INSERT temp10 INTO TABLE temp9.
    temp10-n = `state`.
    temp10-v = `Error`.
    INSERT temp10 INTO TABLE temp9.
    
    CLEAR temp1.
    
    temp2-n = `number`.
    temp2-v = `4.74`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `unit`.
    temp2-v = `M`.
    INSERT temp2 INTO TABLE temp1.
    temp2-n = `title`.
    temp2-v = `Target`.
    INSERT temp2 INTO TABLE temp1.
    
    CLEAR temp3.
    
    temp4-n = `number`.
    temp4-v = `-54.49`.
    INSERT temp4 INTO TABLE temp3.
    temp4-n = `unit`.
    temp4-v = `%`.
    INSERT temp4 INTO TABLE temp3.
    temp4-n = `title`.
    temp4-v = `Deviation`.
    INSERT temp4 INTO TABLE temp3.
    popup->popover(
        placement    = `Bottom`
        showheader   = abap_false
        contentwidth = `300px`
        )->card( width = `100%`
            )->header( `f`
                )->_generic(
                    name   = `NumericHeader`
                    ns     = `card`
                    t_prop = temp9
                    )->_generic(
                        name = `sideIndicators`
                        ns   = `card`
                        )->_generic(
                            name   = `NumericSideIndicator`
                            ns     = `card`
                            t_prop = temp1
                        )->get_parent(
                        )->_generic(
                            name   = `NumericSideIndicator`
                            ns     = `card`
                            t_prop = temp3 ).

    client->popover_display(
      xml   = popup->stringify( )
      by_id = id ).

  ENDMETHOD.

ENDCLASS.
