CLASS Z2UI5_CL_DEMO_APP_075 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    DATA mv_path TYPE string.
    DATA mv_value TYPE string.
    DATA mr_table TYPE REF TO data.
    DATA mv_check_edit TYPE abap_bool.
    DATA mv_check_download TYPE abap_bool.

    DATA mv_file TYPE string.

  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS ui5_on_init.
    METHODS ui5_on_event.

    METHODS ui5_view_main_display.

    METHODS ui5_view_init_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_075 IMPLEMENTATION.


  METHOD ui5_on_event.
    TRY.

        CASE client->get( )-event.

          WHEN 'START' OR 'CHANGE'.
            ui5_view_main_display( ).

          WHEN 'UPLOAD'.

            SPLIT mv_value AT `;` INTO DATA(lv_dummy) DATA(lv_data).
            SPLIT lv_data AT `,` INTO lv_dummy lv_data.

            DATA(lv_data2) = z2ui5_cl_util=>conv_decode_x_base64( lv_data ).
            mv_file = z2ui5_cl_util=>conv_get_string_by_xstring( lv_data2 ).

            client->message_box_display( `CSV loaded to table` ).

            ui5_view_main_display( ).

            CLEAR mv_value.
            CLEAR mv_path.

          WHEN 'BACK'.
            client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

        ENDCASE.

      CATCH cx_root INTO DATA(x).
        client->message_box_display( text = x->get_text( ) type = `error` ).
    ENDTRY.

  ENDMETHOD.


  METHOD ui5_on_init.

    ui5_view_init_display( ).

  ENDMETHOD.


  METHOD ui5_view_init_display.

      ui5_view_main_display( ).

*    client->view_display( Z2UI5_cl_xml_view=>factory( client
*         )->_z2ui5( )->timer(  client->_event( `START` )
*         )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_file_uploader=>get_js( )
*         )->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_view_main_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell( )->page(
            title          = 'abap2UI5 - Upload Files'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
        )->header_content(
            )->toolbar_spacer(
            )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->get_parent( ).

    IF mv_file IS NOT INITIAL.

      page->code_editor(
          value    = client->_bind( mv_file )
          editable = abap_false
      ).

    ENDIF.

    DATA(footer) = page->footer( )->overflow_toolbar( ).

    footer->_z2ui5( )->file_uploader(
      value       = client->_bind_edit( mv_value )
      path        = client->_bind_edit( mv_path )
      placeholder = 'filepath here...'
      upload      = client->_event( 'UPLOAD' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      ui5_on_init( ).
      RETURN.
    ENDIF.

    IF client->get( )-check_on_navigated = abap_true.
      ui5_view_main_display( ).
    ENDIF.

    ui5_on_event( ).

  ENDMETHOD.
ENDCLASS.
