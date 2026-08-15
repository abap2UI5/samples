CLASS z2ui5_cl_smp_app_212 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_view_display TYPE abap_bool.
    "! the Page this app renders into when it is embedded in another app's
    "! view; left empty the app builds a view of its own and displays it
    DATA mo_parent_page  TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA mt_table        TYPE REF TO data.
    DATA mt_table_tmp    TYPE REF TO data.
    DATA ms_table_row    TYPE REF TO data.

    METHODS set_app_data
      IMPORTING
        table TYPE string.

  PROTECTED SECTION.
    DATA mv_table             TYPE string.
    DATA mt_comp              TYPE abap_component_tab.
    DATA mt_dfies             TYPE z2ui5_cl_smp_context=>ty_t_dfies.
    DATA client            TYPE REF TO z2ui5_if_client.

    METHODS on_init.

    METHODS on_event.

    METHODS view_display.

    METHODS get_data.

    METHODS get_comp
      RETURNING
        VALUE(result) TYPE abap_component_tab.

    METHODS row_select.

    METHODS prefill_popup_values
      IMPORTING
        index TYPE string.

    METHODS render_popup.

    METHODS get_dfies.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_212 IMPLEMENTATION.

  METHOD on_event.

    IF client->check_on_event( `ROW_SELECT` ).
      row_select( ).
    ENDIF.

  ENDMETHOD.


  METHOD row_select.

    DATA(lt_arg) = client->get( )-t_event_arg.
    READ TABLE lt_arg INTO DATA(ls_arg) INDEX 1.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    prefill_popup_values( ls_arg ).

    render_popup( ).

  ENDMETHOD.


  METHOD prefill_popup_values.

    FIELD-SYMBOLS <tab>       TYPE STANDARD TABLE.
    FIELD-SYMBOLS <table_row> TYPE any.

    ASSIGN mt_table->* TO <tab>.

    ASSIGN <tab>[ index ] TO FIELD-SYMBOL(<row>).

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    LOOP AT mt_dfies INTO DATA(dfies).

      ASSIGN COMPONENT dfies-fieldname OF STRUCTURE <row> TO FIELD-SYMBOL(<value_tab>).

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      ASSIGN ms_table_row->* TO <table_row>.
      ASSIGN COMPONENT dfies-fieldname OF STRUCTURE <table_row> TO FIELD-SYMBOL(<value_struc>).

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      <value_struc> = <value_tab>.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_dfies.

    mt_dfies = z2ui5_cl_smp_context=>rtti_get_t_dfies_by_table_name( mv_table ).

  ENDMETHOD.


  METHOD render_popup.

    FIELD-SYMBOLS <row> TYPE any.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns:form` v = `sap.ui.layout.form` ).

    DATA(content) = popup->ele( `Dialog`
        )->a( n = `contentWidth` v = `60%`
        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `layout`   v = `ResponsiveGridLayout`
            )->a( n = `editable` b = abap_true
            )->ele( n = `content` ns = `form` ).

    " Walk through all comps — in edit mode the key fields are not editable.
    LOOP AT mt_dfies REFERENCE INTO DATA(dfies).

      ASSIGN ms_table_row->* TO <row>.
      ASSIGN COMPONENT dfies->fieldname OF STRUCTURE <row> TO FIELD-SYMBOL(<val>).

      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      content->tag( `Label`
          )->a( n = `text` v = `text` ).

      content->tag( `Input`
          )->a( n = `enabled`       b = abap_false
          )->a( n = `value`         v = client->_bind( <val> )
          )->a( n = `showValueHelp` b = abap_false ).

    ENDLOOP.

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD on_init.

    get_data( ).

    get_dfies( ).

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
              )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    ELSE.
      page = mo_parent_page.
    ENDIF.

    ASSIGN mt_table->* TO <tab>.

    DATA(table) = page->ele( `Table`
        )->a( n = `items`   v = client->_bind( val = <tab> )
        )->a( n = `growing` v = `true`
        )->a( n = `width`   v = `auto` ).

    DATA(headder) = table->ele( `headerToolbar`
        )->ele( `OverflowToolbar`
            )->tag( `ToolbarSpacer` ).

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
          INTO CORRESPONDING FIELDS OF TABLE @<table>
          UP TO 100 ROWS.

      CATCH cx_root.

    ENDTRY.

    ASSIGN mt_table_tmp->* TO <table_tmp>.

    <table_tmp> = <table>.

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
