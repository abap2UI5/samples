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

    DATA mt_combo TYPE ty_t_combo.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.
    DATA:
      BEGIN OF app,
        check_initialized TYPE abap_bool,
        view_main         TYPE string,
        view_popup        TYPE string,
        get               TYPE z2ui5_if_types=>ty_s_get,
      END OF app.

    METHODS on_init.
    METHODS on_event.
    METHODS on_render.
    METHODS on_render_main.

    METHODS set_data.
    METHODS on_render_popup.
    METHODS on_render_popup_save.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_058 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client     = mo_client.
    app-get        = mo_client->get( ).
    app-view_popup = ``.

    IF app-check_initialized = abap_false.
      app-check_initialized = abap_true.
      on_init( ).
    ENDIF.

    IF app-get-event IS NOT INITIAL.
      on_event( ).
    ENDIF.

    on_render( ).
    CLEAR app-get.
  ENDMETHOD.

  METHOD on_event.

    CASE app-get-event.
      WHEN `BUTTON_START`.
        set_data( ).
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
             any = ms_layout ).
        app-view_popup = `POPUP_SAVE`.
      WHEN `BUTTON_SAVE_LAYOUT`.
        DATA(ls_layout) = VALUE ty_s_db_layout(
          data = z2ui5_cl_util=>xml_stringify( ms_layout )
          name = mv_layout ).
        INSERT ls_layout INTO TABLE mt_db_layout.
        app-view_popup = `POPUP_SAVE`.
      WHEN `BACK`.
        mo_client->nav_app_leave( mo_client->get_app( app-get-s_draft-id_prev_app_stack ) ).
    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

    set_data( ).
    app-view_main = `MAIN`.

    ms_layout-title = `data`.
    ms_layout-t_cols = VALUE #(
        ( name = `PRODUCT`    title = `PRODUCT` visible = abap_true )
        ( name = `CREATE_DAT` title = `CREATE_DAT` visible = abap_true )
        ( name = `CREATE_BY`  title = `CREATE_BY` visible = abap_true )
        ( name = `STORAGE_LOCATION` title = `STORAGE_LOCATION`  visible = abap_true )
        ( name = `QUANTITY`   title = `QUANTITY` visible = abap_true ) ).
  ENDMETHOD.

  METHOD on_render.

    CASE app-view_popup.
      WHEN `POPUP`.
        on_render_popup( ).
      WHEN `POPUP_SAVE`.
        on_render_popup_save( ).
    ENDCASE.

    CASE app-view_main.
      WHEN `MAIN`.
        on_render_main( ).
    ENDCASE.
  ENDMETHOD.

  METHOD on_render_main.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view = lo_view->shell( )->page( id = `page_main`
             title                  = `abap2UI5 - Table Layout Sample`
             navbuttonpress         = mo_client->_event( `BACK` )
             shownavbutton          = mo_client->check_app_prev_stack( ) ).

    DATA(tab) = lo_view->table(
        headertext         = ms_layout-title
        items              = mo_client->_bind( mt_table )
        alternaterowcolors = ms_layout-check_zebra
        sticky             = ms_layout-sticky_header
*        autopopinmode = abap_true
        mode               = ms_layout-selmode ).

    tab->header_toolbar(
          )->toolbar(
              )->title( text = ms_layout-title && ` (` && shift_right( CONV string( lines( mt_table ) ) ) && `)`
      )->toolbar_spacer(
              )->button(
                  icon  = `sap-icon://save`
                  press = mo_client->_event( `BUTTON_SAVE` )
              )->button(
                  icon  = `sap-icon://action-settings`
                  press = mo_client->_event( `BUTTON_SETUP` ) ).

    DATA(lv_width) = 10.
    DATA(lo_columns) = tab->columns( ).
    LOOP AT ms_layout-t_cols REFERENCE INTO DATA(lr_field)
          WHERE visible = abap_true.
      lo_columns->column(
            minscreenwidth = shift_right( CONV string( lv_width ) ) && `px`
            demandpopin    = abap_true
            width          = lr_field->length )->text( text = CONV string( lr_field->title ) ).
      lv_width = lv_width + 10.
    ENDLOOP.

    DATA(lo_cells) = tab->items( )->column_list_item(
        press    = mo_client->_event( val = `DETAIL` t_arg = VALUE #( ( `${UUID}` ) ) )
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

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_render_popup.

    DATA(ro_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    ro_popup = ro_popup->dialog( title        = `View Setup`
                                 resizable    = abap_true
          contentheight                       = `50%`
                                 contentwidth = `50%` ).

    ro_popup->custom_header(
          )->bar(
              )->content_right(
          )->button( text  = `zurücksetzten`
                     press = mo_client->_event( `BUTTON_INIT` ) ).

    DATA(lo_tab) = ro_popup->tab_container( ).

    mt_combo = VALUE ty_t_combo(
                       ( key = `None`  text = `None` )
                       ( key = `SingleSelect` text = `SingleSelect` )
                       ( key = `SingleSelectLeft` text = `SingleSelectLeft` )
                       ( key = `MultiSelect`  text = `MultiSelect` ) ).

    lo_tab->tab( text     = `Table`
                 selected = mo_client->_bind_edit( mv_check_table )
       )->simple_form( editable = abap_true
           )->content( `form`
               )->label( `zebra mode`
               )->checkbox( mo_client->_bind( ms_layout-check_zebra )
               )->label( `sticky header`
               )->input( mo_client->_bind( ms_layout-sticky_header )
               )->label( text = `Title`
               )->input( value = mo_client->_bind( ms_layout-title )
               )->label( `sel mode`
               )->combobox(
                   selectedkey = mo_client->_bind_edit( ms_layout-selmode )
                   items       = mo_client->_bind( mt_combo )
                   )->item(
                       key  = `{KEY}`
                       text = `{TEXT}` ).

    lo_tab->tab(
                text     = `Columns`
                selected = mo_client->_bind( mv_check_columns )
       )->table(
        items = mo_client->_bind_edit( ms_layout-t_cols )
        )->columns(
            )->column( )->text( `Visible` )->get_parent(
            )->column( )->text( `Name` )->get_parent(
            )->column( )->text( `Title` )->get_parent(
            )->column( )->text( `Editable` )->get_parent(
            )->column( )->text( `Length` )->get_parent(
        )->get_parent(
        )->items( )->column_list_item(
            )->cells(
                )->checkbox( `{VISIBLE}`
                )->text( `{NAME}`
                )->input( `{TITLE}`
                  )->checkbox( `{EDITABLE}`
                  )->input( `{LENGTH}`
         "       )->text( '{DESCR}'
      )->get_parent( )->get_parent( )->get_parent( )->get_parent( )->get_parent( ).

    lo_tab->tab(
                    text     = `Sort`
                    selected = mo_client->_bind( mv_check_sort ) ).

    ro_popup->end_button( )->button(
              text  = `continue`
              press = mo_client->_event( `POPUP_FILTER_CONTINUE` )
              type  = `Emphasized` ).

    mo_client->popup_display( ro_popup->stringify( ) ).
  ENDMETHOD.

  METHOD on_render_popup_save.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    lo_popup = lo_popup->dialog( title        = `abap2UI5 - Layout`
                                 contentwidth = `50%`
        )->input( description = `Name`
                  value       = mo_client->_bind( mv_layout )
        )->button( text  = `Save`
                   press = mo_client->_event( `BUTTON_SAVE_LAYOUT` )
        )->table(
            mode  = `SingleSelectLeft`
            items = mo_client->_bind_edit( mt_db_layout )
            )->columns(
                )->column( )->text( `Name` )->get_parent(
                )->column( )->text( `User` )->get_parent(
                )->column( )->text( `Default` )->get_parent(
             "   )->column( )->text( 'Description' )->get_parent(
            )->get_parent(
            )->items( )->column_list_item( selected = `{SELKZ}`
                )->cells(
                    )->text( `{NAME}`
                    )->text( `{USER}`
                    )->text( `{DEFAULT}`
        )->get_parent( )->get_parent( )->get_parent( )->get_parent(
        )->footer( )->overflow_toolbar(
            )->toolbar_spacer(
             )->button(
                text  = `load`
                press = mo_client->_event( `POPUP_LAYOUT_LOAD` )
                type  = `Emphasized`
            )->button(
                text  = `close`
                press = mo_client->_event( `POPUP_LAYOUT_CONTINUE` )
                type  = `Emphasized` ).

    mo_client->popup_display( lo_popup->stringify( ) ).
  ENDMETHOD.

  METHOD set_data.

    mt_table = VALUE #(
        ( product = `table`    create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `chair`    create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `sofa`     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `computer` create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `oven`     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `table2`   create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 ) ).
  ENDMETHOD.
ENDCLASS.
