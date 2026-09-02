CLASS z2ui5_cl_smp_app_501 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_table TYPE z2ui5_cl_smp_app_500=>ty_t_rows.
    DATA ms_row   TYPE z2ui5_cl_smp_app_500=>ty_row.

    CLASS-METHODS factory
      IMPORTING it_table      TYPE z2ui5_cl_smp_app_500=>ty_t_rows
                iv_row_id     TYPE i
                iv_edit       TYPE abap_bool
      RETURNING VALUE(result) TYPE REF TO z2ui5_cl_smp_app_501.

  PROTECTED SECTION.
    DATA client   TYPE REF TO z2ui5_if_client.
    DATA mv_init  TYPE abap_bool.
    DATA mv_edit  TYPE abap_bool.
    DATA mv_row_id TYPE i.

    METHODS on_init.
    METHODS render_popup.
    METHODS on_event.
    METHODS popup_edit.
    METHODS popup_delete.
    METHODS leave.
ENDCLASS.


CLASS z2ui5_cl_smp_app_501 IMPLEMENTATION.

  METHOD factory.
    result = NEW #( ).
    result->mt_table  = it_table.
    result->mv_row_id = iv_row_id.
    result->mv_edit   = iv_edit.
  ENDMETHOD.


  METHOD z2ui5_if_app~main.
    me->client = client.
    IF mv_init = abap_false.
      mv_init = abap_true.
      on_init( ).
      render_popup( ).
    ENDIF.
    on_event( ).
  ENDMETHOD.


  METHOD on_init.
    " table -> single edit row (table_to_row in the original)
    ms_row = VALUE #( mt_table[ row_id = mv_row_id ] DEFAULT VALUE #( row_id = mv_row_id ) ).
  ENDMETHOD.


  METHOD render_popup.
    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(form) = popup->dialog(
                     title      = COND #( WHEN mv_edit = abap_true THEN 'Edit Row' ELSE 'Add Row' )
                     afterclose = client->_event( 'POPUP_CLOSE' )
                 )->simple_form( editable = abap_true
                 )->content( 'form' ).

    " key field disabled in edit mode, like the original
    form->label( 'Carrier' ).
    form->input( value = client->_bind_edit( ms_row-carrid )
                 enabled = xsdbool( mv_edit = abap_false ) ).

    form->label( 'Connection' ).
    form->input( value = client->_bind_edit( ms_row-connid )
                 enabled = xsdbool( mv_edit = abap_false ) ).

    form->label( 'From' ).
    form->input( client->_bind_edit( ms_row-cityfrom ) ).

    form->label( 'To' ).
    form->input( client->_bind_edit( ms_row-cityto ) ).

    DATA(toolbar) = form->get_root( )->get_child( )->buttons( ).
    toolbar->button( text = 'Cancel'
                     press = client->_event( 'POPUP_CLOSE' ) ).
    IF mv_edit = abap_true.
      toolbar->button( text = 'Delete'
                       type = 'Reject'
                       press = client->_event( 'POPUP_DELETE' ) ).
    ENDIF.
    toolbar->button( text = 'OK'
                     type = 'Emphasized'
                     press = client->_event( COND #( WHEN mv_edit = abap_true
                                                     THEN 'POPUP_EDIT' ELSE 'POPUP_ADD' ) ) ).

    client->popup_display( popup->stringify( ) ).
  ENDMETHOD.


  METHOD on_event.
    CASE client->get( )-event.
      WHEN 'POPUP_EDIT'.
        popup_edit( ).
        leave( ).
      WHEN 'POPUP_ADD'.
        APPEND ms_row TO mt_table.
        leave( ).
      WHEN 'POPUP_DELETE'.
        popup_delete( ).
        leave( ).
      WHEN 'POPUP_CLOSE'.
        leave( ).
    ENDCASE.
  ENDMETHOD.


  METHOD popup_edit.
    DATA(row) = REF #( mt_table[ row_id = mv_row_id ] OPTIONAL ).
    IF row IS BOUND.
      row->* = ms_row.
    ENDIF.
  ENDMETHOD.


  METHOD popup_delete.
    DELETE mt_table WHERE row_id = mv_row_id.
  ENDMETHOD.


  METHOD leave.
    client->popup_destroy( ).
    client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
  ENDMETHOD.

ENDCLASS.