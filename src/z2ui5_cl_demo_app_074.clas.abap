CLASS z2ui5_cl_demo_app_074 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_path TYPE string.
    DATA mv_value TYPE string.
    DATA mr_table TYPE REF TO data.
    DATA mv_check_edit TYPE abap_bool.
    DATA mv_check_download TYPE abap_bool.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS ui5_on_event.

    METHODS ui5_view_main_display.

    METHODS ui5_view_init_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_074 IMPLEMENTATION.


  METHOD ui5_on_event.
    TRY.

        CASE client->get( )-event.

          WHEN 'START' OR 'CHANGE'.
            ui5_view_main_display( ).

          WHEN 'UPLOAD'.

            SPLIT mv_value AT `;` INTO DATA(lv_dummy) DATA(lv_data).
            SPLIT lv_data AT `,` INTO lv_dummy lv_data.

            DATA(lv_data2) = z2ui5_cl_util=>conv_decode_x_base64( lv_data ).
            DATA(lv_ready) = z2ui5_cl_util=>conv_get_string_by_xstring( lv_data2 ).

            mr_table = z2ui5_cl_util=>itab_get_itab_by_csv( lv_ready ).
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


  METHOD ui5_view_init_display.

       ui5_view_main_display( ).

*    client->view_display( z2ui5_cl_xml_view=>factory( client
*         )->_z2ui5( )->timer( client->_event( `START` )
*         )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_file_uploader=>get_js( )
*         )->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_view_main_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell( )->page(
            title          = 'abap2UI5 - CSV to ABAP internal Table'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
        )->header_content(
            )->toolbar_spacer(
            )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->get_parent( ).

    IF mr_table IS NOT INITIAL.

      FIELD-SYMBOLS <tab> TYPE table.
      ASSIGN mr_table->* TO <tab>.

      DATA(tab) = page->table(
              items = COND #( WHEN mv_check_edit = abap_true THEN client->_bind_edit( <tab> ) ELSE client->_bind_edit( <tab> ) )
          )->header_toolbar(
              )->overflow_toolbar(
                  )->title( 'CSV Content'
                  )->toolbar_spacer(
          )->get_parent( )->get_parent( ).


      DATA(lr_fields) = z2ui5_cl_util=>rtti_get_t_attri_by_struc( <tab> ).
      DATA(lo_cols) = tab->columns( ).
      LOOP AT lr_fields REFERENCE INTO DATA(lr_col).
        lo_cols->column( )->text( lr_col->name ).
      ENDLOOP.
      DATA(lo_cells) = tab->items( )->column_list_item( )->cells( ).
      LOOP AT lr_fields REFERENCE INTO lr_col.
        lo_cells->text( `{` && lr_col->name && `}` ).
      ENDLOOP.
    ENDIF.

    DATA(footer) = page->footer( )->overflow_toolbar( ).

    footer->_z2ui5( )->file_uploader(
      value       = client->_bind_edit( mv_value )
      path        = client->_bind_edit( mv_path )
      placeholder = 'filepath here...'
      upload      = client->_event( 'UPLOAD' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      ui5_view_init_display( ).
      RETURN.
    ENDIF.

    IF client->get( )-check_on_navigated = abap_true.
      ui5_view_main_display( ).
    ENDIF.

    ui5_on_event( ).

  ENDMETHOD.
ENDCLASS.
