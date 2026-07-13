"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputAssistedTabularSuggestions
"! In this example assisted input is provided with table-like suggestions where several columns can
"! display more details.
CLASS z2ui5_cl_demo_app_435 DEFINITION PUBLIC.

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
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_435 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Input - Assisted Tabular Suggestions`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputAssistedTabularSuggestions` ).

    DATA(layout) = page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).

    " the sap.ui.model.type.Currency formatter of the original is replaced by a preformatted price text
    layout->label( text     = `Tabular suggestions with default configuration.`
                   labelfor = `productInput` ).
    DATA(input1) = layout->input( id                           = `productInput`
                                  placeholder                  = `Enter product`
                                  showsuggestion               = abap_true
                                  showtablesuggestionvaluehelp = abap_false
                                  suggestionrows               = client->_bind( t_products )
                       )->get( ).
    input1->suggestion_columns(
        )->column(
            )->label( `Name` )->get_parent(
        )->column( halign = `Center`
            )->label( `Product ID` )->get_parent(
        )->column( halign = `Center`
            )->label( `Supplier Name` )->get_parent(
        )->column( halign = `End`
            )->label( `Price` ).
    input1->suggestion_rows(
        )->column_list_item(
            )->cells(
                )->label( `{NAME}`
                )->label( `{PRODUCT_ID}`
                )->label( `{SUPPLIER_NAME}`
                )->label( `{PRICE} {CURRENCY_CODE}` ).

    " property enableTableAutoPopinMode="true" omitted - only available since UI5 1.89
    layout->label( text     = `Tabular suggestions with enableTableAutoPopinMode="true"`
                   labelfor = `popinTableInput` ).
    DATA(input2) = layout->input( id                           = `popinTableInput`
                                  placeholder                  = `Enter product`
                                  showsuggestion               = abap_true
                                  showtablesuggestionvaluehelp = abap_false
                                  suggestionrows               = client->_bind( t_products )
                       )->get( ).
    input2->suggestion_columns(
        )->column( `20rem`
            )->label( `Name` )->get_parent(
        )->column( width  = `10rem`
                   halign = `Center`
            )->label( `Product ID` )->get_parent(
        )->column( width  = `10rem`
                   halign = `Center`
            )->label( `Supplier Name` )->get_parent(
        )->column( width  = `10rem`
                   halign = `End`
            )->label( `Price` ).
    input2->suggestion_rows(
        )->column_list_item(
            )->cells(
                )->label( `{NAME}`
                )->label( `{PRODUCT_ID}`
                )->label( `{SUPPLIER_NAME}`
                )->label( `{PRICE} {CURRENCY_CODE}` ).

    layout->label( text     = `Tabular suggestions with custom column popin configuration`
                   labelfor = `customPopinTableInput` ).
    DATA(input3) = layout->input( id                           = `customPopinTableInput`
                                  placeholder                  = `Enter product`
                                  showsuggestion               = abap_true
                                  showtablesuggestionvaluehelp = abap_false
                                  suggestionrows               = client->_bind( t_products )
                       )->get( ).
    input3->suggestion_columns(
        )->column( `20rem`
            )->label( `Name` )->get_parent(
        )->column( `10rem`
            )->label( `Product ID` )->get_parent(
        )->column( width          = `10rem`
                   popindisplay   = `Inline`
                   minscreenwidth = `Large`
                   demandpopin    = abap_true
            )->label( `Supplier Name` )->get_parent(
        )->column( width          = `10rem`
                   popindisplay   = `Inline`
                   minscreenwidth = `Large`
                   demandpopin    = abap_true
            )->label( `Price` ).
    input3->suggestion_rows(
        )->column_list_item(
            )->cells(
                )->label( `{NAME}`
                )->label( `{PRODUCT_ID}`
                )->label( `{SUPPLIER_NAME}`
                )->label( `{PRICE} {CURRENCY_CODE}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      t_products = VALUE #(
          ( name          = `Notebook Basic 15`
            product_id    = `HT-1000`
            supplier_name = `Very Best Screens`
            price         = `956.00`
            currency_code = `EUR` )
          ( name          = `Notebook Basic 17`
            product_id    = `HT-1001`
            supplier_name = `Very Best Screens`
            price         = `1249.00`
            currency_code = `EUR` )
          ( name          = `Notebook Basic 18`
            product_id    = `HT-1002`
            supplier_name = `Very Best Screens`
            price         = `1570.00`
            currency_code = `EUR` )
          ( name          = `Notebook Basic 19`
            product_id    = `HT-1003`
            supplier_name = `Smartcards`
            price         = `1650.00`
            currency_code = `EUR` )
          ( name          = `ITelO Vault`
            product_id    = `HT-1007`
            supplier_name = `Technocom`
            price         = `299.00`
            currency_code = `EUR` )
          ( name          = `Notebook Professional 15`
            product_id    = `HT-1010`
            supplier_name = `Very Best Screens`
            price         = `1999.00`
            currency_code = `EUR` )
          ( name          = `Notebook Professional 17`
            product_id    = `HT-1011`
            supplier_name = `Very Best Screens`
            price         = `2299.00`
            currency_code = `EUR` )
          ( name          = `ITelO Vault Net`
            product_id    = `HT-1020`
            supplier_name = `Technocom`
            price         = `459.00`
            currency_code = `EUR` ) ).

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
