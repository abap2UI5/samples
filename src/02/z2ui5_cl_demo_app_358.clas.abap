CLASS z2ui5_cl_demo_app_358 DEFINITION PUBLIC.

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
        weight_state   TYPE string,
        price          TYPE string,
        currency_code  TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_358 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_products = VALUE #(
      ( name           = `Notebook Basic 15`
        product_id     = `HT-1000`
        supplier_name  = `Very Best Screens`
        dimensions     = `30 x 18 x 3 cm`
        weight_measure = `4.2`
        weight_unit    = `KG`
        weight_state   = `None`
        price          = `956`
        currency_code  = `EUR` )
      ( name           = `Notebook Basic 17`
        product_id     = `HT-1001`
        supplier_name  = `Very Best Screens`
        dimensions     = `29 x 17 x 4 cm`
        weight_measure = `4.5`
        weight_unit    = `KG`
        weight_state   = `Warning`
        price          = `1249`
        currency_code  = `EUR` )
      ( name           = `Notebook Basic 18`
        product_id     = `HT-1002`
        supplier_name  = `Smartcards`
        dimensions     = `28 x 16 x 4 cm`
        weight_measure = `4.2`
        weight_unit    = `KG`
        weight_state   = `None`
        price          = `1570`
        currency_code  = `EUR` )
      ( name           = `ITelO Vault`
        product_id     = `HT-1007`
        supplier_name  = `TECUM`
        dimensions     = `32 x 10 x 1 cm`
        weight_measure = `0.1`
        weight_unit    = `KG`
        weight_state   = `None`
        price          = `299`
        currency_code  = `USD` )
      ( name           = `Gladiator MX`
        product_id     = `HT-1024`
        supplier_name  = `Panorama Studios`
        dimensions     = `53 x 30 x 7 cm`
        weight_measure = `7.5`
        weight_unit    = `KG`
        weight_state   = `Error`
        price          = `1430`
        currency_code  = `EUR` ) ).

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_util_xml=>factory( ).
    DATA(root) = view->__( n = `View` ns = `mvc`
        p = VALUE #( ( n = `displayBlock` v = abap_true )
                     ( n = `height`       v = `100%` )
                     ( n = `xmlns`        v = `sap.m` )
                     ( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ) ) ).

    DATA(page) = root->__( `Shell`
       )->__( n = `Page`
              p = VALUE #( ( n = `navButtonPress` v = client->_event_nav_app_leave( ) )
                           ( n = `showNavButton`  v = client->check_app_prev_stack( ) )
                           ( n = `title`          v = `abap2UI5 - Table` ) ) ).

    page->__( `headerContent`
       )->_( n = `Link`
             p = VALUE #( ( n = `href`   v = `https://ui5.sap.com/sdk/#/entity/sap.m.Table/sample/sap.m.sample.Table` )
                          ( n = `target` v = `_blank` )
                          ( n = `text`   v = `UI5 Demo Kit` ) ) ).

    DATA(tab) = page->__( n = `Table`
        p = VALUE #( ( n = `inset` v = abap_false )
                     ( n = `items` v = client->_bind( t_products ) ) ) ).

    tab->__( `headerToolbar`
       )->__( `OverflowToolbar`
       )->_( n = `Title`
             p = VALUE #( ( n = `level` v = `H2` )
                          ( n = `text`  v = `Products` ) )
       )->_( `ToolbarSpacer` ).

    DATA(cols) = tab->__( `columns` ).
    cols->__( n = `Column` a = `width` v = `12em`
       )->_( n = `Text` a = `text` v = `Product` ).
    cols->__( n = `Column`
              p = VALUE #( ( n = `demandPopin`    v = abap_true )
                           ( n = `minScreenWidth` v = `Tablet` ) )
       )->_( n = `Text` a = `text` v = `Supplier` ).
    cols->__( n = `Column`
              p = VALUE #( ( n = `demandPopin`    v = abap_true )
                           ( n = `hAlign`         v = `End` )
                           ( n = `minScreenWidth` v = `Desktop` ) )
       )->_( n = `Text` a = `text` v = `Dimensions` ).
    cols->__( n = `Column`
              p = VALUE #( ( n = `demandPopin`    v = abap_true )
                           ( n = `hAlign`         v = `Center` )
                           ( n = `minScreenWidth` v = `Desktop` ) )
       )->_( n = `Text` a = `text` v = `Weight` ).
    cols->__( n = `Column` a = `hAlign` v = `End`
       )->_( n = `Text` a = `text` v = `Price` ).

    DATA(cells) = tab->__( `items`
       )->__( n = `ColumnListItem` a = `vAlign` v = `Middle`
       )->__( `cells` ).
    cells->_( n = `ObjectIdentifier`
              p = VALUE #( ( n = `text`  v = `{PRODUCT_ID}` )
                           ( n = `title` v = `{NAME}` ) ) ).
    cells->_( n = `Text` a = `text` v = `{SUPPLIER_NAME}` ).
    cells->_( n = `Text` a = `text` v = `{DIMENSIONS}` ).
    cells->_( n = `ObjectNumber`
              p = VALUE #( ( n = `number` v = `{WEIGHT_MEASURE}` )
                           ( n = `state`  v = `{WEIGHT_STATE}` )
                           ( n = `unit`   v = `{WEIGHT_UNIT}` ) ) ).
    cells->_( n = `ObjectNumber`
              p = VALUE #( ( n = `number` v = `{PRICE}` )
                           ( n = `unit`   v = `{CURRENCY_CODE}` ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
