CLASS z2ui5_cl_demo_app_058 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF s_combobox.

    TYPES ty_t_combo TYPE STANDARD TABLE OF s_combobox WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_s_cols,
        visible  TYPE abap_bool,
        name     TYPE string,
        length   TYPE string,
        title    TYPE string,
        editable TYPE abap_bool,
      END OF ty_s_cols.

    TYPES:
      BEGIN OF ty_s_db_layout,
        selkz   TYPE abap_bool,
        name    TYPE string,
        user    TYPE string,
        default TYPE abap_bool,
        data    TYPE string,
      END OF ty_s_db_layout.
    DATA mt_db_layout TYPE STANDARD TABLE OF ty_s_db_layout.

    DATA:
      BEGIN OF ms_layout,
        check_zebra   TYPE abap_bool,
        title         TYPE string,
        sticky_header TYPE string,
        selmode       TYPE string,
        t_cols        TYPE STANDARD TABLE OF ty_s_cols,
      END OF ms_layout.

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

    DATA mv_check_table TYPE abap_bool.

    DATA mv_check_columns TYPE abap_bool.
    DATA mt_table TYPE ty_t_table.

    DATA mv_layout TYPE string.
    DATA mv_check_sort TYPE abap_bool.



  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA:
      BEGIN OF app,
        check_initialized TYPE abap_bool,
        view_main         TYPE string,
        view_popup        TYPE string,
        get               TYPE z2ui5_if_types=>ty_s_get,
      END OF app.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_render.
    METHODS z2ui5_on_render_main.

    METHODS z2ui5_set_data.
    METHODS z2ui5_on_render_popup.
    METHODS z2ui5_on_render_popup_save.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_058 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client     = client.
    app-get        = client->get( ).
    app-view_popup = ``.
*    app-next-title = `Filter`.


    IF app-check_initialized = abap_false.
      app-check_initialized = abap_true.
      z2ui5_on_init( ).
    ENDIF.

    IF app-get-event IS NOT INITIAL.
      z2ui5_on_event( ).
    ENDIF.

    z2ui5_on_render( ).

*    client->set_next( app-next ).
    CLEAR app-get.
