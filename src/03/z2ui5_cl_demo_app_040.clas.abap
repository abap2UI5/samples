CLASS z2ui5_cl_demo_app_040 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_barcode TYPE string.
    DATA mv_load_lib TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA:
      BEGIN OF app,
        view_main         TYPE string,
        view_popup        TYPE string,
        get               TYPE z2ui5_if_types=>ty_s_get,
      END OF app.

    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_040 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    app-get    = client->get( ).
    app-view_popup = ``.

    IF app-get-event IS NOT INITIAL.
      on_event( ).
    ENDIF.

    view_display( ).

    app-get = VALUE #( ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `LOAD_BC` ).
      client->message_box_display( `JSBarcode Library loaded` ).
      mv_load_lib = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(lv_xml) = `<mvc:View ` && |\n| &&
                          `    xmlns:mvc="sap.ui.core.mvc" displayBlock="true"` && |\n| &&
                          `  xmlns:z2ui5="z2ui5"  xmlns:m="sap.m" xmlns="http://www.w3.org/1999/xhtml"` && |\n| &&
                          `    ><m:Button ` && |\n| &&
                          `  text="back" ` && |\n| &&
                          `  press="` && client->_event_nav_app_leave( ) && `" ` && |\n| &&
                          `  class="sapUiContentPadding sapUiResponsivePadding--content"/> ` && |\n| &&
      `<html><head>` && |\n| &&
                          `</head>` && |\n| &&
                          `<body>` && |\n| &&
                          `<m:Button text="LoadJSBarcode" press="` && client->_event( `LOAD_BC` ) && `" />` && |\n| &&
                          `<m:Input value="` && client->_bind_edit( mv_barcode ) && `" />` && |\n| &&
                         `<m:Button text="Display Barcode" press="` && client->_event( `DISPLAY_BC` ) && `" />` && |\n| &&
                          `<h1>JSBarcode Library</h1>` && |\n| &&
                          `  <svg id="barcode">` && |\n| &&
*                          `  jsbarcode-format="upc"` && |\n|  &&
*                          `  jsbarcode-value="` && mv_barcode && `"` && |\n|  &&
*                          `  jsbarcode-textmargin="0"` && |\n|  &&
*                          `  jsbarcode-fontoptions="bold">` && |\n|  &&
                          `</svg>` && |\n|.

    IF mv_load_lib = abap_true.
      mv_load_lib = abap_false.
      lv_xml = lv_xml && `<script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"> </script>`.

    ENDIF.

    IF mv_barcode IS NOT INITIAL.
      lv_xml = lv_xml && `<script>  $("#" + sap.z2ui5.oView.createId( 'barcode' ) ).JsBarcode("` && mv_barcode && `") </script>`.
    ENDIF.
    lv_xml = lv_xml && `</body>` && |\n| &&
           `</html> ` && |\n| &&
             `</mvc:View>`.

    client->view_display( lv_xml ).

  ENDMETHOD.

ENDCLASS.
