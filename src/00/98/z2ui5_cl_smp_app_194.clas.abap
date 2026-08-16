CLASS z2ui5_cl_smp_app_194 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_view_display TYPE abap_bool.
    "! the Page this app renders into when it is embedded in another app's
    "! view; left empty the app builds a view of its own and displays it
    DATA mo_parent_page  TYPE REF TO z2ui5_cl_ui5_view_builder.

    DATA mv_table        TYPE string.
    DATA mt_table        TYPE REF TO data.
    DATA mt_table_tmp    TYPE REF TO data.
    DATA ms_table_row    TYPE REF TO data.
    DATA mt_comp         TYPE abap_component_tab.
    DATA ms_fixval       TYPE REF TO data.

    METHODS set_app_data
      IMPORTING
        table TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.

    METHODS view_display.

    METHODS get_data.

    METHODS get_comp
      RETURNING
        VALUE(result) TYPE abap_component_tab.

    METHODS get_fixval.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_194 IMPLEMENTATION.

  METHOD on_event.

    FIELD-SYMBOLS <row> TYPE any.

    IF client->check_on_event( `BUTTON` ).

      LOOP AT mt_comp REFERENCE INTO DATA(comp).

        ASSIGN ms_table_row->* TO <row>.
        ASSIGN COMPONENT comp->name OF STRUCTURE <row> TO FIELD-SYMBOL(<val>).

        IF sy-subrc <> 0.
          CONTINUE.

        ELSE.
          client->_bind( <val> ).

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    get_data( ).
    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    FIELD-SYMBOLS <tab> TYPE data.

    IF mo_parent_page IS INITIAL.
      DATA(page) = z2ui5_cl_ui5_view_builder=>factory(
          )->ele( n = `View` ns = `mvc`
              )->a( n = `displayBlock` v = `true`
              )->a( n = `height`       v = `100%`
              )->a( n = `xmlns`        v = `sap.m`
              )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
              )->a( n = `xmlns:core`   v = `sap.ui.core`

              " a real sap.m.Page, because the footer below needs one: mvc:View has
              " no footer aggregation, and UI5 resolves the unknown lowercase tag as
              " a control class - sap/m/footer.js, 404, and the whole view dies
              " instead of rendering without its toolbar. Embedded, the caller
              " supplies the Page; standalone this is it
              )->ele( `Page` ).

    ELSE.
      page = mo_parent_page.
    ENDIF.

    ASSIGN mt_table->* TO <tab>.

    DATA(table) = page->ele( `Table`
        )->a( n = `items`   v = client->_bind( <tab> )
        )->a( n = `growing` v = `true`
        )->a( n = `width`   v = `auto` ).

    DATA(columns) = table->ele( `columns` ).

    LOOP AT mt_comp INTO DATA(comp).

      columns->ele( `Column`
          )->tag( `Text`
              )->a( n = `text` v = comp-name ).

    ENDLOOP.

    DATA(cells) = columns->end(
        )->ele( `items`
            )->ele( `ColumnListItem`
                )->a( n = `vAlign` v = `Middle`
                )->a( n = `type`   v = `Navigation`
                )->ele( `cells` ).

    LOOP AT mt_comp INTO comp.
      cells->ele( `ObjectIdentifier`
          )->a( n = `text` v = |\{{ comp-name }\}| ).
    ENDLOOP.

    page->ele( `footer`
        )->ele( `OverflowToolbar`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `BUTTON` )
                )->a( n = `text`  v = `Save`
                )->a( n = `type`  v = `Accept` ).

    IF mo_parent_page IS INITIAL.
      client->view_display( page->stringify( ) ).

    ELSE.
      mv_view_display = abap_true.

    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).

    ENDIF.

    on_event( ).

  ENDMETHOD.


  METHOD set_app_data.

    mv_table = table.

  ENDMETHOD.


  METHOD get_data.

    FIELD-SYMBOLS <table>     TYPE STANDARD TABLE.
    FIELD-SYMBOLS <table_tmp> TYPE STANDARD TABLE.

    mt_comp = get_comp( ).

    TRY.

        DATA(new_struct_desc) = cl_abap_structdescr=>create( mt_comp ).

        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_table     TYPE HANDLE new_table_desc.

        CREATE DATA mt_table_tmp TYPE HANDLE new_table_desc.
        CREATE DATA ms_table_row TYPE HANDLE new_struct_desc.

        ASSIGN mt_table->* TO <table>.

        SELECT *
          FROM (mv_table)
          ORDER BY PRIMARY KEY
          INTO CORRESPONDING FIELDS OF TABLE @<table>
          UP TO 100 ROWS.

      CATCH cx_root.

    ENDTRY.

    ASSIGN mt_table_tmp->* TO <table_tmp>.

    <table_tmp> = <table>.
    get_fixval( ).

  ENDMETHOD.


  METHOD get_fixval.

    TYPES:
      BEGIN OF ty_s_fixvalue,
        low        TYPE string,
        high       TYPE string,
        option     TYPE string,
        ddlanguage TYPE string,
        ddtext     TYPE string,
      END OF ty_s_fixvalue.
    TYPES ty_t_fixvalue TYPE STANDARD TABLE OF ty_s_fixvalue WITH EMPTY KEY.

    DATA comp        TYPE cl_abap_structdescr=>component_table.
    DATA lt_fixval   TYPE ty_t_fixvalue.
    DATA structdescr TYPE REF TO cl_abap_structdescr.

    LOOP AT mt_comp REFERENCE INTO DATA(dfies).

      comp = VALUE cl_abap_structdescr=>component_table(
                       BASE comp
                       ( name = dfies->name
                         type = CAST #( cl_abap_datadescr=>describe_by_data( lt_fixval ) ) ) ).
    ENDLOOP.

    structdescr = cl_abap_structdescr=>create( comp ).

    CREATE DATA ms_fixval TYPE HANDLE structdescr.

  ENDMETHOD.


  METHOD get_comp.

    DATA index TYPE int4.

    TRY.

        TRY.

            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = mv_table
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

ENDCLASS.
