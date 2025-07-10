CLASS z2ui5_cl_demo_app_343 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_data        TYPE REF TO data.
    DATA mt_data2       TYPE REF TO data.

    DATA mo_layout_obj  TYPE REF TO z2ui5_cl_demo_app_333.
    DATA mo_layout_obj2 TYPE REF TO z2ui5_cl_demo_app_333.

    METHODS get_data  IMPORTING iv_tabname TYPE string.
    METHODS get_data2 IMPORTING iv_tabname TYPE string.

    METHODS ui5_view_display
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS xml_table
      IMPORTING
        i_page   TYPE REF TO z2ui5_cl_xml_view
        i_client TYPE REF TO z2ui5_if_client
        i_data   TYPE REF TO data
        i_layout TYPE REF TO z2ui5_cl_demo_app_333.

    METHODS get_comp
      IMPORTING
        iv_tabname    TYPE string
      RETURNING
        VALUE(result) TYPE abap_component_tab.

ENDCLASS.


CLASS z2ui5_cl_demo_app_343 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      get_data( 'Z2UI5_T_01' ).
      get_data2( 'Z2UI5_T_01' ).

      mo_layout_obj = z2ui5_cl_demo_app_333=>factory( i_data   =  mt_data
                                                      vis_cols = 5 ).
      mo_layout_obj2 = z2ui5_cl_demo_app_333=>factory( i_data   =  mt_data2
                                                       vis_cols = 3 ).

      ui5_view_display( client ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'GO'.
        DATA(app) = z2ui5_cl_demo_app_336=>factory( ).
        client->nav_app_call( app ).
    ENDCASE.

***    " Kommen wir aus einer anderen APP
***    IF client->get( )-check_on_navigated = abap_true.
***      TRY.
***          " Kommen wir aus einer anderen APP
***          CAST z2ui5_cl_demo_app_336( client->get_app( client->get( )-s_draft-id_prev_app ) ).
***
***        CATCH cx_root.
***      ENDTRY.
***    ENDIF.


    IF     client->get( )-check_on_navigated = abap_true
       AND client->check_on_init( )          = abap_false.
      ui5_view_display( client ).
    ENDIF.


    IF mo_layout_obj->mr_data IS NOT BOUND.
      client->message_toast_display( 'ERROR - mo_layout_obj->mr_data is not bound!' ).
    ENDIF.
    IF mo_layout_obj2->mr_data IS NOT BOUND.
      client->message_toast_display( 'ERROR - mo_layout_obj_2->mr_data  is not bound!' ).
    ENDIF.
    IF mo_layout_obj->mr_data->* <> mt_data->*.
      client->message_toast_display( 'ERROR - mo_layout_obj_2->mr_data  <> mt_data!' ).
    ENDIF.
    IF mo_layout_obj2->mr_data->* <> mt_data2->*.
      client->message_toast_display( 'ERROR - mo_layout_obj_2->mr_data  <> ms_data!' ).
    ENDIF.

    client->view_model_update( ).

  ENDMETHOD.

  METHOD ui5_view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell( )->page( title          = 'RTTI IV'
                                                                navbuttonpress = client->_event( 'BACK' )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    page->button( text  = 'CALL Next App'
                  press = client->_event( 'GO' )
                  type  = 'Success' ).

    xml_table( i_page   = page
               i_client = client
               i_data   = mt_data
               i_layout = mo_layout_obj ).

    xml_table( i_page   = page
               i_client = client
               i_data   = mt_data2
               i_layout = mo_layout_obj2 ).

    client->view_display( page ).

  ENDMETHOD.

  METHOD xml_table.

    DATA(table) = i_page->table( width = 'auto'
                                 items = i_client->_bind_edit( val = i_data ) ).

    DATA(columns) = table->columns( ).

    LOOP AT i_layout->ms_data-t_layout REFERENCE INTO DATA(layout).
      DATA(lv_index) = sy-tabix.

      columns->column( visible = i_client->_bind( val       = layout->visible
                                                  tab       = i_layout->ms_data-t_layout
                                                  tab_index = lv_index )
       )->text( layout->name ).

    ENDLOOP.

    DATA(column_list_item) = columns->get_parent( )->items(
                                       )->column_list_item( valign = 'Middle'
                                                            type   = `Inactive`   ).

    DATA(cells) = column_list_item->cells( ).

    LOOP AT i_layout->ms_data-t_layout REFERENCE INTO layout.

      lv_index = sy-tabix.

      cells->object_identifier( text = |\{{ layout->name }\}| ).  "."|\{{ layout->fname }\}| ).

    ENDLOOP.

  ENDMETHOD.

  METHOD get_data.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.

    DATA(t_comp) = get_comp( iv_tabname ).
    TRY.

        DATA(new_struct_desc) = cl_abap_structdescr=>create( t_comp ).

        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_DATA TYPE HANDLE new_table_desc.

        ASSIGN mt_DATA->* TO <table>.

        SELECT *
          FROM (iv_tabname)
          INTO CORRESPONDING FIELDS OF TABLE @<table>
          UP TO 3 ROWS.

        SORT <table>.

      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.

  METHOD get_data2.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.

    DATA(t_comp) = get_comp( iv_tabname ).
    TRY.

        DATA(new_struct_desc) = cl_abap_structdescr=>create( t_comp ).

        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_DATA2 TYPE HANDLE new_table_desc.

        ASSIGN mt_DATA2->* TO <table>.

        SELECT *
          FROM (iv_tabname)
          INTO CORRESPONDING FIELDS OF TABLE @<table>
          UP TO 4 ROWS.

        SORT <table>.

      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.

  METHOD get_comp.

    DATA selkz TYPE abap_bool.

    TRY.
        TRY.

            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = iv_tabname
                                                 RECEIVING  p_descr_ref    = DATA(typedesc)
                                                 EXCEPTIONS type_not_found = 1
                                                            OTHERS         = 2 ).

            DATA(structdesc) = CAST cl_abap_structdescr( typedesc ).

            DATA(comp) = structdesc->get_components( ).

            LOOP AT comp INTO DATA(com).

              IF com-as_include = abap_false.

                APPEND com TO result.

              ENDIF.

            ENDLOOP.

          CATCH cx_root INTO DATA(root). " TODO: variable is assigned but never used (ABAP cleaner)

        ENDTRY.

        DATA(component) = VALUE cl_abap_structdescr=>component_table(
                                    ( name = 'SELKZ'
                                      type = CAST #( cl_abap_datadescr=>describe_by_data( selkz ) ) ) ).

        APPEND LINES OF component TO result.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
