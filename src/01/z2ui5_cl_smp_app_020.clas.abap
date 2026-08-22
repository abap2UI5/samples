CLASS z2ui5_cl_smp_app_020 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA text          TYPE string.
    DATA cancel_text   TYPE string.
    DATA cancel_event  TYPE string.
    DATA confirm_text  TYPE string.
    DATA confirm_event TYPE string.
    DATA event         TYPE string.

    CLASS-METHODS factory
      IMPORTING
        i_text          TYPE string
        i_cancel_text   TYPE string
        i_cancel_event  TYPE string
        i_confirm_text  TYPE string
        i_confirm_event TYPE string
      RETURNING
        VALUE(result)   TYPE REF TO z2ui5_cl_smp_app_020.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_020 IMPLEMENTATION.

  METHOD factory.

    CREATE OBJECT result.
    result->text          = i_text.
    result->cancel_text   = i_cancel_text.
    result->cancel_event  = i_cancel_event.
    result->confirm_text  = i_confirm_text.
    result->confirm_event = i_confirm_event.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA dialog TYPE REF TO z2ui5_cl_ui5_view_builder.

    CASE client->get_event( ).
      WHEN cancel_event OR confirm_event.
        event = client->get_event( ).
        client->popup_destroy( ).
        client->nav_app_leave( ).
        RETURN.
    ENDCASE.

    
    popup = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core` ).
    
    dialog = popup->ele( `Dialog`
        )->a( n = `title` v = `abap2UI5 - Popup to decide` ).

    dialog->tag( `MessageStrip`
        )->a( n = `text`     v = `A reusable decision popup opened as a sub-app: its text, button labels and events ` &&
                   `are passed in by the caller, and the pressed event is sent back.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    dialog->ele( `VBox`
        )->tag( `Text`
            )->a( n = `text` v = text
    )->end(
        )->ele( `buttons`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( cancel_event )
                )->a( n = `text`  v = cancel_text
            )->tag( `Button`
                )->a( n = `press` v = client->_event( confirm_event )
                )->a( n = `text`  v = confirm_text
                )->a( n = `type`  v = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
