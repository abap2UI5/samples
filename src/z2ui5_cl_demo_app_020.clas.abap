CLASS z2ui5_cl_demo_app_020 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    CLASS-METHODS factory
      IMPORTING
        i_text          TYPE string
        i_cancel_text   TYPE string
        i_cancel_event  TYPE string
        i_confirm_text  TYPE string
        i_confirm_event TYPE string
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_demo_app_020.

    DATA text          TYPE string.
    DATA cancel_text   TYPE string.
    DATA cancel_event  TYPE string.
    DATA confirm_text  TYPE string.
    DATA confirm_event TYPE string.
    DATA event         TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_020 IMPLEMENTATION.

  METHOD factory.

    result = NEW #( ).
    result->text          = i_text.
    result->cancel_text   = i_cancel_text.
    result->cancel_event  = i_cancel_event.
    result->confirm_text  = i_confirm_text.
    result->confirm_event = i_confirm_event.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    CASE client->get( )-event.
      WHEN cancel_event OR confirm_event.
        event = client->get( )-event.
        client->popup_destroy( ).
        client->nav_app_leave( ).
        RETURN.
    ENDCASE.

    client->popup_display( z2ui5_cl_xml_view=>factory_popup(
         )->dialog( `abap2UI5 - Popup to decide`
                )->vbox(
                    )->text( text )->get_parent(
                )->buttons(
                        )->button(
                            text  = cancel_text
                            press = client->_event( cancel_event )
                        )->button(
                            text  = confirm_text
                            press = client->_event( confirm_event )
                            type  = `Emphasized`
                        )->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
