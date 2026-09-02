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
    DATA client    TYPE REF TO z2ui5_if_client.
    DATA mv_edit   TYPE abap_bool.
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

    IF client->check_on_init( ).
      on_init( ).
      render_popup( ).
    ELSEIF client->check_on_navigated( ).
      render_popup( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    " table -> the single row the popup edits (table_to_row in the original)
    ms_row = VALUE #( mt_table[ row_id = mv_row_id ] DEFAULT VALUE #( row_id = mv_row_id ) ).

  ENDMETHOD.


  METHOD render_popup.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns:form` v = `sap.ui.layout.form` ).

    DATA(dialog) = popup->ele( `Dialog`
        )->a( n = `title`      v = COND #( WHEN mv_edit = abap_true THEN `Edit Row` ELSE `Add Row` )
        )->a( n = `afterClose` v = client->_event( `POPUP_CLOSE` ) ).

    DATA(form) = dialog->ele( n = `SimpleForm` ns = `form`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form` ).

    " the key fields are disabled in edit mode, like the original
    form->tag( `Label`
        )->a( n = `text` v = `Carrier` ).
    form->tag( `Input`
        )->a( n = `value`   v = client->_bind( ms_row-carrid )
        )->a( n = `enabled` b = xsdbool( mv_edit = abap_false ) ).

    form->tag( `Label`
        )->a( n = `text` v = `Connection` ).
    form->tag( `Input`
        )->a( n = `value`   v = client->_bind( ms_row-connid )
        )->a( n = `enabled` b = xsdbool( mv_edit = abap_false ) ).

    form->tag( `Label`
        )->a( n = `text` v = `From` ).
    form->tag( `Input`
        )->a( n = `value` v = client->_bind( ms_row-cityfrom ) ).

    form->tag( `Label`
        )->a( n = `text` v = `To` ).
    form->tag( `Input`
        )->a( n = `value` v = client->_bind( ms_row-cityto ) ).

    DATA(buttons) = dialog->ele( `buttons` ).

    buttons->tag( `Button`
        )->a( n = `text`  v = `Cancel`
        )->a( n = `press` v = client->_event( `POPUP_CLOSE` ) ).

    IF mv_edit = abap_true.
      buttons->tag( `Button`
          )->a( n = `text`  v = `Delete`
          )->a( n = `type`  v = `Reject`
          )->a( n = `press` v = client->_event( `POPUP_DELETE` ) ).
    ENDIF.

    buttons->tag( `Button`
        )->a( n = `text`  v = `OK`
        )->a( n = `type`  v = `Emphasized`
        )->a( n = `press` v = client->_event( COND #( WHEN mv_edit = abap_true
                                                      THEN `POPUP_EDIT` ELSE `POPUP_ADD` ) ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `POPUP_EDIT`.
        popup_edit( ).
        leave( ).

      WHEN `POPUP_ADD`.
        APPEND ms_row TO mt_table.
        leave( ).

      WHEN `POPUP_DELETE`.
        popup_delete( ).
        leave( ).

      WHEN `POPUP_CLOSE`.
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
