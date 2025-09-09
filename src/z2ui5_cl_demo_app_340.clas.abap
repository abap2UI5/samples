CLASS z2ui5_cl_demo_app_340 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_init     TYPE abap_bool.
    DATA mt_data_tmp TYPE REF TO data.
    DATA mt_data     TYPE REF TO data.
    DATA ms_data_row TYPE REF TO data.

    DATA mo_layout   TYPE REF TO z2ui5_cl_demo_app_333.

    CLASS-METHODS factory
      IMPORTING
        io_table      TYPE REF TO data
        io_layout     TYPE REF TO z2ui5_cl_demo_app_333 OPTIONAL
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_demo_app_340.

  PROTECTED SECTION.
    METHODS on_init.
    METHODS on_event    IMPORTING !client TYPE REF TO z2ui5_if_client.
    METHODS render_main IMPORTING !client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.

ENDCLASS.


CLASS z2ui5_cl_demo_app_340 IMPLEMENTATION.

  METHOD on_event.
    CASE client->get( )-event.

      WHEN 'POPUP_CLOSE'.

        client->popup_destroy( ).

        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'BACK'.

        client->nav_app_leave( ).

    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

  ENDMETHOD.

  METHOD render_main.

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    popup = z2ui5_cl_xml_view=>factory_popup( ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA simple_form TYPE REF TO z2ui5_cl_xml_view.
    simple_form = popup->dialog( title        = 'Test'
                                       contentwidth = '60%'
                                       afterclose   = client->_event( 'POPUP_CLOSE' )
          )->simple_form( title    = ''
                          layout   = 'ResponsiveGridLayout'
                          editable = abap_true
          )->content( ns = 'form' )->label( text = 'Test'    )->input( value = 'TEST' ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    IF mv_init IS INITIAL.
      mv_init = abap_true.

      render_main( client ).

    ENDIF.

    IF mo_layout->mr_data IS INITIAL.
      client->message_toast_display( 'ERROR - mo_layout_obj->mr_data is initial'  ).
      RETURN.
    ENDIF.

    FIELD-SYMBOLS <data> TYPE data.
    ASSIGN mo_layout->mr_data->* TO <data>.
    FIELD-SYMBOLS <table> TYPE data.
    ASSIGN mt_data->* TO <table>.

    IF <data> <> <table>.
      client->message_toast_display( 'ERROR - mo_layout_obj->mr_data->* ne mt_table->*'  ).
    ENDIF.
    on_event( client ).

  ENDMETHOD.

  METHOD factory.

    " Add new empty row

    CREATE OBJECT result.

    result->mo_layout = io_layout.

    TRY.
        DATA comp TYPE abap_component_tab.
        comp = z2ui5_cl_util=>rtti_get_t_attri_by_any( io_table ).
      CATCH cx_root.
    ENDTRY.

    TRY.
        DATA new_struct_desc TYPE REF TO cl_abap_structdescr.
        new_struct_desc = cl_abap_structdescr=>create( comp ).

        DATA new_table_desc TYPE REF TO cl_abap_tabledescr.
        new_table_desc = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA result->mt_data     TYPE HANDLE new_table_desc.
        CREATE DATA result->mt_data_tmp TYPE HANDLE new_table_desc.
        CREATE DATA result->ms_data_row TYPE HANDLE new_struct_desc.

      CATCH cx_root.
    ENDTRY.

    FIELD-SYMBOLS <table> TYPE data.
    ASSIGN io_table->* TO <table>.

    FIELD-SYMBOLS <data> TYPE data.
    ASSIGN result->mt_data->* TO <data>.
    <data> = <table>.

    ASSIGN result->mt_data_tmp->* TO <data>.
    <data> = <table>.

  ENDMETHOD.

ENDCLASS.
