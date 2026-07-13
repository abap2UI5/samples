"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemIcon
"! This list item offers a standardized user interface for list content with title, description and
"! icon.
CLASS z2ui5_cl_demo_app_479 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id      TYPE string,
        name            TYPE string,
        product_pic_url TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_479 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    DATA(base_url) = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/`.
    t_products = VALUE #(
      ( product_id      = `HT-1000`
        name            = `Notebook Basic 15`
        product_pic_url = base_url && `HT-1000.jpg` )
      ( product_id      = `HT-1001`
        name            = `Notebook Basic 17`
        product_pic_url = base_url && `HT-1001.jpg` )
      ( product_id      = `HT-1002`
        name            = `Notebook Basic 18`
        product_pic_url = base_url && `HT-1002.jpg` )
      ( product_id      = `HT-1003`
        name            = `Notebook Basic 19`
        product_pic_url = base_url && `HT-1003.jpg` )
      ( product_id      = `HT-1007`
        name            = `ITelO Vault`
        product_pic_url = base_url && `HT-1007.jpg` )
      ( product_id      = `HT-1010`
        name            = `Notebook Professional 15`
        product_pic_url = base_url && `HT-1010.jpg` )
      ( product_id      = `HT-1011`
        name            = `Notebook Professional 17`
        product_pic_url = base_url && `HT-1011.jpg` )
      ( product_id      = `HT-1020`
        name            = `ITelO Vault Net`
        product_pic_url = base_url && `HT-1020.jpg` )
      ( product_id      = `HT-1021`
        name            = `ITelO Vault SAT`
        product_pic_url = base_url && `HT-1021.jpg` )
      ( product_id      = `HT-1022`
        name            = `Comfort Easy`
        product_pic_url = base_url && `HT-1022.jpg` ) ).

    " the original list binding sorts the items by name
    SORT t_products BY name.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Standard List Item - Icon`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemIcon` ).

    page->list(
        headertext = `Products`
        items      = client->_bind( t_products )
        )->_generic(
            name   = `StandardListItem`
            t_prop = VALUE #( ( n = `title`            v = `{NAME}` )
                              ( n = `description`      v = `{PRODUCT_ID}` )
                              ( n = `icon`             v = `{PRODUCT_PIC_URL}` )
                              ( n = `iconDensityAware` v = `false` )
                              ( n = `iconInset`        v = `false` ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
