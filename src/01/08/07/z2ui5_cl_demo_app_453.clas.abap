"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxTwoColumnsLayout
"! Use the dropdown list with two columns layout if you need to display additional information to
"! your options, like e.g. currencies to countries or abbreviations to systems.
CLASS z2ui5_cl_demo_app_453 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id TYPE string,
        name       TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_453 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: MultiComboBox - Two columns layout`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.MultiComboBox/sample/sap.m.sample.MultiComboBoxTwoColumnsLayout` ).

    page->vertical_layout( class = `sapUiContentPadding`
                           width = `100%`
        )->multi_combobox(
            showsecondaryvalues = abap_true
            width               = `500px`
            items               = client->_bind( t_products )
            )->list_item( key            = `{PRODUCT_ID}`
                          text           = `{NAME}`
                          additionaltext = `{PRODUCT_ID}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      t_products = VALUE #(
        ( product_id = `HT-1000` name = `Notebook Basic 15` )
        ( product_id = `HT-1001` name = `Notebook Basic 17` )
        ( product_id = `HT-1002` name = `Notebook Basic 18` )
        ( product_id = `HT-1003` name = `Notebook Basic 19` )
        ( product_id = `HT-1007` name = `ITelO Vault` )
        ( product_id = `HT-1010` name = `Notebook Professional 15` )
        ( product_id = `HT-1011` name = `Notebook Professional 17` )
        ( product_id = `HT-1020` name = `ITelO Vault Net` )
        ( product_id = `HT-1021` name = `ITelO Vault SAT` )
        ( product_id = `HT-1022` name = `Comfort Easy` )
        ( product_id = `HT-1023` name = `Comfort Senior` )
        ( product_id = `HT-1030` name = `Ergo Screen E-I` )
        ( product_id = `HT-1031` name = `Ergo Screen E-II` )
        ( product_id = `HT-1032` name = `Ergo Screen E-III` )
        ( product_id = `HT-1035` name = `Flat Basic` )
        ( product_id = `HT-1036` name = `Flat Future` ) ).
      SORT t_products BY name.

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
