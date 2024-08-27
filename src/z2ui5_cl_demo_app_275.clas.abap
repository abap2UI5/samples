CLASS z2ui5_cl_demo_app_275 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_fields,
        productid TYPE string,
        name      TYPE string,
      END OF ty_fields .
    TYPES:
      BEGIN OF ty_products,
        productcollection TYPE STANDARD TABLE OF ty_fields WITH EMPTY KEY,
      END OF ty_products .

    DATA lt_products TYPE ty_products.
    DATA omodel LIKE lt_products.
    DATA check_initialized TYPE abap_bool.

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
    METHODS z2ui5_on_init.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_275 IMPLEMENTATION.


  METHOD display_view.

    DATA(page_01) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Title'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page_01->header_content(
       )->button( id = `button_hint_id`
           icon = `sap-icon://hint`
           tooltip = `Sample information`
           press = client->_event( 'CLICK_HINT_ICON' ) ).

    page_01->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Title/sample/sap.m.sample.Title' ).

    DATA(page_02) = page_01->page(
                         enablescrolling = abap_true
                         title = `Page Header Title`
                         titlelevel = `H2`
                         showfooter = abap_false
                         )->list( items = client->_bind( omodel-productcollection )
                             )->header_toolbar(
                                 )->toolbar(
                                     )->title( level = `H3` text = `Products`
                                     )->toolbar_spacer(
                                     )->button( icon = `sap-icon://settings` press = client->_event( `handleButtonPress` ) )->get_parent( )->get_parent(
                             )->standard_list_item( title = '{NAME}' description = '{PRODUCTID}'
                    ).

    client->view_display( page_02->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'CLICK_HINT_ICON'.
        z2ui5_display_popover( `button_hint_id` ).
      WHEN 'handleButtonPress'.
        client->message_toast_display( `Header toolbar button pressed.` ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_display_popover.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom` width = `auto`
              )->quick_view_page( pageid = `sampleInformationId`
                                  header = `Sample information`
                                  description = `The Title control is a simple one line text with additional semantic information about ` &&
                                                `the level of the following section in the page structure for accessibility purposes.` ).

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
      z2ui5_on_init( ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.


  METHOD z2ui5_on_init.

    DATA: lv_url         TYPE string,
          lv_json        TYPE string,
          lo_http_client TYPE REF TO if_http_client,
          lv_response    TYPE string,
          lv_status      TYPE i.

    lv_url = 'https://raw.githubusercontent.com/SAP/openui5/master/src/sap.ui.documentation/test/sap/ui/documentation/sdk/products.json'.

    " Create HTTP client instance
    CALL METHOD cl_http_client=>create_by_url
      EXPORTING
        url    = lv_url
      IMPORTING
        client = lo_http_client
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc <> 0.
      WRITE: / 'Error in creating HTTP client'.
      RETURN.
    ENDIF.

    " Send HTTP GET request
    CALL METHOD lo_http_client->send
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        OTHERS                     = 4.
    IF sy-subrc <> 0.
      WRITE: / 'Error in sending HTTP request'.
      RETURN.
    ENDIF.

    " Receive HTTP response
    CALL METHOD lo_http_client->receive
      EXCEPTIONS
        http_communication_failure = 1
        http_invalid_state         = 2
        http_processing_failed     = 3
        OTHERS                     = 4.
    IF sy-subrc <> 0.
      WRITE: / 'Error in receiving HTTP response'.
      RETURN.
    ENDIF.

    " Get the response body
    lv_response = lo_http_client->response->get_cdata( ).

    " Clean up HTTP client
    lo_http_client->close( ).

    DATA(var_data) = lv_response.

    /ui2/cl_json=>deserialize( EXPORTING json        = var_data
                                         pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                CHANGING data        = omodel
                            ).

  ENDMETHOD.
ENDCLASS.
