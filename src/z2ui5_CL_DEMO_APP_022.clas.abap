CLASS z2ui5_cl_demo_app_022 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        title TYPE string,
        value TYPE string,
        descr TYPE string,
        info  TYPE string,
      END OF ty_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA mv_value1 TYPE string.
    DATA mv_value2 TYPE string.
    DATA mv_value3 TYPE string.

    DATA:
      BEGIN OF app,
        client            TYPE REF TO z2ui5_if_client,
        check_initialized TYPE abap_bool,
        s_get             TYPE z2ui5_if_client=>ty_s_get,
      END OF app.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS z2ui5_cl_demo_app_022 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    app-client     = client.
    app-s_get      = client->get( ).

    IF app-check_initialized = abap_false.
      app-check_initialized = abap_true.

      DATA(ls_row) = VALUE ty_row( title = 'Peter'  value = 'red' info = 'completed'  descr = 'this is a description' ).
      DO 100 TIMES.
        INSERT ls_row INTO TABLE t_tab.
      ENDDO.

        client->scroll_position_set( VALUE #(
               ( n = 'id_page'  )
               ( n = 'id_text3'  )
             ) ).

      DATA(view) = z2ui5_cl_xml_view=>factory( client )->shell( ).
      DATA(page) = view->page(
          id = 'id_page'
          title = 'abap2ui5 - Scrolling (use Chrome to avoid incompatibilities)'
          navbuttonpress = client->_event( 'BACK' )
          shownavbutton = abap_true
          ).

      page->header_content( )->link( text = 'Source_Code' target = '_blank' href = view->hlp_get_source_code_url( ) ).

      DATA(tab) = page->table( sticky = 'ColumnHeaders,HeaderToolbar' headertext = 'Table with some entries' items = client->_bind( t_tab ) ).

      tab->columns(
          )->column( )->text( 'Title' )->get_parent(
          )->column( )->text( 'Color' )->get_parent(
          )->column( )->text( 'Info' )->get_parent(
          )->column( )->text( 'Description' ).

      tab->items( )->column_list_item( )->cells(
         )->text( '{TITLE}'
         )->text( '{VALUE}'
         )->text( '{INFO}'
        )->text( '{DESCR}' ).

      page->footer( )->overflow_toolbar(
           )->button( text = 'Scroll Top'     press = client->_event( 'BUTTON_SCROLL_TOP' )
           )->button( text = 'Scroll 500 up'   press = client->_event( 'BUTTON_SCROLL_UP' )
           )->button( text = 'Scroll 500 down' press = client->_event( 'BUTTON_SCROLL_DOWN' )
           )->button( text = 'Scroll Bottom'   press = client->_event( 'BUTTON_SCROLL_BOTTOM' )
           )->toolbar_spacer(
           )->button( text = 'Server Event and hold position' press = client->_event( 'BUTTON_SCROLL_HOLD' )
         ).

      client->view_display( view->stringify( ) ).
      RETURN.
    ENDIF.

    client->message_toast_display( 'server roundtrip' ).
    CASE client->get( )-event.

      WHEN 'BUTTON_SCROLL_TOP'.
        client->scroll_position_set( VALUE #( ( n = 'id_page' v = '0' ) ) ).

      WHEN 'BUTTON_SCROLL_BOTTOM'.
        client->scroll_position_set( VALUE #( ( n = 'id_page' v = '99999' ) ) ).

      WHEN 'BUTTON_SCROLL_UP'.
        DATA(lv_pos) = CONV i( app-s_get-t_scroll_pos[ n = `id_page` ]-v ) - 500.
        if lv_pos < 0.
        lv_pos = 0.
        endif.
        client->scroll_position_set(  VALUE #( (  n = 'id_page'  v = lv_pos ) ) ).

      WHEN 'BUTTON_SCROLL_DOWN'.
        lv_pos = CONV i( VALUE #( app-s_get-t_scroll_pos[ n = `id_page` ]-v OPTIONAL ) ) + 500.
        client->scroll_position_set(  VALUE #( (  n = 'id_page'  v = lv_pos ) ) ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
