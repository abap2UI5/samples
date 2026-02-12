CLASS z2ui5_cl_demo_app_328 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_table     TYPE REF TO data.
    DATA mo_table_obj TYPE REF TO z2ui5_cl_demo_app_329.

    METHODS get_data.

    METHODS view_display
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_328 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    FIELD-SYMBOLS <line> TYPE any.
    FIELD-SYMBOLS: <tab> TYPE ANY TABLE.

    IF client->check_on_init( ).
      get_data( ).
      mo_table_obj = z2ui5_cl_demo_app_329=>factory( mt_table ).
      view_display( client ).
    ENDIF.

    CASE client->get( )-event.
      WHEN `SELECTION_CHANGE`.

        client->view_model_update( ).

      WHEN `GO`.

        ASSIGN mt_table->* TO <tab>.

        LOOP AT <tab> ASSIGNING <line>.

          ASSIGN COMPONENT `SELKZ` OF STRUCTURE <line> TO FIELD-SYMBOL(<lv_selkz>).
          IF <lv_selkz> IS NOT ASSIGNED.
            CONTINUE.
          ENDIF.

          IF <lv_selkz> = abap_true.
            DATA(lv_okay) = abap_true.
            EXIT.
          ENDIF.

        ENDLOOP.

        IF lv_okay = abap_true.

          get_data( ).
          mo_table_obj = z2ui5_cl_demo_app_329=>factory( mt_table ).
          view_display( client ).

          ASSIGN mt_table->* TO FIELD-SYMBOL(<table>).
          ASSIGN mo_table_obj->mr_data->* TO FIELD-SYMBOL(<val>).

          IF <table> <> <val>.
            client->message_toast_display( `Error - MT_TABLE <> MO_TABLE_OBJ->MR_TABLE_DATA` ).
          ELSE.
            client->message_toast_display( `Success - MT_TABLE = MO_TABLE_OBJ->MR_TABLE_DATA` ).
          ENDIF.

        ELSE.
          client->message_toast_display( `Plases select a Line` ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell( )->page( title          = `RTTI IV`
                                                                navbuttonpress = client->_event_nav_app_leave( )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    lo_page->button( text  = `GO`
                  press = client->_event( `GO` )
                  type  = `Success` ).

    ASSIGN mt_table->* TO FIELD-SYMBOL(<table>).
    lo_page->table( headertext      = `Table`
                 mode            = `MultiSelect`
                 items           = client->_bind_edit( <table> )
                 selectionchange = client->_event( `SELECTION_CHANGE` )
              )->columns(
                  )->column( )->text( `id `
              )->get_parent( )->get_parent(
              )->items(
                  )->column_list_item( selected = `{SELKZ}`
                      )->cells(
                          )->text( `{ID}` ).

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD get_data.

    DATA lv_selkz TYPE abap_bool.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.

    DATA(lt_comp) = z2ui5_cl_util=>rtti_get_t_attri_by_table_name( `Z2UI5_T_01` ).

    APPEND LINES OF VALUE cl_abap_structdescr=>component_table(
                              ( name = `SELKZ`
                                type = CAST #( cl_abap_datadescr=>describe_by_data( lv_selkz ) ) ) ) TO lt_comp.

    TRY.

        DATA(lv_new_struct_desc) = cl_abap_structdescr=>create( lt_comp ).

        DATA(lv_new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = lv_new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_table TYPE HANDLE lv_new_table_desc.

        ASSIGN mt_table->* TO <table>.

        SELECT id FROM z2ui5_t_01
          INTO CORRESPONDING FIELDS OF TABLE @<table>
          UP TO 4 ROWS.

      CATCH cx_root.

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
