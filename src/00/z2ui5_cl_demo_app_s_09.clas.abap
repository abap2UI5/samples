* Scenario 3 — Optimistic locking (timestamp check)
*
* On read we remember the record's last-changed timestamp. On save,
* we re-read it and reject if it changed in the meantime. Same idea
* as HTTP ETag or OData's @odata.etag.
*
* When to use this:
*   - Any time silent overwrites would be a problem
*   - Combine with Scenario 2 — it costs almost nothing and catches
*     real bugs

CLASS z2ui5_cl_demo_app_s_09 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA vbeln TYPE vbak-vbeln VALUE `0000004711`.
    DATA auart TYPE vbak-auart.

    DATA token_aedat TYPE vbak-aedat.
    DATA token_aezet TYPE vbak-UPD_TMSTMP.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event_save.
    METHODS view_display.
    METHODS data_read.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_s_09 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( `SAVE` ).
      on_event_save( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    data_read( ).
    view_display( ).

  ENDMETHOD.


  METHOD data_read.

    SELECT SINGLE auart, aedat, UPD_TMSTMP
      FROM vbak
      WHERE vbeln = @vbeln
      INTO ( @auart, @token_aedat, @token_aezet ).

  ENDMETHOD.


  METHOD on_event_save.

    DATA current_aedat TYPE vbak-aedat.
    DATA current_aezet TYPE vbak-UPD_TMSTMP.

    SELECT SINGLE aedat, UPD_TMSTMP
      FROM vbak
      WHERE vbeln = @vbeln
      INTO ( @current_aedat, @current_aezet ).

    IF current_aedat <> token_aedat OR current_aezet <> token_aezet.
      client->message_box_display(
        |Sales order { vbeln } has been changed by another user since you opened it. Please refresh.| ).
      RETURN.
    ENDIF.

    "don't do that, just for demo
    "DATA(now) = z2ui5_cl_util=>time_get_timestampl( ).
    "UPDATE vbak
    "  SET auart = @auart,
    "      aedat = @sy-datum,
    "      UPD_TMSTMP = @now
    "  WHERE vbeln = @vbeln.
    "COMMIT WORK.

    data_read( ).
    client->view_model_update( ).
    client->message_toast_display( `Saved.` ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
            title          = `Edit Sales Order — Optimistic Locking`
            shownavbutton  = client->check_app_prev_stack( )
            navbuttonpress = client->_event_nav_app_leave( )
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
                    press = client->_event( `SAVE` ) ).
    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
