"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Title/sample/sap.m.sample.Title
"! The Title control is a simple one line text with additional semantic information about the level
"! of the following section in the page structure for accessibility purposes.
CLASS z2ui5_cl_demo_app_485 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name       TYPE string,
        product_id TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_485 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( `BUTTON_PRESS` ).
      client->message_toast_display( `Header toolbar button pressed.` ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_products = VALUE #(
        ( name = `Notebook Basic 15`        product_id = `HT-1000` )
        ( name = `Notebook Basic 17`        product_id = `HT-1001` )
        ( name = `Notebook Basic 18`        product_id = `HT-1002` )
        ( name = `Notebook Basic 19`        product_id = `HT-1003` )
        ( name = `ITelO Vault`              product_id = `HT-1007` )
        ( name = `Notebook Professional 15` product_id = `HT-1010` )
        ( name = `Notebook Professional 17` product_id = `HT-1011` )
        ( name = `ITelO Vault Net`          product_id = `HT-1020` )
        ( name = `ITelO Vault SAT`          product_id = `HT-1021` )
        ( name = `Comfort Easy`             product_id = `HT-1022` )
        ( name = `Comfort Senior`           product_id = `HT-1023` )
        ( name = `Ergo Screen E-I`          product_id = `HT-1030` )
        ( name = `Ergo Screen E-II`         product_id = `HT-1031` )
        ( name = `Ergo Screen E-III`        product_id = `HT-1032` )
        ( name = `Flat Basic`               product_id = `HT-1035` )
        ( name = `Flat Future`              product_id = `HT-1036` ) ).

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Title`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Title/sample/sap.m.sample.Title` ).

    page->page(
            title           = `Page Header Title`
            titlelevel      = `H2`
            enablescrolling = abap_true
            showfooter      = abap_false
            )->list( client->_bind( t_products )
                )->header_toolbar(
                    )->toolbar(
                        )->title(
                            text  = `Products`
                            level = `H3`
                        )->toolbar_spacer(
                        )->button(
                            icon  = `sap-icon://settings`
                            press = client->_event( `BUTTON_PRESS` )
                    )->get_parent(
                )->get_parent(
                )->items(
                    )->standard_list_item(
                        title       = `{NAME}`
                        description = `{PRODUCT_ID}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
