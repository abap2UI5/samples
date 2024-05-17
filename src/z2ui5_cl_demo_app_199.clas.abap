CLASS z2ui5_cl_demo_app_199 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_table TYPE REF TO data.

    DATA mt_comp  TYPE abap_component_tab.

  PROTECTED SECTION.
    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS on_init.
    METHODS on_event.

    METHODS render_main.

  PRIVATE SECTION.
    METHODS get_data.
    METHODS refresh.
    METHODS add_data.

    METHODS get_comp
      RETURNING VALUE(result) TYPE abap_component_tab.
ENDCLASS.

CLASS z2ui5_cl_demo_app_199 IMPLEMENTATION.

  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'BACK'.

        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'REFRESH'.

        refresh( ).
        client->view_model_update( ).

      WHEN 'ADD'.

        add_data( ).
        client->view_model_update( ).

    ENDCASE.
  ENDMETHOD.

  METHOD on_init.
    get_data( ).
    render_main( ).
  ENDMETHOD.

  METHOD render_main.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    FIELD-SYMBOLS <tab> TYPE data.
    ASSIGN mt_table->* TO <tab>.

    DATA(page) = view->page( id             = `page_main`
                             title          = 'Refresh'
                             navbuttonpress = client->_event( 'BACK' )
                             shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
                             class          = 'sapUiContentPadding' ).

    DATA(table) = page->table( growing = 'true'
                               width   = 'auto'
                               items   = client->_bind( <tab> )
*                               headertext = mv_table
                               ).

    DATA(columns) = table->columns( ).

    LOOP AT mt_comp INTO DATA(comp).

      IF comp-name = 'DATA'.
        CONTINUE.
      ENDIF.

      columns->column( )->text( comp-name ).

    ENDLOOP.

    DATA(cells) = columns->get_parent( )->items(
                                       )->column_list_item( valign = 'Middle'
                                                            type   = 'Navigation'
                                       )->cells( ).

    LOOP AT mt_comp INTO comp.

      IF comp-name = 'DATA'.
        CONTINUE.
      ENDIF.

      cells->object_identifier( text = '{' && comp-name && '}' ).
    ENDLOOP.

    page->button( text  = 'Refresh'
                  press = client->_event( 'REFRESH' )
                  )->button( text  = 'Add'
                             press = client->_event( 'ADD' ) ).

    client->view_display( page->get_root( )->xml_get( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      on_init( ).

    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD get_data.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.

    mt_comp = get_comp( ).

    TRY.

        DATA(new_struct_desc) = cl_abap_structdescr=>create( mt_comp ).

        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_table TYPE HANDLE new_table_desc.

        ASSIGN mt_table->* TO <table>.

        SELECT * FROM z2ui5_t_01
          INTO CORRESPONDING FIELDS OF TABLE @<table>
          UP TO 2 ROWS.

      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.

  METHOD get_comp.
    TRY.

        DATA index TYPE int4.

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

        DATA(component) = VALUE cl_abap_structdescr=>component_table(
                                    ( name = 'ROW_ID'
                                      type = CAST #( cl_abap_datadescr=>describe_by_data( index ) ) ) ).

        APPEND LINES OF component TO result.

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

  METHOD add_data.

    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.

    ASSIGN mt_table->* TO <tab>.

    APPEND LINES OF <tab> TO <tab>.

  ENDMETHOD.

  METHOD refresh.

    get_data( ).

  ENDMETHOD.

ENDCLASS.
