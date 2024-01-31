class Z2UI5_CL_DEMO_APP_145 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  data LV_B64 type STRING .
  data LV_FILENAME type STRING .

  methods CONSTRUCTOR
    importing
      !B64_IMAGE type STRING
      !FILENAME type STRING .
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



CLASS Z2UI5_CL_DEMO_APP_145 IMPLEMENTATION.


  METHOD CONSTRUCTOR.
    lv_b64 = b64_image.
    lv_filename = filename.
  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).

      client->view_display( z2ui5_cl_xml_view=>factory(
        )->_z2ui5( )->timer(  client->_event( `START` )
          )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_imagemapster=>load_editor_js( )
          )->stringify( ) ).

    ENDIF.

    z2ui5_on_event( client ).

  ENDMETHOD.


  METHOD Z2UI5_ON_EVENT.

    CASE client->get( )-event.
      WHEN 'START'.
        z2ui5_on_rendering( client ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_ON_INIT.


  ENDMETHOD.


  METHOD Z2UI5_ON_RENDERING.


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
