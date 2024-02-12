CLASS z2ui5_cl_demo_app_165 DEFINITION PUBLIC.

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
    DATA mt_layout TYPE z2ui5_cl_popup_layout=>ty_t_layout.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA mv_check_initialized TYPE abap_bool.
    METHODS on_event.
    METHODS view_display.
    METHODS set_data.

  PRIVATE SECTION.

ENDCLASS.


CLASS z2ui5_cl_demo_app_165 IMPLEMENTATION.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `BUTTON_START`.
        client->nav_app_call( z2ui5_cl_popup_layout=>factory( i_tab = mt_table t_layout = mt_layout ) ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD set_data.

    "replace this with a db select here...
    mt_table = VALUE #(
        ( product = 'table'    create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair'    create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'sofa'     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'sofa'     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'sofa'     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'computer' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'oven'     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'table2'   create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
    ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view = view->shell( )->page( id = `page_main`
             title          = 'abap2UI5 - Popup Layout'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
         )->header_content(
             )->link(
                 text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->get_parent( ).

    DATA(vbox) = view->vbox( ).

    DATA(tab) = vbox->table(
        items = client->_bind( val = mt_table )
           )->header_toolbar(
             )->overflow_toolbar(
                 )->toolbar_spacer(
           )->button(  text = `Popup Layout` press = client->_event( `BUTTON_START` ) type = `Emphasized`
            )->get_parent( )->get_parent( ).

    DATA(lo_columns) = tab->columns( ).
    LOOP AT mt_layout REFERENCE INTO DATA(lr_layout).
      DATA(lv_index) = sy-tabix.

      DATA(lo_col) = lo_columns->column(
        visible         = client->_bind( val = lr_layout->visible         tab = mt_layout tab_index = lv_index )
        mergeduplicates = client->_bind( val = lr_layout->mergeduplicates tab = mt_layout tab_index = lv_index ) ).

      lo_col->text( text = lr_layout->name ).

    ENDLOOP.

    DATA(lo_cells) = tab->items( )->column_list_item( ).
    LOOP AT mt_layout REFERENCE INTO lr_layout.
      lo_cells->text( `{` && lr_layout->name && `}`  ).
    ENDLOOP.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF mv_check_initialized = abap_false.
      mv_check_initialized = abap_true.
      DATA(ls_result) = z2ui5_cl_popup_layout=>factory( i_tab = mt_table )->ms_result.
      mt_layout = ls_result-t_layout.
      set_data( ).
      view_display( ).
      RETURN.
    ENDIF.

    IF client->get( )-check_on_navigated = abap_true.
      TRY.
          DATA(lo_popup_layout) = CAST z2ui5_cl_popup_layout( client->get_app( client->get( )-s_draft-id_prev_app ) ).
          mt_layout = lo_popup_layout->result( )-t_layout.
          client->view_model_update( ).
        CATCH cx_root.
      ENDTRY.
      RETURN.
    ENDIF.

    IF client->get( )-event IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
