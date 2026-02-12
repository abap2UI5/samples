CLASS z2ui5_cl_demo_app_105 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mo_client TYPE REF TO z2ui5_if_client .
    DATA mo_view_parent TYPE REF TO z2ui5_cl_xml_view .
    DATA mv_class_1 TYPE string .
    DATA mv_init TYPE abap_bool .

    METHODS on_init .

    METHODS on_event .
    METHODS display_view
      CHANGING
        !xml TYPE REF TO z2ui5_cl_xml_view OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_105 IMPLEMENTATION.

  METHOD display_view.

    mo_view_parent->input( value       = mo_client->_bind_edit( mv_class_1 )
                           placeholder = `Input From Class 1` ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `MESSAGE_SUB` ).
      mo_client->message_box_display( `event sub app` ).

    ENDIF.
  ENDMETHOD.

  METHOD on_init.

    display_view( ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mv_init = abap_false.
      mv_init = abap_true.
      on_init( ).
      RETURN.
    ENDIF.

    on_event( ).
  ENDMETHOD.
ENDCLASS.
