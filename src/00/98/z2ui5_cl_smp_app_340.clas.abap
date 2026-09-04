CLASS z2ui5_cl_smp_app_340 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_data_tmp TYPE REF TO data.
    DATA mt_data     TYPE REF TO data.
    DATA ms_data_row TYPE REF TO data.

    DATA mo_layout   TYPE REF TO z2ui5_cl_smp_app_333.

    CLASS-METHODS factory
      IMPORTING
        io_table      TYPE REF TO data
        io_layout     TYPE REF TO z2ui5_cl_smp_app_333 OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_smp_app_340.

  PROTECTED SECTION.
    METHODS on_event    IMPORTING client TYPE REF TO z2ui5_if_client.
    METHODS view_display IMPORTING client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_340 IMPLEMENTATION.

  METHOD on_event.

    IF client->check_on_event( `POPUP_CLOSE` ).

      client->popup_destroy( ).
      client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns:form` v = `sap.ui.layout.form` ).

    popup->ele( `Dialog`
        )->a( n = `title`        v = `Test`
        )->a( n = `contentWidth` v = `60%`
        )->a( n = `afterClose`   v = client->_event( `POPUP_CLOSE` )
        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `title`    v = ``
            )->a( n = `layout`   v = `ResponsiveGridLayout`
            )->a( n = `editable` b = abap_true
            )->ele( n = `content` ns = `form`
                )->tag( `Label`
                    )->a( n = `text` v = `Test`
                )->tag( `Input`
                    )->a( n = `value` v = `TEST` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    " No check_on_navigated( ) branch: this app shows a POPUP, not a main
    " view. The framework pushes the model back into the still-standing
    " popup by itself - only an app that owns the MAIN slot has to
    " re-display (AGENTS.md 9).
    IF client->check_on_init( ).
      view_display( client ).

    ENDIF.

    IF mo_layout->mr_data IS INITIAL.

      client->message_toast_display( `ERROR - mo_layout_obj->mr_data is initial` ).
      RETURN.
    ENDIF.

    ASSIGN mo_layout->mr_data->* TO FIELD-SYMBOL(<data>).
    ASSIGN mt_data->* TO FIELD-SYMBOL(<table>).

    IF <data> <> <table>.
      client->message_toast_display( `ERROR - mo_layout_obj->mr_data->* ne mt_table->*` ).
    ENDIF.
    on_event( client ).

  ENDMETHOD.


  METHOD factory.

    DATA lo_struct TYPE REF TO cl_abap_structdescr.
    DATA comp      TYPE cl_abap_structdescr=>component_table.

    " Add new empty row

    result = NEW #( ).

    result->mo_layout = io_layout.

    TRY.
        " io_table references a table - the popup is built from its line type
        DATA(lo_type) = cl_abap_typedescr=>describe_by_data_ref( io_table ).
        IF lo_type->kind = cl_abap_typedescr=>kind_table.
          lo_struct = CAST #( CAST cl_abap_tabledescr( lo_type )->get_table_line_type( ) ).
        ELSE.
          lo_struct = CAST #( lo_type ).
        ENDIF.
        comp = lo_struct->get_components( ).
      CATCH cx_root ##NO_HANDLER.
    ENDTRY.

    TRY.
        DATA(new_struct_desc) = cl_abap_structdescr=>create( comp ).

        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA result->mt_data     TYPE HANDLE new_table_desc.
        CREATE DATA result->mt_data_tmp TYPE HANDLE new_table_desc.
        CREATE DATA result->ms_data_row TYPE HANDLE new_struct_desc.

      CATCH cx_root ##NO_HANDLER.
    ENDTRY.

    ASSIGN io_table->* TO FIELD-SYMBOL(<table>).

    ASSIGN result->mt_data->* TO FIELD-SYMBOL(<data>).
    <data> = <table>.

    ASSIGN result->mt_data_tmp->* TO <data>.
    <data> = <table>.

  ENDMETHOD.

ENDCLASS.