*    CLEAR app-next.

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE app-get-event.
      WHEN `BUTTON_START`.
        z2ui5_set_data( ).
      WHEN `BUTTON_SETUP`.
        app-view_popup = `POPUP`.
      WHEN `BUTTON_SAVE`.
        app-view_popup = `POPUP_SAVE`.

      WHEN `POPUP_LAYOUT_LOAD`.
        DATA(ls_layout2) = mt_db_layout[ selkz = abap_true ].
        z2ui5_cl_util=>xml_parse(
          EXPORTING
            xml  = ls_layout2-data
          IMPORTING
             any = ms_layout
        ).
        app-view_popup = `POPUP_SAVE`.

      WHEN `BUTTON_SAVE_LAYOUT`.
        DATA(ls_layout) = VALUE ty_s_db_layout(
          data = z2ui5_cl_util=>xml_stringify( ms_layout )
          name = mv_layout
          ).
        INSERT ls_layout INTO TABLE mt_db_layout.
        app-view_popup = `POPUP_SAVE`.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( app-get-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    app-view_main = `MAIN`.

    ms_layout-title = `data`.
    ms_layout-t_cols = VALUE #(
        ( name = `PRODUCT`    title = `PRODUCT` visible = abap_true )
        ( name = `CREATE_DAT` title = `CREATE_DAT` visible = abap_true )
        ( name = `CREATE_BY`  title = `CREATE_BY` visible = abap_true )
        ( name = `STORAGE_LOCATION` title = `STORAGE_LOCATION`  visible = abap_true )
        ( name = `QUANTITY`   title = `QUANTITY` visible = abap_true )
    ).

  ENDMETHOD.


  METHOD z2ui5_on_render.

    CASE app-view_popup.
      WHEN `POPUP`.
        z2ui5_on_render_popup( ).
      WHEN `POPUP_SAVE`.
        z2ui5_on_render_popup_save( ).
    ENDCASE.

    CASE app-view_main.
      WHEN 'MAIN'.
        z2ui5_on_render_main( ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_render_main.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view = view->page( id = `page_main`
             title          = 'abap2UI5 - List Report Features'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
         )->header_content(
             )->link(
                 text = 'Demo' target = '_blank'
                 href = 'https://twitter.com/abap2UI5/status/1662821284873396225'
             )->link(
                 text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->get_parent( ).

    DATA(page) = view->dynamic_page(
            headerexpanded = abap_true
            headerpinned   = abap_true
            ).

    DATA(header_title) = page->title( ns = 'f'
            )->get( )->dynamic_page_title( ).

    header_title->heading( ns = 'f' )->hbox(
        )->title( `Layout` ).

    header_title->expanded_content( 'f' ).

    header_title->snapped_content( ns = 'f' ).

    DATA(lo_box) = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween` )->flex_box( alignitems = `Start` ).

    lo_box->get_parent( )->hbox( justifycontent = `End` )->button(
        text = `Go` press = client->_event( `BUTTON_START` ) type = `Emphasized`
        ).

    DATA(cont) = page->content( ns = 'f' ).

    DATA(tab) = cont->table(
        headertext = ms_layout-title
        items = client->_bind( mt_table )
        alternaterowcolors = ms_layout-check_zebra
        sticky = ms_layout-sticky_header
        autopopinmode = abap_true
        mode = ms_layout-selmode ).

    tab->header_toolbar(
          )->toolbar(
              )->title( text = ms_layout-title && ` (` && shift_right( CONV string( lines( mt_table ) ) ) && `)` level = `H2`

      )->toolbar_spacer(
              )->button(
                  icon = 'sap-icon://save'
                  press = client->_event( 'BUTTON_SAVE' )
              )->button(
                  icon = 'sap-icon://action-settings'
                  press = client->_event( 'BUTTON_SETUP' )
              ).

    DATA(lv_width) = 10.
    DATA(lo_columns) = tab->columns( ).
    LOOP AT ms_layout-t_cols REFERENCE INTO DATA(lr_field)
          WHERE visible = abap_true.
      lo_columns->column(
            minscreenwidth = shift_right( CONV string( lv_width ) ) && `px`
            demandpopin = abap_true width = lr_field->length )->text( text = CONV char10( lr_field->title )
            ).
      lv_width = lv_width + 10.
    ENDLOOP.

    DATA(lo_cells) = tab->items( )->column_list_item(
        press = client->_event( val = 'DETAIL' t_arg = VALUE #( ( `${UUID}` ) ) )
        selected = `{SELKZ}`
      )->cells( ).

    LOOP AT ms_layout-t_cols REFERENCE INTO lr_field
          WHERE visible = abap_true.
      IF lr_field->editable = abap_true.
        lo_cells->input( `{` && lr_field->name && `}` ).
      ELSE.
        lo_cells->text( text = `{` && lr_field->name && `}` ).
      ENDIF.
    ENDLOOP.

    client->view_display( page->get_root( )->xml_get( ) ).

  ENDMETHOD.


  METHOD z2ui5_on_render_popup.

    DATA(ro_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    ro_popup = ro_popup->dialog( title = 'View Setup'  resizable = abap_true
          contentheight = `50%` contentwidth = `50%` ).

    ro_popup->custom_header(
          )->bar(
              )->content_right(
          )->button( text = `zurücksetzten` press = client->_event( 'BUTTON_INIT' ) ).

    DATA(lo_tab) = ro_popup->tab_container( ).

    lo_tab->tab( text = 'Table' selected = client->_bind_edit( mv_check_table )
       )->simple_form( editable = abap_true
           )->content( 'form'
               )->label( 'zebra mode'
               )->checkbox( client->_bind( ms_layout-check_zebra )
               )->label( 'sticky header'
               )->input( client->_bind( ms_layout-sticky_header )
               )->label( text = `Title`
               )->input( value = client->_bind( ms_layout-title )
               )->label( 'sel mode'
               )->combobox(
                   selectedkey = client->_bind_edit( ms_layout-selmode )
                   items       = client->_bind_local( VALUE ty_t_combo(
                       ( key = 'None'  text = 'None' )
                       ( key = 'SingleSelect' text = 'SingleSelect' )
                       ( key = 'SingleSelectLeft' text = 'SingleSelectLeft' )
                       ( key = 'MultiSelect'  text = 'MultiSelect' ) ) )
                   )->item(
                       key = '{KEY}'
                       text = '{TEXT}' ).

    lo_tab->tab(
                text     = 'Columns'
                selected = client->_bind( mv_check_columns )
       )->table(
        items = client->_bind_edit( ms_layout-t_cols )
        )->columns(
            )->column( )->text( 'Visible' )->get_parent(
            )->column( )->text( 'Name' )->get_parent(
            )->column( )->text( 'Title' )->get_parent(
            )->column( )->text( 'Editable' )->get_parent(
            )->column( )->text( 'Length' )->get_parent(
        )->get_parent(
        )->items( )->column_list_item(
            )->cells(
                )->checkbox( '{VISIBLE}'
                )->text( '{NAME}'
                )->input( '{TITLE}'
                  )->checkbox( '{EDITABLE}'
                  )->input( '{LENGTH}'
         "       )->text( '{DESCR}'
    )->get_parent( )->get_parent( )->get_parent( )->get_parent(  )->get_parent( ).

    lo_tab->tab(
                    text     = 'Sort'
                    selected = client->_bind( mv_check_sort ) ).

    ro_popup->footer( )->overflow_toolbar(
          )->toolbar_spacer(
          )->button(
              text  = 'continue'
              press = client->_event( 'POPUP_FILTER_CONTINUE' )
              type  = 'Emphasized' ).

    client->popup_display( ro_popup->get_root( )->xml_get( ) ).


  ENDMETHOD.


  METHOD z2ui5_on_render_popup_save.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    lo_popup = lo_popup->dialog( title = 'abap2UI5 - Layout'  contentwidth = `50%`
        )->input( description = `Name` value = client->_bind( mv_layout )
        )->button( text = `Save` press = client->_event( `BUTTON_SAVE_LAYOUT` )
        )->table(
            mode = 'SingleSelectLeft'
            items = client->_bind_edit( mt_db_layout )
            )->columns(
                )->column( )->text( 'Name' )->get_parent(
                )->column( )->text( 'User' )->get_parent(
                )->column( )->text( 'Default' )->get_parent(
             "   )->column( )->text( 'Description' )->get_parent(
            )->get_parent(
            )->items( )->column_list_item( selected = '{SELKZ}'
                )->cells(
                    )->text( '{NAME}'
                    )->text( '{USER}'
                    )->text( '{DEFAULT}'
        )->get_parent( )->get_parent( )->get_parent( )->get_parent(
        )->footer( )->overflow_toolbar(
            )->toolbar_spacer(
             )->button(
                text  = 'load'
                press = client->_event( 'POPUP_LAYOUT_LOAD' )
                type  = 'Emphasized'
            )->button(
                text  = 'close'
                press = client->_event( 'POPUP_LAYOUT_CONTINUE' )
                type  = 'Emphasized' ).

    client->popup_display( lo_popup->get_root( )->xml_get( ) ).

  ENDMETHOD.


  METHOD z2ui5_set_data.

    mt_table = VALUE #(
        ( product = 'table'    create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair'    create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'sofa'     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'computer' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'oven'     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'table2'   create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
    ).

  ENDMETHOD.
ENDCLASS.
