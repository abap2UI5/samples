CLASS z2ui5_cl_demo_app_053 DEFINITION PUBLIC.

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

    DATA mv_search_value TYPE string.
    DATA mt_table TYPE ty_t_table.


  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS view_display.
    METHODS on_event.
    METHODS z2ui5_set_search.
    METHODS set_data.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_053 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      set_data( ).
      view_display( ).
      RETURN.
    ENDIF.

    on_event( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'BUTTON_SEARCH' OR 'BUTTON_START'.
        set_data( ).
        z2ui5_set_search( ).
        client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page( id = `page_main`
            title                         = 'abap2UI5 - Search with Enter'
            navbuttonpress                = client->_event( 'BACK' )
            shownavbutton                 = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(vbox) = page->vbox( ).

    vbox->hbox( )->search_field(
         value  = client->_bind_edit( mv_search_value )
         search = client->_event( 'BUTTON_SEARCH' )
         change = client->_event( 'BUTTON_SEARCH' )
*         livechange = client->__event( 'BUTTON_SEARCH' )
         width  = `17.5rem`
         id     = `SEARCH` )->button(
        text  = `Go`
        press = client->_event( `BUTTON_START` )
        type  = `Emphasized` ).

    DATA(tab) = vbox->table( items = client->_bind( val = mt_table ) ).

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

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD set_data.

    mt_table = VALUE #(
        ( product = 'table' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair' create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
        ( product = 'sofa' create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
        ( product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
        ( product = 'printer' create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
        ( product = 'table2' create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 ) ).

  ENDMETHOD.


  METHOD z2ui5_set_search.

    IF mv_search_value IS NOT INITIAL.

      z2ui5_cl_util=>itab_filter_by_val(
        EXPORTING
          val = mv_search_value
        CHANGING
          tab = mt_table ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
