"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxGrouping
"! Items in the MultiComboBox could be grouped by a property
CLASS z2ui5_cl_demo_app_452 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id    TYPE string,
        name          TYPE string,
        supplier_name TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_452 IMPLEMENTATION.

  METHOD view_display.

    DATA supplier TYPE string.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: MultiComboBox - Grouping of items`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxGrouping` ).

    DATA(combo) = page->vertical_layout( class = `sapUiContentPadding`
                                         width = `100%`
        )->multi_combobox( width = `500px` ).

    " the binding sorter with group header factory is not available in abap2UI5 - the grouped items are rendered statically
    LOOP AT t_products INTO DATA(s_product).

      IF s_product-supplier_name <> supplier.

        supplier = s_product-supplier_name.
        combo->_generic( name   = `SeparatorItem`
                         ns     = `core`
                         t_prop = VALUE #( ( n = `text` v = s_product-supplier_name ) ) ).

      ENDIF.

      combo->item( key  = s_product-product_id
                   text = s_product-name ).
    ENDLOOP.

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      t_products = VALUE #(
        ( product_id = `HT-1000` name = `Notebook Basic 15`        supplier_name = `Very Best Screens` )
        ( product_id = `HT-1001` name = `Notebook Basic 17`        supplier_name = `Very Best Screens` )
        ( product_id = `HT-1002` name = `Notebook Basic 18`        supplier_name = `Very Best Screens` )
        ( product_id = `HT-1003` name = `Notebook Basic 19`        supplier_name = `Smartcards` )
        ( product_id = `HT-1007` name = `ITelO Vault`              supplier_name = `Technocom` )
        ( product_id = `HT-1010` name = `Notebook Professional 15` supplier_name = `Very Best Screens` )
        ( product_id = `HT-1011` name = `Notebook Professional 17` supplier_name = `Very Best Screens` )
        ( product_id = `HT-1020` name = `ITelO Vault Net`          supplier_name = `Technocom` )
        ( product_id = `HT-1021` name = `ITelO Vault SAT`          supplier_name = `Technocom` )
        ( product_id = `HT-1022` name = `Comfort Easy`             supplier_name = `Technocom` )
        ( product_id = `HT-1023` name = `Comfort Senior`           supplier_name = `Technocom` )
        ( product_id = `HT-1030` name = `Ergo Screen E-I`          supplier_name = `Very Best Screens` )
        ( product_id = `HT-1031` name = `Ergo Screen E-II`         supplier_name = `Very Best Screens` )
        ( product_id = `HT-1032` name = `Ergo Screen E-III`        supplier_name = `Very Best Screens` )
        ( product_id = `HT-1035` name = `Flat Basic`               supplier_name = `Very Best Screens` )
        ( product_id = `HT-1036` name = `Flat Future`              supplier_name = `Very Best Screens` ) ).
      SORT t_products BY supplier_name.

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
