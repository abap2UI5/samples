CLASS z2ui5_cl_demo_app_059 DEFINITION PUBLIC.

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

*    DATA mv_search_value TYPE string.
    DATA mt_table TYPE ty_t_table.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS set_data.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_059 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF client->check_on_init( ).
      set_data( ).
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    me->client = client.

    IF client->check_on_event( `BUTTON_SEARCH` ).
      set_data( ).
      z2ui5_cl_util=>itab_filter_by_val(
          EXPORTING
              val = client->get_event_arg( 1 )
          CHANGING
              tab = mt_table ).

      client->view_model_update( ).
    ENDIF.

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


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page1) = view->shell( )->page( id = `page_main`
            title                          = `abap2UI5 - Search Field with Backend Live Change`
            navbuttonpress                 = client->_event_nav_app_leave( )
            shownavbutton                  = client->check_app_prev_stack( ) ).

    DATA(lo_box) = page1->vbox( )->text( `Search`
        )->search_field( width      = `17.5rem`
                         livechange = client->_event(
            val    = `BUTTON_SEARCH`
            t_arg  = VALUE #( ( `${$source>/value}` ) )
            s_ctrl = VALUE #( check_allow_multi_req = abap_true ) ) ).

    DATA(tab) = lo_box->table( client->_bind( mt_table ) ).
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

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
