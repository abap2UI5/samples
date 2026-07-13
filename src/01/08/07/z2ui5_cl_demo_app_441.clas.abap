"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListCounter
"! The counter of an item quickly shows how many detail entries are related, without having to
"! navigate to the detail page.
CLASS z2ui5_cl_demo_app_441 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        quantity TYPE i,
      END OF ty_s_product.
    DATA t_products TYPE TABLE OF ty_s_product.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_441 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: List - Counter Indication`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.List/sample/sap.m.sample.ListCounter` ).

    " The headerLevel property of the original sample is omitted here (available only since UI5 1.117)
    page->list(
           headertext = `Products`
           items      = client->_bind( t_products )
           )->items(
               )->standard_list_item(
                   title   = `{NAME}`
                   counter = `{QUANTITY}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      t_products = VALUE #(
        ( name = `Notebook Basic 15`        quantity = 10 )
        ( name = `Notebook Basic 17`        quantity = 20 )
        ( name = `Notebook Basic 18`        quantity = 10 )
        ( name = `Notebook Basic 19`        quantity = 15 )
        ( name = `ITelO Vault`              quantity = 15 )
        ( name = `Notebook Professional 15` quantity = 16 )
        ( name = `Notebook Professional 17` quantity = 17 )
        ( name = `ITelO Vault Net`          quantity = 14 )
        ( name = `ITelO Vault SAT`          quantity = 50 )
        ( name = `Comfort Easy`             quantity = 30 )
        ( name = `Comfort Senior`           quantity = 24 ) ).

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
