CLASS z2ui5_cl_demo_app_344 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_data        TYPE REF TO data.
    DATA mt_data2       TYPE REF TO data.

    DATA mo_layout_obj  TYPE REF TO z2ui5_cl_demo_app_333.
    DATA mo_layout_obj2 TYPE REF TO z2ui5_cl_demo_app_333.

    METHODS get_data  IMPORTING iv_tabname TYPE string.
    METHODS get_data2 IMPORTING iv_tabname TYPE string.

    METHODS ui5_view_display
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
      IMPORTING
        iv_tabname    TYPE string
      RETURNING
        VALUE(result) TYPE abap_component_tab.

ENDCLASS.


CLASS z2ui5_cl_demo_app_344 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ) IS NOT INITIAL.
      get_data( 'Z2UI5_T_01' ).
      get_data2( 'Z2UI5_T_01' ).

      mo_layout_obj = z2ui5_cl_demo_app_333=>factory( i_data   =  mt_data
                                                      vis_cols = 5 ).
      mo_layout_obj2 = z2ui5_cl_demo_app_333=>factory( i_data   =  mt_data2
                                                       vis_cols = 3 ).

      ui5_view_display( client ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'GO'.
        DATA app TYPE REF TO z2ui5_cl_demo_app_336.
        app = z2ui5_cl_demo_app_336=>factory( ).
        client->nav_app_call( app ).
    ENDCASE.

***    " Kommen wir aus einer anderen APP
***    IF client->get( )-check_on_navigated = abap_true.
***      TRY.
***          " Kommen wir aus einer anderen APP
***          CAST z2ui5_cl_demo_app_336( client->get_app( client->get( )-s_draft-id_prev_app ) ).
***
***        CATCH cx_root.
***      ENDTRY.
***    ENDIF.


    IF     client->get( )-check_on_navigated = abap_true
       AND client->check_on_init( )          = abap_false.
      ui5_view_display( client ).
    ENDIF.


    IF mo_layout_obj->mr_data IS NOT BOUND.
      client->message_toast_display( 'ERROR - mo_layout_obj->mr_data is not bound!' ).
    ENDIF.
    IF mo_layout_obj2->mr_data IS NOT BOUND.
      client->message_toast_display( 'ERROR - mo_layout_obj_2->mr_data  is not bound!' ).
    ENDIF.

    FIELD-SYMBOLS <table> TYPE data.
    ASSIGN mt_data->* TO <table>.
    FIELD-SYMBOLS <val> TYPE data.
    ASSIGN mo_layout_obj->mr_data->* TO <val>.
    IF <val> <> <table>.
      client->message_toast_display( 'ERROR - mo_layout_obj_2->mr_data  <> mt_data!' ).
    ENDIF.

    FIELD-SYMBOLS <table2> TYPE data.
    ASSIGN mt_data2->* TO <table2>.
    FIELD-SYMBOLS <val2> TYPE data.
    ASSIGN mo_layout_obj2->mr_data->* TO <val2>.
    IF <table2> <> <val2>.
      client->message_toast_display( 'ERROR - mo_layout_obj_2->mr_data  <> ms_data!' ).
    ENDIF.

    client->view_model_update( ).

  ENDMETHOD.

  METHOD ui5_view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell( )->page( title          = 'RTTI IV'
                                                                navbuttonpress = client->_event( 'BACK' )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    page->button( text  = 'CALL Next App'
                  press = client->_event( 'GO' )
                  type  = 'Success' ).

    xml_table( i_page   = page
               i_client = client
               i_data   = mt_data
               i_layout = mo_layout_obj ).

    xml_table( i_page   = page
               i_client = client
               i_data   = mt_data2
               i_layout = mo_layout_obj2 ).

    client->view_display( page ).

  ENDMETHOD.

  METHOD xml_table.

    FIELD-SYMBOLS <table> TYPE data.
    ASSIGN i_data->* TO <table>.
    DATA table TYPE REF TO z2ui5_cl_xml_view.
    table = i_page->table( width = 'auto'
                                 items = i_client->_bind_edit( val = <table> ) ).

    DATA columns TYPE REF TO z2ui5_cl_xml_view.
    columns = table->columns( ).

    DATA temp1 LIKE LINE OF i_layout->ms_data-t_layout.
    DATA layout LIKE REF TO temp1.
    LOOP AT i_layout->ms_data-t_layout REFERENCE INTO layout.
      DATA lv_index LIKE sy-tabix.
      lv_index = sy-tabix.

      columns->column( visible = i_client->_bind( val       = layout->visible
                                                  tab       = i_layout->ms_data-t_layout
                                                  tab_index = lv_index )
       )->text( layout->name ).

    ENDLOOP.

    DATA column_list_item TYPE REF TO z2ui5_cl_xml_view.
    column_list_item = columns->get_parent( )->items(
                                       )->column_list_item( valign = 'Middle'
                                                            type   = `Inactive`   ).

    DATA cells TYPE REF TO z2ui5_cl_xml_view.
    cells = column_list_item->cells( ).

    LOOP AT i_layout->ms_data-t_layout REFERENCE INTO layout.

      lv_index = sy-tabix.

      cells->object_identifier( text = |\{{ layout->name }\}| ).  "."|\{{ layout->fname }\}| ).

    ENDLOOP.

  ENDMETHOD.

  METHOD get_data.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.

    DATA t_comp TYPE abap_component_tab.
    t_comp = get_comp( iv_tabname ).
    TRY.

        DATA new_struct_desc TYPE REF TO cl_abap_structdescr.
        new_struct_desc = cl_abap_structdescr=>create( t_comp ).

        DATA new_table_desc TYPE REF TO cl_abap_tabledescr.
        new_table_desc = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_data TYPE HANDLE new_table_desc.

        ASSIGN mt_data->* TO <table>.

        SELECT *
          FROM (iv_tabname)
          INTO CORRESPONDING FIELDS OF TABLE <table>
          UP TO 3 ROWS.

        SORT <table>.

      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.

  METHOD get_data2.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.

    DATA t_comp TYPE abap_component_tab.
    t_comp = get_comp( iv_tabname ).
    TRY.

        DATA new_struct_desc TYPE REF TO cl_abap_structdescr.
        new_struct_desc = cl_abap_structdescr=>create( t_comp ).

        DATA new_table_desc TYPE REF TO cl_abap_tabledescr.
        new_table_desc = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_data2 TYPE HANDLE new_table_desc.

        ASSIGN mt_data2->* TO <table>.

        SELECT *
          FROM (iv_tabname)
          INTO CORRESPONDING FIELDS OF TABLE <table>
          UP TO 4 ROWS.

        SORT <table>.

      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.

  METHOD get_comp.

    DATA selkz TYPE abap_bool.

    TRY.
        TRY.

            DATA typedesc TYPE REF TO cl_abap_typedescr.
            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = iv_tabname
                                                 RECEIVING  p_descr_ref    = typedesc
                                                 EXCEPTIONS type_not_found = 1
                                                            OTHERS         = 2 ).

            DATA temp2 TYPE REF TO cl_abap_structdescr.
            temp2 ?= typedesc.
            DATA structdesc LIKE temp2.
            structdesc = temp2.

            DATA comp TYPE abap_component_tab.
            comp = structdesc->get_components( ).

            DATA com LIKE LINE OF comp.
            LOOP AT comp INTO com.

              IF com-as_include = abap_false.

                APPEND com TO result.

              ENDIF.

            ENDLOOP.

            DATA root TYPE REF TO cx_root.
          CATCH cx_root INTO root. " TODO: variable is assigned but never used (ABAP cleaner)

        ENDTRY.

        DATA temp3 TYPE cl_abap_structdescr=>component_table.
        CLEAR temp3.
        DATA temp4 LIKE LINE OF temp3.
        temp4-name = 'SELKZ'.
        DATA temp1 TYPE REF TO cl_abap_datadescr.
        temp1 ?= cl_abap_datadescr=>describe_by_data( selkz ).
        temp4-type = temp1.
        INSERT temp4 INTO TABLE temp3.
        DATA component LIKE temp3.
        component = temp3.

        APPEND LINES OF component TO result.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
