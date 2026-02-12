CLASS z2ui5_cl_demo_app_344 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_data        TYPE REF TO data.
    DATA mt_data2       TYPE REF TO data.

    DATA mo_layout_obj  TYPE REF TO z2ui5_cl_demo_app_333.
    DATA mo_layout_obj2 TYPE REF TO z2ui5_cl_demo_app_333.

    METHODS get_data  IMPORTING iv_tabname TYPE string.
    METHODS get_data2 IMPORTING iv_tabname TYPE string.

    METHODS view_display
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

CLASS z2ui5_cl_demo_app_344 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      get_data( `Z2UI5_T_01` ).
      get_data2( `Z2UI5_T_01` ).

      mo_layout_obj = z2ui5_cl_demo_app_333=>factory( i_data   = mt_data
                                                      vis_cols = 5 ).
      mo_layout_obj2 = z2ui5_cl_demo_app_333=>factory( i_data   = mt_data2
                                                       vis_cols = 3 ).

      view_display( client ).
    ENDIF.

    IF client->check_on_event( `GO` ).
      DATA(lo_app) = z2ui5_cl_demo_app_336=>factory( ).
      client->nav_app_call( lo_app ).
    ENDIF.

***    " Kommen wir aus einer anderen APP
***    IF client->get( )-check_on_navigated = abap_true.
***      TRY.
***          " Kommen wir aus einer anderen APP
***          CAST z2ui5_cl_demo_app_336( client->get_app( client->get( )-s_draft-id_prev_app ) ).
***
***        CATCH cx_root.
***      ENDTRY.
***    ENDIF.

    IF client->get( )-check_on_navigated = abap_true
        AND client->check_on_init( )          = abap_false.
      view_display( client ).
    ENDIF.

    IF mo_layout_obj->mr_data IS NOT BOUND.
      client->message_toast_display( `ERROR - mo_layout_obj->mr_data is not bound!` ).
    ENDIF.
    IF mo_layout_obj2->mr_data IS NOT BOUND.
      client->message_toast_display( `ERROR - mo_layout_obj_2->mr_data  is not bound!` ).
    ENDIF.

    ASSIGN mt_data->* TO FIELD-SYMBOL(<lo_table>).
    ASSIGN mo_layout_obj->mr_data->* TO FIELD-SYMBOL(<val>).
    IF <val> <> <lo_table>.
      client->message_toast_display( `ERROR - mo_layout_obj_2->mr_data  <> mt_data!` ).
    ENDIF.

    ASSIGN mt_data2->* TO FIELD-SYMBOL(<table2>).
    ASSIGN mo_layout_obj2->mr_data->* TO FIELD-SYMBOL(<val2>).
    IF <table2> <> <val2>.
      client->message_toast_display( `ERROR - mo_layout_obj_2->mr_data  <> ms_data!` ).
    ENDIF.

    client->view_model_update( ).
  ENDMETHOD.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell( )->page( title          = `RTTI IV`
                                                                navbuttonpress = client->_event_nav_app_leave( )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    lo_page->button( text  = `CALL Next App`
                  press = client->_event( `GO` )
                  type  = `Success` ).

    xml_table( i_page   = lo_page
               i_client = client
               i_data   = mt_data
               i_layout = mo_layout_obj ).

    xml_table( i_page   = lo_page
               i_client = client
               i_data   = mt_data2
               i_layout = mo_layout_obj2 ).

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD xml_table.

    ASSIGN i_data->* TO FIELD-SYMBOL(<lo_table>).
    DATA(lo_table) = i_page->table( width = `auto`
                                 items = i_client->_bind_edit( <lo_table> ) ).

    DATA(lo_columns) = lo_table->columns( ).

    LOOP AT i_layout->ms_data-t_layout REFERENCE INTO DATA(layout).
      DATA(lv_index) = sy-tabix.

      lo_columns->column( visible = i_client->_bind( val       = layout->visible
                                                  tab       = i_layout->ms_data-t_layout
                                                  tab_index = lv_index )
        )->text( layout->name ).

    ENDLOOP.

    DATA(lo_column_list_item) = lo_columns->get_parent( )->items(
                                       )->column_list_item( valign = `Middle`
                                                            type   = `Inactive` ).

    DATA(lo_cells) = lo_column_list_item->cells( ).

    LOOP AT i_layout->ms_data-t_layout REFERENCE INTO layout.

      lv_index = sy-tabix.

      lo_cells->object_identifier( text = |\{{ layout->name }\}| ).  "."|\{{ layout->fname }\}| ).

    ENDLOOP.
  ENDMETHOD.

  METHOD get_data.

    FIELD-SYMBOLS <lo_table> TYPE STANDARD TABLE.

    DATA(lt_comp) = get_comp( iv_tabname ).
    TRY.

        DATA(lv_new_struct_desc) = cl_abap_structdescr=>create( lt_comp ).

        DATA(lv_new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = lv_new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_data TYPE HANDLE lv_new_table_desc.

        ASSIGN mt_data->* TO <lo_table>.

        SELECT *
          FROM (iv_tabname)
          INTO CORRESPONDING FIELDS OF TABLE @<lo_table>
          UP TO 3 ROWS.

        SORT <lo_table>.

      CATCH cx_root.

    ENDTRY.
  ENDMETHOD.

  METHOD get_data2.

    FIELD-SYMBOLS <lo_table> TYPE STANDARD TABLE.

    DATA(lt_comp) = get_comp( iv_tabname ).
    TRY.

        DATA(lv_new_struct_desc) = cl_abap_structdescr=>create( lt_comp ).

        DATA(lv_new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = lv_new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_data2 TYPE HANDLE lv_new_table_desc.

        ASSIGN mt_data2->* TO <lo_table>.

        SELECT *
          FROM (iv_tabname)
          INTO CORRESPONDING FIELDS OF TABLE @<lo_table>
          UP TO 4 ROWS.

        SORT <lo_table>.

      CATCH cx_root.

    ENDTRY.
  ENDMETHOD.

  METHOD get_comp.

    DATA lv_selkz TYPE abap_bool.

    TRY.
        TRY.

            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = iv_tabname
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
ENDCLASS.
