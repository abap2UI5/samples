CLASS z2ui5_cl_demo_app_212 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_view_display      TYPE abap_bool.
    DATA mv_view_model_update TYPE abap_bool.
    DATA mo_parent_view       TYPE REF TO z2ui5_cl_xml_view.
    DATA mt_table             TYPE REF TO data.
    DATA mt_table_tmp         TYPE REF TO data.
    DATA ms_table_row         TYPE REF TO data.

    METHODS set_app_data
      IMPORTING
        !table TYPE string.

  PROTECTED SECTION.
    DATA mv_table             TYPE string.
    DATA mt_comp              TYPE abap_component_tab.
    DATA mt_dfies             TYPE z2ui5_cl_util=>ty_t_dfies.
    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS on_init.

    METHODS on_event.

    METHODS render_main.

    METHODS get_data.

    METHODS get_comp
      RETURNING
        VALUE(result) TYPE abap_component_tab.

    METHODS init_layout.

    METHODS on_after_navigation.

    METHODS row_select.

    METHODS prefill_popup_values
      IMPORTING
        !index TYPE string.

    METHODS render_popup.

  PRIVATE SECTION.
    METHODS get_dfies.

ENDCLASS.


CLASS z2ui5_cl_demo_app_212 IMPLEMENTATION.

  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( ).

      WHEN 'ROW_SELECT'.

        row_select( ).

      WHEN OTHERS.



    ENDCASE.
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
      ASSIGN ms_table_row->* TO <table_row>.
      ASSIGN COMPONENT dfies-fieldname OF STRUCTURE <table_row> TO FIELD-SYMBOL(<value_struc>).

      IF <value_tab> IS ASSIGNED AND <value_struc> IS ASSIGNED.
        <value_struc> = <value_tab>.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD get_dfies.

    mt_dfies = z2ui5_cl_util=>rtti_get_t_dfies_by_table_name( mv_table ).

  ENDMETHOD.

  METHOD render_popup.

    FIELD-SYMBOLS <row> TYPE any.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(content) = popup->dialog( contentwidth = '60%'
          )->simple_form( layout   = 'ResponsiveGridLayout'
                          editable = abap_true
          )->content( ns = 'form' ).

    " Gehe über alle Comps wenn wir im Edit sind dann sind keyfelder nicht eingabebereit.
    LOOP AT mt_dfies REFERENCE INTO DATA(dfies).

      ASSIGN ms_table_row->* TO <row>.
      ASSIGN COMPONENT dfies->fieldname OF STRUCTURE <row> TO FIELD-SYMBOL(<val>).
      IF <val> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.



      content->label( text = `text` ).

      content->input( value       = client->_bind_edit( <val> )
                    enabled       = abap_false
                    showvaluehelp = abap_false ).

    ENDLOOP.

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

  METHOD on_init.
    get_data( ).

    get_dfies( ).

    init_layout( ).

    render_main( ).
  ENDMETHOD.

  METHOD init_layout.



  ENDMETHOD.

  METHOD render_main.

    FIELD-SYMBOLS <tab> TYPE data.

    IF mo_parent_view IS INITIAL.
      DATA(page) = z2ui5_cl_xml_view=>factory( ).
    ELSE.
      page = mo_parent_view->get( `Page` ).
    ENDIF.

    ASSIGN mt_table->* TO <tab>.

    DATA(table) = page->table( growing = 'true'
                               width   = 'auto'
                               items   = client->_bind_edit( val = <tab> ) ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(headder) = table->header_toolbar(
               )->overflow_toolbar(
                 )->toolbar_spacer( ).



    IF mo_parent_view IS INITIAL.

      client->view_display( page->get_root( )->xml_get( ) ).

    ELSE.

      mv_view_display = abap_true.

    ENDIF.

  ENDMETHOD.

  METHOD z2ui5_if_app~main.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      on_init( ).

    ENDIF.

    on_event( ).

    on_after_navigation( ).

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
                                    ( name = 'ROW_ID'
                                      type = CAST #( cl_abap_datadescr=>describe_by_data( index ) ) ) ).

        APPEND LINES OF component TO result.

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

  METHOD on_after_navigation.



  ENDMETHOD.

ENDCLASS.
