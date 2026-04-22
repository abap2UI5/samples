CLASS z2ui5_cl_demo_app_125 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA title  TYPE string.
    DATA favicon  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_125 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(tmp) = view->_z2ui5( )->title( client->_bind_edit( title )
         )->shell(
         )->page(
                 title          = `abap2UI5 - Change Browser Title`
                 navbuttonpress = client->_event_nav_app_leave( )
                 shownavbutton  = client->check_app_prev_stack( )
             )->simple_form( title    = `Form Title`
                             editable = abap_true
                 )->content( `form`
                     )->title( `Input`
                     )->label( `title`
                     )->input( client->_bind_edit( title ) ).

    client->view_display( tmp->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      title = `my title`.

      view_display( ).

    ENDIF.

    CASE client->get( )-event.

      WHEN `SET_VIEW`.
        view_display( ).
        client->message_toast_display( |{ title } - title changed| ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
