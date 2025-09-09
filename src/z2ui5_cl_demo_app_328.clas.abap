CLASS z2ui5_cl_demo_app_328 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_table     TYPE REF TO data.
    DATA mo_table_obj TYPE REF TO z2ui5_cl_demo_app_329.

    METHODS get_data.

    METHODS ui5_view_display
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_328 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    FIELD-SYMBOLS <line> TYPE any.
    FIELD-SYMBOLS: <tab> TYPE ANY TABLE.

    IF client->check_on_init( ) IS NOT INITIAL.
      get_data( ).
      mo_table_obj = z2ui5_cl_demo_app_329=>factory( mt_table ).
      ui5_view_display( client ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( ).

      WHEN 'SELECTION_CHANGE'.

        client->view_model_update( ).

*        IF mt_table->* <> mo_table_obj->mr_data->*.
*          client->message_toast_display( 'Error - MT_TABLE <> MO_TABLE_OBJ->MR_TABLE_DATA'  ).
*       ELSE.
*          client->message_toast_display( 'Success - MT_TABLE = MO_TABLE_OBJ->MR_TABLE_DATA'  ).
*        ENDIF.

      WHEN 'GO'.

        ASSIGN mt_table->* TO <tab>.

        LOOP AT <tab> ASSIGNING <line>.

          FIELD-SYMBOLS <selkz> TYPE any.
          ASSIGN COMPONENT 'SELKZ' OF STRUCTURE <line> TO <selkz>.
          IF <selkz> IS NOT ASSIGNED.
            CONTINUE.
          ENDIF.

          IF <selkz> = abap_true.
            DATA okay LIKE abap_true.
            okay = abap_true.
            EXIT.
          ENDIF.

        ENDLOOP.

        IF okay = abap_true.

          get_data( ).
          mo_table_obj = z2ui5_cl_demo_app_329=>factory( mt_table ).
          ui5_view_display( client ).

          FIELD-SYMBOLS <table> TYPE data.
          ASSIGN mt_table->* TO <table>.
          FIELD-SYMBOLS <val> TYPE data.
          ASSIGN mo_table_obj->mr_data->* TO <val>.

          IF <table> <> <val>.
            client->message_toast_display( 'Error - MT_TABLE <> MO_TABLE_OBJ->MR_TABLE_DATA'  ).
          ELSE.
            client->message_toast_display( 'Success - MT_TABLE = MO_TABLE_OBJ->MR_TABLE_DATA'  ).
          ENDIF.

        ELSE.
          client->message_toast_display( 'Plases select a Line'  ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.

  METHOD ui5_view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell( )->page( title          = 'RTTI IV'
                                                                navbuttonpress = client->_event( 'BACK' )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    page->button( text  = 'GO'
                  press = client->_event( 'GO' )
                  type  = 'Success' ).


    FIELD-SYMBOLS <table> TYPE data.
    ASSIGN mt_table->* TO <table>.
    page->table( headertext      = 'Table'
                 mode            = 'MultiSelect'
                 items           = client->_bind_edit( <table> )
                 selectionchange = client->_event( 'SELECTION_CHANGE' )
              )->columns(
                  )->column( )->text( 'id '
              )->get_parent( )->get_parent(
              )->items(
                  )->column_list_item( selected = '{SELKZ}'
                      )->cells(
                          )->text( '{ID}' ).

    client->view_display( page ).

  ENDMETHOD.

  METHOD get_data.

    DATA selkz TYPE abap_bool.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.

    DATA t_comp TYPE abap_component_tab.
    t_comp = z2ui5_cl_util=>rtti_get_t_attri_by_table_name( 'Z2UI5_T_01' ).

    DATA temp1 TYPE cl_abap_structdescr=>component_table.
    CLEAR temp1.
    DATA temp2 LIKE LINE OF temp1.
    temp2-name = 'SELKZ'.
    DATA temp3 TYPE REF TO cl_abap_datadescr.
    temp3 ?= cl_abap_datadescr=>describe_by_data( selkz ).
    temp2-type = temp3.
    INSERT temp2 INTO TABLE temp1.
    APPEND LINES OF temp1 TO t_comp.

    TRY.

        DATA new_struct_desc TYPE REF TO cl_abap_structdescr.
        new_struct_desc = cl_abap_structdescr=>create( t_comp ).

        DATA new_table_desc TYPE REF TO cl_abap_tabledescr.
        new_table_desc = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_table TYPE HANDLE new_table_desc.

        ASSIGN mt_table->* TO <table>.

        SELECT id FROM z2ui5_t_01
          INTO CORRESPONDING FIELDS OF TABLE <table>
          UP TO 4 ROWS.

      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
