CLASS z2ui5_cl_smp_app_324 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS call_dynpro.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_324 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
          )->ele( n = `View` ns = `mvc`
              )->a( n = `displayBlock` v = `true`
              )->a( n = `height`       v = `100%`
              )->a( n = `xmlns`        v = `sap.m`
              )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
              )->a( n = `xmlns:core`   v = `sap.ui.core`

              )->ele( `Shell`
                  )->ele( `Page`
                      )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                      )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )

                      )->tag( `Button`
                          )->a( n = `press` v = client->_event( `PRESS` )
                          )->a( n = `text`  v = `Call dynpro` ).

      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( ).

      CASE client->get_event( ).
        WHEN `PRESS`.
          call_dynpro( ).
      ENDCASE.

    ENDIF.

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
