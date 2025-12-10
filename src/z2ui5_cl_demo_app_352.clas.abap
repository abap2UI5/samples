CLASS z2ui5_cl_demo_app_352 DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA input TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

    METHODS on_event
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_352 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) =   view->shell(
             )->page( title          = 'abap2UI5 - Softkeyboard on/off'
                      navbuttonpress = client->_event( 'BACK' )
                      shownavbutton  = client->check_app_prev_stack( ) ).

    page->_z2ui5( )->focus( focusid = `ZINPUT`

      )->simple_form( editable = abap_true

                 )->content( 'form'
                     )->title( 'Keyboard on/off'
                     )->label( 'Input'
                     )->input( id               = `ZINPUT`
                               value            = client->_bind_edit( input )
                               showvaluehelp    = abap_true
                               valuehelprequest = client->_event( 'CALL_KEYBOARD' )
                               valuehelpiconsrc = 'sap-icon://keyboard-and-mouse' ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'CALL_KEYBOARD'.

      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
