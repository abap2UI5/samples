CLASS z2ui5_cl_demo_app_370 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        productid    TYPE string,
        productname  TYPE string,
        suppliername TYPE string,
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


CLASS z2ui5_cl_demo_app_370 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      t_products = VALUE #(
          ( productid = `1` productname = `table`    suppliername = `Company 1` )
          ( productid = `2` productname = `chair`    suppliername = `Company 2` )
          ( productid = `3` productname = `sofa`     suppliername = `Company 3` )
          ( productid = `4` productname = `computer` suppliername = `Company 4` )
          ( productid = `5` productname = `printer`  suppliername = `Company 5` )
          ( productid = `6` productname = `table2`   suppliername = `Company 6` ) ).

      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Object Identifier inside a Table`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectIdentifier` ).

    page->table( client->_bind( t_products )
        )->columns(
            )->column(
                )->text( `Product` )->get_parent(
            )->column(
                )->text( `Supplier` )->get_parent( )->get_parent(
        )->items(
            )->column_list_item(
               )->cells(
                 )->object_identifier( title = `{PRODUCTNAME}`
                                       text  = `{PRODUCTID}`
                 )->text( `{SUPPLIERNAME}` ).

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
                                  description = `The object identifier is a display control that enables the user to easily identify a specific object. It shows a title and an additional text inside a table.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.

ENDCLASS.
