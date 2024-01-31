CLASS z2ui5_cl_demo_app_118 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA check_initialized TYPE abap_bool .

    METHODS view_main.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_118 IMPLEMENTATION.


  METHOD view_main.


    DATA(view) = z2ui5_cl_xml_view=>factory( ).

*    view->_cc( )->font_awesome( )->load_animation_js( faw_js_url = `https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.2/js/all.min.js` ).
    view->_generic( ns = `html` name = `script` t_prop = value #( ( n = `src` v = `https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.2/js/all.min.js` ) ) ).

    DATA(page) = view->shell( )->page(
            title          = 'abap2UI5 - FontAwsome Fonts'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code'  target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
         )->get_parent( ).

    page->vbox( height = `100%` justifycontent = `Center` alignitems = `Center`
          )->hbox( )->button( text = `text` icon = `sap-icon://fa-brands/xbox`
    )->icon(
        src    = `sap-icon://fa-regular/face-smile`
        size   =  `6rem`
        color  = `red`
        class  = `fa-bounce`
    )->icon(
        size   =  `13rem`
        color  = `black`
        class  = `fa-brands fa-github-square`
        ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      client->view_display( z2ui5_cl_xml_view=>factory(
        )->_z2ui5( )->timer(  client->_event( `START` )
*        )->_cc( )->font_awesome( )->load_icons( font_uri = `https://cdn.jsdelivr.net/gh/choper725/resources/dist/`
        )->_generic( ns = `html` name = `script` )->_cc_plain_xml( Z2UI5_CL_CC_FONT_AWESOME_ICONS=>get_js_icon( `https://cdn.jsdelivr.net/gh/choper725/resources/dist/` )  )->get_parent(
        )->stringify( ) ).


*      client->timer_set( event_finished = client->_event( `START` ) interval_ms = `0` ).

    ENDIF.

    CASE client->get( )-event.
      WHEN 'START'.

        view_main( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
