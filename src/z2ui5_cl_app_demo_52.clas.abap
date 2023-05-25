CLASS z2ui5_cl_app_demo_52 DEFINITION PUBLIC.

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

    DATA mt_table TYPE ty_T_table.
    DATA check_initialized TYPE abap_bool.
    DATA next TYPE z2ui5_if_client=>ty_s_next.

    DATA mv_check_popover TYPE abap_bool.
    DATA mv_product TYPE string.

    METHODS  z2ui5_set_data.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_app_demo_52 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

    ENDIF.

    CLEAR next.

    CASE client->get( )-event.

      WHEN `POPOVER_DETAIL`.
        DATA(lv_id) = client->get( )-event_data.
        next-popover_open_by_id = lv_id.
        mv_check_popover = abap_true.
        mv_product = client->get( )-event_data2.

      WHEN 'BUTTON_START'.
        z2ui5_set_data( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack ) ).


    ENDCASE.

    IF mv_check_popover = abap_false.

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

      DATA(page) = view->dynamic_page( headerexpanded = abap_true  headerpinned = abap_true ).

      DATA(header_title) = page->title( ns = 'f'  )->get( )->dynamic_page_title( ).
      header_title->heading( ns = 'f' )->hbox( )->title( `Item Popover` ).
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
      lo_cells->link( text = '{PRODUCT}' press = client->_event( val = `POPOVER_DETAIL` hold_view = abap_true data = `${$source>/id}` data2 = `${PRODUCT}` ) ).
      lo_cells->text( `{CREATE_DATE}` ).
      lo_cells->text( `{CREATE_BY}` ).
      lo_cells->text( `{STORAGE_LOCATION}` ).
      lo_cells->text( `{QUANTITY}` ).

      next-xml_main = page->get_root( )->xml_get( ).

    ELSE.

      mv_check_popover = abap_false.

      DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

      lo_popup->popover( placement = `Right` title = `abap2UI5 - Popover - ` && mv_product  contentwidth = `50%`
        )->simple_form( editable = abap_true
        )->content( 'form'
            )->label( 'Product'
            )->text(  mv_product
            )->label( 'info2'
            )->text(  `this is a text`
            )->label( 'info3'
            )->text(  `this is a text`
            )->text(  `this is a text`
          )->get_parent( )->get_parent(
          )->footer(
           )->overflow_toolbar(
              )->toolbar_spacer(
              )->button(
                  text  = 'details'
                  press = client->_event( 'BUTTON_DETAILS' )
                  type  = 'Emphasized'

                  ).

      next-xml_popup = lo_popup->get_root( )->xml_get( ).
    ENDIF.


    client->set_next( next ).

  ENDMETHOD.


  METHOD z2ui5_set_data.

    mt_table = VALUE #(
        ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
             ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
             ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
             ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
             ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
             ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
             ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
             ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
    ).

  ENDMETHOD.

ENDCLASS.
