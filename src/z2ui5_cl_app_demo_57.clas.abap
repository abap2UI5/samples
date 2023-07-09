CLASS z2ui5_cl_app_demo_57 DEFINITION PUBLIC.

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
    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    DATA mt_table TYPE ty_t_table.
    DATA mv_check_download TYPE abap_bool.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    DATA:
      BEGIN OF app,
        check_initialized TYPE abap_bool,
        view_main         TYPE string,
        view_popup        TYPE string,
        get               TYPE z2ui5_if_client=>ty_s_get,
      END OF app.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_on_render.
    METHODS z2ui5_on_render_main.

    METHODS z2ui5_set_data.

  PRIVATE SECTION.

    CLASS-METHODS hlp_get_csv_by_tab
      IMPORTING
        val           TYPE STANDARD TABLE
      RETURNING
        VALUE(rv_row) TYPE string.

    CLASS-METHODS hlp_get_base64
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE string.

ENDCLASS.



CLASS Z2UI5_CL_APP_DEMO_57 IMPLEMENTATION.


  METHOD hlp_get_base64.

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


  METHOD hlp_get_csv_by_tab.

    IF val IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lo_struc) = CAST cl_abap_structdescr( cl_abap_structdescr=>describe_by_data( val[ 1 ] ) ).
    DATA(lt_components) = lo_struc->get_components( ).

    rv_row  = ``.
    LOOP AT lt_components INTO DATA(lv_name) FROM 2.
      rv_row = rv_row && lv_name-name && `;`.
    ENDLOOP.
    rv_row = rv_row && cl_abap_char_utilities=>cr_lf.



    LOOP AT val assigning FIELD-SYMBOL(<row>).

      DATA(lv_index) = 2.
      DO.
        ASSIGN COMPONENT lv_index OF STRUCTURE <row> TO FIELD-SYMBOL(<field>).
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.
        rv_row = rv_row && <field>.
        lv_index = lv_index + 1.
        rv_row = rv_row && `;`.
      ENDDO.

      rv_row = rv_row && cl_abap_char_utilities=>cr_lf.
    ENDLOOP.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client     = client.
    app-get        = client->get( ).

    IF app-check_initialized = abap_false.
      app-check_initialized = abap_true.
      z2ui5_on_init( ).
    ENDIF.

    IF app-get-event IS NOT INITIAL.
      z2ui5_on_event( ).
    ENDIF.

    z2ui5_on_render( ).

    CLEAR app-get.

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE app-get-event.

      WHEN 'BUTTON_START'.
        z2ui5_set_data( ).

      WHEN `BUTTON_DOWNLOAD`.
        mv_check_download = abap_true.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( app-get-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    app-view_main = `MAIN`.

  ENDMETHOD.


  METHOD z2ui5_on_render.

    CASE app-view_main.
      WHEN 'MAIN'.
        z2ui5_on_render_main( ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_render_main.

    DATA(view) = z2ui5_cl_xml_view=>factory( client ).

      view = view->page( id = `page_main`
                title          = 'abap2UI5 - List Report Features'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton  = abap_true
            )->header_content(
                )->link(
                    text = 'Demo' target = '_blank'
                    href = 'https://twitter.com/abap2UI5/status/1661723127595016194'
                )->link(
                    text = 'Source_Code' target = '_blank' href = view->hlp_get_source_code_url( )
           )->get_parent( ).

    IF mv_check_download = abap_true.
      mv_check_download = abap_false.

      DATA(lv_csv) = hlp_get_csv_by_tab( mt_table ).
      DATA(lv_base64) = hlp_get_base64( lv_csv ).

      view->zz_plain( `<html:iframe src="data:text/csv;base64,` && lv_base64 && `" hidden="hidden" />`).

    ENDIF.

    DATA(page) = view->dynamic_page( headerexpanded = abap_true  headerpinned = abap_true ).

    DATA(header_title) = page->title( ns = 'f'  )->get( )->dynamic_page_title( ).
    header_title->heading( ns = 'f' )->hbox( )->title( `Download CSV` ).
    header_title->expanded_content( 'f' ).
    header_title->snapped_content( ns = 'f' ).

    DATA(lo_box) = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween` )->flex_box( alignItems = `Start` ).


    lo_box->get_parent( )->hbox( justifycontent = `End` )->button(
        text = `Go`
        press = client->_event( `BUTTON_START` )
        type = `Emphasized` ).

    DATA(cont) = page->content( ns = 'f' ).

    DATA(tab) = cont->table( items = client->_bind( val = mt_table ) ).

  tab->header_toolbar(
          )->toolbar(
              )->toolbar_spacer(
              )->button(
                  icon = 'sap-icon://download'
                  press = client->_event( 'BUTTON_DOWNLOAD' )
              ).

    DATA(lo_columns) = tab->columns( ).
    lo_columns->column( )->text( text = `Product` ).
    lo_columns->column( )->text( text = `Date` ).
    lo_columns->column( )->text( text = `Name` ).
    lo_columns->column( )->text( text = `Location` ).
    lo_columns->column( )->text( text = `Quantity` ).

    DATA(lo_cells) = tab->items( )->column_list_item( ).
    lo_cells->text( `{PRODUCT}` ).
    lo_cells->text( `{CREATE_DATE}` ).
    lo_cells->text( `{CREATE_BY}` ).
    lo_cells->text( `{STORAGE_LOCATION}` ).
    lo_cells->text( `{QUANTITY}` ).

    client->view_display( page->get_root( )->xml_get( ) ).

  ENDMETHOD.


  METHOD z2ui5_set_data.

    mt_table = VALUE #(
        ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
    ).

  ENDMETHOD.
ENDCLASS.
