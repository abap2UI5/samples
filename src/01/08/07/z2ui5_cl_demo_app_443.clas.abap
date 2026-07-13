"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListGrowing
"! The Growing feature helps if your content is too big to be loaded/shown at once. It paginates the
"! content into smaller chunks - aka pages - which are loaded/shown one after another. Random access
"! to pages (e.g jumping to the end) is not possible. Depending on the model the content is loaded
"! on demand (OData) or shown on demand (JSON).
CLASS z2ui5_cl_demo_app_443 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name       TYPE string,
        product_id TYPE string,
        pic        TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE TABLE OF ty_s_product.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_443 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: List - Growing`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListGrowing` ).

    " The iconDensityAware property of the original sample is not available in the view API and is omitted here
    page->list(
           headertext          = `Products`
           items               = client->_bind( t_products )
           growing             = abap_true
           growingthreshold    = `4`
           growingscrolltoload = abap_false
           )->items(
               )->standard_list_item(
                   title       = `{NAME}`
                   description = `{PRODUCT_ID}`
                   icon        = `{PIC}`
                   iconinset   = abap_false ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

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
        ( name = `Comfort Easy`             product_id = `HT-1022` pic = pic_url && `HT-1022.jpg` )
        ( name = `Comfort Senior`           product_id = `HT-1023` pic = pic_url && `HT-1023.jpg` )
        ( name = `Ergo Screen E-I`          product_id = `HT-1030` pic = pic_url && `HT-1030.jpg` ) ).

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
