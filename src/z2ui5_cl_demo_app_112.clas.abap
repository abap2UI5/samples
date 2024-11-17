CLASS z2ui5_cl_demo_app_112 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA client         TYPE REF TO z2ui5_if_client.
    DATA mo_view_parent TYPE REF TO z2ui5_cl_xml_view.
    DATA mv_class_2     TYPE string.
    DATA mv_init        TYPE abap_bool.
    DATA mr_data        TYPE REF TO data.

    METHODS on_init.
    METHODS on_event.

    METHODS display_view
      CHANGING
        xml TYPE REF TO z2ui5_cl_xml_view OPTIONAL.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.


CLASS z2ui5_cl_demo_app_112 IMPLEMENTATION.

  METHOD display_view.
    " TODO: parameter XML is never used or assigned (ABAP cleaner)

    mo_view_parent->input( value       = client->_bind_edit( mv_class_2 )
                           placeholder = `Input From Class 2` ).

  ENDMETHOD.

  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'MESSAGE_SUB'.
        client->message_box_display( `event sub app` ).

    ENDCASE.

  ENDMETHOD.

  METHOD on_init.

*    mv_descr = `data sub app`.
    display_view( ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF mv_init = abap_false.
      mv_init = abap_true.
      on_init( ).
      RETURN.
    ENDIF.

    on_event( ).

  ENDMETHOD.

ENDCLASS.
