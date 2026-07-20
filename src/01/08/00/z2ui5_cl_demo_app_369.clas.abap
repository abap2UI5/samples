CLASS z2ui5_cl_demo_app_369 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        productname   TYPE string,
        measure       TYPE p LENGTH 10 DECIMALS 2,
        unit          TYPE string,
        state_measure TYPE string,
        price         TYPE p LENGTH 14 DECIMALS 3,
        waers         TYPE waers,
        state_price   TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_369 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_products.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      
      CLEAR temp1.
      
      temp2-productname = `table`.
      temp2-measure = 100.
      temp2-unit = `KG`.
      temp2-state_measure = `Warning`.
      temp2-price = `1000.50`.
      temp2-waers = `EUR`.
      temp2-state_price = `Success`.
      INSERT temp2 INTO TABLE temp1.
      temp2-productname = `chair`.
      temp2-measure = 123.
      temp2-unit = `KG`.
      temp2-state_measure = `Warning`.
      temp2-price = `2000.55`.
      temp2-waers = `USD`.
      temp2-state_price = `Error`.
      INSERT temp2 INTO TABLE temp1.
      temp2-productname = `sofa`.
      temp2-measure = 700.
      temp2-unit = `KG`.
      temp2-state_measure = `Warning`.
      temp2-price = `3000.11`.
      temp2-waers = `CNY`.
      temp2-state_price = `Success`.
      INSERT temp2 INTO TABLE temp1.
      temp2-productname = `computer`.
      temp2-measure = 200.
      temp2-unit = `KG`.
      temp2-state_measure = `Success`.
      temp2-price = `4000.88`.
      temp2-waers = `USD`.
      temp2-state_price = `Success`.
      INSERT temp2 INTO TABLE temp1.
      temp2-productname = `printer`.
      temp2-measure = 90.
      temp2-unit = `KG`.
      temp2-state_measure = `Warning`.
      temp2-price = `5000.47`.
      temp2-waers = `EUR`.
      temp2-state_price = `Error`.
      INSERT temp2 INTO TABLE temp1.
      temp2-productname = `table2`.
      temp2-measure = 600.
      temp2-unit = `KG`.
      temp2-state_measure = `Information`.
      temp2-price = `6000.33`.
      temp2-waers = `GBP`.
      temp2-state_price = `Success`.
      INSERT temp2 INTO TABLE temp1.
      t_products = temp1.

      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Object Number inside a Table`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( `CLICK_HINT_ICON` ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectNumber` ).

    page->table( client->_bind( t_products )
        )->columns(
            )->column(
                )->text( `Product` )->get_parent(
            )->column( halign = `End`
                )->text( `Weight` )->get_parent(
            )->column( halign = `End`
                )->text( `Price` )->get_parent( )->get_parent(
        )->items(
            )->column_list_item(
               )->cells(
                 )->text( `{PRODUCTNAME}`
                 )->object_number( number = `{MEASURE}`
                                   unit   = `{UNIT}`
                                   state  = `{STATE_MEASURE}`
                 )->object_number( number = `{ parts: [ { path : 'PRICE' } , { path : 'WAERS' } ] }`
                                   state  = `{STATE_PRICE}` ).

    client->view_display( page->stringify( ) ).

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
                                  description = `The object number displays a number with unit and semantic state. The price column uses a composite binding of amount and currency.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.
ENDCLASS.
