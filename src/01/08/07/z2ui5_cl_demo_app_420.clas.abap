"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Carousel/sample/sap.m.sample.CarouselWithControls
"! With the Carousel a user can browse through multi-page content by swiping left or right.
CLASS z2ui5_cl_demo_app_420 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name            TYPE string,
        product_id      TYPE string,
        product_pic_url TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_420 IMPLEMENTATION.

  METHOD view_display.

    " Image URLs of the mock models sap/ui/demo/mock/img.json and products.json used by the original sample
    DATA(base_url) = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/`.

    " Subset of the mock model sap/ui/demo/mock/products.json used by the original sample
    t_products = VALUE #(
      ( name = `Notebook Basic 15` product_id = `HT-1000` product_pic_url = base_url && `HT-1000.jpg` )
      ( name = `Notebook Basic 17` product_id = `HT-1001` product_pic_url = base_url && `HT-1001.jpg` )
      ( name = `Notebook Basic 18` product_id = `HT-1002` product_pic_url = base_url && `HT-1002.jpg` )
      ( name = `Notebook Basic 19` product_id = `HT-1003` product_pic_url = base_url && `HT-1003.jpg` )
      ( name = `ITelO Vault` product_id = `HT-1007` product_pic_url = base_url && `HT-1007.jpg` )
      ( name = `Notebook Professional 15` product_id = `HT-1010` product_pic_url = base_url && `HT-1010.jpg` )
      ( name = `Notebook Professional 17` product_id = `HT-1011` product_pic_url = base_url && `HT-1011.jpg` )
      ( name = `ITelO Vault Net` product_id = `HT-1020` product_pic_url = base_url && `HT-1020.jpg` )
      ( name = `ITelO Vault SAT` product_id = `HT-1021` product_pic_url = base_url && `HT-1021.jpg` )
      ( name = `Comfort Easy` product_id = `HT-1022` product_pic_url = base_url && `HT-1022.jpg` ) ).

    DATA(lorem) = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.` &&
      ` At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.` &&
      ` Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.` &&
      ` Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Carousel with Controls`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Carousel/sample/sap.m.sample.CarouselWithControls` ).

    page->title( id    = `carouselTitle`
                 class = `sapUiSmallMarginTop`
                 text  = `Carousel with Different Controls` ).

    " ariaLabelledBy association of the original sample is omitted here - not supported by the abap2UI5 view API
    page->carousel( class = `sapUiContentPadding`
        )->vertical_layout(
            )->image( src = base_url && `HT-7777-large.jpg`
                      alt = `Example picture of speakers`
        )->get_parent(
        )->image( src = base_url && `HT-6120-large.jpg`
                  alt = `Example picture of USB flash drive`
        )->text( class = `sapUiSmallMargin`
                 text  = lorem
        )->scroll_container(
            height     = `100%`
            width      = `100%`
            horizontal = abap_false
            vertical   = abap_true
            )->list(
                headertext = `Some List Content 1`
                items      = client->_bind( t_products )
                " iconDensityAware of the original sample is omitted here - not supported by the abap2UI5 view API
                )->standard_list_item(
                    title       = `{NAME}`
                    description = `{PRODUCT_ID}`
                    icon        = `{PRODUCT_PIC_URL}`
                    iconinset   = abap_false
            )->get_parent(
        )->get_parent(
        )->image( src = base_url && `HT-6100-large.jpg`
                  alt = `Example picture of spotlight` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
