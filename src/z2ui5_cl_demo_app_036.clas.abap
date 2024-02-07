CLASS Z2UI5_CL_DEMO_APP_036 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    DATA mv_value TYPE string.

  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.
    DATA:
      BEGIN OF app,
        check_initialized TYPE abap_bool,
        view_main         TYPE string,
        view_popup        TYPE string,
        get               TYPE z2ui5_if_types=>ty_s_get,
      END OF app.

    METHODS Z2UI5_on_init.
    METHODS Z2UI5_on_event.
    METHODS Z2UI5_on_render.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_036 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    me->client = client.
    app-get      = client->get( ).
    app-view_popup = ``.

    IF app-check_initialized = abap_false.
      app-check_initialized = abap_true.
      Z2UI5_on_init( ).
    ENDIF.

    IF app-get-event IS NOT INITIAL.
      Z2UI5_on_event( ).
    ENDIF.

    Z2UI5_on_render( ).

    CLEAR app-get.

  ENDMETHOD.


  METHOD Z2UI5_on_event.

    CASE app-get-event.

      WHEN 'POST'.
        client->message_toast_display( app-get-t_event_arg[ 1 ] ).

      WHEN 'MYCC'.
        client->message_toast_display( 'MYCC event ' && mv_value ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( app-get-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_on_init.

    app-view_main = 'VIEW_MAIN'.
    mv_value = 'test'.

  ENDMETHOD.


  METHOD Z2UI5_on_render.

    data(view) = z2ui5_cl_xml_view=>factory( ).
    data(lv_xml) = `<mvc:View` && |\n|  &&
                          `    xmlns:mvc="sap.ui.core.mvc" displayBlock="true"` && |\n|  &&
                          `  xmlns:z2ui5="z2ui5"  xmlns:m="sap.m" xmlns="http://www.w3.org/1999/xhtml"` && |\n|  &&
                          `    ><m:Button ` && |\n|  &&
                          `  text="back" ` && |\n|  &&
                          `  press="` && client->_event( 'BACK' ) && `" ` && |\n|  &&
                          `  class="sapUiContentPadding sapUiResponsivePadding--content"/> ` && |\n|  &&
                   `       <m:Link target="_blank" text="Source_Code" href="` && z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( ) && `"/>` && |\n|  &&
                          `<html><head><style>` && |\n|  &&
                          `body {background-color: powderblue;}` && |\n|  &&
                          `h1   {color: blue;}` && |\n|  &&
                          `p    {color: red;}` && |\n|  &&
                          `</style>` &&
                          `</head>` && |\n|  &&
                          `<body>` && |\n|  &&
                          `<h1>This is a heading with css</h1>` && |\n|  &&
                          `<p>This is a paragraph with css.</p>` && |\n|  &&
                          `<h1>My First JavaScript</h1>` && |\n|  &&
                          `<button type="button" onclick="myFunction()">` && |\n|  &&
                          `run javascript code sent from the backend.</button>` && |\n|  &&
                           `<button type="button" onclick="myFunction2()">sent data to backend and come back</button>` && |\n|  &&
                          `<Input id='input' value='frontend data' /><h1>This is SVG</h1><p id="demo"></p><svg id="svg" version="1.1"` && |\n|  &&
                          `       baseProfile="full"` && |\n|  &&
                          `       width="500" height="500"` && |\n|  &&
                          `       xmlns="http://www.w3.org/2000/svg">` && |\n|  &&
                          `    <rect width="100%" height="100%" />` && |\n|  &&
                          `    <circle id="circle" cx="100" cy="100" r="80" />` && |\n|  &&
                          `  </svg>` && |\n|  &&
                          `<div>X: <input id="sliderX" type="range" min="1" max="500" value="100" /></div><h1>This is canvas</h1><canvas id="canvas" width="500" height="300"></canvas>` && |\n|  &&
                          `<script> debugger; var canvas = document.getElementById(sap.z2ui5.oView.createId( 'canvas' ));` && |\n|  &&
                          `  if (canvas.getContext){` && |\n|  &&
                          `let context = canvas.getContext('2d');` && |\n|  &&
                          `context.fillStyle = 'rgb(200,0,0)';` && |\n|  &&
                          `context.fillRect (10, 10, 80, 80);` && |\n|  &&
                          `context.fillStyle = 'rgba(0, 0, 200, 0.5)';` && |\n|  &&
                          `context.fillRect (100, 10, 80, 80);` && |\n|  &&
                          `context.strokeStyle = 'rgb(200,0,0)';` && |\n|  &&
                          `context.strokeRect (190, 10, 80, 80);` && |\n|  &&
                          `context.strokeStyle = 'rgba(0, 0, 200, 0.5)';` && |\n|  &&
                          `    context.strokeRect (280, 10, 80, 80);` && |\n|  &&
                          `    context.fillStyle = 'rgb(200,0,0)';` && |\n|  &&
                          `    context.fillRect (370, 10, 80, 80);` && |\n|  &&
                          `    context.clearRect (380, 20, 60, 20);` && |\n|  &&
                          `    context.fillRect (390, 25, 10, 10);` && |\n|  &&
                          `    context.fillRect (420, 25, 10, 10);` && |\n|  &&
                          `    context.clearRect (385, 60, 50, 10); }  ` && |\n|  &&
                          ` function myFunction( ) { alert( 'button pressed' ) }` && |\n|  &&
                          ` function myFunction2( ) { sap.z2ui5.oView.getController().onEvent({ 'EVENT' : 'POST', 'METHOD' : 'UPDATE' }, ` && ' document.getElementById(sap.z2ui5.oView.createId( "input" )).value ' && ` ) }` && |\n|  &&
                                                                    `</script> <script src="https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/barcodes/JsBarcode.code128.min.js"> </script>` &&
*                                                    ` <z2ui5:MyCC change=" ` && client->_event( 'MYCC' ) && `"  value="` && client->_bind( mv_value ) && `"/>` && |\n|  &&

                          `</body>` && |\n|  &&
                          `</html> ` && |\n|  &&
                            `</mvc:View>`.

    client->view_display( lv_xml ).

  ENDMETHOD.
ENDCLASS.
