CLASS z2ui5_cl_demo_app_075 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_path TYPE string.
    DATA mv_value TYPE string.
    DATA mr_table TYPE REF TO data.
    DATA mv_check_edit TYPE abap_bool.
    DATA mv_check_download TYPE abap_bool.

    DATA mv_file TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_075 IMPLEMENTATION.

  METHOD on_event.

    TRY.

        CASE client->get( )-event.

          WHEN `START` OR `CHANGE`.
            view_display( ).

          WHEN `UPLOAD`.

            SPLIT mv_value AT `;` INTO DATA(lv_dummy) DATA(lv_data).
            SPLIT lv_data AT `,` INTO lv_dummy lv_data.

            DATA(lv_data2) = z2ui5_cl_util=>conv_decode_x_base64( lv_data ).
            mv_file = z2ui5_cl_util=>conv_get_string_by_xstring( lv_data2 ).

            client->message_box_display( `CSV loaded to table` ).

            view_display( ).

            mv_value = VALUE #( ).
            mv_path = VALUE #( ).
        ENDCASE.

      CATCH cx_root INTO DATA(x).
        client->message_box_display( text = x->get_text( )
                                     type = `error` ).
    ENDTRY.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell( )->page(
            title          = `abap2UI5 - Upload Files`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    IF mv_file IS NOT INITIAL.

      page->code_editor(
          value    = client->_bind( mv_file )
          editable = abap_false ).

    ENDIF.

    DATA(footer) = page->footer( )->overflow_toolbar( ).

    footer->_z2ui5( )->file_uploader(
      value       = client->_bind_edit( mv_value )
      path        = client->_bind_edit( mv_path )
      placeholder = `filepath here...`
*      enabled     = abap_false
      upload      = client->_event( `UPLOAD` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).
      RETURN.
    ENDIF.

    IF client->get( )-check_on_navigated = abap_true.
      view_display( ).
    ENDIF.

    on_event( ).

  ENDMETHOD.

ENDCLASS.
