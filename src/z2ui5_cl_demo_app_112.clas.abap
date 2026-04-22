CLASS z2ui5_cl_demo_app_112 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA mo_view_parent TYPE REF TO z2ui5_cl_xml_view.
    DATA mv_class_2 TYPE string.
    DATA mr_data TYPE REF TO data.

    METHODS on_event.
    METHODS view_display
      CHANGING
        xml TYPE REF TO z2ui5_cl_xml_view OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_112 IMPLEMENTATION.

  METHOD view_display.

    mo_view_parent->input( value       = client->_bind_edit( mv_class_2 )
                           placeholder = `Input From Class 2` ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `MESSAGE_SUB` ).
      client->message_box_display( `event sub app` ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
