CLASS z2ui5_cl_demo_app_125 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA title  TYPE string.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
    METHODS display_view
      IMPORTING
        i_client TYPE REF TO z2ui5_if_client.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_125 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      title = `my title`.
      display_view( client ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'SET_VIEW'.
         display_view( client ).
        client->message_toast_display( |{ title } - title changed| ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

    ENDCASE.

  ENDMETHOD.

  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(tmp) = view->_z2ui5( )->title( i_client->_bind_edit( title )
         )->shell(
         )->page(
                 title          = 'abap2UI5 - Change Browser Title'
                 navbuttonpress = i_client->_event( val = 'BACK' check_view_destroy = abap_true )
                 shownavbutton  = abap_true
             )->header_content(
                 )->link(
                     text = 'Source_Code'
                     href = z2ui5_cl_demo_utility=>factory( i_client )->app_get_url_source_code( )
                     target = '_blank'
             )->get_parent(
             )->simple_form( title = 'Form Title' editable = abap_true
                 )->content( 'form'
                     )->title( 'Input'
                     )->label( 'title'
                     )->input( i_client->_bind_edit( title ) ).

    i_client->view_display( tmp->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
