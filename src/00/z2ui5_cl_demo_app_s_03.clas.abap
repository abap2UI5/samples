CLASS z2ui5_cl_demo_app_s_03 DEFINITION PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.
    DATA mv_magic_key TYPE string.
    DATA: BEGIN OF message,
            text TYPE string VALUE IS INITIAL,
            type TYPE string VALUE `None`,
          END OF message.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.
    METHODS view_display.
    METHODS on_event.

ENDCLASS.

CLASS z2ui5_cl_demo_app_s_03 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      view_display( ).
    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    SELECT
      SINGLE FROM icfservloc
      FIELDS icfactive
      WHERE icf_name = `MIME_DEMO`
      INTO @DATA(icfactive).

    " Note, these are demo sounds and are part of the abap2UI5 sample repo.
    " They are NOT meant to use in production.
    lo_view->_generic( name = `script`
                    ns   = `html` )->_cc_plain_xml(
                        |function playSuccess() \{ new Audio("/SAP/PUBLIC/BC/ABAP/mime_demo/z2ui5_demo_success.mp3").play(); \}|
                     && |function playError() \{ new Audio("/SAP/PUBLIC/BC/ABAP/mime_demo/z2ui5_demo_error.mp3").play(); \}| ).

    DATA(lo_vbox) = lo_view->page( title = `Play success and error sounds` )->vbox( class = `sapUiSmallMargin` ).

    IF icfactive = abap_false.
      lo_vbox->message_strip(
          text    = `ICF Service '/SAP/PUBLIC/BC/ABAP/mime_demo' is not active. Sounds will not play. Please activate the ICF service first.`
          type    = `Warning`
          visible = abap_true ).
    ENDIF.

    lo_vbox->message_strip(
        text    = mo_client->_bind( message-text )
        type    = mo_client->_bind( message-type )
        visible = `{= !!$` && mo_client->_bind( message-text ) && ` }` ).
    lo_vbox->text( text = `The magic key is: abap2UI5` ).
    lo_vbox->input( id          = `inputApp`
                 value       = mo_client->_bind_edit( mv_magic_key )
                 placeholder = `Enter magic key`
                 submit      = mo_client->_event( `ENTER` ) ).
    lo_vbox->button( text  = `submit`
                  type  = `accept`
                  press = mo_client->_event( `ENTER` ) ).

    lo_view->_z2ui5( )->focus( focusid = `inputApp` ).
    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `ENTER` ).
      IF mv_magic_key = `abap2UI5`.
        mo_client->follow_up_action( val = `playSuccess()` ).
        message-type = `Success`.
        message-text = `Hooray!`.
      ELSE.
        mo_client->follow_up_action( val = `playError()` ).
        message-type = `Error`.
        message-text = `That wasn't the magic key`.
      ENDIF.
      CLEAR mv_magic_key.
      mo_client->view_model_update( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
