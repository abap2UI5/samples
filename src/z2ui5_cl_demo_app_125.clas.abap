CLASS z2ui5_cl_demo_app_125 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA title  TYPE string.
    DATA favicon  TYPE string.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
    data client type ref to z2ui5_if_client.
    METHODS display_view.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_125 IMPLEMENTATION.


  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(tmp) = view->_z2ui5( )->title( client->_bind_edit( title )
                   )->_z2ui5( )->favicon( favicon = client->_bind_edit( favicon )
         )->shell(
         )->page(
                 title          = 'abap2UI5 - Change Browser Title'
                 navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                 shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
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
                     )->label( 'favicon'
                     )->input( client->_bind_edit( favicon )
                   ).

    client->view_display( tmp->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      title = `my title`.
      favicon = `https://cdn.jsdelivr.net/gh/choper725/resources/123/abap2ui5.png`.

      display_view( ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'SET_VIEW'.
         display_view( ).
        client->message_toast_display( |{ title } - title changed| ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
