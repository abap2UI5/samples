class Z2UI5_CL_DEMO_APP_106 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  data MV_VALUE type STRING .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_106 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).

      view->shell(
            )->page(
                    title          = 'abap2UI5 - Rich Text Editor'
                    navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                    shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
                )->header_content(
                    )->link(
                        text = 'Source_Code'
                        href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                        target = '_blank'
                )->get_parent(
                )->simple_form( title = 'Rich Text Editor' editable = abap_true
                  )->content( 'form'
                   )->rich_text_editor( width = `100%`
                                        height = `400px`
                                        value = client->_bind_edit( mv_value )
                                        customtoolbar = abap_true
                                        showGroupFont = abap_true
                                        showGroupLink = abap_true
                                        showGroupInsert = abap_true
                       )->get_parent( )->get_parent( )->get_parent(
                 )->footer(
                    )->overflow_toolbar(
                        )->button(
                            text  = 'Send To Server'
                            type = 'Emphasized'
                            icon  = 'sap-icon://paper-plane'
                            press = client->_event( 'SERVER' )
                          ).

      client->view_display( view->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'SERVER'.
        client->message_box_display( mv_value ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack  ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
