CLASS z2ui5_cl_demo_app_161 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    METHODS view_display.
    METHODS on_event.
    METHODS simple_popup1.
    METHODS simple_popup2.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_161 IMPLEMENTATION.

  METHOD simple_popup1.

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    DATA dialog TYPE REF TO z2ui5_cl_xml_view.
    DATA content TYPE REF TO z2ui5_cl_xml_view.
    popup = z2ui5_cl_xml_view=>factory_popup( ).

    
    dialog = popup->dialog(
            afterclose = client->_event( `BTN_OK_1ND` )
         )->content( ).

    
    content = dialog->button( text  = `Open 2nd popup`
                                    press = client->_event( `GOTO_2ND` ) ).

    dialog->get_parent( )->buttons(
                  )->button(
                      text  = `OK`
                      press = client->_event( `BTN_OK_1ND` )
                      type  = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD simple_popup2.

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    DATA dialog TYPE REF TO z2ui5_cl_xml_view.
    DATA content TYPE REF TO z2ui5_cl_xml_view.
    popup = z2ui5_cl_xml_view=>factory_popup( ).

    
    dialog = popup->dialog(
        afterclose = client->_event( `BTN_OK_2ND` )
         )->content( ).

    
    content = dialog->label( `this is a second popup` ).

    dialog->get_parent( )->buttons(
                  )->button(
                      text  = `GOTO 1ST POPUP`
                      press = client->_event( `BTN_OK_2ND` )
                      type  = `Emphasized` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).
    
    page = view->shell(
        )->page(
                title          = `abap2UI5 - Popup To Popup`
                navbuttonpress = client->_event_nav_app_leave( )
                shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `This sample opens a popup from a button and then chains to a second popup ` &&
                   `from within the first one.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->button(
        text  = `Open Popup...`
        press = client->_event( `POPUP` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `GOTO_2ND`.
        simple_popup2( ).

      WHEN `BTN_OK_2ND`.
        client->popup_destroy( ).
        simple_popup1( ).

      WHEN `BTN_OK_1ND`.
        client->popup_destroy( ).

      WHEN `POPUP`.
        simple_popup1( ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
      RETURN.
    ENDIF.
    on_event( ).

  ENDMETHOD.

ENDCLASS.
