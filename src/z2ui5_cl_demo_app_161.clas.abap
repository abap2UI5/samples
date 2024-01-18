class Z2UI5_CL_DEMO_APP_161 definition
  public
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data CLIENT type ref to Z2UI5_IF_CLIENT .

  methods UI5_DISPLAY .
  methods UI5_EVENT .
  methods SIMPLE_POPUP1 .
  methods SIMPLE_POPUP2 .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_161 IMPLEMENTATION.


  METHOD SIMPLE_POPUP1.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( client ).

    DATA(dialog) = popup->dialog( )->content( ).

    DATA(content) = dialog->button( text = `Open 2nd popup` press = client->_event( 'GOTO_2ND' ) ).

    dialog->get_parent( )->footer( )->overflow_toolbar(
                  )->toolbar_spacer(
                  )->button(
                      text  = 'OK'
                      press = client->_event( 'BTN_OK' )
                      type  = 'Emphasized' ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD SIMPLE_POPUP2.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( client ).

    DATA(dialog) = popup->dialog( )->content( ).

    DATA(content) = dialog->label( text = 'this is a second popup' ).

    dialog->get_parent( )->footer( )->overflow_toolbar(
                  )->toolbar_spacer(
                  )->button(
                      text  = 'GOTO 1ST POPUP'
                      press = client->_event( 'BTN_OK' )
                      type  = 'Emphasized' ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD UI5_DISPLAY.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
                title          = 'abap2UI5 - Popup To Popup'
                navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
                shownavbutton  = abap_true
            )->header_content(
                )->link(
                    text = 'Source_Code'
                    target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
                    )->get_parent(
           )->button(
            text  = 'Open Popup...'
            press = client->_event( 'POPUP' ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD UI5_EVENT.

    CASE client->get( )-event.
      WHEN 'GOTO_2ND'.
        simple_popup2( ).

      WHEN 'BTN_OK'.
        client->popup_destroy(  ).

      WHEN 'POPUP'.
        simple_popup1( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.
      ui5_display( ).
      RETURN.
    ENDIF.

    ui5_event( ).

  ENDMETHOD.
ENDCLASS.
