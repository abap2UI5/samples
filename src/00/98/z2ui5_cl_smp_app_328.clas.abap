CLASS z2ui5_cl_smp_app_328 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_table     TYPE REF TO data.
    DATA mo_table_obj TYPE REF TO z2ui5_cl_smp_app_329.

    METHODS get_data.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_328 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    FIELD-SYMBOLS <line> TYPE any.
    FIELD-SYMBOLS: <tab> TYPE ANY TABLE.

    IF client->check_on_init( ).

      get_data( ).
      mo_table_obj = z2ui5_cl_smp_app_329=>factory( mt_table ).
      view_display( client ).
    ENDIF.

    CASE client->get_event( ).
      WHEN `GO`.

        ASSIGN mt_table->* TO <tab>.

        LOOP AT <tab> ASSIGNING <line>.

          ASSIGN COMPONENT `SELKZ` OF STRUCTURE <line> TO FIELD-SYMBOL(<selkz>).

          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

          IF <selkz> = abap_true.

            DATA(okay) = abap_true.
            EXIT.
          ENDIF.

        ENDLOOP.

        IF okay = abap_true.

          get_data( ).
          mo_table_obj = z2ui5_cl_smp_app_329=>factory( mt_table ).
          view_display( client ).

          ASSIGN mt_table->* TO FIELD-SYMBOL(<table>).
          ASSIGN mo_table_obj->mr_data->* TO FIELD-SYMBOL(<val>).

          IF <table> <> <val>.
            client->message_toast_display( `Error - MT_TABLE <> MO_TABLE_OBJ->MR_TABLE_DATA` ).

          ELSE.
            client->message_toast_display( `Success - MT_TABLE = MO_TABLE_OBJ->MR_TABLE_DATA` ).
          ENDIF.

        ELSE.
          client->message_toast_display( `Please select a line` ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_ui5_view_builder=>factory( )->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `height`       v = `100%`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`   v = `sap.ui.core` )->ele( `Shell` )->ele( `Page`
        )->a( n = `title`          v = `RTTI IV`
        )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
        )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `Button`
        )->a( n = `press` v = client->_event( `GO` )
        )->a( n = `text`  v = `GO`
        )->a( n = `type`  v = `Success` ).

    ASSIGN mt_table->* TO FIELD-SYMBOL(<table>).
    page->ele( `Table`
        )->a( n = `items`           v = client->_bind( <table> )
        )->a( n = `headerText`      v = `Table`
        )->a( n = `mode`            v = `MultiSelect`
        )->a( n = `selectionChange` v = client->_event( `SELECTION_CHANGE` ) )->ele( `columns` )->ele( `Column` )->tag( `Text`
                      )->a( n = `text` v = `id ` )->end( )->end( )->ele( `items` )->ele( `ColumnListItem`
                      )->a( n = `selected` v = `{SELKZ}` )->ele( `cells` )->tag( `Text`
                              )->a( n = `text` v = `{ID}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD get_data.

    DATA selkz TYPE abap_bool.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.

    DATA(t_comp) = z2ui5_cl_smp_context=>rtti_get_t_attri_by_table_name( `Z2UI5_T_01` ).

    APPEND LINES OF VALUE cl_abap_structdescr=>component_table(
                              ( name = `SELKZ`
                                type = CAST #( cl_abap_datadescr=>describe_by_data( selkz ) ) ) ) TO t_comp.

    TRY.

        DATA(new_struct_desc) = cl_abap_structdescr=>create( t_comp ).

        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_table TYPE HANDLE new_table_desc.

        ASSIGN mt_table->* TO <table>.

        SELECT id FROM z2ui5_t_01
          INTO CORRESPONDING FIELDS OF TABLE @<table>
          UP TO 4 ROWS.

      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
