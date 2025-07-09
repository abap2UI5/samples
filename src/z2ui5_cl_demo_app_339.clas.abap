CLASS z2ui5_cl_demo_app_339 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_view_display TYPE abap_bool.
    DATA mo_parent_view  TYPE REF TO z2ui5_cl_xml_view.
    DATA mv_init         TYPE abap_bool.
    DATA mv_table        TYPE string.

    DATA mt_table_tmp    TYPE REF TO data.
    DATA mt_table        TYPE REF TO data.

    DATA mo_layout   TYPE REF TO z2ui5_cl_demo_app_333.

    METHODS set_app_data
      IMPORTING
        !table TYPE string.

  PROTECTED SECTION.
    METHODS on_init.
    METHODS on_event    IMPORTING !client TYPE REF TO z2ui5_if_client.

    METHODS render_main IMPORTING !client TYPE REF TO z2ui5_if_client.
    METHODS get_data.

  PRIVATE SECTION.
    METHODS get_comp
      RETURNING
        VALUE(result) TYPE abap_component_tab.
ENDCLASS.


CLASS z2ui5_cl_demo_app_339 IMPLEMENTATION.

  METHOD get_comp.

    DATA selkz TYPE abap_bool.

    IF mv_table IS INITIAL.
      mv_table = 'Z2UI5_T_01'.
    ENDIF.

    TRY.
        TRY.

            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = mv_table
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

  METHOD on_event.
    CASE client->get( )-event.

      WHEN 'SELECTION_CHANGE'.

    client->nav_app_call( Z2UI5_CL_DEMO_APP_340=>factory(
                            io_table  = mt_table
                            io_layout = mo_layout  ) ).

      WHEN 'BACK'.

        client->nav_app_leave( ).

    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

  ENDMETHOD.

  METHOD render_main.

    IF mo_parent_view IS INITIAL.

      DATA(page) = z2ui5_cl_xml_view=>factory( ).

    ELSE.

      page = mo_parent_view->get( `Page` ).

    ENDIF.

    mo_layout = z2ui5_cl_demo_app_333=>factory( i_data   = mt_table
                                                    vis_cols = 5 ).

    DATA(table) = page->table( width = 'auto'
                               mode  = 'SingleSelectLeft'
                               selectionchange  = client->_event( 'SELECTION_CHANGE' )
                               items = client->_bind_edit( val = mt_table->* ) ).

    DATA(columns) = table->columns( ).

    LOOP AT mo_layout->ms_data-t_layout REFERENCE INTO DATA(layout).
      DATA(lv_index) = sy-tabix.

      columns->column( visible = client->_bind( val       = layout->visible
                                                tab       = mo_layout->ms_data-t_layout
                                                tab_index = lv_index )
       )->text( layout->name ).

    ENDLOOP.

    DATA(column_list_item) = columns->get_parent( )->items(
                                       )->column_list_item( valign   = 'Middle'
                                                            type     = `Inactive`
                                                            selected = `{SELKZ}` ).

    DATA(cells) = column_list_item->cells( ).

    LOOP AT mo_layout->ms_data-t_layout REFERENCE INTO layout.

      lv_index = sy-tabix.

      cells->object_identifier( text = |\{{ layout->name }\}| ).  "."|\{{ layout->fname }\}| ).

    ENDLOOP.

    IF mo_parent_view IS INITIAL.

      client->view_display( page->get_root( )->xml_get( ) ).

    ELSE.

      mv_view_display = abap_true.

    ENDIF.
  ENDMETHOD.

  METHOD set_app_data.

    mv_table = table.

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    IF mv_init IS INITIAL.
      mv_init = abap_true.

      get_data( ).

      render_main( client ).

    ENDIF.

    IF mo_layout->mr_data->* <> mt_table->*.
      client->message_toast_display( 'ERROR - mo_layout->mr_data->* ne mt_table->*'  ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

  METHOD get_data.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.

    DATA(t_comp) = get_comp( ).
    TRY.

        DATA(new_struct_desc) = cl_abap_structdescr=>create( t_comp ).

        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_table     TYPE HANDLE new_table_desc.
        CREATE DATA mt_table_tmp TYPE HANDLE new_table_desc.

        ASSIGN mt_table->* TO <table>.

        SELECT *
          FROM (mv_table)
          INTO CORRESPONDING FIELDS OF TABLE @<table>
          UP TO 3 ROWS.

        SORT <table>.

      CATCH cx_root.

    ENDTRY.

    mt_table_tmp = mt_table.

  ENDMETHOD.

ENDCLASS.
