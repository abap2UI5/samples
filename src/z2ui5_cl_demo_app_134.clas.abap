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
    DATA mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA mv_scrollupdate TYPE abap_bool.

    DATA mv_field_01  TYPE string.
    DATA mv_field_02 TYPE string.
    DATA mv_selstart TYPE string.
    DATA mv_selend TYPE string.

    DATA mt_scroll TYPE z2ui5_if_types=>ty_t_name_value.

  PROTECTED SECTION.
    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS init
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_134 IMPLEMENTATION.

  METHOD display_view.

    DATA(ls_row) = VALUE ty_row( title = `Peter`  value = `red` info = `completed`  descr = `this is a description` ).
    DO 100 TIMES.
      INSERT ls_row INTO TABLE mt_tab.
    ENDDO.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( )->shell( ).
    DATA(lo_page) = lo_view->page(
        id             = `id_page`
        title          = `abap2ui5 - Scrolling (use Chrome to avoid incompatibilities)`
        navbuttonpress = client->_event( `BACK` )
        shownavbutton  = client->check_app_prev_stack( ) ).

    lo_page->_z2ui5( )->scrolling(
          setupdate = client->_bind_edit( mv_scrollupdate )
          items     = client->_bind_edit( mt_scroll ) ).

    DATA(lo_tab) = lo_page->table( sticky     = `ColumnHeaders,HeaderToolbar`
                             headertext = `Table with some entries`
                             items      = client->_bind( mt_tab ) ).

    lo_tab->columns(
        )->column( )->text( `Title` )->get_parent(
        )->column( )->text( `Color` )->get_parent(
        )->column( )->text( `Info` )->get_parent(
        )->column( )->text( `Description` ).

    lo_tab->items( )->column_list_item( )->cells(
       )->text( `{TITLE}`
       )->text( `{VALUE}`
       )->text( `{INFO}`
      )->text( `{DESCR}` ).

    lo_page->footer( )->overflow_toolbar(
         )->button( text  = `Scroll Top`
                    press = client->_event( `BUTTON_SCROLL_TOP` )
         )->button( text  = `Scroll 500 up`
                    press = client->_event( `BUTTON_SCROLL_UP` )
         )->button( text  = `Scroll 500 down`
                    press = client->_event( `BUTTON_SCROLL_DOWN` )
         )->button( text  = `Scroll Bottom`
                    press = client->_event( `BUTTON_SCROLL_BOTTOM` ) ).

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD init.

    mv_field_01 = `this is a text`.
    mv_field_02 = `this is another text`.
    mv_selstart = `3`.
    mv_selend = `7`.

    INSERT VALUE #( n = `id_page` ) INTO TABLE mt_scroll.
    display_view( client ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      init( client ).
      RETURN.
    ENDIF.

    client->message_toast_display( `server roundtrip` ).
    CASE client->get( )-event.
      WHEN `BACK`.
        client->nav_app_leave( ).
      WHEN `BUTTON_SCROLL_TOP`.
        CLEAR mt_scroll.
        INSERT VALUE #( n = `id_page` v = `0` ) INTO TABLE mt_scroll.
        mv_scrollupdate = abap_true.
        client->view_model_update( ).
      WHEN `BUTTON_SCROLL_UP`.

        DATA(lv_pos) = CONV i( mt_scroll[ n = `id_page` ]-v ).
        lv_pos = lv_pos - 500.
        IF lv_pos < 0.
          lv_pos = 0.
        ENDIF.
        mt_scroll[ n = `id_page` ]-v = shift_left( shift_right( CONV string( lv_pos ) ) ).
        mv_scrollupdate = abap_true.
        client->view_model_update( ).
      WHEN `BUTTON_SCROLL_DOWN`.

        lv_pos = mt_scroll[ n = `id_page` ]-v.
        lv_pos = lv_pos + 500.
        IF lv_pos < 0.
          lv_pos = 0.
        ENDIF.
        mt_scroll[ n = `id_page` ]-v = shift_left( shift_right( CONV string( lv_pos ) ) ).
        mv_scrollupdate = abap_true.
        client->view_model_update( ).
      WHEN `BUTTON_SCROLL_BOTTOM`.
        CLEAR mt_scroll.
        INSERT VALUE #( n = `id_page` v = `99999` ) INTO TABLE mt_scroll.
        mv_scrollupdate = abap_true.
        client->view_model_update( ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
