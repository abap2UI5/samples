" @keywords popup app dialog edit row factory nav_app_leave popup_destroy called app add delete
" @summary The app behind the dialog of Z2UI5_CL_SMP_APP_500 - it is a full app with its own state, shows a Dialog instead of a view, and leaves the edited table on itself for the caller.
CLASS z2ui5_cl_smp_app_501 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the whole table, edited in place: the caller reads it back off this
    " instance with get_app_prev( ), so it is PUBLIC and it is the contract
    DATA t_table TYPE z2ui5_cl_smp_app_500=>ty_t_row.
    DATA s_row   TYPE z2ui5_cl_smp_app_500=>ty_s_row.

    CLASS-METHODS factory
      IMPORTING t_table       TYPE z2ui5_cl_smp_app_500=>ty_t_row
                row_id        TYPE i
                edit          TYPE abap_bool
      RETURNING VALUE(result) TYPE REF TO z2ui5_cl_smp_app_501.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA edit   TYPE abap_bool.
    DATA row_id TYPE i.

    METHODS on_init.
    METHODS on_event.
    METHODS popup_display.
    METHODS leave.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_501 IMPLEMENTATION.

  METHOD factory.

    result         = NEW #( ).
    result->t_table = t_table.
    result->row_id  = row_id.
    result->edit    = edit.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
      popup_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

    " No check_on_navigated( ) branch: this app owns a POPUP, not the main
    " view slot. The framework pushes the model back into the still-standing
    " dialog by itself - only an app that owns the main slot re-displays.

  ENDMETHOD.


  METHOD on_init.

    " the one row the dialog edits; an add starts from an empty row that
    " already carries the id the caller handed over
    s_row = VALUE #( t_table[ row_id = row_id ] DEFAULT VALUE #( row_id = row_id ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `POPUP_EDIT`.
        DATA(row) = REF #( t_table[ row_id = row_id ] OPTIONAL ).
        IF row IS BOUND.
          row->* = s_row.
        ENDIF.
        leave( ).

      WHEN `POPUP_ADD`.
        INSERT s_row INTO TABLE t_table.
        leave( ).

      WHEN `POPUP_DELETE`.
        DELETE t_table WHERE row_id = row_id.
        leave( ).

      WHEN `POPUP_CLOSE`.
        leave( ).

    ENDCASE.

  ENDMETHOD.


  METHOD leave.

    client->popup_destroy( ).
    client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

  ENDMETHOD.


  METHOD popup_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns:form` v = `sap.ui.layout.form` ).

    DATA(dialog) = popup->ele( `Dialog`
        )->a( n = `title`      t = COND #( WHEN edit = abap_true THEN `Edit Row` ELSE `Add Row` )
        )->a( n = `afterClose` v = client->_event( `POPUP_CLOSE` ) ).

    " the key fields are locked once the row exists - an edit may not turn a
    " row into a different one
    dialog->ele( n = `SimpleForm` ns = `form`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Label`
                )->a( n = `text` v = `Carrier`
            )->tag( `Input`
                )->a( n = `value`   v = client->_bind( s_row-carrid )
                )->a( n = `enabled` b = xsdbool( edit = abap_false )
            )->tag( `Label`
                )->a( n = `text` v = `Connection`
            )->tag( `Input`
                )->a( n = `value`   v = client->_bind( s_row-connid )
                )->a( n = `enabled` b = xsdbool( edit = abap_false )
            )->tag( `Label`
                )->a( n = `text` v = `From`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( s_row-cityfrom )
            )->tag( `Label`
                )->a( n = `text` v = `To`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( s_row-cityto ) ).

    " the buttons are the Dialog's own aggregation, not the form's - held in
    " a variable and started as a new statement rather than climbed back to
    DATA(buttons) = dialog->ele( `buttons`
        )->tag( `Button`
            )->a( n = `text`  v = `Cancel`
            )->a( n = `press` v = client->_event( `POPUP_CLOSE` ) ).

    IF edit = abap_true.
      buttons->tag( `Button`
          )->a( n = `text`  v = `Delete`
          )->a( n = `type`  v = `Reject`
          )->a( n = `press` v = client->_event( `POPUP_DELETE` ) ).
    ENDIF.

    buttons->tag( `Button`
        )->a( n = `text`  v = `OK`
        )->a( n = `type`  v = `Emphasized`
        )->a( n = `press` v = client->_event( COND #( WHEN edit = abap_true
                                                      THEN `POPUP_EDIT`
                                                      ELSE `POPUP_ADD` ) ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
