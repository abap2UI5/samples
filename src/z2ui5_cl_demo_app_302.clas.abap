CLASS z2ui5_cl_demo_app_302 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_product,
        product        TYPE string,
        supplier       TYPE string,
        additionalInfo TYPE string,
      END OF ty_product.

    DATA check_initialized TYPE abap_bool.
    DATA lt_a_data TYPE TABLE OF ty_product.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_302 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Object Attribute inside Table'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon = `sap-icon://hint`
           tooltip = `Sample information`
           press = client->_event( 'CLICK_HINT_ICON' ) ).

    page->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectAttribute/sample/sap.m.sample.ObjectAttributeInTable' ).

    page->table( id = `idProductsTable`
           items = client->_bind( lt_a_data )
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
                   text = '{PRODUCT}' )->get_parent(
               )->object_attribute(
                   text = '{SUPPLIER}'
               )->object_attribute(
                   text = '{SUPPLIER}'
                   active = abap_true
           )->get_parent(
          ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'CLICK_HINT_ICON'.
        z2ui5_display_popover( `button_hint_id` ).
      WHEN 'onPress'.
        client->message_toast_display( client->get_event_arg( 1 ) && ` marker pressed!` ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_display_popover.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom` width = `auto`
              )->quick_view_page( pageid = `sampleInformationId`
                                  header = `Sample information`
                                  description = `This is an example of Object Attribute used inside Table.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id
    ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).

      lt_a_data = VALUE #(
        ( product = 'Power Projector 4713'    supplier = 'Robert Brown Entertainment' )
        ( product = 'HT-1022'                 supplier = 'Pear Computing Services' )
        ( product = 'Ergo Screen E-III'       supplier = 'DelBont Industries' )
        ( product = 'Gladiator MX'            supplier = 'Asia High tech' )
        ( product = 'Hurricane GX'            supplier = 'Telecomunicaciones Star' )
        ( product = 'Notebook Basic 17'       supplier = 'Pear Computing Services' )
        ( product = 'ITelO Vault SAT'         supplier = 'New Line Design' )
        ( product = 'Hurricane GX'            supplier = 'Robert Brown Entertainment' )
        ( product = 'Webcam'                  supplier = 'Getränkegroßhandel Janssen' )
        ( product = 'Deskjet Super Highspeed' supplier = 'Vente Et Réparation de Ordinateur' )
      ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
