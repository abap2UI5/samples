CLASS z2ui5_cl_demo_app_324 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mo_client TYPE REF TO z2ui5_if_client.
    METHODS call_dynpro.
ENDCLASS.

CLASS z2ui5_cl_demo_app_324 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    TRY.
        IF mo_client->check_on_init( ).
          mo_client->view_display( z2ui5_cl_xml_view=>factory(
                                    )->page( shownavbutton  = mo_client->check_app_prev_stack( )
                                             navbuttonpress = mo_client->_event_nav_app_leave( )
                                    )->button( text  = `Call dynpro`
                                               press = mo_client->_event( `PRESS` )
                                    )->stringify( ) ).
        ENDIF.

        IF mo_client->check_on_event( `PRESS` ).
          call_dynpro( ).
        ENDIF.

      CATCH cx_root INTO DATA(x).
        mo_client->nav_app_call( z2ui5_cl_pop_error=>factory( x ) ).
    ENDTRY.
  ENDMETHOD.

  METHOD call_dynpro.

    " of course this makes no sense in abap2UI5.
    " It's just to provoke "Sending of dynpro SAPLSPO1 0500 not possible" error.
    DATA(fm) = `POPUP_TO_CONFIRM`.
    CALL FUNCTION fm
      EXPORTING
        text_question  = `Test`
      EXCEPTIONS
        text_not_found = 1
        OTHERS         = 2.
  ENDMETHOD.
ENDCLASS.
