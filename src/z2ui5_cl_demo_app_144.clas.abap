CLASS z2ui5_cl_demo_app_144 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA check_initialized TYPE abap_bool .
    DATA lv_b64 TYPE string .
    DATA lv_filename TYPE string .

    METHODS constructor
      IMPORTING
        b64_image TYPE string
        filename  TYPE string.

  PROTECTED SECTION.

    DATA imagemapster TYPE REF TO z2ui5_cl_cc_imagemapster.
    DATA ls_map_cfg TYPE imagemapster->ty_c.


    METHODS z2ui5_on_rendering
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_on_init.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_144 IMPLEMENTATION.


  METHOD constructor.
    lv_b64 = b64_image.
    lv_filename = filename.
  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).

      client->view_display( z2ui5_cl_xml_view=>factory( client
        )->_z2ui5( )->timer(  client->_event( `START` )
          )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_imagemapster=>load_editor_js( )
          )->stringify( ) ).

    ENDIF.

    z2ui5_on_event( client ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'START'.
        z2ui5_on_rendering( client ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.


  ENDMETHOD.


  METHOD z2ui5_on_rendering.


    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->_generic( ns = `html` name = `style` )->_cc_plain_xml( z2ui5_cl_cc_imagemapster=>load_editor_css( ) ).

    DATA(page) = view->page(
          showheader       = abap_true
            title          = 'abap2UI5 - imagemap editor demo'
            navbuttonpress = client->_event( 'BACK' )
            enablescrolling = abap_false
              shownavbutton = abap_true ).

    page->html( content = z2ui5_cl_cc_imagemapster=>load_editor_html( ) ).

    view->html( content = `<script>` && z2ui5_cl_cc_imagemapster=>load_editor( base64_data_uri = lv_b64 filename = lv_filename ) && `</script>` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
