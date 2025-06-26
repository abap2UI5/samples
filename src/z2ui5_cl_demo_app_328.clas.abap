CLASS z2ui5_cl_demo_app_328 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_table     TYPE REF TO data.
    DATA mo_table_obj TYPE REF TO z2ui5_cl_demo_app_329.

    METHODS ui5_view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_328 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      mt_table = z2ui5_cl_util=>rtti_create_tab_by_name( 'Z2UI5_T_01' ).
      FIELD-SYMBOLS <table> TYPE STANDARD TABLE.
      ASSIGN mt_table->* TO <table>.

      SELECT * FROM z2ui5_t_01
        INTO CORRESPONDING FIELDS OF TABLE @<table>
        UP TO 1 ROWS.

      mo_table_obj = z2ui5_cl_demo_app_329=>factory( mt_table ).
      ui5_view_display( client ).
      RETURN.
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'GO'.
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

    DATA(table) = page->table( client->_bind( mt_table->* ) ).

    DATA(columns) = table->columns( ).
    DATA(mt_comp) = z2ui5_cl_util=>rtti_get_t_attri_by_table_name( 'Z2UI5_T_01' ).

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

ENDCLASS.
