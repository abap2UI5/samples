CLASS z2ui5_cl_demo_app_199 DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_table   TYPE REF TO data.
    DATA mv_counter TYPE string.
    DATA mt_comp    TYPE abap_component_tab.

  PROTECTED SECTION.
    DATA mo_client            TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS render_main.

  PRIVATE SECTION.
    METHODS refresh_data.
    METHODS add_data.

ENDCLASS.

CLASS z2ui5_cl_demo_app_199 IMPLEMENTATION.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `CLEAR`.
        refresh_data( ).
        mo_client->view_model_update( ).
      WHEN `ADD`.
        add_data( ).
        mo_client->view_model_update( ).
    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

    refresh_data( ).
    render_main( ).
  ENDMETHOD.

  METHOD render_main.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    FIELD-SYMBOLS <tab> TYPE data.
    ASSIGN mt_table->* TO <tab>.

    DATA(lo_page) = lo_view->page( id             = `page_main`
                             title          = `Refresh`
                             navbuttonpress = mo_client->_event_nav_app_leave( )
                             shownavbutton  = mo_client->check_app_prev_stack( )
                             class          = `sapUiContentPadding` ).
    DATA(lo_table) = lo_page->table( growing = `true`
                               width   = `auto`
                               items   = mo_client->_bind_edit( <tab> ) ).

    DATA(lo_columns) = lo_table->columns( ).

    LOOP AT mt_comp INTO DATA(comp).
      lo_columns->column( )->text( comp-name ).
    ENDLOOP.

    DATA(lo_cells) = lo_columns->get_parent( )->items(
                                       )->column_list_item( valign = `Middle`
                                                            type   = `Navigation`
                                       )->cells( ).

    LOOP AT mt_comp INTO comp.
      lo_cells->object_identifier( text = `{` && comp-name && `}` ).
    ENDLOOP.

    lo_page->button( text  = `Clear`
                  press = mo_client->_event( `CLEAR` )
                  )->button( text  = `Add`
                             press = mo_client->_event( `ADD` ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      on_init( ).
    ENDIF.

    ASSIGN mt_table->* TO <tab>.
    IF mv_counter <> lines( <tab> ) AND mv_counter IS NOT INITIAL.
      mo_client->message_box_display( text = `Frontend Lines <> Backend!`
                                   type = `error` ).
    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD refresh_data.

    FIELD-SYMBOLS <lo_table> TYPE STANDARD TABLE.
    TYPES ty_t_01 TYPE STANDARD TABLE OF z2ui5_t_01.

    TRY.

        CREATE DATA mt_table TYPE ty_t_01.
        ASSIGN mt_table->* TO <lo_table>.
        mt_comp = z2ui5_cl_util=>rtti_get_t_attri_by_any( <lo_table> ).

        SELECT id, id_prev FROM z2ui5_t_01
          INTO CORRESPONDING FIELDS OF TABLE @<lo_table>
          UP TO 2 ROWS.

        mv_counter = 2.

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

  METHOD add_data.

    FIELD-SYMBOLS <tab> TYPE STANDARD TABLE.
    ASSIGN mt_table->* TO <tab>.
    APPEND LINES OF <tab> TO <tab>.

    mv_counter = lines( <tab> ).
  ENDMETHOD.
ENDCLASS.
