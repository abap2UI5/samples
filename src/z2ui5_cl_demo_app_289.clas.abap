CLASS z2ui5_cl_demo_app_289 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_product,
        product        TYPE string,
        type           TYPE string,
        additionalinfo TYPE string,
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



CLASS z2ui5_cl_demo_app_289 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Object Marker in a table'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( 'CLICK_HINT_ICON' ) ).

    page->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectMarker/sample/sap.m.sample.ObjectMarker' ).

    page->table( id = `idProductsTable`
           items    = client->_bind( lt_a_data )
           )->columns(
               )->column(
                   )->text( text = `Products`
               )->get_parent(
               )->column(
                   )->text( text = `Status`
               )->get_parent(
               )->column(
                   )->text( text = `Status (active)`
               )->get_parent( )->get_parent(
           )->column_list_item(
               )->object_identifier(
                   text = '{PRODUCT}' )->get_parent(
               )->object_marker(
                   type           = '{TYPE}'
                   additionalinfo = '{ADDITIONALINFO}' )->get_parent(
               )->object_marker(
                   type           = '{TYPE}'
                   additionalinfo = '{ADDITIONALINFO}'
                   press          = client->_event( val = `onPress` t_arg = VALUE #( ( `${TYPE}` ) ) ) ).

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
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `The ObjectMarker is a small building block representing an object by an icon or text and icon. Often it is used in a table.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).

      lt_a_data = VALUE #(
        ( product = 'Power Projector 4713'    type = 'Locked' )
        ( product = 'Power Projector 4713'    type = 'LockedBy' additionalinfo = 'John Doe' )
        ( product = 'Power Projector 4713'    type = 'LockedBy' )
        ( product = 'Gladiator MX'            type = 'Draft' )
        ( product = 'Hurricane GX'            type = 'Unsaved' )
        ( product = 'Hurricane GX'            type = 'UnsavedBy' additionalinfo = 'John Doe' )
        ( product = 'Hurricane GX'            type = 'UnsavedBy' )
        ( product = 'Hurricane GX'            type = 'Unsaved' )
        ( product = 'Webcam'                  type = 'Favorite' )
        ( product = 'Deskjet Super Highspeed' type = 'Flagged' ) ).

    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
