CLASS z2ui5_cl_demo_app_134 DEFINITION PUBLIC.

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

    DATA check_initialized TYPE abap_bool.
    DATA field_01  TYPE string.
    DATA field_02 TYPE string.
    DATA focus_id TYPE string.
    DATA selstart TYPE string.
    DATA selend TYPE string.
    DATA update_focus TYPE abap_bool.

  PROTECTED SECTION.
    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS init
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_134 IMPLEMENTATION.


  METHOD display_view.

  DATA(ls_row) = VALUE ty_row( title = 'Peter'  value = 'red' info = 'completed'  descr = 'this is a description' ).
      DO 100 TIMES.
        INSERT ls_row INTO TABLE t_tab.
      ENDDO.

        client->scroll_position_set( VALUE #(
               ( n = 'id_page'  )
               ( n = 'id_text3'  )
             ) ).

      DATA(view) = z2ui5_cl_xml_view=>factory( )->shell( ).
      DATA(page) = view->page(
          id = 'id_page'
          title = 'abap2ui5 - Scrolling (use Chrome to avoid incompatibilities)'
          navbuttonpress = client->_event( 'BACK' )
          shownavbutton = abap_true
          ).

      page->header_content( )->link( text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( ) ).

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

  ENDMETHOD.


  METHOD init.

    field_01 = `this is a text`.
    field_02 = `this is another text`.
    selstart = `3`.
    selend = `7`.

    client->view_display( z2ui5_cl_xml_view=>factory(
    )->_cc( )->scroll( )->load_cc(
    )->_cc( )->timer( )->control( client->_event( `DISPLAY_VIEW`)
    )->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      init( client ).
      RETURN.
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

      WHEN 'DISPLAY_VIEW'.
        display_view( client ).

      WHEN 'BUTTON01' OR 'BUTTON02'.
        update_focus = abap_true.
        focus_id = client->get( )-event.
        client->view_model_update( ).
*        display_view( client ).
        client->message_toast_display( |focus changed| ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
