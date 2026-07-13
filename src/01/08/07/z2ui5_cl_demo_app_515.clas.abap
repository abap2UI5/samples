"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.FixFlex/sample/sap.ui.layout.sample.FixFlexMinFlexSize
"! Shows a FixFlex control where the minFlexSize is set to 400px.
CLASS z2ui5_cl_demo_app_515 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        product_id     TYPE string,
        supplier_name  TYPE string,
        dimensions     TYPE string,
        weight_measure TYPE string,
        weight_unit    TYPE string,
        price          TYPE string,
        currency_code  TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_515 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Fix Flex - Vertical Direction with minFlexSize`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.layout.FixFlex/sample/sap.ui.layout.sample.FixFlexMinFlexSize` ).

    DATA(layout) = page->fix_flex( ns = `layout` ).
    " the wrapper fix_flex method does not support the minFlexSize property - generic property used
    layout->_generic_property( VALUE #( n = `minFlexSize` v = `400` ) ).

    " the original binds the object header against the first product of the demo kit mock model - here the values are used directly
    DATA(header) = layout->fix_content( `layout`
        )->object_header(
            responsive          = abap_true
            fullscreenoptimized = abap_true
            intro               = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`
            title               = `Long title truncated to 80 chars on all devices and to 50 chars on phone portrait`
            number              = `956.00`
            numberunit          = `EUR`
            numberstate         = `Success`
            backgrounddesign    = `Translucent` ).

    header->attributes(
        )->object_attribute(
            title = `Manufacturer`
            text  = `Very Best Screens` ).

    header->statuses(
        )->object_status(
            title = `Approval`
            text  = `Pending`
            state = `Warning` ).

    DATA(markers) = header->markers( ).
    markers->object_marker( type = `Flagged` ).
    markers->object_marker( type = `Favorite` ).

    DATA(products_table) = layout->flex_content( `layout`
        )->table(
            id               = `idProductsTable`
            items            = client->_bind( t_products )
            growing          = abap_true
            growingthreshold = `50` ).

    products_table->header_toolbar(
        )->overflow_toolbar(
            )->title(
                text  = `Products`
                level = `H2` ).

    products_table->columns(
        )->column( `12em`
            )->text( `Product` )->get_parent(
        )->column(
            minscreenwidth = `Tablet`
            demandpopin    = abap_true
            )->text( `Supplier` )->get_parent(
        )->column(
            minscreenwidth = `Tablet`
            demandpopin    = abap_true
            halign         = `Right`
            )->text( `Dimensions` )->get_parent(
        )->column(
            minscreenwidth = `Tablet`
            demandpopin    = abap_true
            halign         = `Center`
            )->text( `Weight` )->get_parent(
        )->column( halign = `Right`
            )->text( `Price` ).

    products_table->items(
        )->column_list_item(
            )->cells(
                )->object_identifier(
                    title = `{NAME}`
                    text  = `{PRODUCT_ID}` )->get_parent(
                )->text( `{SUPPLIER_NAME}`
                )->text( `{DIMENSIONS}`
                )->object_number(
                    number = `{WEIGHT_MEASURE}`
                    unit   = `{WEIGHT_UNIT}`
                )->object_number(
                    number = `{PRICE}`
                    unit   = `{CURRENCY_CODE}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      t_products = VALUE #(
        ( name           = `Notebook Basic 15`
          product_id     = `HT-1000`
          supplier_name  = `Very Best Screens`
          dimensions     = `30 x 18 x 3 cm`
          weight_measure = `4.2`
          weight_unit    = `KG`
          price          = `956.00`
          currency_code  = `EUR` )
        ( name           = `Notebook Basic 17`
          product_id     = `HT-1001`
          supplier_name  = `Very Best Screens`
          dimensions     = `29 x 17 x 3.1 cm`
          weight_measure = `4.5`
          weight_unit    = `KG`
          price          = `1249.00`
          currency_code  = `EUR` )
        ( name           = `Notebook Basic 18`
          product_id     = `HT-1002`
          supplier_name  = `Very Best Screens`
          dimensions     = `28 x 19 x 2.5 cm`
          weight_measure = `4.2`
          weight_unit    = `KG`
          price          = `1570.00`
          currency_code  = `EUR` )
        ( name           = `Notebook Basic 19`
          product_id     = `HT-1003`
          supplier_name  = `Smartcards`
          dimensions     = `32 x 21 x 4 cm`
          weight_measure = `4.2`
          weight_unit    = `KG`
          price          = `1650.00`
          currency_code  = `EUR` )
        ( name           = `ITelO Vault`
          product_id     = `HT-1007`
          supplier_name  = `Technocom`
          dimensions     = `32 x 22 x 3 cm`
          weight_measure = `0.2`
          weight_unit    = `KG`
          price          = `299.00`
          currency_code  = `EUR` )
        ( name           = `Notebook Professional 15`
          product_id     = `HT-1010`
          supplier_name  = `Very Best Screens`
          dimensions     = `33 x 20 x 3 cm`
          weight_measure = `4.3`
          weight_unit    = `KG`
          price          = `1999.00`
          currency_code  = `EUR` )
        ( name           = `Notebook Professional 17`
          product_id     = `HT-1011`
          supplier_name  = `Very Best Screens`
          dimensions     = `33 x 23 x 2 cm`
          weight_measure = `4.1`
          weight_unit    = `KG`
          price          = `2299.00`
          currency_code  = `EUR` )
        ( name           = `ITelO Vault Net`
          product_id     = `HT-1020`
          supplier_name  = `Technocom`
          dimensions     = `10 x 1.8 x 17 cm`
          weight_measure = `0.16`
          weight_unit    = `KG`
          price          = `459.00`
          currency_code  = `EUR` )
        ( name           = `ITelO Vault SAT`
          product_id     = `HT-1021`
          supplier_name  = `Technocom`
          dimensions     = `11 x 1.7 x 18 cm`
          weight_measure = `0.18`
          weight_unit    = `KG`
          price          = `149.00`
          currency_code  = `EUR` )
        ( name           = `Comfort Easy`
          product_id     = `HT-1022`
          supplier_name  = `Technocom`
          dimensions     = `84 x 1.5 x 14 cm`
          weight_measure = `0.2`
          weight_unit    = `KG`
          price          = `1679.00`
          currency_code  = `EUR` ) ).

      " the original sorts the table items by name via a view sorter
      SORT t_products BY name.

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
