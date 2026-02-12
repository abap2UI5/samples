CLASS z2ui5_cl_demo_app_057 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        selkz            TYPE abap_bool,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
      END OF ty_s_tab .
    TYPES
      ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY .

    DATA mt_table TYPE ty_t_table .
    DATA mv_check_download TYPE abap_bool .

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

  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_057 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client     = mo_client.
    app-get        = mo_client->get( ).

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
      WHEN `BUTTON_DOWNLOAD`.
        mv_check_download = abap_true.
      WHEN `BACK`.
        mo_client->nav_app_leave( mo_client->get_app( app-get-s_draft-id_prev_app_stack ) ).
    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

    app-view_main = `MAIN`.
  ENDMETHOD.

  METHOD on_render.

    CASE app-view_main.
      WHEN `MAIN`.
        on_render_main( ).
    ENDCASE.
  ENDMETHOD.

  METHOD on_render_main.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    lo_view = lo_view->page( id    = `page_main`
              title          = `abap2UI5 - List Report Features`
              navbuttonpress = mo_client->_event( `BACK` )
              shownavbutton  = mo_client->check_app_prev_stack( ) ).

    IF mv_check_download = abap_true.
      mv_check_download = abap_false.

      DATA(lv_csv) = z2ui5_cl_util=>itab_get_csv_by_itab( mt_table ).
      DATA(lv_csv_x) = z2ui5_cl_util=>conv_get_xstring_by_string( lv_csv ).
      DATA(lv_base64) = z2ui5_cl_util=>conv_encode_x_base64( lv_csv_x ).

      lo_view->_generic( ns     = `html`
                      name   = `iframe`
                      t_prop = VALUE #( ( n = `src` v = `data:text/csv;base64,` && lv_base64 ) ( n = `hidden` v = `hidden` ) ) ).

    ENDIF.

    DATA(lo_page) = lo_view->dynamic_page( headerexpanded = abap_true
                                     headerpinned   = abap_true ).

    DATA(lo_header_title) = lo_page->title( ns = `f` )->get( )->dynamic_page_title( ).
    lo_header_title->heading( ns = `f` )->hbox( )->title( `Download CSV` ).
    lo_header_title->expanded_content( `f` ).
    lo_header_title->snapped_content( ns = `f` ).

    DATA(lo_box) = lo_page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems     = `Start`
                      justifycontent = `SpaceBetween` )->flex_box( alignitems = `Start` ).

    lo_box->get_parent( )->hbox( justifycontent = `End` )->button(
        text  = `Go`
        press = mo_client->_event( `BUTTON_START` )
        type  = `Emphasized` ).

    DATA(lo_cont) = lo_page->content( ns = `f` ).

    DATA(lo_tab) = lo_cont->table( items = mo_client->_bind( mt_table ) ).

    lo_tab->header_toolbar(
            )->toolbar(
                )->toolbar_spacer(
                )->button(
                    icon  = `sap-icon://download`
                    press = mo_client->_event( `BUTTON_DOWNLOAD` ) ).

    DATA(lo_columns) = lo_tab->columns( ).
    lo_columns->column( )->text( text = `Product` ).
    lo_columns->column( )->text( text = `Date` ).
    lo_columns->column( )->text( text = `Name` ).
    lo_columns->column( )->text( text = `Location` ).
    lo_columns->column( )->text( text = `Quantity` ).

    DATA(lo_cells) = lo_tab->items( )->column_list_item( ).
    lo_cells->text( `{PRODUCT}` ).
    lo_cells->text( `{CREATE_DATE}` ).
    lo_cells->text( `{CREATE_BY}` ).
    lo_cells->text( `{STORAGE_LOCATION}` ).
    lo_cells->text( `{QUANTITY}` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD set_data.

    mt_table = VALUE #(
        ( product = `table` create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `chair` create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = `sofa` create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = `computer` create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = `printer` create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = `table2` create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 ) ).
  ENDMETHOD.
ENDCLASS.
