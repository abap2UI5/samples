* Scenario 5 — Stateful session with a persistent enqueue
*
* Classic SAP GUI behaviour: the moment the user opens the screen the
* lock is held until they save or leave. With set_session_stateful( ),
* abap2UI5 keeps the session alive between roundtrips so a real
* ENQUEUE_EVVBAK survives.
*
* When to use this:
*   - Internal back-office apps with few concurrent users
*   - You want users to immediately see "locked by X" when opening
*
* Cost: each active user pins a work process. Do NOT use this for
* high-traffic apps.

CLASS z2ui5_cl_demo_app_s_11 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA vbeln TYPE vbak-vbeln VALUE `0000004711`.
    DATA auart TYPE vbak-auart.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event_save.
    METHODS on_event_cancel.
    METHODS lock_acquire.
    METHODS lock_release.
    METHODS view_display.
    METHODS data_read.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_s_11 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( `SAVE` ).
      on_event_save( ).
    ELSEIF client->check_on_event( `CANCEL` ).
      on_event_cancel( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    lock_acquire( ).

  ENDMETHOD.


  METHOD lock_acquire.

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

      client->set_session_stateful( abap_false ).
      client->message_box_display( |Sales order { vbeln } is locked by another user.| ).
      RETURN.

    ENDIF.

    client->set_session_stateful( ).
    data_read( ).
    view_display( ).

  ENDMETHOD.


  METHOD lock_release.

    CALL FUNCTION 'DEQUEUE_EVVBAK'
      EXPORTING
        mode_vbak = `E`
        mandt     = sy-mandt
        vbeln     = vbeln.

    client->set_session_stateful( abap_false ).

  ENDMETHOD.


  METHOD data_read.

    SELECT SINGLE auart
      FROM vbak
      WHERE vbeln = @vbeln
      INTO @auart.

  ENDMETHOD.


  METHOD on_event_save.

    "don't do that, just demo
    "DATA(now) = z2ui5_cl_util=>time_get_timestampl( ).
    "UPDATE vbak
    "  SET auart = @auart,
    "      aedat = @sy-datum,
    "      UPD_TMSTMP = @now
    "  WHERE vbeln = @vbeln.
    "COMMIT WORK.

    lock_release( ).
    client->message_toast_display( `Saved.` ).
    client->nav_app_leave( ).

  ENDMETHOD.


  METHOD on_event_cancel.

    lock_release( ).
    client->nav_app_leave( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
            title          = `Edit Sales Order — Stateful Lock`
            shownavbutton  = client->check_app_prev_stack( )
            navbuttonpress = client->_event( `CANCEL` )
            )->simple_form(
                title    = `Header`
                editable = abap_true
                )->content( `form`
                )->label( `Sales Order`
                )->input(
                    value   = vbeln
                    enabled = abap_false
                )->label( `Type`
                )->input( client->_bind_edit( auart )
                )->button(
                    text  = `Save`
                    press = client->_event( `SAVE` )
                )->button(
                    text  = `Cancel`
                    press = client->_event( `CANCEL` ) ).
    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
