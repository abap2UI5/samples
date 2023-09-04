CLASS z2ui5_cl_demo_app_087 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        selkz            TYPE abap_bool,
        row_id           TYPE string,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
        meins            TYPE meins,
        price            TYPE p LENGTH 10 DECIMALS 2,
        waers            TYPE waers,
        selected         TYPE abap_bool,
        process          TYPE string,
        process_state    TYPE string,
      END OF ty_s_tab .
    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    DATA mv_product TYPE string.
    DATA mt_f4_table TYPE ty_t_table .

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_view_display.
    METHODS z2ui5_on_event.
    METHODS z2ui5_f4_set_data.
    METHODS z2ui5_display_f4_popup.

  PRIVATE SECTION.

ENDCLASS.



CLASS z2ui5_cl_demo_app_087 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_f4_set_data( ).
      z2ui5_view_display( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'F4'.
        z2ui5_display_f4_popup( ).

      WHEN 'CONFIRM'.
        DELETE mt_f4_table WHERE selkz <> abap_true.
        mv_product = VALUE #( mt_f4_table[ 1 ]-product OPTIONAL ).
        client->view_model_update( ).

      WHEN 'CANCEL'.
        client->popup_destroy( ).

      WHEN 'SEARCH'.
        DATA(lt_arg) = client->get( )-t_event_arg.
        READ TABLE lt_arg INTO DATA(ls_arg) INDEX 1.
        z2ui5_f4_set_data( ).
        LOOP AT mt_f4_table INTO DATA(ls_tab).
          IF ls_tab-product CS ls_arg.
            CONTINUE.
          ENDIF.
          DELETE mt_f4_table.
        ENDLOOP.
        client->popup_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( client ).
    DATA(page) = view->shell(
        )->page(
                title          = 'abap2UI5 - Table Select Dialog'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton  = abap_true
            )->header_content(
                )->link( text = 'Source_Code' target = '_blank' href = view->hlp_get_source_code_url( )
           )->get_parent( ).

    page->input( value = client->_bind_edit( mv_product ) editable = abap_true
                 valuehelprequest = client->_event( 'F4' ) showvaluehelp = abap_true ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_f4_set_data.

    mt_f4_table = VALUE #(
        ( selkz = abap_false row_id = '1' product = 'table'    create_date = `01.01.2023` create_by = `Olaf` storage_location = `AREA_001` quantity = 400  meins = 'ST' price = '1000.50' waers = 'EUR' process = '10'  process_state = 'None' )
        ( selkz = abap_false row_id = '2' product = 'chair'    create_date = `01.01.2022` create_by = `Karlo` storage_location = `AREA_001` quantity = 123   meins = 'ST' price = '2000.55' waers = 'USD' process = '20' process_state = 'Warning' )
        ( selkz = abap_false row_id = '3' product = 'sofa'     create_date = `01.05.2021` create_by = `Elin` storage_location = `AREA_002` quantity = 700   meins = 'ST' price = '3000.11' waers = 'CNY' process = '30' process_state = 'Success' )
        ( selkz = abap_false row_id = '4' product = 'computer' create_date = `27.01.2023` create_by = `Theo` storage_location = `AREA_002` quantity = 200  meins = 'ST' price = '4000.88' waers = 'USD' process = '40' process_state = 'Information' )
        ( selkz = abap_false row_id = '5' product = 'printer'  create_date = `01.01.2023` create_by = `Renate` storage_location = `AREA_003` quantity = 90   meins = 'ST' price = '5000.47' waers = 'EUR' process = '70' process_state = 'Warning' )
        ( selkz = abap_false row_id = '6' product = 'table2'   create_date = `01.01.2023` create_by = `Angela` storage_location = `AREA_003` quantity = 110  meins = 'ST' price = '6000.33' waers = 'GBP' process = '90'  process_state = 'Error' )
    ).

  ENDMETHOD.

  METHOD z2ui5_display_f4_popup.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( client ).

    popup = popup->table_select_dialog(
              items              =  `{path:'` && client->_bind_edit( val = mt_f4_table path = abap_true ) && `', sorter : { path : 'STORAGE_LOCATION', descending : false } }`
              cancel             = client->_event( 'CANCEL' )
              search             = client->_event( val = 'SEARCH' t_arg = VALUE #( ( `${$parameters>/value}` ) ( `${$parameters>/clearButtonPressed}`  ) ) )
              confirm            = client->_event( val = 'CONFIRM' t_arg = VALUE #( ( `${$parameters>/selectedContexts[0]/sPath}` ) ) )
            ).

    popup = popup->column_list_item( valign = `Top` selected = `{SELKZ}`
              )->cells(
                )->text( text = `{PRODUCT}`
                )->text( text = `{STORAGE_LOCATION}` )->get_parent( )->get_parent(
              )->columns(
      )->column( width = '8rem' )->header( ns = `` )->text( text = `Product` )->get_parent( )->get_parent(
      )->column( width = '8rem' )->header( ns = `` )->text( text = `Storage Location ` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
