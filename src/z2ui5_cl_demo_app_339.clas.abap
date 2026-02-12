CLASS z2ui5_cl_demo_app_339 DEFINITION PUBLIC.
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
        !lo_table TYPE string.

  PROTECTED SECTION.
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

    DATA lv_selkz TYPE abap_bool.

    IF mv_table IS INITIAL.
      mv_table = `Z2UI5_T_01`.
    ENDIF.

    TRY.
        TRY.

            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = mv_table
                                                 RECEIVING p_descr_ref     = DATA(typedesc)
                                                 EXCEPTIONS type_not_found = 1
                                                            OTHERS         = 2 ).

            DATA(lv_structdesc) = CAST cl_abap_structdescr( typedesc ).

            DATA(lo_comp) = lv_structdesc->get_components( ).

            LOOP AT lo_comp INTO DATA(com).

              IF com-as_include = abap_false.

                APPEND com TO result.

              ENDIF.

            ENDLOOP.

          CATCH cx_root INTO DATA(root). " TODO: variable is assigned but never used (ABAP cleaner)

        ENDTRY.

        DATA(lv_component) = VALUE cl_abap_structdescr=>component_table(
                                    ( name = `SELKZ`
                                      type = CAST #( cl_abap_datadescr=>describe_by_data( lv_selkz ) ) ) ).

        APPEND LINES OF lv_component TO result.

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

  METHOD on_event.

    IF client->check_on_event( `SELECTION_CHANGE` ).

      client->nav_app_call( z2ui5_cl_demo_app_340=>factory(
                              io_table  = mt_table
                              io_layout = mo_layout ) ).
    ENDIF.
  ENDMETHOD.

  METHOD render_main.

    IF mo_parent_view IS INITIAL.

      DATA(lo_page) = z2ui5_cl_xml_view=>factory( ).

    ELSE.

      lo_page = mo_parent_view->get( `Page` ).

    ENDIF.

    mo_layout = z2ui5_cl_demo_app_333=>factory( i_data       = mt_table
                                                    vis_cols = 5 ).
    ASSIGN mt_table->* TO FIELD-SYMBOL(<lo_table>).

    DATA(lo_table) = lo_page->table( width           = `auto`
                               mode            = `SingleSelectLeft`
                               selectionchange = client->_event( `SELECTION_CHANGE` )
                               items           = client->_bind_edit( <lo_table> ) ).

    DATA(lo_columns) = lo_table->columns( ).

    LOOP AT mo_layout->ms_data-t_layout REFERENCE INTO DATA(layout).
      DATA(lv_index) = sy-tabix.

      lo_columns->column( visible = client->_bind( val       = layout->visible
                                                tab       = mo_layout->ms_data-t_layout
                                                tab_index = lv_index )
        )->text( layout->name ).

    ENDLOOP.

    DATA(lo_column_list_item) = lo_columns->get_parent( )->items(
                                       )->column_list_item( valign   = `Middle`
                                                            type     = `Inactive`
                                                            selected = `{SELKZ}` ).

    DATA(lo_cells) = lo_column_list_item->cells( ).

    LOOP AT mo_layout->ms_data-t_layout REFERENCE INTO layout.

      lv_index = sy-tabix.

      lo_cells->object_identifier( text = |\{{ layout->name }\}| ).  "."|\{{ layout->fname }\}| ).

    ENDLOOP.

    IF mo_parent_view IS INITIAL.

      client->view_display( lo_page->stringify( ) ).

    ELSE.

      mv_view_display = abap_true.

    ENDIF.
  ENDMETHOD.

  METHOD set_app_data.

    mv_table = lo_table.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    IF mv_init IS INITIAL.
      mv_init = abap_true.

      get_data( ).

      render_main( client ).

    ENDIF.

    ASSIGN mo_layout->mr_data->* TO FIELD-SYMBOL(<data>).
    ASSIGN mt_table->* TO FIELD-SYMBOL(<lo_table>).

    IF <data> <> <lo_table>.
      client->message_toast_display( `ERROR - mo_layout->mr_data->* ne mt_table->*` ).
    ENDIF.

    on_event( client ).
  ENDMETHOD.

  METHOD get_data.

    FIELD-SYMBOLS <lo_table> TYPE STANDARD TABLE.

    DATA(lt_comp) = get_comp( ).
    TRY.

        DATA(lv_new_struct_desc) = cl_abap_structdescr=>create( lt_comp ).

        DATA(lv_new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = lv_new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_table     TYPE HANDLE lv_new_table_desc.
        CREATE DATA mt_table_tmp TYPE HANDLE lv_new_table_desc.

        ASSIGN mt_table->* TO <lo_table>.

        SELECT *
          FROM (mv_table)
          INTO CORRESPONDING FIELDS OF TABLE @<lo_table>
          UP TO 3 ROWS.

        SORT <lo_table>.

      CATCH cx_root.

    ENDTRY.

    mt_table_tmp = mt_table.
  ENDMETHOD.
ENDCLASS.
