"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FacetFilter/sample/sap.m.sample.FacetFilterLight
"! This is a 'Light' version of the Facet Filter. It is for small displays where only a selectable
"! summary bar is shown, and a dialog is shown for setting the facet values.
CLASS z2ui5_cl_demo_app_401 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        category       TYPE string,
        supplier_name  TYPE string,
        dimensions     TYPE string,
        weight_measure TYPE string,
        weight_unit    TYPE string,
        weight_state   TYPE string,
        price          TYPE string,
        currency_code  TYPE string,
      END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_facet,
        text  TYPE string,
        count TYPE i,
      END OF ty_s_facet.
    TYPES ty_t_facet TYPE STANDARD TABLE OF ty_s_facet WITH EMPTY KEY.
    DATA t_products     TYPE ty_t_product.
    DATA t_products_all TYPE ty_t_product.
    DATA t_categories   TYPE ty_t_facet.
    DATA t_suppliers    TYPE ty_t_facet.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA t_range_category TYPE RANGE OF string.
    DATA t_range_supplier TYPE RANGE OF string.

    METHODS set_data.
    METHODS view_display.
    METHODS on_event_list_close
      IMPORTING
        facet TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_401 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      set_data( ).
      view_display( ).

    ELSEIF client->check_on_event( `RESET` ).

      t_range_category = VALUE #( ).
      t_range_supplier = VALUE #( ).
      t_products = t_products_all.
      client->view_model_update( ).

    ELSEIF client->check_on_event( `LIST_CLOSE_CATEGORY` ).
      on_event_list_close( `CATEGORY` ).
    ELSEIF client->check_on_event( `LIST_CLOSE_SUPPLIER` ).
      on_event_list_close( `SUPPLIER` ).
    ENDIF.

  ENDMETHOD.


  METHOD set_data.

    " Data taken from the shared mock data sap/ui/demo/mock/products.json of the original sample
    t_products = VALUE #(
        ( name = `Comfort Easy` category = `Accessories` supplier_name = `Technocom` dimensions = `84 x 1.5 x 14 cm` weight_measure = `0.2` weight_unit = `KG` weight_state = `Success` price = `1679.00` currency_code = `EUR` )
        ( name = `Comfort Senior` category = `Accessories` supplier_name = `Technocom` dimensions = `80 x 1.6 x 13 cm` weight_measure = `0.8` weight_unit = `KG` weight_state = `Success` price = `512.00` currency_code = `EUR` )
        ( name = `Ergo Screen E-I` category = `Flat Screen Monitors` supplier_name = `Very Best Screens` dimensions = `37 x 12 x 36 cm` weight_measure = `21` weight_unit = `KG` weight_state = `Error` price = `230.00` currency_code = `EUR` )
        ( name = `ITelO Vault` category = `Accessories` supplier_name = `Technocom` dimensions = `32 x 22 x 3 cm` weight_measure = `0.2` weight_unit = `KG` weight_state = `Success` price = `299.00` currency_code = `EUR` )
        ( name = `ITelO Vault Net` category = `Accessories` supplier_name = `Technocom` dimensions = `10 x 1.8 x 17 cm` weight_measure = `0.16` weight_unit = `KG` weight_state = `Success` price = `459.00` currency_code = `EUR` )
        ( name = `ITelO Vault SAT` category = `Accessories` supplier_name = `Technocom` dimensions = `11 x 1.7 x 18 cm` weight_measure = `0.18` weight_unit = `KG` weight_state = `Success` price = `149.00` currency_code = `EUR` )
        ( name = `Notebook Basic 15` category = `Laptops` supplier_name = `Very Best Screens` dimensions = `30 x 18 x 3 cm` weight_measure = `4.2` weight_unit = `KG` weight_state = `Warning` price = `956.00` currency_code = `EUR` )
        ( name = `Notebook Basic 17` category = `Laptops` supplier_name = `Very Best Screens` dimensions = `29 x 17 x 3.1 cm` weight_measure = `4.5` weight_unit = `KG` weight_state = `Warning` price = `1249.00` currency_code = `EUR` )
        ( name = `Notebook Basic 19` category = `Laptops` supplier_name = `Smartcards` dimensions = `32 x 21 x 4 cm` weight_measure = `4.2` weight_unit = `KG` weight_state = `Warning` price = `1650.00` currency_code = `EUR` )
        ( name = `Notebook Professional 15` category = `Accessories` supplier_name = `Very Best Screens` dimensions = `33 x 20 x 3 cm` weight_measure = `4.3` weight_unit = `KG` weight_state = `Warning` price = `1999.00` currency_code = `EUR` ) ).

    SORT t_products BY name.
    t_products_all = t_products.

    " Facet values with counters as delivered precomputed in /ProductCollectionStats/Filters
    t_categories = VALUE #(
        ( text = `Accessories` count = 6 )
        ( text = `Flat Screen Monitors` count = 1 )
        ( text = `Laptops` count = 3 ) ).
    t_suppliers = VALUE #(
        ( text = `Smartcards` count = 1 )
        ( text = `Technocom` count = 5 )
        ( text = `Very Best Screens` count = 4 ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Facet Filter - Light`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FacetFilter/sample/sap.m.sample.FacetFilterLight` ).

    DATA(vbox) = page->vbox( id = `idVBox` ).

    " The bound lists collection of the original is unrolled into two static facet filter lists
    vbox->facet_filter( id                  = `idFacetFilter`
                        type                = `Light`
                        showpersonalization = abap_true
                        showreset           = abap_true
                        reset               = client->_event( `RESET` )
        )->facet_filter_list( title     = `Category`
                              key       = `Category`
                              mode      = `MultiSelect`
                              listclose = client->_event( val   = `LIST_CLOSE_CATEGORY`
                                                          t_arg = VALUE #( ( `$event.mParameters.selectedItems` ) ) )
                              items     = client->_bind( t_categories )
            )->facet_filter_item( text    = `{TEXT}`
                                  key     = `{TEXT}`
                                  counter = `{COUNT}` )->get_parent( )->get_parent(
        )->facet_filter_list( title     = `SupplierName`
                              key       = `SupplierName`
                              mode      = `MultiSelect`
                              listclose = client->_event( val   = `LIST_CLOSE_SUPPLIER`
                                                          t_arg = VALUE #( ( `$event.mParameters.selectedItems` ) ) )
                              items     = client->_bind( t_suppliers )
            )->facet_filter_item( text    = `{TEXT}`
                                  key     = `{TEXT}`
                                  counter = `{COUNT}` ).

    " The original controller appends the demo table of sap.m.sample.Table with an adjusted first column
    DATA(tab) = vbox->table( id    = `idProductsTable`
                             inset = abap_false
                             items = client->_bind( t_products ) ).

    tab->header_toolbar(
       )->overflow_toolbar(
           )->title( text  = `Products`
                     level = `H2`
           )->toolbar_spacer( ).

    DATA(columns) = tab->columns( ).
    columns->column( `12em` )->text( `Product` ).
    columns->column( minscreenwidth = `Tablet`
                     demandpopin    = abap_true )->text( `Supplier` ).
    columns->column( minscreenwidth = `Desktop`
                     demandpopin    = abap_true
                     halign         = `End` )->text( `Dimensions` ).
    columns->column( minscreenwidth = `Desktop`
                     demandpopin    = abap_true
                     halign         = `Center` )->text( `Weight` ).
    columns->column( halign = `End` )->text( `Price` ).

    DATA(cells) = tab->items( )->column_list_item( valign = `Middle` )->cells( ).
    cells->object_identifier( title = `{NAME}`
                              text  = `{CATEGORY}` )->get_parent( ).
    cells->text( `{SUPPLIER_NAME}` ).
    cells->text( `{DIMENSIONS}` ).
    cells->object_number( number = `{WEIGHT_MEASURE}`
                          unit   = `{WEIGHT_UNIT}`
                          state  = `{WEIGHT_STATE}` ).
    cells->object_number( number = `{PRICE}`
                          unit   = `{CURRENCY_CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event_list_close.

    DATA t_range TYPE RANGE OF string.

    TRY.
        DATA(t_arg) = client->get( )-t_event_arg.
        DATA(json) = z2ui5_cl_ajson=>parse( t_arg[ 1 ] ).

        LOOP AT json->members( `/` ) INTO DATA(member).
          APPEND VALUE #( sign   = `I`
                          option = `EQ`
                          low    = json->get( |/{ member }/mProperties/text| ) ) TO t_range.
        ENDLOOP.

      CATCH cx_root.
    ENDTRY.

    IF facet = `CATEGORY`.
      t_range_category = t_range.
    ELSE.
      t_range_supplier = t_range.
    ENDIF.

    t_products = t_products_all.
    DELETE t_products WHERE category NOT IN t_range_category OR supplier_name NOT IN t_range_supplier.

    client->view_model_update( ).

  ENDMETHOD.

ENDCLASS.
