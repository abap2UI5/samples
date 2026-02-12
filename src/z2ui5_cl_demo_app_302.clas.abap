CLASS z2ui5_cl_demo_app_302 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_product,
        product        TYPE string,
        supplier       TYPE string,
        additionalinfo TYPE string,
      END OF ty_product.

    DATA lt_a_data TYPE TABLE OF ty_product.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_302 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Object Attribute inside Table`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `CLICK_HINT_ICON` ) ).

    lo_page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectAttribute/sample/sap.m.sample.ObjectAttributeInTable` ).

    lo_page->table( id = `idProductsTable`
           items    = mo_client->_bind( lt_a_data )
           )->columns(
               )->column(
                   )->text( text = `Products`
               )->get_parent(
               )->column(
                   )->text( text = `Supplier`
               )->get_parent(
               )->column(
                   )->text( text = `Supplier (active)`
               )->get_parent( )->get_parent(
           )->column_list_item(
               )->object_identifier(
                   text = `{PRODUCT}` )->get_parent(
               )->object_attribute(
                   text = `{SUPPLIER}`
               )->object_attribute(
                   text   = `{SUPPLIER}`
                   active = abap_true
           )->get_parent( ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `CLICK_HINT_ICON`.
        display_popover( `button_hint_id` ).
      WHEN `ON_PRESS`.
        mo_client->message_toast_display( mo_client->get_event_arg( 1 ) && ` marker pressed!` ).
    ENDCASE.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `This is an example of Object Attribute used inside Table.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).

      lt_a_data = VALUE #(
        ( product = `Power Projector 4713`    supplier = `Robert Brown Entertainment` )
        ( product = `HT-1022`                 supplier = `Pear Computing Services` )
        ( product = `Ergo Screen E-III`       supplier = `DelBont Industries` )
        ( product = `Gladiator MX`            supplier = `Asia High tech` )
        ( product = `Hurricane GX`            supplier = `Telecomunicaciones Star` )
        ( product = `Notebook Basic 17`       supplier = `Pear Computing Services` )
        ( product = `ITelO Vault SAT`         supplier = `New Line Design` )
        ( product = `Hurricane GX`            supplier = `Robert Brown Entertainment` )
        ( product = `Webcam`                  supplier = `Getränkegroßhandel Janssen` )
        ( product = `Deskjet Super Highspeed` supplier = `Vente Et Réparation de Ordinateur` ) ).
    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.
ENDCLASS.
