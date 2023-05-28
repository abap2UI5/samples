CLASS z2ui5_cl_app_demo_58 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

 TYPES:
      BEGIN OF s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF s_combobox.

    TYPES ty_t_combo TYPE STANDARD TABLE OF s_combobox WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_S_cols,
        visible  TYPE abap_bool,
        name     TYPE string,
        length   TYPE string,
        title    TYPE string,
        editable TYPE abap_bool,
      END OF ty_S_cols.

          TYPES:
      BEGIN OF ty_S_sort,
        "  selkz      TYPE abap_bool,
        name TYPE string,
        type TYPE string,
        " descr      TYPE string,
        "  check_descending TYPE string,
      END OF ty_S_sort.

   DATA:
      BEGIN OF ms_layout,
        check_zebra   TYPE abap_bool,
        title         TYPE string,
        sticky_header TYPE string,
        selmode       TYPE string,
        t_cols        TYPE STANDARD TABLE OF ty_S_cols,
        t_sort        TYPE STANDARD TABLE OF ty_S_sort,
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

    TYPES:
      BEGIN OF ty_S_filter,
        product TYPE RANGE OF string,
      END OF ty_S_filter.


    DATA mv_check_sort TYPE abap_bool.
    DATA ms_filter TYPE ty_s_filter.


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
    METHODS z2ui5_on_render_main.

    METHODS z2ui5_set_data.
    METHODS z2ui5_on_render_popup.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_app_demo_58 IMPLEMENTATION.


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



  METHOD z2ui5_on_render.

    CASE app-view_popup.
      WHEN `POPUP`.
        z2ui5_on_render_popup( ).
    ENDCASE.

    CASE app-view_main.
      WHEN 'MAIN'.
        z2ui5_on_render_main( ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE app-get-event.

      WHEN `BUTTON_START`.
        z2ui5_set_data( ).


      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( app-get-id_prev_app_stack ) ).

    ENDCASE.



  ENDMETHOD.


  METHOD z2ui5_on_init.

    app-view_main = `MAIN`.


  ENDMETHOD.


  METHOD z2ui5_on_render_main.

    DATA(view) = z2ui5_cl_xml_view=>factory(
        )->page( id = `page_main`
                title          = 'abap2UI5 - List Report Features'
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
            headerexpanded = abap_true
            headerpinned   = abap_true
            ).

    DATA(header_title) = page->title( ns = 'f'
            )->get( )->dynamic_page_title( ).

    header_title->heading( ns = 'f' )->hbox(
        )->title( `Filter` ).

    header_title->expanded_content( 'f' ).

    header_title->snapped_content( ns = 'f' ).

    DATA(lo_box) = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween` )->flex_box( alignItems = `Start` ).



    DATA(cont) = page->content( ns = 'f' ).

*    DATA(tab) = cont->table( items = client->_bind( val = mt_table ) ).

    DATA(tab) = cont->table(
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
                  icon = 'sap-icon://action-settings'
                  press = client->_event( 'BUTTON_SETUP' )
              ).

*    DATA(lo_columns) = tab->columns( ).
*    lo_columns->column( )->text( text = `Product` ).
*    lo_columns->column( )->text( text = `Date` ).
*    lo_columns->column( )->text( text = `Name` ).
*    lo_columns->column( )->text( text = `Location` ).
*    lo_columns->column( )->text( text = `Quantity` ).
*
*    DATA(lo_cells) = tab->items( )->column_list_item( ).
*    lo_cells->text( `{PRODUCT}` ).
*    lo_cells->text( `{CREATE_DATE}` ).
*    lo_cells->text( `{CREATE_BY}` ).
*    lo_cells->text( `{STORAGE_LOCATION}` ).
*    lo_cells->text( `{QUANTITY}` ).


    data(lv_width) = 10.
    DATA(lo_columns) = tab->columns( ).
    LOOP AT ms_layout-t_cols REFERENCE INTO DATA(lr_field)
          WHERE visible = abap_true.
      lo_columns->column(
            minscreenwidth = shift_right( conv string( lv_width ) ) && `px`
            demandpopin = abap_true width = lr_field->length )->text( text = CONV char10( lr_field->title )
        )->footer(
        )->object_number( number = `Summe` unit = 'ST' state = `Warning` ).
        lv_width = lv_width + 10.
    ENDLOOP.

    DATA(lo_cells) = tab->items( )->column_list_item(
        press = client->_event( val = 'DETAIL' data = `${UUID}` )
        selected = `{SELKZ}`
        type = `Navigation` )->cells( ).
    LOOP AT ms_layout-t_cols REFERENCE INTO lr_field
          WHERE visible = abap_true.
      IF lr_field->editable = abap_true.
        lo_cells->input( `{` && lr_field->name && `}` ).
      ELSE.
        " lo_cells->text(  `{` && lr_field->name && `}` ).
        lo_cells->link( text = `{` && lr_field->name && `}`
        "   press = client->_event( val = `POPUP_DETAIL` data = `${` && lr_field->name && `}` ) ).
           press = client->_event( val = `POPUP_DETAIL` data = `${$source>/id}` ) ).
          " press = client->_event( val = `POPUP_DETAIL` data = `$event` ) ).
      ENDIF.
    ENDLOOP.


    app-next-xml_main = page->get_root( )->xml_get( ).

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



  METHOD z2ui5_on_render_popup.


  DATA(ro_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    ro_popup = ro_popup->dialog( title = 'View Setup'  resizable = abap_true
          contentheight = `50%` contentwidth = `50%` ).

    ro_popup->custom_header(
          )->bar(
              )->content_right(
          )->button( text = `zurücksetzten` press = client->_event( 'BUTTON_INIT' ) ).


    DATA(lo_tab) = ro_popup->tab_container( ).

    lo_tab->tab( text = 'Table' selected = client->_bind( mv_check_table )
       )->simple_form( editable = abap_true
           )->content( 'form'
               )->label( 'zebra mode'
               )->checkbox( client->_bind( ms_layout-check_zebra )
               )->label( 'sticky header'
               )->input( client->_bind( ms_layout-sticky_header )
               )->label( text = `Title`
               )->Input( value = client->_bind( ms_layout-title )
               )->label( 'sel mode'
               )->combobox(
                   selectedkey = client->_bind( ms_layout-selmode )
                   items       = client->_bind_one( VALUE ty_t_combo(
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
      "  mode = 'MultiSelect'
        items = client->_bind( ms_layout-t_cols )
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
                )->Input( '{TITLE}'
                  )->checkbox( '{EDITABLE}'
                  )->Input( '{LENGTH}'
         "       )->text( '{DESCR}'
    )->get_parent( )->get_parent( )->get_parent( )->get_parent(  )->get_parent( ).

    DATA(lo_tab_sort) = lo_tab->tab(
                   text     = 'Sort'
                   selected = client->_bind( mv_check_sort ) ).

    lo_tab_sort->button( icon = `sap-icon://add` press = client->_event(  `SORT_ADD`  ) ).

    DATA(lo_hbox) = lo_tab_sort->list(
           items           = client->_bind( ms_layout-t_sort )
           selectionchange = client->_event( 'SELCHANGE' )
              )->custom_list_item(
                 )->hbox( ).

    lo_hbox->combobox(
                 selectedkey = `{NAME}`
                 items       = client->_bind( ms_layout-t_cols )
*                                    ( key = 'BLUE'  text = 'green' )
*                                    ( key = 'GREEN' text = 'blue' )
*                                    ( key = 'BLACK' text = 'red' )
*                                    ( key = 'GRAY'  text = 'gray' ) ) )
             )->item(
                     key = '{NAME}'
                     text = '{NAME}'
             )->get_parent(
              )->segmented_button( `{TYPE}`
)->items(
 )->segmented_button_item(
     key = 'DESCENDING'
     icon = 'sap-icon://sort-descending'
 )->segmented_button_item(
     key = 'ASCENDING'
     icon = 'sap-icon://sort-ascending'
)->get_parent( )->get_parent(
)->button( type = `Transparent` icon = 'sap-icon://decline' press = client->_event( val = `SORT_DELETE` data = `${NAME}` ) ).
*            )->get_parent( )->get_parent( )->get_parent(

*           )->button(
*                text  = 'counter descending'
*                icon = 'sap-icon://sort-descending'
*                press = client->_event( 'SORT_DESCENDING' )
*            )->button(
*                text  = 'counter ascending'
*                icon = 'sap-icon://sort-ascending'
*                press = client->_event( 'SORT_ASCENDING' )
*              )->get_parent( ).


*        lo_tab->tab(
*                        text     = 'Group'
*                        selected = client->_bind( mv_check_group )
*                 )->get_parent( )->get_parent( ).

    ro_popup->footer( )->overflow_toolbar(
          )->toolbar_spacer(
          )->button(
              text  = 'continue'
              press = client->_event( 'POPUP_FILTER_CONTINUE' )
              type  = 'Emphasized' ).

    app-next-xml_popup = ro_popup->get_root( )->xml_get( ).


  ENDMETHOD.

ENDCLASS.
