"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxGrouping
"! Items in the ComboBox could be grouped by a property
CLASS z2ui5_cl_demo_app_428 DEFINITION PUBLIC.

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
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_428 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    " subset of the demo kit mock data sap/ui/demo/mock/products.json
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
        ( product_id = `HT-1036` name = `Flat Future`              supplier_name = `Very Best Screens` )
        ( product_id = `HT-1040` name = `Laser Professional Eco`   supplier_name = `Alpha Printers` )
        ( product_id = `HT-1041` name = `Laser Basic`              supplier_name = `Alpha Printers` )
        ( product_id = `HT-1042` name = `Laser Allround`           supplier_name = `Alpha Printers` )
        ( product_id = `HT-1060` name = `Cordless Mouse`           supplier_name = `Oxynum` )
        ( product_id = `HT-1061` name = `Speed Mouse`              supplier_name = `Oxynum` )
        ( product_id = `HT-1062` name = `Track Mouse`              supplier_name = `Oxynum` )
        ( product_id = `HT-1063` name = `Ergonomic Keyboard`       supplier_name = `Oxynum` ) ).

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: ComboBox - Grouping of items`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
            class          = `sapUiContentPadding` ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ComboBox/sample/sap.m.sample.ComboBoxGrouping` ).

    " the group headers are created client-side by the sorter with group:true - kept in the binding
    page->combobox(
        items = `{path:'` && client->_bind( val = t_products path = abap_true ) && `', sorter: { path: 'SUPPLIER_NAME', descending: false, group: true } }`
        )->item(
            key  = `{PRODUCT_ID}`
            text = `{NAME}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
