"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputAssistedTwoValues
"! This example shows how to easily implement an assisted input with two-value suggestions.
CLASS z2ui5_cl_demo_app_436 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
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


CLASS z2ui5_cl_demo_app_436 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Input - Assisted Two Values`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Input/sample/sap.m.sample.InputAssistedTwoValues` ).

    DATA(layout) = page->vertical_layout( class = `sapUiContentPadding`
                                          width = `100%` ).

    layout->label( text     = `Product`
                   labelfor = `productInput` ).
    layout->input( id              = `productInput`
                   placeholder     = `Enter product`
                   showsuggestion  = abap_true
                   suggestionitems = client->_bind( t_products )
        )->get( )->suggestion_items(
            )->list_item( text           = `{NAME}`
                          additionaltext = `{SUPPLIER_NAME}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      t_products = VALUE #(
          ( name = `Notebook Basic 15`        supplier_name = `Very Best Screens` )
          ( name = `Notebook Basic 17`        supplier_name = `Very Best Screens` )
          ( name = `Notebook Basic 18`        supplier_name = `Very Best Screens` )
          ( name = `Notebook Basic 19`        supplier_name = `Smartcards` )
          ( name = `ITelO Vault`              supplier_name = `Technocom` )
          ( name = `Notebook Professional 15` supplier_name = `Very Best Screens` )
          ( name = `Notebook Professional 17` supplier_name = `Very Best Screens` )
          ( name = `ITelO Vault Net`          supplier_name = `Technocom` ) ).

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
