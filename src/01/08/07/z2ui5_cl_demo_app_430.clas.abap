"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DisplayListItem/sample/sap.m.sample.DisplayListItem
"! Use the Display List Item for showing name/value pairs.
CLASS z2ui5_cl_demo_app_430 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_supplier,
        supplier_name TYPE string,
        street        TYPE string,
        house_number  TYPE string,
        zip_code      TYPE string,
        city          TYPE string,
        country       TYPE string,
      END OF ty_s_supplier.
    DATA s_supplier TYPE ty_s_supplier.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_430 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    " first entry of the demo kit mock data sap/ui/demo/mock/supplier.json
    s_supplier = VALUE #(
        supplier_name = `Red Point Stores`
        street        = `Main St`
        house_number  = `1618`
        zip_code      = `31415`
        city          = `Maintown`
        country       = `Germany` ).

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Display List Item`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.DisplayListItem/sample/sap.m.sample.DisplayListItem` ).

    DATA(list) = page->vertical_layout(
                     class = `sapUiContentPadding`
                     width = `100%`
                     )->list( headertext = `Address` ).

    list->_generic(
        name   = `DisplayListItem`
        t_prop = VALUE #(
            ( n = `label` v = `Name` )
            ( n = `value` v = client->_bind( s_supplier-supplier_name ) ) ) ).
    list->_generic(
        name   = `DisplayListItem`
        t_prop = VALUE #(
            ( n = `label` v = `Street` )
            ( n = `value` v = |{ client->_bind( s_supplier-street ) } { client->_bind( s_supplier-house_number ) }| ) ) ).
    list->_generic(
        name   = `DisplayListItem`
        t_prop = VALUE #(
            ( n = `label` v = `City` )
            ( n = `value` v = |{ client->_bind( s_supplier-zip_code ) } { client->_bind( s_supplier-city ) }| )
            ( n = `type`  v = `Navigation` ) ) ).
    list->_generic(
        name   = `DisplayListItem`
        t_prop = VALUE #(
            ( n = `label` v = `Country` )
            ( n = `value` v = client->_bind( s_supplier-country ) )
            ( n = `type`  v = `Navigation` ) ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
