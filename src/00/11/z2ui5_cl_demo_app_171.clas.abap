CLASS z2ui5_cl_demo_app_171 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_171 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.

    TRY.

        IF client->check_on_init( ).
          "init values here..

        ELSEIF client->check_on_navigated( ).
          DATA(lo_app_prev) = client->get_app_prev( ).
          "read attributes of previous app here...

        ELSEIF client->check_on_event( ).

          CASE client->get( )-event.
            WHEN `OK`.
              DATA(lt_arg) = client->get_event_arg( ).
              "...

            WHEN `CANCEL`.
              "...

          ENDCASE.

        ENDIF.

      CATCH cx_root INTO DATA(lx).
        client->message_box_display( lx ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
