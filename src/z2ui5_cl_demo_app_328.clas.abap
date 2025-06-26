CLASS z2ui5_cl_demo_app_328 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_table     TYPE REF TO data.
    DATA mt_comp      TYPE cl_abap_structdescr=>component_table.
    DATA mo_table_obj TYPE REF TO z2ui5_cl_demo_app_329.

    DATA client       TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
    METHODS get_data.

  PRIVATE SECTION.
    METHODS ui5_view_display.
ENDCLASS.


CLASS z2ui5_cl_demo_app_328 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      get_data( ).

      mo_table_obj = z2ui5_cl_demo_app_329=>factory( mt_table ).

      ui5_view_display( ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( ).

      WHEN 'SELECTION_CHANGE' OR 'GO'.

        IF mt_table->* <> mo_table_obj->mr_data->*.
          client->message_toast_display( 'Error - MT_TABLE <> MO_TABLE_OBJ->MR_TABLE_DATA'  ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.

  METHOD ui5_view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell( )->page( title      = 'RTTI IV'
                                       navbuttonpress = client->_event( 'BACK' )
                                       shownavbutton  = client->check_app_prev_stack( ) ).

    page->button( text  = 'GO'
                  press = client->_event( 'GO' )
                  type  = 'Success' ).

    DATA(table) = page->table( growing         = 'true'
                               width           = 'auto'
                               items           = client->_bind( mt_table->* )
                               mode            = 'MultiSelect'
                               selectionchange = client->_event( 'SELECTION_CHANGE' ) ).

    DATA(columns) = table->columns( ).

    LOOP AT mt_comp INTO DATA(comp) WHERE name CP `ID*`.

      columns->column( )->text( comp-name ).

    ENDLOOP.

    DATA(cells) = columns->get_parent( )->items(
                                       )->column_list_item( valign = 'Middle'
                                                            type   = 'Navigation'
                                       )->cells( ).

    LOOP AT mt_comp INTO comp.
      cells->object_identifier( text = |\{{ comp-name }\}| ).
    ENDLOOP.

    client->view_display( page ).

  ENDMETHOD.

  METHOD get_data.
    DATA selkz TYPE abap_bool.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.

    mt_comp = z2ui5_cl_util=>rtti_get_t_attri_by_table_name( 'Z2UI5_T_01' ).

    APPEND LINES OF VALUE cl_abap_structdescr=>component_table(
                              ( name = 'SELKZ'
                                type = CAST #( cl_abap_datadescr=>describe_by_data( selkz ) ) ) ) TO mt_comp.

    TRY.

        DATA(new_struct_desc) = cl_abap_structdescr=>create( mt_comp ).

        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_table TYPE HANDLE new_table_desc.

        ASSIGN mt_table->* TO <table>.

        SELECT * FROM z2ui5_t_01
          INTO CORRESPONDING FIELDS OF TABLE @<table>
          UP TO 10 ROWS.

      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
