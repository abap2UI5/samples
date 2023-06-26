CLASS z2ui5_cl_app_demo_40 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_barcode TYPE string.
    DATA mv_load_lib TYPE abap_bool.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA:
      BEGIN OF app,
        check_initialized TYPE abap_bool,
        view_main         TYPE string,
        view_popup        TYPE string,
        get               TYPE z2ui5_if_client=>ty_s_get,
      END OF app.

    METHODS z2ui5_on_event.
    METHODS z2ui5_on_render.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_APP_DEMO_40 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    app-get    = client->get( ).
    app-view_popup = ``.

    IF app-get-event IS NOT INITIAL.
      z2ui5_on_event( ).
    ENDIF.

    z2ui5_on_render( ).

    CLEAR app-get.

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE app-get-event.

      WHEN 'LOAD_BC'.
        client->message_box_display( 'JSBarcode Library loaded').
        mv_load_lib = abap_true.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( app-get-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_render.

    data(lv_xml) = `<mvc:View controllerName="project1.controller.View1"` && |\n|  &&
                          `    xmlns:mvc="sap.ui.core.mvc" displayBlock="true"` && |\n|  &&
                          `  xmlns:z2ui5="z2ui5"  xmlns:m="sap.m" xmlns="http://www.w3.org/1999/xhtml"` && |\n|  &&
                          `    ><m:Button ` && |\n|  &&
                          `  text="back" ` && |\n|  &&
                          `  press="` && client->_event( 'BACK' ) && `" ` && |\n|  &&
                          `  class="sapUiContentPadding sapUiResponsivePadding--content"/> ` && |\n|  &&
                   `       <m:Link target="_blank" text="Source_Code" href="` && Z2UI5_CL_XML_VIEW=>factory( client )->hlp_get_source_code_url( ) && `"/>` && |\n|  &&

                          `<html><head>` && |\n|  &&
                          `</head>` && |\n|  &&
                          `<body>` && |\n|  &&
                          `<m:Button text="LoadJSBarcode" press="` && client->_event( 'LOAD_BC' ) && `" />` && |\n|  &&
                          `<m:Input value="` && client->_bind( mv_barcode ) && `" />` && |\n|  &&
                         `<m:Button text="Display Barcode" press="` && client->_event( 'DISPLAY_BC' ) && `" />` && |\n|  &&
                          `<h1>JSBarcode Library</h1>` && |\n|  &&
                          `  <svg class="barcode"` && |\n|  &&
                          `  jsbarcode-format="upc"` && |\n|  &&
                          `  jsbarcode-value="` && mv_barcode && `"` && |\n|  &&
                          `  jsbarcode-textmargin="0"` && |\n|  &&
                          `  jsbarcode-fontoptions="bold">` && |\n|  &&
                          `</svg>` && |\n|.
    IF mv_load_lib = abap_true.
      mv_load_lib = abap_false.
      lv_xml = lv_xml && `<script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js"> </script>`.
    ENDIF.

    lv_xml = lv_xml && `<script> JsBarcode(".barcode").init(); </script>` &&
           `</body>` && |\n|  &&
           `</html> ` && |\n|  &&
             `</mvc:View>`.

    client->view_display( z2ui5_cl_xml_view=>factory( client )->hlp_replace_controller_name( lv_xml ) ).

  ENDMETHOD.
ENDCLASS.
