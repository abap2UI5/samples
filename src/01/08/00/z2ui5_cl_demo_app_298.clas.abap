"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Select/sample/sap.m.sample.SelectValueState
"! Visualizes the validation state of the control, for example, Error, Warning and Success.
CLASS z2ui5_cl_demo_app_298 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product_collection,
        product_id TYPE string,
        name       TYPE string,
      END OF ty_s_product_collection.
    DATA lt_a_products TYPE TABLE OF ty_s_product_collection.
    DATA selectedproducterrorcollection TYPE string.
    DATA selectedproductwrnngcollection TYPE string.
    DATA selectedproductsccsscollection TYPE string.
    DATA selectedproductinforcollection TYPE string.

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


CLASS z2ui5_cl_demo_app_298 IMPLEMENTATION.

  METHOD view_display.

    DATA page_01 TYPE REF TO z2ui5_cl_xml_view.
    page_01 = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Select - Validation states`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Select/sample/sap.m.sample.SelectValueState` ).

    page_01->page( showheader = abap_false
              )->content(
                  )->hbox( class = `sapUiMediumMarginBottom`
                      )->label( text = `Error state`
                          labelfor   = `errorSelect`
                          class      = `sapUiTinyMarginEnd sapUiTinyMarginTop`
                      )->select(
                          id             = `errorSelect`
                          forceselection = abap_true
                          selectedkey    = client->_bind( selectedproducterrorcollection )
                          valuestate     = `Error`
                          valuestatetext = `error value state text`
                          items          = client->_bind( lt_a_products )
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
                          selectedkey    = client->_bind( selectedproductwrnngcollection )
                          valuestate     = `Warning`
                          valuestatetext = `This is a Level 1 explanation. The items Lorem and Ipsum are not recommended from the system.`
                          items          = client->_bind( lt_a_products )
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
                          selectedkey    = client->_bind( selectedproductsccsscollection )
                          valuestate     = `Success`
                          valuestatetext = `success value state text`
                          items          = client->_bind( lt_a_products )
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
                          selectedkey    = client->_bind( selectedproductinforcollection )
                          valuestate     = `Information`
                          valuestatetext = `information value state text`
                          items          = client->_bind( lt_a_products )
                          )->item( key  = `{PRODUCT_ID}`
                                   text = `{NAME}`
                      )->get_parent(
                  )->get_parent(
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
                                  description = `Visualizes the validation state of the control, for example, Error, Warning and Success.` ).

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

    DATA temp1 TYPE string.
    DATA temp2 TYPE string.
    DATA temp3 TYPE string.
    DATA temp4 TYPE string.
    DATA temp5 LIKE lt_a_products.
    DATA temp6 LIKE lt_a_products.
    DATA temp7 LIKE LINE OF temp6.
    CLEAR temp1.
    selectedproducterrorcollection = temp1.
    
    CLEAR temp2.
    selectedproductwrnngcollection = temp2.
    
    CLEAR temp3.
    selectedproductsccsscollection = temp3.
    
    CLEAR temp4.
    selectedproductinforcollection = temp4.
    
    CLEAR temp5.
    lt_a_products                  = temp5.

    selectedproducterrorcollection  = `HT-998`.
    selectedproductwrnngcollection  = `HT-999`.
    selectedproductsccsscollection  = `HT-1000`.
    selectedproductinforcollection  = `HT-1007`.

    " Populate the internal table
    
    CLEAR temp6.
    
    temp7-product_id = `HT-998`.
    temp7-name = `Notebook Basic 11`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-999`.
    temp7-name = `Notebook Basic 13`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-1000`.
    temp7-name = `Notebook Basic 15`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-1001`.
    temp7-name = `Notebook Basic 17`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-1002`.
    temp7-name = `Notebook Basic 18`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-1003`.
    temp7-name = `Notebook Basic 19`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-1007`.
    temp7-name = `ITelO Vault`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-1008`.
    temp7-name = `Notebook Professional 11`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-1009`.
    temp7-name = `Notebook Professional 13`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-1010`.
    temp7-name = `Notebook Professional 15`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-1011`.
    temp7-name = `Notebook Professional 17`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-1012`.
    temp7-name = `Notebook Professional 19`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-1020`.
    temp7-name = `ITelO Vault Net`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-1021`.
    temp7-name = `ITelO Vault SAT`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-1022`.
    temp7-name = `Comfort Easy`.
    INSERT temp7 INTO TABLE temp6.
    temp7-product_id = `HT-1023`.
    temp7-name = `Comfort Senior`.
    INSERT temp7 INTO TABLE temp6.
    lt_a_products = temp6.
    SORT lt_a_products BY name.

  ENDMETHOD.

ENDCLASS.
