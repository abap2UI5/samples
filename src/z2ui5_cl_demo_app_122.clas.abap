CLASS z2ui5_cl_demo_app_122 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    DATA ui5_version TYPE string.
    DATA ui5_theme TYPE string.
    DATA ui5_gav TYPE string.
    DATA device_systemtype TYPE string.
    DATA device_os TYPE string.
    DATA device_browser TYPE string.
    DATA check_initialized TYPE abap_bool .

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS display_view.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_122 IMPLEMENTATION.


  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    client->view_display( view->shell(
          )->page(
                  title          = 'abap2UI5'
                  navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                  shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
              )->header_content(
                  )->link(
                      text = 'Source_Code'
                      href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                      target = '_blank'
              )->get_parent(
              )->_z2ui5( )->info_frontend(
                                        finished          = client->_event( `INFO_FINISHED` )
                                        device_browser    = client->_bind_edit( device_browser )
                                        device_os         = client->_bind_edit( device_os )
                                        device_systemtype = client->_bind_edit( device_systemtype )
                                        ui5_gav           = client->_bind_edit( ui5_gav )
                                        ui5_theme         = client->_bind_edit( ui5_theme )
                                        ui5_version       = client->_bind_edit( ui5_version )
              )->simple_form( title = 'Information' editable = abap_true
                  )->content( 'form'
                      )->label( 'device_browser'
                      )->input( client->_bind_edit( device_browser )
                      )->label( `device_os`
                      )->input( client->_bind_edit( device_os )
                      )->label( `device_systemtype`
                      )->input( client->_bind_edit( device_systemtype )
                      )->label( `ui5_gav`
                      )->input( client->_bind_edit( ui5_gav )
                      )->label( `ui5_theme`
                      )->input( client->_bind_edit( ui5_theme )
                      )->label( `ui5_version`
                      )->input( client->_bind_edit( ui5_version )
           )->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view(  ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
