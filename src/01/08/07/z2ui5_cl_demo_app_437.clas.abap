"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputGrouping
"! Items in the Input could be grouped by a property
CLASS z2ui5_cl_demo_app_437 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_437 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Input - Grouping of items`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputGrouping` ).

    DATA(layout) = page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).

    " the binding sorter with group=true of the original cannot be declared in the binding -
    " the items are pre-sorted descending by supplier name in ABAP, group headers are not rendered
    layout->label( text     = `Input with grouped suggestions`
                   labelfor = `productInputWithList` ).
    layout->input( id              = `productInputWithList`
                   placeholder     = `Enter product`
                   showsuggestion  = abap_true
                   suggestionitems = client->_bind( t_products )
        )->get( )->suggestion_items(
            )->item( text = `{NAME}` ).

    " the sap.ui.model.type.Currency formatter of the original is replaced by a preformatted price text
    layout->label( text     = `Input with grouped tabular suggestions`
                   labelfor = `productInputWithTable` ).
    DATA(input) = layout->input( id                           = `productInputWithTable`
                                 placeholder                  = `Enter product`
                                 showsuggestion               = abap_true
                                 showtablesuggestionvaluehelp = abap_false
                                 suggestionrows               = client->_bind( t_products )
                      )->get( ).
    input->suggestion_columns(
        )->column( popindisplay = `Inline`
                   demandpopin  = abap_true
            )->label( `Name` )->get_parent(
        )->column( halign         = `Center`
                   popindisplay   = `Inline`
                   demandpopin    = abap_true
                   minscreenwidth = `Tablet`
            )->label( `Product ID` )->get_parent(
        )->column( halign         = `Center`
                   popindisplay   = `Inline`
                   minscreenwidth = `Tablet`
            )->label( `Supplier Name` )->get_parent(
        )->column( halign       = `End`
                   popindisplay = `Inline`
                   demandpopin  = abap_true
            )->label( `Price` ).
    input->suggestion_rows(
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
      SORT t_products BY supplier_name DESCENDING.

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
