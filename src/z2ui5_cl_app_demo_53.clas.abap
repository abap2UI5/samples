CLASS z2ui5_cl_app_demo_53 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_token,
        key     TYPE string,
        text    TYPE string,
        visible TYPE abap_bool,
        selkz   TYPE abap_bool,
      END OF ty_S_token.

    DATA mv_value TYPE string.
    DATA mt_token            TYPE STANDARD TABLE OF ty_S_token WITH EMPTY KEY.
    DATA mt_token_sugg       TYPE STANDARD TABLE OF ty_S_token WITH EMPTY KEY.


    TYPES:
      BEGIN OF ty_s_tab,
        selkz            TYPE abap_bool,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
      END OF ty_s_tab.

    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    DATA mt_table TYPE ty_t_table.
    DATA ms_detail TYPE z2ui5_t_draft.
    DATA mv_check_columns TYPE abap_bool.
    DATA mv_check_sort TYPE abap_bool.
    DATA mv_check_table TYPE abap_bool.

    DATA mv_contentheight TYPE string VALUE `70%`.
    DATA mv_contentwidth TYPE string VALUE `70%`.

    DATA mv_check_download_csv TYPE abap_bool.

    TYPES:
      BEGIN OF ty_S_out,
        selkz               TYPE abap_bool,
        uuid                TYPE string,
        uuid_prev           TYPE string,
        uuid_prev_app       TYPE string,
        uuid_prev_app_stack TYPE string,
        timestampl          TYPE string,
        uname               TYPE string,
      END OF ty_s_out.

    DATA:
      BEGIN OF ms_view,
        headerpinned   TYPE abap_bool,
        headerexpanded TYPE abap_bool,
        search_val     TYPE string,
        title          TYPE string,
        t_tab          TYPE ty_t_table,
      END OF ms_view.

    TYPES:
      BEGIN OF ty_S_cols,
        visible  TYPE abap_bool,
        name     TYPE string,
        length   TYPE string,
        title    TYPE string,
        editable TYPE abap_bool,
      END OF ty_S_cols.

    TYPES:
      BEGIN OF ty_S_filter_show,
        selkz TYPE abap_bool,
        name  TYPE string,
        value TYPE string,
      END OF ty_S_filter_show.

    TYPES:
      BEGIN OF ty_S_filter,
        product TYPE RANGE OF string,
      END OF ty_S_filter.

    TYPES:
      BEGIN OF ty_S_sort,
        name TYPE string,
        type TYPE string,
      END OF ty_S_sort.


    DATA ms_filter TYPE ty_s_filter.

    DATA:
      BEGIN OF ms_layout,
        check_zebra   TYPE abap_bool,
        title         TYPE string,
        sticky_header TYPE string,
        selmode       TYPE string,
        t_filter_show TYPE STANDARD TABLE OF ty_S_filter_show,
        s_filter      TYPE ty_s_filter,
        t_cols        TYPE STANDARD TABLE OF ty_S_cols,
        t_sort        TYPE STANDARD TABLE OF ty_S_sort,
      END OF ms_layout.

    TYPES:
      BEGIN OF s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF s_combobox.

    TYPES ty_t_combo TYPE STANDARD TABLE OF s_combobox WITH EMPTY KEY.

    CLASS-METHODS encode_base64
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE string.

    TYPES:
      BEGIN OF ty_S_db_layout,
        selkz   TYPE ABap_bool,
        name    TYPE string,
        user    TYPE string,
        default TYPE abap_bool,
        data    TYPE string,
      END OF ty_S_db_layout.
    DATA mt_db_layout TYPE STANDARD TABLE OF ty_S_db_layout.

    DATA mv_layout_name TYPE string.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA:
      BEGIN OF app,
        check_initialized TYPE abap_bool,
        view_main         TYPE string,
        view_popup        TYPE string,
        get               TYPE z2ui5_if_client=>ty_s_get,
        next              TYPE z2ui5_if_client=>ty_s_next,
      END OF app.


    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_render.
    METHODS init_table_output.
    METHODS z2ui5_on_render_main.
    METHODS z2ui5_on_render_pop_filter.

    METHODS z2ui5_set_search.
    METHODS z2ui5_set_data.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_app_demo_53 IMPLEMENTATION.


  METHOD encode_base64.

    TRY.
        CALL METHOD ('CL_WEB_HTTP_UTILITY')=>encode_base64
          EXPORTING
            unencoded = val
          RECEIVING
            encoded   = result.

      CATCH cx_sy_dyn_call_illegal_class.

        DATA(classname) = 'CL_HTTP_UTILITY'.
        CALL METHOD (classname)=>encode_base64
          EXPORTING
            unencoded = val
          RECEIVING
            encoded   = result.

    ENDTRY.

  ENDMETHOD.


  METHOD init_table_output.

    " CLEAR  ms_layout-s_table.
    " CLEAR mt_cols.
    "  CLEAR  ms_layout-t_cols.

    ms_view-headerexpanded = abap_true.
    ms_view-headerpinned   = abap_true.

    DATA(lt_cols)   = lcl_db=>get_fieldlist_by_table( mt_table ).
    LOOP AT lt_cols REFERENCE INTO DATA(lr_col) FROM 2.

      INSERT VALUE #(
        name = lr_col->*
      ) INTO TABLE  ms_layout-t_filter_show.

      INSERT VALUE #(
         visible = abap_true
         name = lr_col->*
       "  length = `10px`
         title = lr_col->*
       ) INTO TABLE ms_layout-t_cols.

