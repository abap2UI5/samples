"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListSelection
"! 'Single selection' forces the user to choose exactly one out of many items. With the 'multi'
"! selection the user can pick multiple items at the same time. This is helpful for e.g. batch
"! processing. With 'includeItem' the selection is also changed when pressing the item.
CLASS z2ui5_cl_demo_app_446 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name       TYPE string,
        product_id TYPE string,
        pic        TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE TABLE OF ty_s_product.
    DATA mode TYPE string.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_446 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: List - Selection`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListSelection` ).

    DATA(product_list) = page->list(
           id                     = `ProductList`
           items                  = client->_bind( t_products )
           mode                   = client->_bind_edit( mode )
           includeiteminselection = abap_true ).

    product_list->header_toolbar(
       )->overflow_toolbar(
           )->title(
               text  = `Products`
               level = `H2`
           )->toolbar_spacer(
           )->select(
               selectedkey = client->_bind_edit( mode )
               )->items(
                   )->item(
                       key  = `None`
                       text = `No Selection`
                   )->item(
                       key  = `SingleSelect`
                       text = `Single Selection`
                   )->item(
                       key  = `SingleSelectLeft`
                       text = `Single Selection Left`
                   )->item(
                       key  = `SingleSelectMaster`
                       text = `Single Selection (Master)`
                   )->item(
                       key  = `MultiSelect`
                       text = `Multi Selection` ).

    " The iconDensityAware property of the original sample is not available in the view API and is omitted here
    product_list->items(
       )->standard_list_item(
           title       = `{NAME}`
           description = `{PRODUCT_ID}`
           icon        = `{PIC}`
           iconinset   = abap_false ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      mode = `MultiSelect`.
      DATA(pic_url) = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/`.
      t_products = VALUE #(
        ( name = `Notebook Basic 15`        product_id = `HT-1000` pic = pic_url && `HT-1000.jpg` )
        ( name = `Notebook Basic 17`        product_id = `HT-1001` pic = pic_url && `HT-1001.jpg` )
        ( name = `Notebook Basic 18`        product_id = `HT-1002` pic = pic_url && `HT-1002.jpg` )
        ( name = `Notebook Basic 19`        product_id = `HT-1003` pic = pic_url && `HT-1003.jpg` )
        ( name = `ITelO Vault`              product_id = `HT-1007` pic = pic_url && `HT-1007.jpg` )
        ( name = `Notebook Professional 15` product_id = `HT-1010` pic = pic_url && `HT-1010.jpg` )
        ( name = `Notebook Professional 17` product_id = `HT-1011` pic = pic_url && `HT-1011.jpg` )
        ( name = `ITelO Vault Net`          product_id = `HT-1020` pic = pic_url && `HT-1020.jpg` )
        ( name = `ITelO Vault SAT`          product_id = `HT-1021` pic = pic_url && `HT-1021.jpg` )
        ( name = `Comfort Easy`             product_id = `HT-1022` pic = pic_url && `HT-1022.jpg` ) ).

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
