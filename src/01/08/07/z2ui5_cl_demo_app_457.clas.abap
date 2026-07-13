"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputGrouping
"! Items in the MultiInput could be grouped by a property
CLASS z2ui5_cl_demo_app_457 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name          TYPE string,
        product_id    TYPE string,
        supplier_name TYPE string,
        price         TYPE string,
        currency_code TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_457 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_products = VALUE #(
        ( name = `Notebook Basic 15`        product_id = `HT-1000` supplier_name = `Very Best Screens` price = `956.00`   currency_code = `EUR` )
        ( name = `Notebook Basic 17`        product_id = `HT-1001` supplier_name = `Very Best Screens` price = `1,249.00` currency_code = `EUR` )
        ( name = `Notebook Basic 18`        product_id = `HT-1002` supplier_name = `Very Best Screens` price = `1,570.00` currency_code = `EUR` )
        ( name = `Notebook Basic 19`        product_id = `HT-1003` supplier_name = `Smartcards`        price = `1,650.00` currency_code = `EUR` )
        ( name = `ITelO Vault`              product_id = `HT-1007` supplier_name = `Technocom`         price = `299.00`   currency_code = `EUR` )
        ( name = `Notebook Professional 15` product_id = `HT-1010` supplier_name = `Very Best Screens` price = `1,999.00` currency_code = `EUR` )
        ( name = `Notebook Professional 17` product_id = `HT-1011` supplier_name = `Very Best Screens` price = `2,299.00` currency_code = `EUR` )
        ( name = `ITelO Vault Net`          product_id = `HT-1020` supplier_name = `Technocom`         price = `459.00`   currency_code = `EUR` )
        ( name = `ITelO Vault SAT`          product_id = `HT-1021` supplier_name = `Technocom`         price = `149.00`   currency_code = `EUR` )
        ( name = `Comfort Easy`             product_id = `HT-1022` supplier_name = `Technocom`         price = `1,679.00` currency_code = `EUR` )
        ( name = `Comfort Senior`           product_id = `HT-1023` supplier_name = `Technocom`         price = `512.00`   currency_code = `EUR` )
        ( name = `Ergo Screen E-I`          product_id = `HT-1030` supplier_name = `Very Best Screens` price = `230.00`   currency_code = `EUR` )
        ( name = `Flat Basic`               product_id = `HT-1035` supplier_name = `Smartcards`        price = `399.00`   currency_code = `EUR` )
        ( name = `Flat Future`              product_id = `HT-1036` supplier_name = `Smartcards`        price = `430.00`   currency_code = `EUR` ) ).

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    " grouping of the suggestions is done by a client-side sorter with group = true - as in the original view
    DATA(sorter) = `', sorter:{path:'SUPPLIER_NAME', group:true, ascending:false}}`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: MultiInput - Grouping of items`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiInput/sample/sap.m.sample.MultiInputGrouping` ).

    DATA(layout) = page->vertical_layout(
        class = `sapUiContentPadding`
        width = `100%` ).

    layout->label(
        text     = `Multi Input with grouped suggestions`
        labelfor = `productMIWithList` ).

    layout->multi_input(
        id              = `productMIWithList`
        placeholder     = `Enter Product ...`
        showsuggestion  = abap_true
        showvaluehelp   = abap_false
        suggestionitems = `{path:'` && client->_bind( val  = t_products
                                                      path = abap_true ) && sorter
        )->suggestion_items(
            )->item(
                text = `{NAME}`
                key  = `{PRODUCT_ID}` ).

    layout->label(
        text     = `Multi Input with grouped tabular suggestions`
        labelfor = `productMIWithTable` ).

    " showTableSuggestionValueHelp and suggestionRows are not part of the typed MultiInput method - built generically
    " the JavaScript token validator of the original cannot be ported (client-side JavaScript only)
    DATA(input_table) = layout->_generic(
        name   = `MultiInput`
        t_prop = VALUE #( ( n = `id`                           v = `productMIWithTable` )
                          ( n = `placeholder`                  v = `Enter Product ...` )
                          ( n = `showSuggestion`               v = `true` )
                          ( n = `showValueHelp`                v = `false` )
                          ( n = `showTableSuggestionValueHelp` v = `false` )
                          ( n = `suggestionRows`               v = `{path:'` && client->_bind( val  = t_products
                                                                                               path = abap_true ) && sorter ) ) ).

    input_table->suggestion_columns(
        )->column(
            halign       = `Begin`
            popindisplay = `Inline`
            demandpopin  = abap_true
            )->label( `Name` )->get_parent(
        )->column(
            halign         = `Center`
            popindisplay   = `Inline`
            demandpopin    = abap_true
            minscreenwidth = `Tablet`
            )->label( `Product ID` )->get_parent(
        )->column(
            halign         = `Center`
            popindisplay   = `Inline`
            demandpopin    = abap_false
            minscreenwidth = `Tablet`
            )->label( `Supplier Name` )->get_parent(
        )->column(
            halign       = `End`
            popindisplay = `Inline`
            demandpopin  = abap_true
            )->label( `Price` ).

    input_table->suggestion_rows(
        )->column_list_item(
            )->cells(
                )->label( `{NAME}`
                )->label( `{PRODUCT_ID}`
                )->label( `{SUPPLIER_NAME}`
                )->label( `{ parts:[{path:'PRICE'},{path:'CURRENCY_CODE'}], type: 'sap.ui.model.type.Currency', formatOptions: {showMeasure: true} }` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
