CLASS z2ui5_cl_demo_app_125 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA title  TYPE string.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_125 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      title = `my title`.
      client->view_display( z2ui5_cl_xml_view=>factory(
          )->_cc( )->title( )->load_cc(
          )->_cc( )->timer( )->control( client->_event( `SET_VIEW`)
          )->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'SET_VIEW'.
        client->message_toast_display( |{ title } - title changed| ).

        DATA(view) = z2ui5_cl_xml_view=>factory( ).
        client->view_display( view->_cc(
              )->title( )->control( title
              )->shell(
              )->page(
                      title          = 'abap2UI5 - Change Browser Title'
                      navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                      shownavbutton  = abap_true
                  )->header_content(
                      )->link(
                          text = 'Source_Code'
                          href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                          target = '_blank'
                  )->get_parent(
                  )->simple_form( title = 'Form Title' editable = abap_true
                      )->content( 'form'
                          )->title( 'Input'
                          )->label( 'title'
                          )->input( client->_bind_edit( title )
                          )->button(
                              text  = 'Change title'
                              press = client->_event( 'SET_VIEW' )
               )->stringify( ) ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
