CLASS z2ui5_cl_demo_app_194 DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_view_display TYPE abap_bool.
    DATA mo_parent_view  TYPE REF TO z2ui5_cl_xml_view.

    DATA mv_table        TYPE string.
    DATA mt_table        TYPE REF TO data.
    DATA mt_table_tmp    TYPE REF TO data.
    DATA ms_table_row    TYPE REF TO data.
    DATA mt_comp         TYPE abap_component_tab.
    DATA ms_fixval       TYPE REF TO data.
    METHODS set_app_data
      IMPORTING
        !lo_table TYPE string.

  PROTECTED SECTION.
    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.

    METHODS render_main.

  PRIVATE SECTION.
    METHODS get_data.

    METHODS get_comp
      RETURNING
        VALUE(result) TYPE abap_component_tab.

    METHODS get_fixval.
ENDCLASS.

CLASS z2ui5_cl_demo_app_194 IMPLEMENTATION.

  METHOD on_event.

    FIELD-SYMBOLS <row> TYPE any.

    IF mo_client->check_on_event( `BUTTON` ).

      LOOP AT mt_comp REFERENCE INTO DATA(lo_comp).

        ASSIGN ms_table_row->* TO <row>.
        ASSIGN COMPONENT lo_comp->name OF STRUCTURE <row> TO FIELD-SYMBOL(<val>).
        IF <val> IS NOT ASSIGNED.
          CONTINUE.
        ELSE.

          mo_client->_bind( <val> ).

        ENDIF.

      ENDLOOP.

    ENDIF.
  ENDMETHOD.

  METHOD on_init.

    get_data( ).
    render_main( ).
  ENDMETHOD.

  METHOD render_main.

    FIELD-SYMBOLS <tab> TYPE data.

    IF mo_parent_view IS INITIAL.
      DATA(lo_page) = z2ui5_cl_xml_view=>factory( ).
    ELSE.
      lo_page = mo_parent_view->get( `Page` ).
    ENDIF.

    ASSIGN mt_table->* TO <tab>.

    DATA(lo_table) = lo_page->table( growing = `true`
                               width   = `auto`
                               items   = mo_client->_bind( <tab> )
*                               headertext = mv_table
                               ).

    DATA(lo_columns) = lo_table->columns( ).

    LOOP AT mt_comp INTO DATA(lo_comp).

      lo_columns->column( )->text( lo_comp-name ).

    ENDLOOP.

    DATA(lo_cells) = lo_columns->get_parent( )->items(
                                       )->column_list_item( valign = `Middle`
                                                            type   = `Navigation`
                                       )->cells( ).

    LOOP AT mt_comp INTO lo_comp.
      lo_cells->object_identifier( text = |\{{ lo_comp-name }\}| ).
    ENDLOOP.

    lo_page->footer( )->overflow_toolbar(
                         )->toolbar_spacer(
                         )->button( text  = `Save`
                                    press = mo_client->_event( `BUTTON` )
                                    type  = `Success` ).

    IF mo_parent_view IS INITIAL.

      mo_client->view_display( lo_page->stringify( ) ).

    ELSE.

      mv_view_display = abap_true.

    ENDIF.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      on_init( ).

    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD set_app_data.

    " TODO: parameter COUNT is never used (ABAP cleaner)

    mv_table = lo_table.
  ENDMETHOD.

  METHOD get_data.

    FIELD-SYMBOLS <lo_table>     TYPE STANDARD TABLE.
    FIELD-SYMBOLS <table_tmp> TYPE STANDARD TABLE.

    mt_comp = get_comp( ).

    TRY.

        DATA(lv_new_struct_desc) = cl_abap_structdescr=>create( mt_comp ).

        DATA(lv_new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = lv_new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_table     TYPE HANDLE lv_new_table_desc.

        CREATE DATA mt_table_tmp TYPE HANDLE lv_new_table_desc.
        CREATE DATA ms_table_row TYPE HANDLE lv_new_struct_desc.

        ASSIGN mt_table->* TO <lo_table>.

        SELECT *
          FROM (mv_table)
          INTO CORRESPONDING FIELDS OF TABLE @<lo_table>
          UP TO 100 ROWS.

      CATCH cx_root.

    ENDTRY.

    ASSIGN mt_table_tmp->* TO <table_tmp>.

    <table_tmp> = <lo_table>.
    get_fixval( ).
  ENDMETHOD.

  METHOD get_fixval.

    TYPES:
      BEGIN OF fixvalue,
        low        TYPE string,
        high       TYPE string,
        option     TYPE string,
        ddlanguage TYPE string,
        ddtext     TYPE string,
      END OF fixvalue.
    TYPES fixvalues TYPE STANDARD TABLE OF fixvalue WITH DEFAULT KEY.

    DATA lo_comp        TYPE cl_abap_structdescr=>component_table.
    DATA lt_fixval   TYPE fixvalues.
    DATA lo_structdescr TYPE REF TO cl_abap_structdescr.

    LOOP AT mt_comp REFERENCE INTO DATA(dfies).

      lo_comp = VALUE cl_abap_structdescr=>component_table(
                       BASE lo_comp
                       ( name = dfies->name
                         type = CAST #( cl_abap_datadescr=>describe_by_data( lt_fixval ) ) ) ).
    ENDLOOP.

    lo_structdescr = cl_abap_structdescr=>create( lo_comp ).

    CREATE DATA ms_fixval TYPE HANDLE lo_structdescr.
  ENDMETHOD.

  METHOD get_comp.

    DATA lv_index TYPE int4.

    TRY.

        TRY.

            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = mv_table
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

        DATA(lv_component) = VALUE cl_abap_structdescr=>component_table(
                                    ( name = `ROW_ID`
                                      type = CAST #( cl_abap_datadescr=>describe_by_data( lv_index ) ) ) ).

        APPEND LINES OF lv_component TO result.

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
