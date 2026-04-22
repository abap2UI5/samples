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
      END OF ty_s_tab.
    TYPES
      ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    DATA mt_table TYPE ty_t_table.
    DATA mv_check_download TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    DATA:
      BEGIN OF app,
        view_main         TYPE string,
        view_popup        TYPE string,
        get               TYPE z2ui5_if_types=>ty_s_get,
      END OF app.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS view_display_main.

    METHODS set_data.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_057 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client     = client.
    app-get        = client->get( ).

    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

    IF app-get-event IS NOT INITIAL.
      on_event( ).
    ENDIF.

    view_display( ).

    app-get = VALUE #( ).

  ENDMETHOD.


  METHOD on_event.

    CASE app-get-event.

      WHEN `BUTTON_START`.
        set_data( ).

      WHEN `BUTTON_DOWNLOAD`.
        mv_check_download = abap_true.
    ENDCASE.

  ENDMETHOD.


  METHOD on_init.

    app-view_main = `MAIN`.

  ENDMETHOD.


  METHOD view_display.

    CASE app-view_main.
      WHEN `MAIN`.
        view_display_main( ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display_main.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view = view->page( id    = `page_main`
              title          = `abap2UI5 - List Report Features`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

    IF mv_check_download = abap_true.
      mv_check_download = abap_false.

      DATA(lv_csv) = z2ui5_cl_util=>itab_get_csv_by_itab( mt_table ).
      DATA(lv_csv_x) = z2ui5_cl_util=>conv_get_xstring_by_string( lv_csv ).
      DATA(lv_base64) = z2ui5_cl_util=>conv_encode_x_base64( lv_csv_x ).

      view->_generic( ns     = `html`
                      name   = `iframe`
                      t_prop = VALUE #( ( n = `src` v = `data:text/csv;base64,` && lv_base64 ) ( n = `hidden` v = `hidden` ) ) ).

    ENDIF.

    DATA(page) = view->dynamic_page( headerexpanded = abap_true
                                     headerpinned   = abap_true ).

    DATA(header_title) = page->title( ns = `f` )->get( )->dynamic_page_title( ).
    header_title->heading( `f` )->hbox( )->title( `Download CSV` ).
    header_title->expanded_content( `f` ).
    header_title->snapped_content( `f` ).

    DATA(lo_box) = page->header( )->dynamic_page_header( abap_true
         )->flex_box( alignitems     = `Start`
                      justifycontent = `SpaceBetween` )->flex_box( alignitems = `Start` ).

    lo_box->get_parent( )->hbox( justifycontent = `End` )->button(
        text  = `Go`
        press = client->_event( `BUTTON_START` )
        type  = `Emphasized` ).

    DATA(cont) = page->content( `f` ).

    DATA(tab) = cont->table( client->_bind( val = mt_table ) ).

    tab->header_toolbar(
            )->toolbar(
                )->toolbar_spacer(
                )->button(
                    icon  = `sap-icon://download`
                    press = client->_event( `BUTTON_DOWNLOAD` ) ).

    DATA(lo_columns) = tab->columns( ).
    lo_columns->column( )->text( `Product` ).
    lo_columns->column( )->text( `Date` ).
    lo_columns->column( )->text( `Name` ).
    lo_columns->column( )->text( `Location` ).
    lo_columns->column( )->text( `Quantity` ).

    DATA(lo_cells) = tab->items( )->column_list_item( ).
    lo_cells->text( `{PRODUCT}` ).
    lo_cells->text( `{CREATE_DATE}` ).
    lo_cells->text( `{CREATE_BY}` ).
    lo_cells->text( `{STORAGE_LOCATION}` ).
    lo_cells->text( `{QUANTITY}` ).

    client->view_display( page->stringify( ) ).

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
