CLASS z2ui5_cl_smp_app_339 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_view_display TYPE abap_bool.
    "! the Page this app renders into when it is embedded in another app's
    "! view; left empty the app builds a view of its own and displays it
    DATA mo_parent_page  TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA mv_table        TYPE string.

    DATA mt_table_tmp    TYPE REF TO data.
    DATA mt_table        TYPE REF TO data.

    DATA mo_layout       TYPE REF TO z2ui5_cl_smp_app_333.

    METHODS set_app_data
      IMPORTING
        !table TYPE string.

  PROTECTED SECTION.
    DATA mv_init TYPE abap_bool.

    METHODS on_event     IMPORTING !client TYPE REF TO z2ui5_if_client.
    METHODS view_display IMPORTING !client TYPE REF TO z2ui5_if_client.
    METHODS get_data.

    METHODS get_comp
      RETURNING
        VALUE(result) TYPE abap_component_tab.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_339 IMPLEMENTATION.

  METHOD get_comp.

    DATA selkz TYPE abap_bool.

    IF mv_table IS INITIAL.
      mv_table = `Z2UI5_T_01`.
    ENDIF.

    TRY.
        TRY.

            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = mv_table
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
                                    ( name = `SELKZ`
                                      type = CAST #( cl_abap_datadescr=>describe_by_data( selkz ) ) ) ).

        APPEND LINES OF component TO result.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SELECTION_CHANGE`.

        client->nav_app_call( z2ui5_cl_smp_app_340=>factory( io_table  = mt_table
                                                              io_layout = mo_layout  ) ).

      WHEN `BACK`.

        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    IF mo_parent_page IS INITIAL.
      DATA(page) = z2ui5_cl_ui5_view_builder=>factory(
          )->ele( n = `View` ns = `mvc`
              )->a( n = `displayBlock` v = `true`
              )->a( n = `height`       v = `100%`
              )->a( n = `xmlns`        v = `sap.m`
              )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
              )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    ELSE.
      page = mo_parent_page.

    ENDIF.

    mo_layout = z2ui5_cl_smp_app_333=>factory( i_data   = mt_table
                                                vis_cols = 5 ).
    ASSIGN mt_table->* TO FIELD-SYMBOL(<table>).

    DATA(table) = page->ele( `Table`
        )->a( n = `items`           v = client->_bind( val = <table> )
        )->a( n = `mode`            v = `SingleSelectLeft`
        )->a( n = `width`           v = `auto`
        )->a( n = `selectionChange` v = client->_event( `SELECTION_CHANGE` ) ).

    DATA(columns) = table->ele( `columns` ).

    LOOP AT mo_layout->ms_data-t_layout REFERENCE INTO DATA(layout).
      DATA(lv_index) = sy-tabix.

      columns->ele( `Column`
          )->a( n = `visible` v = client->_bind( val       = layout->visible
                                                tab       = mo_layout->ms_data-t_layout
                                                tab_index = lv_index )
          )->tag( `Text`
              )->a( n = `text` v = layout->name ).

    ENDLOOP.

    DATA(column_list_item) = columns->end(
        )->ele( `items`
            )->ele( `ColumnListItem`
                )->a( n = `vAlign`   v = `Middle`
                )->a( n = `selected` v = `{SELKZ}`
                )->a( n = `type`     v = `Inactive` ).

    DATA(cells) = column_list_item->ele( `cells` ).

    LOOP AT mo_layout->ms_data-t_layout REFERENCE INTO layout.

      lv_index = sy-tabix.

      cells->ele( `ObjectIdentifier`
          )->a( n = `text` v = |\{{ layout->name }\}| ).

    ENDLOOP.

    IF mo_parent_page IS INITIAL.
      client->view_display( page->stringify( ) ).

    ELSE.
      mv_view_display = abap_true.

    ENDIF.

  ENDMETHOD.


  METHOD set_app_data.

    mv_table = table.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF mv_init = abap_false.
      mv_init = abap_true.

      get_data( ).
      view_display( client ).

    ENDIF.

    IF client->check_on_navigated( )     = abap_true
        AND client->check_on_init( )          = abap_false.
      view_display( client ).
    ENDIF.

    ASSIGN mo_layout->mr_data->* TO FIELD-SYMBOL(<data>).
    ASSIGN mt_table->* TO FIELD-SYMBOL(<table>).

    IF <data> <> <table>.
      client->message_toast_display( `ERROR - mo_layout->mr_data->* ne mt_table->*`  ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.


  METHOD get_data.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.

    DATA(t_comp) = get_comp( ).
    TRY.

        DATA(new_struct_desc) = cl_abap_structdescr=>create( t_comp ).

        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_table     TYPE HANDLE new_table_desc.
        CREATE DATA mt_table_tmp TYPE HANDLE new_table_desc.

        ASSIGN mt_table->* TO <table>.

        SELECT *
          FROM (mv_table)
          INTO CORRESPONDING FIELDS OF TABLE @<table>
          UP TO 3 ROWS.

        SORT <table>.

      CATCH cx_root.

    ENDTRY.

    mt_table_tmp = mt_table.

  ENDMETHOD.

ENDCLASS.
