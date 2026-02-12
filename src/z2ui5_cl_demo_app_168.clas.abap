CLASS z2ui5_cl_demo_app_168 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS display.
    METHODS event.
    METHODS callback.

  PROTECTED SECTION.
    METHODS get_file
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_168 IMPLEMENTATION.

  METHOD callback.

    TRY.
        DATA(lo_prev) = mo_client->get_app( mo_client->get( )-s_draft-id_prev_app ).
        IF CAST z2ui5_cl_pop_file_dl( lo_prev )->result( ).
          mo_client->message_box_display( `the input is downloaded` ).
        ENDIF.
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

  METHOD display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->shell(
        )->page(
                title          = `abap2UI5 - Popup File Download`
                navbuttonpress = mo_client->_event_nav_app_leave( )
                shownavbutton  = mo_client->check_app_prev_stack( )
           )->button(
                text  = `Open Popup...`
                press = mo_client->_event( `POPUP` ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD event.

    IF mo_client->check_on_event( `POPUP` ).
      DATA(lo_app) = z2ui5_cl_pop_file_dl=>factory( get_file( ) ).
      mo_client->nav_app_call( lo_app ).
    ENDIF.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->get( )-check_on_navigated = abap_true.
      display( ).
      callback( ).
      RETURN.
    ENDIF.

    event( ).
  ENDMETHOD.

  METHOD get_file.

    result = `test`.
  ENDMETHOD.
ENDCLASS.
