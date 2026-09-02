CLASS z2ui5_cl_smp_app_500 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        row_id   TYPE i,
        selkz    TYPE abap_bool,
        carrid   TYPE c LENGTH 3,
        connid   TYPE n LENGTH 4,
        cityfrom TYPE c LENGTH 20,
        cityto   TYPE c LENGTH 20,
      END OF ty_row,
      ty_t_rows TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA mt_table TYPE ty_t_rows.

  PROTECTED SECTION.
    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.
    DATA mv_next_id        TYPE i.

    METHODS on_init.
    METHODS render_main.
    METHODS on_event.
    METHODS on_after_popup.
    METHODS button_delete.
    METHODS button_save.
ENDCLASS.


CLASS z2ui5_cl_smp_app_500 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      on_init( ).
      render_main( ).
    ENDIF.

    on_after_popup( ).
    on_event( ).
  ENDMETHOD.


  METHOD on_init.

    mt_table = VALUE #(
      ( row_id = 1 carrid = 'LH'  connid = '0400' cityfrom = 'FRANKFURT' cityto = 'NEW YORK' )
      ( row_id = 2 carrid = 'UA'  connid = '0941' cityfrom = 'FRANKFURT' cityto = 'SAN FRAN' )
      ( row_id = 3 carrid = 'AA'  connid = '0017' cityfrom = 'NEW YORK'  cityto = 'SAN FRAN' ) ).
    mv_next_id = 4.

  ENDMETHOD.


  METHOD render_main.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->page( title         = 'Demo Table (Simple Selection)'
                             shownavbutton = abap_false ).

    DATA(table) = page->table(
                    growing = 'true'
                    width   = 'auto'
                    items   = client->_bind_edit( mt_table ) ).

    " columns (hardcoded instead of the layout manager)
    DATA(columns) = table->columns( ).
    columns->column( )->text( 'Sel' ).
    columns->column( )->text( 'Carrier' ).
    columns->column( )->text( 'Conn.' ).
    columns->column( )->text( 'From' ).
    columns->column( )->text( 'To' ).

    " one row template; row press opens the edit popup, passing ROW_ID
    DATA(cells) = columns->get_parent( )->items(
        )->column_list_item(
             type  = 'Navigation'
             press = client->_event( val   = 'ROW_SELECT'
                                     t_arg = VALUE #( ( `${ROW_ID}` ) ) )
        )->cells( ).

    cells->checkbox( '{SELKZ}' ).
    cells->text( '{CARRID}' ).
    cells->text( '{CONNID}' ).
    cells->text( '{CITYFROM}' ).
    cells->text( '{CITYTO}' ).

    " footer buttons: Add / Delete / Refresh / Save
    page->footer( )->overflow_toolbar( )->toolbar_spacer(
        )->button( text  = 'Add'
                   icon  = 'sap-icon://add'
                   press = client->_event( 'BUTTON_ADD' )
        )->button( text  = 'Delete'
                   type  = 'Reject'
                   icon  = 'sap-icon://delete'
                   press = client->_event( 'BUTTON_DELETE' )
        )->button( text  = 'Refresh'
                   icon  = 'sap-icon://refresh'
                   press = client->_event( 'BUTTON_REFRESH' )
        )->button( text  = 'Save'
                   type  = 'Success'
                   press = client->_event( 'BUTTON_SAVE' ) ).

    client->view_display( page->stringify( ) ).
  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'ROW_SELECT'.
        DATA(t_arg) = client->get( )-t_event_arg.
        DATA(arg) = t_arg[ 1 ].

        DATA(row_id) = arg.
        client->nav_app_call( z2ui5_cl_smp_app_501=>factory(
                                it_table  = mt_table
                                iv_row_id = CONV #( row_id )
                                iv_edit   = abap_true ) ).

      WHEN 'BUTTON_ADD'.
        client->nav_app_call( z2ui5_cl_smp_app_501=>factory(
                                it_table  = mt_table
                                iv_row_id = mv_next_id
                                iv_edit   = abap_false ) ).
        mv_next_id = mv_next_id + 1.

      WHEN 'BUTTON_DELETE'.

        button_delete( ).

      WHEN 'BUTTON_REFRESH'.
        on_init( ).

      WHEN 'BUTTON_SAVE'.
        button_save( ).
    ENDCASE.
  ENDMETHOD.


  METHOD button_delete.
    DELETE mt_table WHERE selkz = abap_true.
  ENDMETHOD.


  METHOD button_save.
    " no DB / no transport in the test version - just confirm
    client->message_toast_display( |{ lines( mt_table ) } rows "saved"| ).
  ENDMETHOD.


  METHOD on_after_popup.
    " same idea as the original: read the previous app's data back
    IF client->get( )-check_on_navigated = abap_false.
      RETURN.
    ENDIF.

    TRY.
        DATA(app) = CAST z2ui5_cl_smp_app_501(
                      client->get_app( client->get( )-s_draft-id_prev_app ) ).
        mt_table = app->mt_table.

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.