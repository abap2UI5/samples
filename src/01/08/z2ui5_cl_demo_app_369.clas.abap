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
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_369 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      t_products = VALUE #(
          ( productname = `table`    measure = 100 unit = `KG` state_measure = `Warning`     price = `1000.50` waers = `EUR` state_price = `Success` )
          ( productname = `chair`    measure = 123 unit = `KG` state_measure = `Warning`     price = `2000.55` waers = `USD` state_price = `Error` )
          ( productname = `sofa`     measure = 700 unit = `KG` state_measure = `Warning`     price = `3000.11` waers = `CNY` state_price = `Success` )
          ( productname = `computer` measure = 200 unit = `KG` state_measure = `Success`     price = `4000.88` waers = `USD` state_price = `Success` )
          ( productname = `printer`  measure = 90  unit = `KG` state_measure = `Warning`     price = `5000.47` waers = `EUR` state_price = `Error` )
          ( productname = `table2`   measure = 600 unit = `KG` state_measure = `Information` price = `6000.33` waers = `GBP` state_price = `Success` ) ).

      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
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

    IF client->check_on_event( `CLICK_HINT_ICON` ).
      popover_display( `button_hint_id` ).
    ENDIF.

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
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
