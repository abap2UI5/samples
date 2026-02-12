CLASS z2ui5_cl_demo_app_345 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_data1       TYPE REF TO data.

    DATA mo_layout_obj1 TYPE REF TO z2ui5_cl_demo_app_333.

    METHODS get_data.

    METHODS render_main
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
      RETURNING
        VALUE(result) TYPE abap_component_tab.

ENDCLASS.

CLASS z2ui5_cl_demo_app_345 IMPLEMENTATION.

  METHOD get_comp.

    TRY.
        TRY.

            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = `Z2UI5_T_01`
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

          CATCH cx_root.
        ENDTRY.

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

  METHOD get_data.

    FIELD-SYMBOLS <table1> TYPE STANDARD TABLE.

    DATA(lt_comp) = get_comp( ).
    TRY.

        DATA(lv_new_struct_desc) = cl_abap_structdescr=>create( lt_comp ).
        DATA(lv_new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = lv_new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_data1 TYPE HANDLE lv_new_table_desc.
        ASSIGN mt_data1->* TO <table1>.

        SELECT * FROM z2ui5_t_01
          INTO TABLE @<table1>
          UP TO 5 ROWS.

      CATCH cx_root.
    ENDTRY.

    mo_layout_obj1 = z2ui5_cl_demo_app_333=>factory( i_data   = mt_data1
                                                     vis_cols = 2 ).
  ENDMETHOD.

  METHOD render_main.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell( )->page( title          = `RTTI IV`
                                                                navbuttonpress = client->_event_nav_app_leave( )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    lo_page->button( text  = `CALL Next App`
                  press = client->_event( `GO` )
                  type  = `Success` ).

    xml_table( i_page = lo_page
      i_client        = client
      i_data          = mt_data1
      i_layout        = mo_layout_obj1 ).

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD xml_table.

    ASSIGN i_data->* TO FIELD-SYMBOL(<data>).

    DATA(lo_table) = i_page->table( width = `auto`
                                 items = i_client->_bind( <data> ) ).

    DATA(lo_columns) = lo_table->columns( ).

    LOOP AT i_layout->ms_data-t_layout REFERENCE INTO DATA(layout).
      DATA(lv_index) = sy-tabix.

      lo_columns->column( visible = i_client->_bind( val       = layout->visible
                                                  tab       = i_layout->ms_data-t_layout
                                                  tab_index = lv_index )
        )->text( layout->name ).

    ENDLOOP.

    DATA(lo_column_list_item) = lo_columns->get_parent( )->items(
                                       )->column_list_item( ).

    DATA(lo_cells) = lo_column_list_item->cells( ).

    LOOP AT i_layout->ms_data-t_layout REFERENCE INTO layout.

      lv_index = sy-tabix.

      lo_cells->object_identifier( text = |\{{ layout->name }\}| ).  "."|\{{ layout->fname }\}| ).

    ENDLOOP.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      get_data( ).
      render_main( client ).
    ENDIF.

    IF client->check_on_event( `GO` ).
      DATA(lo_app) = z2ui5_cl_demo_app_336=>factory( ).
      client->nav_app_call( lo_app ).
    ENDIF.

    IF client->get( )-check_on_navigated = abap_true
        AND client->check_on_init( )          = abap_false.
      render_main( client ).
    ENDIF.

    IF mo_layout_obj1->mr_data IS NOT BOUND.
      client->message_toast_display( `ERROR - mo_layout_obj->mr_data is not bound!` ).
    ENDIF.

    ASSIGN mt_data1->* TO FIELD-SYMBOL(<lo_table>).
    ASSIGN mo_layout_obj1->mr_data->* TO FIELD-SYMBOL(<val>).
    IF <val> <> <lo_table>.
      client->message_toast_display( `ERROR - mo_layout_obj_2->mr_data  <> mt_data!` ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
