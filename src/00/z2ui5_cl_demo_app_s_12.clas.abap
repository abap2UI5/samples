* Scenario 6 — Soft lock (advisory only)
*
* A soft lock is a row in a custom Z table marking
* "user X is editing sales order Y." It is NOT enforced by the SAP
* kernel — only your app code respects it. Use it for UX feedback
* ("locked by Alice since 09:32"), always layered on top of a real
* save-time guard.
*
* Required Z table ZS_SO_LOCK (create via SE11):
*   MANDT      MANDT       Client (key)
*   VBELN      VBELN_VA    Sales order (key)
*   USERNAME   SYUNAME     Editing user
*   LOCKED_AT  TIMESTAMPL  When the lock started
* Delivery class A.

CLASS z2ui5_cl_demo_app_s_12 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA vbeln       TYPE vbak-vbeln VALUE `0000004711`.
    DATA auart       TYPE vbak-auart.
    DATA locked_by   TYPE string.
    DATA token_aedat TYPE vbak-aedat.
    DATA token_aezet TYPE vbak-UPD_TMSTMP.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event_save.
    METHODS on_event_release.
    METHODS soft_lock_acquire
      RETURNING
        VALUE(ok) TYPE abap_bool.
    METHODS soft_lock_release.
    METHODS view_display.
    METHODS data_read.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_s_12 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( `SAVE` ).
      on_event_save( ).
    ELSEIF client->check_on_event( `RELEASE` ).
      on_event_release( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    IF soft_lock_acquire( ) = abap_false.

      data_read( ).
      view_display( ).
      RETURN.

    ENDIF.

    data_read( ).
    view_display( ).

  ENDMETHOD.


  METHOD soft_lock_acquire.

    DATA s_existing TYPE z2ui5_sample_01.

    SELECT SINGLE *
      FROM z2ui5_sample_01
      WHERE vbeln = @vbeln
      INTO @s_existing.

    IF sy-subrc = 0 AND s_existing-username <> sy-uname.

      locked_by = |Locked by { s_existing-username } since { s_existing-locked_at TIMESTAMP = USER }|.
      ok        = abap_false.
      RETURN.

    ENDIF.

    DATA s_new TYPE z2ui5_sample_01.
    s_new-vbeln    = vbeln.
    s_new-username = sy-uname.
    s_new-locked_at = z2ui5_cl_util=>time_get_timestampl( ).

    MODIFY z2ui5_sample_01 FROM @s_new.
    COMMIT WORK.

    locked_by = ``.
    ok       = abap_true.

  ENDMETHOD.


  METHOD soft_lock_release.

    DELETE FROM z2ui5_sample_01
      WHERE vbeln    = @vbeln
        AND username = @sy-uname.
    COMMIT WORK.

  ENDMETHOD.


  METHOD data_read.

    SELECT SINGLE auart, aedat, UPD_TMSTMP
      FROM vbak
      WHERE vbeln = @vbeln
      INTO ( @auart, @token_aedat, @token_aezet ).

  ENDMETHOD.


  METHOD on_event_save.

    CALL FUNCTION 'ENQUEUE_EVVBAK'
      EXPORTING
        mode_vbak      = `E`
        mandt          = sy-mandt
        vbeln          = vbeln
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.

    IF sy-subrc <> 0.
      client->message_box_display( `Could not acquire enqueue` ).
      RETURN.
    ENDIF.

    DATA current_aedat TYPE vbak-aedat.
    DATA current_aezet TYPE vbak-UPD_TMSTMP.

    SELECT SINGLE aedat, UPD_TMSTMP
      FROM vbak
      WHERE vbeln = @vbeln
      INTO ( @current_aedat, @current_aezet ).

    IF current_aedat <> token_aedat OR current_aezet <> token_aezet.

      CALL FUNCTION 'DEQUEUE_EVVBAK'
        EXPORTING
          mode_vbak = `E`
          mandt     = sy-mandt
          vbeln     = vbeln.

      client->message_box_display( `Record changed by another user. Please refresh.` ).
      RETURN.

    ENDIF.

    "don't do that, just demo
    "DATA(now) = z2ui5_cl_util=>time_get_timestampl( ).
    "UPDATE vbak
    "  SET auart = @auart,
    "      aedat = @sy-datum,
    "      UPD_TMSTMP = @now
    "  WHERE vbeln = @vbeln.
    "COMMIT WORK.

    CALL FUNCTION 'DEQUEUE_EVVBAK'
      EXPORTING
        mode_vbak = `E`
        mandt     = sy-mandt
        vbeln     = vbeln.

    soft_lock_release( ).
    client->message_toast_display( `Saved.` ).
    client->nav_app_leave( ).

  ENDMETHOD.


  METHOD on_event_release.

    soft_lock_release( ).
    client->nav_app_leave( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(editable) = COND abap_bool( WHEN locked_by IS INITIAL THEN abap_true ELSE abap_false ).

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
            title          = `Edit Sales Order — Soft Lock + Save Guard`
            shownavbutton  = client->check_app_prev_stack( )
            navbuttonpress = client->_event_nav_app_leave( )
            )->simple_form(
                title    = `Header`
                editable = editable
                )->content( `form`
                )->label( `Sales Order`
                )->input(
                    value   = vbeln
                    enabled = abap_false
                )->label( `Type`
                )->input( client->_bind_edit( auart )
                )->label( `Status`
                )->input(
                    value   = locked_by
                    enabled = abap_false
                )->button(
                    text    = `Save`
                    press   = client->_event( `SAVE` )
                    enabled = editable
                )->button(
                    text  = `Release & Exit`
                    press = client->_event( `RELEASE` ) ).
    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
