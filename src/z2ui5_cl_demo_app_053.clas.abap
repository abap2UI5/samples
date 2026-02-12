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

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS set_search.
    METHODS set_data.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_053 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client     = mo_client.

    IF mo_client->check_on_init( ).
      set_data( ).
      view_display( ).
      RETURN.
    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `BUTTON_SEARCH` OR `BUTTON_START`.
        set_data( ).
        set_search( ).
        mo_client->view_model_update( ).
    ENDCASE.
  ENDMETHOD.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_page) = lo_view->shell( )->page( id = `page_main`
            title                         = `abap2UI5 - Search with Enter`
            navbuttonpress                = mo_client->_event_nav_app_leave( )
            shownavbutton                 = mo_client->check_app_prev_stack( ) ).

    DATA(lo_vbox) = lo_page->vbox( ).

    lo_vbox->hbox( )->search_field(
         value  = mo_client->_bind_edit( mv_search_value )
         search = mo_client->_event( `BUTTON_SEARCH` )
         change = mo_client->_event( `BUTTON_SEARCH` )
*         livechange = client->__event( 'BUTTON_SEARCH' )
         width  = `17.5rem`
         id     = `SEARCH` )->button(
        text  = `Go`
        press = mo_client->_event( `BUTTON_START` )
        type  = `Emphasized` ).

    DATA(lo_tab) = lo_vbox->table( items = mo_client->_bind( mt_table ) ).

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

  METHOD set_search.

    IF mv_search_value IS NOT INITIAL.

      z2ui5_cl_util=>itab_filter_by_val(
        EXPORTING
          val = mv_search_value
        CHANGING
          tab = mt_table ).

    ENDIF.
  ENDMETHOD.
ENDCLASS.
