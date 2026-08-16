CLASS z2ui5_cl_smp_app_126 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    INTERFACES z2ui5_if_app.

    DATA mv_view_display TYPE abap_bool.
    "! the Page this app renders into when it is embedded in another app's
    "! view; left empty the app builds a view of its own and displays it
    DATA mo_parent_page  TYPE REF TO z2ui5_cl_ui5_view_builder.

    DATA mv_perc         TYPE string.
    DATA mt_table        TYPE REF TO data.
    DATA mt_table_tmp    TYPE REF TO data.
    DATA ms_table_row    TYPE REF TO data.
    DATA mt_table_del    TYPE REF TO data.

    METHODS set_app_data
      IMPORTING data TYPE string.

  PROTECTED SECTION.
    DATA client            TYPE REF TO z2ui5_if_client.

    METHODS on_init.

    METHODS view_display.

    METHODS get_data.

    METHODS get_comp
      RETURNING VALUE(result) TYPE abap_component_tab.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_126 IMPLEMENTATION.

  METHOD get_comp.

    DATA index TYPE int4.
    TRY.

        TRY.

            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = `Z2UI5_T_UTIL_01`
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
                                    ( name = `ROW_ID`
                                      type = CAST #( cl_abap_datadescr=>describe_by_data( index ) ) ) ).

        APPEND LINES OF component TO result.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD get_data.

    FIELD-SYMBOLS <table>     TYPE STANDARD TABLE.
    FIELD-SYMBOLS <table_tmp> TYPE STANDARD TABLE.

    DATA(t_comp) = get_comp( ).

    TRY.

        DATA(new_struct_desc) = cl_abap_structdescr=>create( t_comp ).

        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_table     TYPE HANDLE new_table_desc.
        CREATE DATA mt_table_del TYPE HANDLE new_table_desc.
        CREATE DATA mt_table_tmp TYPE HANDLE new_table_desc.
        CREATE DATA ms_table_row TYPE HANDLE new_struct_desc.

        ASSIGN mt_table->* TO <table>.

        SELECT * FROM z2ui5_t_01
          ORDER BY PRIMARY KEY
          INTO CORRESPONDING FIELDS OF TABLE @<table>
          UP TO 3 ROWS.

      CATCH cx_root.
    ENDTRY.

    ASSIGN mt_table_tmp->* TO <table_tmp>.

    <table_tmp> = <table>.

  ENDMETHOD.


  METHOD on_init.

    get_data( ).
    view_display( ).

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

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample shows the ProgressIndicator control, which renders a ` &&
                   `completion percentage as a labeled progress bar.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->tag( `Label`
        )->a( n = `text` v = `ProgressIndicator`
        )->tag( `ProgressIndicator`
            )->a( n = `percentValue` v = mv_perc
            )->a( n = `displayValue` v = `0,44GB of 32GB used`
            )->a( n = `showValue`    b = abap_true
            )->a( n = `state`        v = `Success` ).

    IF mo_parent_page IS INITIAL.
      client->view_display( page->stringify( ) ).

    ELSE.
      mv_view_display = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD set_app_data.

    mv_perc = data.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