*      INSERT VALUE #(
*       "  selkz = abap_true
*         name = lr_col->*
*      "   length = `10px`
*       ) INTO TABLE  ms_layout-t_cols.

    ENDLOOP.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client     = client.
    app-get        = client->get( ).
    app-view_popup = ``.
    app-next-title = `Filter`.


    IF app-check_initialized = abap_false.
      app-check_initialized = abap_true.
      z2ui5_on_init( ).
    ENDIF.

    IF app-get-event IS NOT INITIAL.
      z2ui5_on_event( ).
    ENDIF.

    z2ui5_on_render( ).


    client->set_next( app-next ).
    CLEAR app-get.
    CLEAR app-next.

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE app-get-event.

      WHEN 'SORT_ADD'.
        INSERT VALUE #( ) INTO TABLE ms_layout-t_sort.
        app-view_popup = 'POPUP_SETUP'.

      WHEN `FLTER_UPDTAE`.

        app-next-s_cursor-id = `FILTER`.
        app-next-s_cursor-cursorpos = `999`.
        app-next-s_cursor-selectionend = `999`.
        app-next-s_cursor-selectionstart  = `999`.

        IF mv_value IS NOT INITIAL.
          CASE mv_value(1).
            WHEN `=`.
              DATA(lv_option) = `EQ`.
              mv_value = mv_value+1.
            WHEN `<`.
              lv_option = `LT`.
              mv_value = mv_value+1.
            WHEN OTHERS.
              lv_option = `EQ`.
          ENDCASE.

          INSERT VALUE #( sign = `I` option = lv_option low = mv_value ) INTO TABLE ms_filter-product.

          CLEAR mv_value.
        ENDIF.


      WHEN `FILTER_VALUE_HELP`.
        app-next-s_cursor-id = `FILTER`.
        app-next-s_cursor-cursorpos = `999`.
        app-next-s_cursor-selectionend = `999`.
        app-next-s_cursor-selectionstart  = `999`.
        DATA(lt_token2) = mt_token.

      WHEN 'BACK'.
        "  app-next-path = `test`.
        client->nav_app_leave( client->get_app( app-get-id_prev_app_stack ) ).

    ENDCASE.

    clear mt_token.
    LOOP AT ms_filter-product REFERENCE INTO DATA(lr_row).
      data(lv_low) = ``.
      CASE lr_row->option.

        WHEN `EQ`.
          lv_low = `=`.
        WHEN `LT`.
          lv_low = `<`.

      ENDCASE.

      DATA(lv_value) = lv_low && lr_row->low.
      INSERT VALUE #( key = lr_row->low text = lv_value ) INTO TABLE mt_token.
    ENDLOOP.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    init_table_output( ).

    ms_view-title = `Standart`.
    ms_layout-selmode = 'MultiSelect'.
    ms_layout-check_zebra = abap_true.
    ms_view-t_tab = CORRESPONDING #( mt_table ).
    ms_layout-sticky_header = `HeaderToolbar,InfoToolbar,ColumnHeaders`.
    ms_layout-title = `Drafts`.

    app-next-t_scroll = VALUE #( ( name = `page_main` ) ).
    app-view_main = `MAIN`.

  ENDMETHOD.


  METHOD z2ui5_on_render.

    CASE app-view_popup.
      WHEN `POPUP_FILTER`.
        z2ui5_on_render_pop_filter( ).
    ENDCASE.

    app-next-path = app-next-path && `/` &&  app-view_main.

    CASE app-view_main.
      WHEN 'MAIN'.
        z2ui5_on_render_main( ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_render_main.

    DATA(view) = z2ui5_cl_xml_view=>factory(
        )->page( id = `page_main`
                title          = 'abap2UI5 - Filter'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton  = abap_true
            )->header_content(
                )->link(
                    text = 'Demo' target = '_blank'
                    href = 'https://twitter.com/OblomovDev/status/1637163852264624139'
                )->link(
                    text = 'Source_Code' target = '_blank' href = z2ui5_cl_xml_view=>hlp_get_source_code_url( app = me get = client->get( ) )
           )->get_parent( ).

    DATA(page) = view->dynamic_page(
            headerexpanded = client->_bind( ms_view-headerexpanded )
            headerpinned   = client->_bind(  ms_view-headerpinned  ) ).

    DATA(header_title) = page->title( ns = 'f'
            )->get( )->dynamic_page_title( ).

    header_title->heading( ns = 'f' )->hbox(
        )->title( ms_view-title
            )->get(
                )->link( text = `test` press =  client->_event( `POPUP_LAYOUT` )
            )->get_parent(
         )->button( id = `btn_layout` press = client->_event( `POPUP_LAYOUT` ) type = `Transparent` icon = `sap-icon://dropdown` ).

    header_title->expanded_content( 'f'
             )->label( text = 'Table Data' ).

    header_title->snapped_content( ns = 'f'
             )->label( text = 'Table Data' ).


    DATA(lo_box) = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween` )->flex_box( alignItems = `Start` ).

    lo_box->vbox(
          )->text(  `Search`
          )->search_field(
                        value = client->_bind( ms_view-search_val )
                         search = client->_event( 'BUTTON_SEARCH' )
                         change = client->_event( 'BUTTON_SEARCH' )
                         width = `17.5rem`
                         id    = `SEARCH`
                   ).

    lo_box->vbox(
        )->text(  `Product:`
        )->multi_input(
                    tokens          = client->_bind( mt_token )
                    showclearicon   = abap_true
                    value           = client->_bind( mv_value )
                    tokenUpdate     = client->_event( 'FLTER_UPDTAE' )
                    submit          = client->_event( 'FLTER_UPDTAE' )
                    id              = `FILTER`
                    valueHelpRequest  = client->_event( 'FILTER_VALUE_HELP' )
                )->item(
                        key = `{KEY}`
                        text = `{TEXT}`
                )->tokens(
                    )->token(
                        key = `{KEY}`
                        text = `{TEXT}`
        ).

    DATA(rt_filter)  = ms_layout-t_filter_show.
    DELETE rt_filter WHERE selkz = abap_false.

    lo_box->get_parent( )->hbox( justifycontent = `End`
        )->button( text = `Go` press = client->_event( `BUTTON_START` ) type = `Emphasized`
        )->button( text = `Adapt Filters (` && shift_right( CONV string( lines(  rt_filter ) ) ) && `)`  press = client->_event( `POPUP_FILTER` )
        ).

    DATA(cont) = page->content( ns = 'f' ).

    DATA(tab) = cont->table(
        items = client->_bind( val = ms_view-t_tab )
        alternaterowcolors = ms_layout-check_zebra
        sticky = ms_layout-sticky_header
        ).

    DATA(lv_width) = 10.
    DATA(lo_columns) = tab->columns( ).
    LOOP AT ms_layout-t_cols REFERENCE INTO DATA(lr_field)
          WHERE visible = abap_true.
      lo_columns->column(
            minscreenwidth = shift_right( CONV string( lv_width ) ) && `px`
            demandpopin = abap_true width = lr_field->length )->text( text = CONV char10( lr_field->title )
        )->footer(
        )->object_number( number = `Summe` unit = 'ST' state = `Warning` ).
      lv_width = lv_width + 10.
    ENDLOOP.

    DATA(lo_cells) = tab->items( )->column_list_item( ).
    LOOP AT ms_layout-t_cols REFERENCE INTO lr_field.
      lo_cells->text( `{` && lr_field->name && `}` ).
    ENDLOOP.

    app-next-xml_main = page->get_root( )->xml_get( ).

  ENDMETHOD.



  METHOD z2ui5_on_render_pop_filter.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    lo_popup->dialog( 'abap2UI5 - Popup to select entry'
        )->table(
            mode = 'MultiSelect'
            items = client->_bind( ms_layout-t_filter_show )
            )->columns(
                )->column( )->text( 'Title' )->get_parent(
                )->column( )->text( 'Color' )->get_parent(
                )->column( )->text( 'Info' )->get_parent(
                )->column( )->text( 'Description' )->get_parent(
            )->get_parent(
            )->items( )->column_list_item( selected = '{SELKZ}'
                )->cells(
             "       )->checkbox( '{SELKZ}'
                    )->text( '{NAME}'
                    )->text( '{VALUE}'
             "       )->text( '{DESCR}'
        )->get_parent( )->get_parent( )->get_parent( )->get_parent(
        )->footer( )->overflow_toolbar(
            )->toolbar_spacer(
            )->button(
                text  = 'continue'
                press = client->_event( 'POPUP_FILTER_CONTINUE' )
                type  = 'Emphasized' ).

    app-next-xml_popup = lo_popup->get_root( )->xml_get( ).

  ENDMETHOD.

  METHOD z2ui5_set_data.

    "dirty solution
    "todo: map filters to rangetab and make a nice select

*    IF ms_layout-s_filter-uuid IS INITIAL.

    DATA(lt_data) = lcl_db=>db_read( ).

    mt_table = lt_data.

*      SELECT FROM z2ui5_t_draft
*          FIELDS uuid, uuid_prev, timestampl, uname
*        INTO CORRESPONDING FIELDS OF TABLE @mt_table
*          UP TO 50 ROWS.
*
*    ELSE.
*
*      SELECT FROM z2ui5_t_draft
*      FIELDS uuid, uuid_prev, timestampl, uname
*      WHERE uuid = @ms_layout-s_filter-uuid
*            INTO CORRESPONDING FIELDS OF TABLE @mt_table
*                    UP TO 50 ROWS.
*
*    ENDIF.

    ms_view-t_tab = CORRESPONDING #( mt_table ).

  ENDMETHOD.


  METHOD z2ui5_set_search.

    ms_view-t_tab = CORRESPONDING #( mt_table ).
    IF ms_view-search_val IS NOT INITIAL.
      LOOP AT ms_view-t_tab REFERENCE INTO DATA(lr_row).
        DATA(lv_row) = ``.
        DATA(lv_index) = 1.
        DO.
          ASSIGN COMPONENT lv_index OF STRUCTURE lr_row->* TO FIELD-SYMBOL(<field>).
          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
          lv_row = lv_row && <field>.
          lv_index = lv_index + 1.
        ENDDO.

        IF lv_row NS ms_view-search_val.
          DELETE ms_view-t_tab.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


ENDCLASS.
