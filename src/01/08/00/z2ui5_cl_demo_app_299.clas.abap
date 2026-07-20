"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Select/sample/sap.m.sample.SelectWithWrappedItemText
"! Illustrates how the text in items wrap.
CLASS z2ui5_cl_demo_app_299 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product_collection,
        product_id TYPE string,
        name       TYPE string,
      END OF ty_s_product_collection.
    DATA lt_product_collection  TYPE TABLE OF ty_s_product_collection.
    DATA lt_product_collection2 TYPE TABLE OF ty_s_product_collection.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS set_data.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_299 IMPLEMENTATION.

  METHOD view_display.

    DATA page_01 TYPE REF TO z2ui5_cl_xml_view.
    page_01 = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Select - Wrapping text`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page_01->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( `CLICK_HINT_ICON` ) ).

    page_01->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Select/sample/sap.m.sample.SelectWithWrappedItemText` ).

    page_01->select(
                width         = `300px`
                wrapitemstext = abap_true
                class         = `sapUiLargeMargin`
                items         = client->_bind( lt_product_collection )
                )->item( key  = `{PRODUCT_ID}`
                         text = `{NAME}`
             )->get_parent(
             )->select(
                width         = `300px`
                wrapitemstext = abap_true
                class         = `sapUiLargeMargin`
                items         = client->_bind( lt_product_collection2 )
                )->item( key  = `{PRODUCT_ID}`
                         text = `{NAME}`
             )->get_parent( ).

    client->view_display( page_01->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `CLICK_HINT_ICON` ) IS NOT INITIAL.
      popover_display( `button_hint_id` ).
    ENDIF.

  ENDMETHOD.


  METHOD popover_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Illustrates how the text in items wrap.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      view_display( client ).
      set_data( ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.


  METHOD set_data.

    DATA temp1 LIKE lt_product_collection.
    DATA temp2 LIKE lt_product_collection2.
    DATA temp3 LIKE lt_product_collection.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 LIKE lt_product_collection2.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp1.
    lt_product_collection  = temp1.
    
    CLEAR temp2.
    lt_product_collection2 = temp2.

    " Populating lt_product_collection
    
    CLEAR temp3.
    
    temp4-product_id = `HT-1001`.
    temp4-name = `Select option 1`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1002`.
    temp4-name = `Lorem Ipsum is simply dummy text of the printing and typesetting industry.`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1003`.
    temp4-name = `Select option 3`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1007`.
    temp4-name = `Select option 4`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product_id = `HT-1010`.
    temp4-name = `Select option 5`.
    INSERT temp4 INTO TABLE temp3.
    lt_product_collection = temp3.
    SORT lt_product_collection BY name.

    " Populating lt_product_collection2
    
    CLEAR temp5.
    
    temp6-product_id = `key1`.
    temp6-name = `Select option 1`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `key2`.
    temp6-name = `Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `key3`.
    temp6-name = `Select option 3`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `key4`.
    temp6-name = `Select option 4`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `key5`.
    temp6-name = `Select option 5`.
    INSERT temp6 INTO TABLE temp5.
    lt_product_collection2 = temp5.
    SORT lt_product_collection2 BY name.

  ENDMETHOD.

ENDCLASS.
