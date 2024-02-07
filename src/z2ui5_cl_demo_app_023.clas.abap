CLASS z2ui5_cl_demo_app_023 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE string.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA:
      BEGIN OF app,
        check_initialized TYPE abap_bool,
        view_main         TYPE string,
        view_popup        TYPE string,
        s_get             TYPE z2ui5_if_types=>ty_s_get,
      END OF app.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_render_main.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_023 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    app-s_get  = client->get( ).

    IF app-check_initialized = abap_false.
      app-check_initialized = abap_true.
      z2ui5_on_init( ).
    ENDIF.

    IF app-s_get-event IS NOT INITIAL.
      z2ui5_on_event( ).
    ENDIF.

    z2ui5_on_render_main( ).

    CLEAR app-s_get.

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE app-s_get-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( app-s_get-s_draft-id_prev_app_stack ) ).

      WHEN OTHERS.
        app-view_main = app-s_get-event.

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    product  = 'tomato'.
    quantity = '500'.
    app-view_main = 'NORMAL'.

  ENDMETHOD.


  METHOD z2ui5_on_render_main.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    CASE app-view_main.

      WHEN 'XML'.

        DATA(lv_xml) = `<mvc:View displayBlock="true" height="100%" xmlns:core="sap.ui.core" xmlns:l="sap.ui.layout" xmlns:html="http://www.w3.org/1999/xhtml" xmlns:f="sap.ui.layout.form" xmlns:mvc="sap.ui.co` &&
    `re.mvc" xmlns:editor="sap.ui.codeeditor" xmlns:ui="sap.ui.table" xmlns="sap.m" xmlns:uxap="sap.uxap" xmlns:mchart="sap.suite.ui.microchart" xmlns:z2ui5="z2ui5" xmlns:webc="sap.ui.webc.main" xmlns:text="sap.ui.richtexteditor" > <Shell> <Page ` && |\n|
    &&
                              `  title="abap2UI5 - XML XML XML" ` && |\n|  &&
                              `  showNavButton="true" ` && |\n|  &&
                              `  navButtonPress="` &&  client->_event( 'BACK' ) && `" ` && |\n|  &&
                              ` > <headerContent ` && |\n|  &&
                              ` > <Link ` && |\n|  &&
                              `  text="Source_Code" ` && |\n|  &&
                              `  target="_blank" ` && |\n|  &&
                              `  href="&lt;system&gt;sap/bc/adt/oo/classes/Z2UI5_CL_DEMO_APP_023/source/main" ` && |\n|  &&
                              ` /></headerContent> <f:SimpleForm ` && |\n|  &&
                              `  title="Form Title" ` && |\n|  &&
                              ` > <f:content ` && |\n|  &&
                              ` > <Title ` && |\n|  &&
                              `  text="Input" ` && |\n|  &&
                              ` /> <Label ` && |\n|  &&
                              `  text="quantity" ` && |\n|  &&
                              ` /> <Input ` && |\n|  &&
                              `  value="` &&  client->_bind( quantity ) && `" ` && |\n|  &&
                              ` /> <Button ` && |\n|  &&
                              `  press="` &&  client->_event( 'NORMAL' ) && `"`  && |\n|  &&
                              `  text="NORMAL" ` && |\n|  &&
                              ` /> <Button ` && |\n|  &&
                                  `  press="` &&  client->_event( 'GENERIC' ) && `"`  && |\n|  &&
                              `  text="GENERIC" ` && |\n|  &&
                              ` /> <Button ` && |\n|  &&
                                 `  press="` &&  client->_event( 'XML' ) && `"`  && |\n|  &&
                              `  text="XML" ` && |\n|  &&
                              ` /></f:content></f:SimpleForm></Page></Shell></mvc:View>`.

        client->view_display( lv_xml ).

      WHEN 'NORMAL'.

        DATA(lv_view_normal_xml) = z2ui5_cl_ui5=>_factory( )->_ns_m(
            )->page(
                    title          = 'abap2UI5 - NORMAL NORMAL NORMAL'
                    navbuttonpress = client->_event( 'BACK' )
                    shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
                )->headercontent(
                    )->link(
                        text = 'Source_Code'
                        href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code(  )
                        target = '_blank'
                )->_go_up( )->_ns_ui(
                )->simpleform( 'Form Title'
                    )->content( )->_ns_m(
                        )->title( 'Input'
                        )->label( 'quantity'
                        )->input( client->_bind( quantity )
                        )->button(
                            text  = 'NORMAL'
                            press = client->_event( 'NORMAL' )
                        )->button(
                            text  = 'GENERIC'
                            press = client->_event( 'GENERIC' )
                        )->button(
                            text  = 'XML'
                            press = client->_event( 'XML' )
                 )->_stringify( ).

        client->view_display( lv_view_normal_xml ).

      WHEN 'GENERIC'.

        DATA(lv_view_gen_xml) = z2ui5_cl_ui5=>_factory(
           )->_add(
                n   = 'Shell'
                ns  = `sap.m`
           )->_add(
                n   = `Page`
                ns  = `sap.m`
                t_p = VALUE #(
                        ( n = `title`          v = 'abap2UI5 - GENERIC GENERIC GENERIC' )
                        ( n = `showNavButton`  v = `true` )
                        ( n = `navButtonPress` v = client->_event( 'BACK' ) ) )
           )->_add(
                n   = `SimpleForm`
                ns  = `sap.ui.layout.form`
                t_p = VALUE #( ( n = `title` v = 'title' ) )
           )->_add(
                n  = `content`
                ns = `sap.ui.layout.form`
           )->_add(
                n   = `Label`
                ns  = `sap.m`
                t_p = VALUE #( ( n = `text` v = 'quantity' ) ) )->_go_up(
           )->_add(
                n   = `Input`
                ns  = `sap.m`
                t_p = VALUE #( ( n = `value` v = client->_bind( quantity ) ) ) )->_go_up(
           )->_add(
                n   = `Button`
                ns  = `sap.m`
                t_p = VALUE #(
                        ( n = `text`  v = `NORMAL` )
                        ( n = `press` v = client->_event( 'NORMAL' ) ) ) )->_go_up(
           )->_add(
                n   = `Button`
                ns  = `sap.m`
                t_p = VALUE #(
                        ( n = `text`  v = `GENERIC` )
                        ( n = `press` v = client->_event( 'GENERIC' ) ) ) )->_go_up(
           )->_add(
                n = `Button`
                ns  = `sap.m`
                t_p = VALUE #(
                        ( n = `text`  v = `XML` )
                        ( n = `press` v = client->_event( 'XML' ) ) )
           )->_stringify( ).

        client->view_display( lv_view_gen_xml ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
