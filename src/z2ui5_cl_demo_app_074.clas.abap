CLASS z2ui5_cl_demo_app_074 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_path TYPE string.
    DATA mv_value TYPE string.
    DATA mr_table TYPE REF TO data.
    DATA mv_check_edit TYPE abap_bool.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS on_event.

    METHODS view_main_display.

    METHODS view_init_display.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_074 IMPLEMENTATION.

  METHOD on_event.

    TRY.

        CASE mo_client->get( )-event.
          WHEN `START` OR `CHANGE`.
            view_main_display( ).
          WHEN `UPLOAD`.

            SPLIT mv_value AT `;` INTO DATA(lv_dummy) DATA(lv_data).
            SPLIT lv_data AT `,` INTO lv_dummy lv_data.

            DATA(lv_data2) = z2ui5_cl_util=>conv_decode_x_base64( lv_data ).
            DATA(lv_ready) = z2ui5_cl_util=>conv_get_string_by_xstring( lv_data2 ).

            mr_table = z2ui5_cl_util=>itab_get_itab_by_csv( lv_ready ).
            mo_client->message_box_display( `CSV loaded to table` ).

            view_main_display( ).

            CLEAR mv_value.
            CLEAR mv_path.
        ENDCASE.

      CATCH cx_root INTO DATA(x).
        mo_client->message_box_display( text = x->get_text( )
                                     type = `error` ).
    ENDTRY.
  ENDMETHOD.

  METHOD view_init_display.

    view_main_display( ).
  ENDMETHOD.

  METHOD view_main_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell( )->page(
            title          = `abap2UI5 - CSV to ABAP internal Table`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).
    FIELD-SYMBOLS <lo_tab> TYPE table.

    IF mr_table IS NOT INITIAL.

      ASSIGN mr_table->* TO <lo_tab>.

      DATA(lo_tab) = lo_page->table(
              items = COND #( WHEN mv_check_edit = abap_true THEN mo_client->_bind_edit( <lo_tab> ) ELSE mo_client->_bind_edit( <lo_tab> ) )
          )->header_toolbar(
              )->overflow_toolbar(
                  )->title( `CSV Content`
                  )->toolbar_spacer(
          )->get_parent( )->get_parent( ).

      DATA(lr_fields) = z2ui5_cl_util=>rtti_get_t_attri_by_any( <lo_tab> ).
      DATA(lo_cols) = lo_tab->columns( ).
      LOOP AT lr_fields REFERENCE INTO DATA(lr_col).
        lo_cols->column( )->text( lr_col->name ).
      ENDLOOP.
      DATA(lo_cells) = lo_tab->items( )->column_list_item( )->cells( ).
      LOOP AT lr_fields REFERENCE INTO lr_col.
        lo_cells->text( `{` && lr_col->name && `}` ).
      ENDLOOP.
    ENDIF.

    DATA(lo_footer) = lo_page->footer( )->overflow_toolbar( ).

    lo_footer->_z2ui5( )->file_uploader(
      value       = mo_client->_bind_edit( mv_value )
      path        = mo_client->_bind_edit( mv_path )
      placeholder = `filepath here...`
      upload      = mo_client->_event( `UPLOAD` ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      view_init_display( ).
      RETURN.
    ENDIF.

    IF mo_client->get( )-check_on_navigated = abap_true.
      view_main_display( ).
    ENDIF.

    on_event( ).
  ENDMETHOD.
ENDCLASS.
