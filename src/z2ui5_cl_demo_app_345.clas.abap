CLASS z2ui5_cl_demo_app_345 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_data1       TYPE REF TO data.
*    DATA mt_data2       TYPE REF TO data.
*    DATA mt_data3       TYPE REF TO data.
*    DATA mt_data4       TYPE REF TO data.
*    DATA mt_data5       TYPE REF TO data.
*    DATA mt_data6       TYPE REF TO data.

    DATA mo_layout_obj1 TYPE REF TO z2ui5_cl_demo_app_333.
*    DATA mo_layout_obj2 TYPE REF TO z2ui5_cl_demo_app_333.
*    DATA mo_layout_obj3 TYPE REF TO z2ui5_cl_demo_app_333.
*    DATA mo_layout_obj4 TYPE REF TO z2ui5_cl_demo_app_333.
*    DATA mo_layout_obj5 TYPE REF TO z2ui5_cl_demo_app_333.
*    DATA mo_layout_obj6 TYPE REF TO z2ui5_cl_demo_app_333.

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

            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = 'Z2UI5_T_01'
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

          CATCH cx_root.
        ENDTRY.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD get_data.

    FIELD-SYMBOLS <table1> TYPE STANDARD TABLE.

    DATA(t_comp) = get_comp( ).
    TRY.

        DATA(new_struct_desc) = cl_abap_structdescr=>create( t_comp ).
        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_data1 TYPE HANDLE new_table_desc.
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

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell( )->page( title          = 'RTTI IV'
                                                                navbuttonpress = client->_event( 'BACK' )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    page->button( text  = 'CALL Next App'
                  press = client->_event( 'GO' )
                  type  = 'Success' ).


    TRY.
        xml_table( i_page   = page
          i_client = client
          i_data   = mt_data1
          i_layout = mo_layout_obj1 ).
        client->message_box_display( `error - reference processed in binding without error` ).
      CATCH cx_root.
        client->message_box_display( `success - reference not allowed for binding throwed` ).
    ENDTRY.


    client->view_display( page ).

  ENDMETHOD.


  METHOD xml_table.

    DATA(table) = i_page->table( width = 'auto'
                                 items = i_client->_bind( val = i_data ) ).

    DATA(columns) = table->columns( ).

    LOOP AT i_layout->ms_data-t_layout REFERENCE INTO DATA(layout).
      DATA(lv_index) = sy-tabix.

      columns->column( visible = i_client->_bind( val       = layout->visible
                                                  tab       = i_layout->ms_data-t_layout
                                                  tab_index = lv_index )
       )->text( layout->name ).

    ENDLOOP.

    DATA(column_list_item) = columns->get_parent( )->items(
                                       )->column_list_item(    ).

    DATA(cells) = column_list_item->cells( ).

    LOOP AT i_layout->ms_data-t_layout REFERENCE INTO layout.

      lv_index = sy-tabix.

      cells->object_identifier( text = |\{{ layout->name }\}| ).  "."|\{{ layout->fname }\}| ).

    ENDLOOP.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      get_data( ).
      render_main( client ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'GO'.
        DATA(app) = z2ui5_cl_demo_app_336=>factory( ).
        client->nav_app_call( app ).
    ENDCASE.


    IF client->get( )-check_on_navigated = abap_true
       AND client->check_on_init( )          = abap_false.
      render_main( client ).
    ENDIF.


    IF mo_layout_obj1->mr_data IS NOT BOUND.
      client->message_toast_display( 'ERROR - mo_layout_obj->mr_data is not bound!' ).
    ENDIF.

    ASSIGN mt_data1->* TO FIELD-SYMBOL(<table>).
    ASSIGN mo_layout_obj1->mr_data->* TO FIELD-SYMBOL(<val>).
    IF <val> <> <table>.
      client->message_toast_display( 'ERROR - mo_layout_obj_2->mr_data  <> mt_data!' ).
    ENDIF.


  ENDMETHOD.
ENDCLASS.
