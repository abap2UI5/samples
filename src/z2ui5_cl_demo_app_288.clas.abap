CLASS z2ui5_cl_demo_app_288 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_product_collection,
        product_id TYPE string,
        name       TYPE string,
      END OF ty_product_collection.

    DATA check_initialized      TYPE abap_bool.
    DATA editable               TYPE abap_bool.
    DATA enabled                TYPE abap_bool.
    DATA lt_product_collection  TYPE TABLE OF ty_product_collection.
    DATA lt_product_collection2 TYPE TABLE OF ty_product_collection.
    DATA lt_product_collection3 TYPE TABLE OF ty_product_collection.
    DATA selected_product       TYPE string.
    DATA selected_product2      TYPE string.
    DATA selected_product3      TYPE string.

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


CLASS z2ui5_cl_demo_app_288 IMPLEMENTATION.

  METHOD display_view.

    DATA(page_01) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page( title          = `abap2UI5 - Sample: Select`
                  navbuttonpress = client->_event( 'BACK' )
                  shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page_01->header_content(
       )->button( id      = `button_hint_id`
                  icon    = `sap-icon://hint`
                  tooltip = `Sample information`
                  press   = client->_event( 'CLICK_HINT_ICON' ) ).

    page_01->header_content(
       )->link( text   = 'UI5 Demo Kit'
                target = '_blank'
                href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Select/sample/sap.m.sample.Select' ).

    DATA(page_02) = page_01->page( showheader = abap_false
                                   class      = `sapUiContentPadding`
                              )->sub_header(
                                  )->toolbar(
                                      )->toolbar_spacer(
                                      )->select( forceselection = abap_false
                                                 selectedkey    = client->_bind( selected_product )
                                                 items          = client->_bind( lt_product_collection )
                                         )->item( key  = '{PRODUCT_ID}'
                                                  text = '{NAME}'
                                      )->get_parent(
                                  )->get_parent(
                              )->get_parent(
                              )->content(
                                  )->hbox( justifyContent = `SpaceAround`
                                      )->select( enabled        = client->_bind( enabled )
                                                 editable       = client->_bind( editable )
                                                 forceselection = abap_false
                                                 selectedkey    = client->_bind( selected_product2 )
                                                 items          = client->_bind( lt_product_collection2 )
                                            )->item( key  = '{PRODUCT_ID}'
                                                     text = '{NAME}'
                                      )->get_parent(
                                      )->vbox(
                                          )->hbox( alignitems = `Center`
                                              )->label( text  = `Enabled:`
                                                        class = `sapUiTinyMarginEnd`
                                              )->switch( type  = `AcceptReject`
                                                         state = client->_bind( enabled )
                                          )->get_parent(
                                          )->hbox( alignitems = `Center`
                                              )->label( text  = `Editable:`
                                                        class = `sapUiTinyMarginEnd`
                                              )->switch( type  = `AcceptReject`
                                                         state = client->_bind( editable )
                                          )->get_parent(
                                      )->get_parent(
                                  )->get_parent(
                              )->get_parent(
                              )->footer(
                                  )->toolbar(
                                      )->toolbar_spacer(
                                          )->select( forceselection  = abap_false
                                                     selectedkey     = client->_bind( selected_product3 )
                                                     type            = `IconOnly`
                                                     icon            = `sap-icon://filter`
                                                     autoadjustwidth = abap_true
                                                     items           = client->_bind( lt_product_collection3 )
                                              )->item( key  = '{PRODUCT_ID}'
                                                       text = '{NAME}'
                             ).

    client->view_display( page_02->stringify( ) ).

  ENDMETHOD.

  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'CLICK_HINT_ICON'.
        z2ui5_display_popover( `button_hint_id` ).
    ENDCASE.

  ENDMETHOD.

  METHOD z2ui5_display_popover.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page(
                  pageid      = `sampleInformationId`
                  header      = `Sample information`
                  description = `Illustrates the usage of a Select in header, footer and content of a page. Note the different display options.` ).

    client->popover_display( xml   = view->stringify( )
                             by_id = id
    ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).

      selected_product  = `HT-1001`.
      selected_product2 = `HT-1001`.
      selected_product3 = `HT-1001`.

      " Populate the internal tables
      lt_product_collection = VALUE #( ( product_id = 'HT-1000' name = 'Notebook Basic 15' )
                                       ( product_id = 'HT-1001' name = 'Notebook Basic 17' )
                                       ( product_id = 'HT-1002' name = 'Notebook Basic 18' )
                                       ( product_id = 'HT-1003' name = 'Notebook Basic 19' )
                                       ( product_id = 'HT-1007' name = 'ITelO Vault' ) ).
      SORT lt_product_collection BY name.

      lt_product_collection2 = VALUE #( ( product_id = 'HT-1000' name = 'Notebook Basic 15' )
                                        ( product_id = 'HT-1001' name = 'Notebook Basic 17' )
                                        ( product_id = 'HT-1002' name = 'Notebook Basic 18' )
                                        ( product_id = 'HT-1003' name = 'Notebook Basic 19' )
                                        ( product_id = 'HT-1007' name = 'ITelO Vault' ) ).
      SORT lt_product_collection2 BY name.

      lt_product_collection3 = VALUE #( ( product_id = 'HT-1000' name = 'Notebook Basic 15' )
                                        ( product_id = 'HT-1001' name = 'Notebook Basic 17' )
                                        ( product_id = 'HT-1002' name = 'Notebook Basic 18' )
                                        ( product_id = 'HT-1003' name = 'Notebook Basic 19' )
                                        ( product_id = 'HT-1007' name = 'ITelO Vault' ) ).
      SORT lt_product_collection3 BY name.

      editable = abap_true.
      enabled = abap_true.

    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
