CLASS z2ui5_cl_smp_app_344 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_data        TYPE REF TO data.
    DATA mt_data2       TYPE REF TO data.

    DATA mo_layout_obj  TYPE REF TO z2ui5_cl_smp_app_333.
    DATA mo_layout_obj2 TYPE REF TO z2ui5_cl_smp_app_333.

    METHODS get_data  IMPORTING iv_tabname TYPE string.
    METHODS get_data2 IMPORTING iv_tabname TYPE string.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
    METHODS xml_table
      IMPORTING
        i_page   TYPE REF TO z2ui5_cl_ui5_view_builder
        i_client TYPE REF TO z2ui5_if_client
        i_data   TYPE REF TO data
        i_layout TYPE REF TO z2ui5_cl_smp_app_333.

    METHODS get_comp
      IMPORTING
        iv_tabname    TYPE string
      RETURNING
        VALUE(result) TYPE abap_component_tab.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_344 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      get_data( `Z2UI5_T_01` ).
      get_data2( `Z2UI5_T_01` ).

      mo_layout_obj = z2ui5_cl_smp_app_333=>factory( i_data   = mt_data
                                                      vis_cols = 5 ).
      mo_layout_obj2 = z2ui5_cl_smp_app_333=>factory( i_data   = mt_data2
                                                       vis_cols = 3 ).

      view_display( client ).

    ELSEIF client->check_on_navigated( ).
      view_display( client ).

    ELSEIF client->check_on_event( ).

      IF client->get_event( ) = `GO`.
        DATA(app) = z2ui5_cl_smp_app_336=>factory( ).
        client->nav_app_call( app ).
      ENDIF.

    ENDIF.

    IF mo_layout_obj->mr_data IS NOT BOUND.
      client->message_toast_display( `ERROR - mo_layout_obj->mr_data is not bound!` ).
    ENDIF.

    IF mo_layout_obj2->mr_data IS NOT BOUND.
      client->message_toast_display( `ERROR - mo_layout_obj_2->mr_data  is not bound!` ).
    ENDIF.

    ASSIGN mt_data->* TO FIELD-SYMBOL(<table>).
    ASSIGN mo_layout_obj->mr_data->* TO FIELD-SYMBOL(<val>).

    IF <val> <> <table>.
      client->message_toast_display( `ERROR - mo_layout_obj_2->mr_data  <> mt_data!` ).
    ENDIF.

    ASSIGN mt_data2->* TO FIELD-SYMBOL(<table2>).
    ASSIGN mo_layout_obj2->mr_data->* TO FIELD-SYMBOL(<val2>).

    IF <table2> <> <val2>.
      client->message_toast_display( `ERROR - mo_layout_obj_2->mr_data  <> ms_data!` ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `RTTI IV`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `Button`
        )->a( n = `press` v = client->_event( `GO` )
        )->a( n = `text`  v = `CALL Next App`
        )->a( n = `type`  v = `Accept` ).

    xml_table( i_page   = page
               i_client = client
               i_data   = mt_data
               i_layout = mo_layout_obj ).

    xml_table( i_page   = page
               i_client = client
               i_data   = mt_data2
               i_layout = mo_layout_obj2 ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD xml_table.

    ASSIGN i_data->* TO FIELD-SYMBOL(<table>).
    DATA(table) = i_page->ele( `Table`
        )->a( n = `items` v = i_client->_bind( val = <table> )
        )->a( n = `width` v = `auto` ).

    DATA(columns) = table->ele( `columns` ).

    LOOP AT i_layout->ms_data-t_layout REFERENCE INTO DATA(layout).
      DATA(lv_index) = sy-tabix.

      columns->ele( `Column`
          )->a( n = `visible` v = i_client->_bind( val       = layout->visible
                                                  tab       = i_layout->ms_data-t_layout
                                                  tab_index = lv_index )
          )->tag( `Text`
              )->a( n = `text` v = layout->name ).

    ENDLOOP.

    DATA(column_list_item) = columns->end(
        )->ele( `items`
            )->ele( `ColumnListItem`
                )->a( n = `vAlign` v = `Middle`
                )->a( n = `type`   v = `Inactive` ).

    DATA(cells) = column_list_item->ele( `cells` ).

    LOOP AT i_layout->ms_data-t_layout REFERENCE INTO layout.

      lv_index = sy-tabix.

      cells->ele( `ObjectIdentifier`
          )->a( n = `text` v = |\{{ layout->name }\}| ).

    ENDLOOP.

  ENDMETHOD.


  METHOD get_data.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.

    DATA(t_comp) = get_comp( iv_tabname ).
    TRY.

        DATA(new_struct_desc) = cl_abap_structdescr=>create( t_comp ).

        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_data TYPE HANDLE new_table_desc.

        ASSIGN mt_data->* TO <table>.

        SELECT *
          FROM (iv_tabname)
          ORDER BY PRIMARY KEY
          INTO CORRESPONDING FIELDS OF TABLE @<table>
          UP TO 3 ROWS.

        SORT <table>.

      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.


  METHOD get_data2.

    FIELD-SYMBOLS <table> TYPE STANDARD TABLE.

    DATA(t_comp) = get_comp( iv_tabname ).
    TRY.

        DATA(new_struct_desc) = cl_abap_structdescr=>create( t_comp ).

        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_data2 TYPE HANDLE new_table_desc.

        ASSIGN mt_data2->* TO <table>.

        SELECT *
          FROM (iv_tabname)
          ORDER BY PRIMARY KEY
          INTO CORRESPONDING FIELDS OF TABLE @<table>
          UP TO 4 ROWS.

        SORT <table>.

      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.


  METHOD get_comp.

    DATA selkz TYPE abap_bool.

    TRY.
        TRY.

            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = iv_tabname
                                                 RECEIVING p_descr_ref     = DATA(typedesc)
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

ENDCLASS.
