CLASS Z2UI5_CL_DEMO_APP_032 DEFINITION PUBLIC.

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



CLASS Z2UI5_CL_DEMO_APP_032 IMPLEMENTATION.


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

    data(lo_view) = z2ui5_cl_xml_view=>factory( ).

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
                          `<button onclick="myFunction()" type="button">send</button>` && |\n|  &&
                          `<Input id='input' value='frontend data' /> ` &&
                          `<script> function myFunction( ) { sap.z2ui5.oView.getController().onEvent({ 'EVENT' : 'POST', 'METHOD' : 'UPDATE' }, document.getElementById(sap.z2ui5.oView.createId( "input" )).value ) } </script>` && |\n|  &&
                          `</body>` && |\n|  &&
                          `</html> ` && |\n|  &&
                            `</mvc:View>`.

    client->view_display( lv_xml ).

  ENDMETHOD.
ENDCLASS.
