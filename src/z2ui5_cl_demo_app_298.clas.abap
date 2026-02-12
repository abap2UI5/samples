CLASS z2ui5_cl_demo_app_298 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_product_collection,
        product_id TYPE string,
        name       TYPE string,
      END OF ty_product_collection.

    DATA lt_a_products TYPE TABLE OF ty_product_collection.
    DATA mv_selectedproducterrorcollection TYPE string.
    DATA mv_selectedproductwrnngcollection TYPE string.
    DATA mv_selectedproductsccsscollection TYPE string.
    DATA mv_selectedproductinforcollection TYPE string.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS set_data.
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

CLASS z2ui5_cl_demo_app_298 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page_01) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Select - Validation states`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page_01->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `CLICK_HINT_ICON` ) ).

    lo_page_01->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Select/sample/sap.m.sample.SelectValueState` ).

    lo_page_01->page( showheader = abap_false
              )->content(
                  )->hbox( class = `sapUiMediumMarginBottom`
                      )->label( text = `Error state`
                          labelfor   = `errorSelect`
                          class      = `sapUiTinyMarginEnd sapUiTinyMarginTop`
                      )->select(
                          id             = `errorSelect`
                          forceselection = abap_true
                          selectedkey    = mo_client->_bind( mv_selectedproducterrorcollection )
                          valuestate     = `Error`
                          valuestatetext = `error value state text`
                          items          = mo_client->_bind( lt_a_products )
                          )->item( key  = `{PRODUCT_ID}`
                                   text = `{NAME}`
                      )->get_parent(
                  )->get_parent(
                  )->hbox( class = `sapUiMediumMarginBottom`
                      )->label( text = `Warning state`
                          labelfor   = `warningSelect`
                          class      = `sapUiTinyMarginEnd sapUiTinyMarginTop`
                      )->select(
                          id             = `warningSelect`
                          forceselection = abap_true
                          selectedkey    = mo_client->_bind( mv_selectedproductwrnngcollection )
                          valuestate     = `Warning`
                          valuestatetext = `This is a Level 1 explanation. The items Lorem and Ipsum are not recommended from the system.`
                          items          = mo_client->_bind( lt_a_products )
                          )->item( key  = `{PRODUCT_ID}`
                                   text = `{NAME}`
                      )->get_parent(
                  )->get_parent(
                  )->hbox( class = `sapUiMediumMarginBottom`
                      )->label( text = `Success state`
                          labelfor   = `successSelect`
                          class      = `sapUiTinyMarginEnd sapUiTinyMarginTop`
                      )->select(
                          id             = `successSelect`
                          forceselection = abap_true
                          selectedkey    = mo_client->_bind( mv_selectedproductsccsscollection )
                          valuestate     = `Success`
                          valuestatetext = `success value state text`
                          items          = mo_client->_bind( lt_a_products )
                          )->item( key  = `{PRODUCT_ID}`
                                   text = `{NAME}`
                      )->get_parent(
                  )->get_parent(
                  )->hbox( class = `sapUiMediumMarginBottom`
                      )->label( text = `Information state`
                          labelfor   = `informationSelect`
                          class      = `sapUiTinyMarginEnd sapUiTinyMarginTop`
                      )->select(
                          id             = `informationSelect`
                          forceselection = abap_true
                          selectedkey    = mo_client->_bind( mv_selectedproductinforcollection )
                          valuestate     = `Information`
                          valuestatetext = `information value state text`
                          items          = mo_client->_bind( lt_a_products )
                          )->item( key  = `{PRODUCT_ID}`
                                   text = `{NAME}`
                      )->get_parent(
                  )->get_parent(
              )->get_parent( ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `CLICK_HINT_ICON` ).
      display_popover( `button_hint_id` ).
    ENDIF.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Visualizes the validation state of the control, for example, Error, Warning and Success.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).
      set_data( ).
    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.

  METHOD set_data.

    CLEAR mv_selectedproducterrorcollection.
    CLEAR mv_selectedproductwrnngcollection.
    CLEAR mv_selectedproductsccsscollection.
    CLEAR mv_selectedproductinforcollection.
    CLEAR lt_a_products.

    mv_selectedproducterrorcollection  = `HT-998`.
    mv_selectedproductwrnngcollection  = `HT-999`.
    mv_selectedproductsccsscollection  = `HT-1000`.
    mv_selectedproductinforcollection  = `HT-1007`.

    " Populate the internal table
    lt_a_products = VALUE #(
      ( product_id = `HT-998`  name = `Notebook Basic 11` )
      ( product_id = `HT-999`  name = `Notebook Basic 13` )
      ( product_id = `HT-1000` name = `Notebook Basic 15` )
      ( product_id = `HT-1001` name = `Notebook Basic 17` )
      ( product_id = `HT-1002` name = `Notebook Basic 18` )
      ( product_id = `HT-1003` name = `Notebook Basic 19` )
      ( product_id = `HT-1007` name = `ITelO Vault` )
      ( product_id = `HT-1008` name = `Notebook Professional 11` )
      ( product_id = `HT-1009` name = `Notebook Professional 13` )
      ( product_id = `HT-1010` name = `Notebook Professional 15` )
      ( product_id = `HT-1011` name = `Notebook Professional 17` )
      ( product_id = `HT-1012` name = `Notebook Professional 19` )
      ( product_id = `HT-1020` name = `ITelO Vault Net` )
      ( product_id = `HT-1021` name = `ITelO Vault SAT` )
      ( product_id = `HT-1022` name = `Comfort Easy` )
      ( product_id = `HT-1023` name = `Comfort Senior` ) ).
    SORT lt_a_products BY name.
  ENDMETHOD.
ENDCLASS.
