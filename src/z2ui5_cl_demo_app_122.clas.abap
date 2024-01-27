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
    METHODS display_view
      IMPORTING
        i_client TYPE REF TO z2ui5_if_client.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_122 IMPLEMENTATION.


  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    i_client->view_display( view->shell(
          )->page(
                  title          = 'abap2UI5'
                  navbuttonpress = i_client->_event( val = 'BACK' check_view_destroy = abap_true )
                  shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
              )->header_content(
                  )->link(
                      text = 'Source_Code'
                      href = z2ui5_cl_demo_utility=>factory( i_client )->app_get_url_source_code( )
                      target = '_blank'
              )->get_parent(
              )->_z2ui5( )->info_frontend(
                                        finished          = i_client->_event( `INFO_FINISHED` )
                                        device_browser    = i_client->_bind_edit( device_browser )
                                        device_os         = i_client->_bind_edit( device_os )
                                        device_systemtype = i_client->_bind_edit( device_systemtype )
                                        ui5_gav           = i_client->_bind_edit( ui5_gav )
                                        ui5_theme         = i_client->_bind_edit( ui5_theme )
                                        ui5_version       = i_client->_bind_edit( ui5_version )
              )->simple_form( title = 'Information' editable = abap_true
                  )->content( 'form'
                      )->label( 'device_browser'
                      )->input( i_client->_bind_edit( device_browser )
                      )->label( `device_os`
                      )->input( i_client->_bind_edit( device_os )
                      )->label( `device_systemtype`
                      )->input( i_client->_bind_edit( device_systemtype )
                      )->label( `ui5_gav`
                      )->input( i_client->_bind_edit( ui5_gav )
                      )->label( `ui5_theme`
                      )->input( i_client->_bind_edit( ui5_theme )
                      )->label( `ui5_version`
                      )->input( i_client->_bind_edit( ui5_version )
           )->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
