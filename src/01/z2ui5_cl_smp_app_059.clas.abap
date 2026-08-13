" @keywords live search parallel requests busy queue typing
CLASS z2ui5_cl_smp_app_059 DEFINITION PUBLIC.

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
    DATA mv_field TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS set_data.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_059 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      set_data( ).
      view_display( ).

    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `BUTTON_SEARCH` ).

      set_data( ).
      z2ui5_cl_smp_context=>itab_filter_by_val(
        EXPORTING
          val = mv_field
        CHANGING
          tab = mt_table ).

    ENDIF.

  ENDMETHOD.


  METHOD set_data.

    mt_table = VALUE #( ).
    DO 1000 TIMES.
      INSERT LINES OF VALUE ty_t_table(
          ( product = `table` create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
          ( product = `chair` create_date = `01.01.2022` create_by = `James` storage_location = `AREA_001` quantity = 123 )
          ( product = `sofa` create_date = `01.05.2021` create_by = `Simone` storage_location = `AREA_001` quantity = 700 )
          ( product = `computer` create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_001` quantity = 200 )
          ( product = `printer` create_date = `01.01.2023` create_by = `Hannah` storage_location = `AREA_001` quantity = 90 )
          ( product = `table2` create_date = `01.01.2023` create_by = `Julia` storage_location = `AREA_001` quantity = 110 )
          ) INTO TABLE mt_table.

    ENDDO.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page1) = view->shell( )->page(
        id             = `page_main`
        title          = `abap2UI5 - Table - Live Search with Parallel Requests`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    page1->message_strip(
        text     = `By default abap2UI5 handles only one backend request at a time - the app is set busy and further ` &&
                   `requests are ignored until the running one is finished. A live search needs the opposite: only the ` &&
                   `newest request matters and older ones can be dropped. Set check_allow_multi_req on the event to ` &&
                   `allow that - type in both fields and compare.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    DATA(lo_box) = page1->hbox( class = `sapUiSmallMarginBegin` ).

    lo_box->vbox( )->text( `Search disabled parallel (default)`
        )->search_field(
            width       = `17.5rem`
            placeholder = `Search products`
            value       = client->_bind( mv_field )
            livechange  = client->_event( `BUTTON_SEARCH` ) ).

    lo_box->vbox( )->text( `Search parallel`
        )->search_field(
            width       = `17.5rem`
            placeholder = `Search products`
            value       = client->_bind( mv_field )
            livechange  = client->_event(
                val    = `BUTTON_SEARCH`
                s_ctrl = VALUE #( check_allow_multi_req = abap_true ) ) ).

    DATA(tab) = page1->table( client->_bind( mt_table ) ).
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
