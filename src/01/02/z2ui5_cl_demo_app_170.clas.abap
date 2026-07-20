CLASS z2ui5_cl_demo_app_170 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_selected_key TYPE string.

    METHODS view_display.
    METHODS on_event.
    METHODS simple_popup1.
    METHODS simple_popup2.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_170 IMPLEMENTATION.

  METHOD simple_popup1.

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    DATA dialog TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE string_table.
    DATA content TYPE REF TO z2ui5_cl_xml_view.
    popup = z2ui5_cl_xml_view=>factory_popup( ).

    
    dialog = popup->dialog( stretch = abap_true
            afterclose                    = client->_event( `BTN_OK_1ND` )
         )->content( ).

    
    CLEAR temp1.
    INSERT `NavCon` INTO TABLE temp1.
    INSERT `POPUP` INTO TABLE temp1.
    INSERT `to` INTO TABLE temp1.
    INSERT `${$parameters>/selectedKey}` INTO TABLE temp1.
    
    content = dialog->icon_tab_bar( selectedkey        = client->_bind( mv_selected_key )
                                                  select     = client->_event_client( val   = client->cs_event-control_by_id
                                                                                      t_arg = temp1 )
                                                  headermode = `Inline`
                                                  expanded   = abap_true
                                                  expandable = abap_false
                                  )->items(
                                    )->icon_tab_filter( key  = `page1`
                                                        text = `Home` )->get_parent(
                                    )->icon_tab_filter( key  = `page2`
                                                        text = `Applications` )->get_parent(
                                    )->icon_tab_filter( key  = `page3`
                                                        text = `Users and Groups`
                                      )->items(
                                         )->icon_tab_filter( key  = `page11`
                                                             text = `User 1` )->get_parent(
                                         )->icon_tab_filter( key  = `page32`
                                                             text = `User 2` )->get_parent(
                                         )->icon_tab_filter( key  = `page33`
                                                             text = `User 3`
      )->get_parent( )->get_parent( )->get_parent( )->get_parent(
                                        )->content( )->vbox( height = `100%`
                                         )->nav_container( id                    = `NavCon`
                                                           initialpage           = `page1`
                                                           defaulttransitionname = `flip`
                                                           height                = `400px`
                                           )->pages(
                                            )->page(
                                              title = `first page`
                                              id    = `page1`
                                           )->get_parent(
                                            )->page(
                                              title = `second page`
                                              id    = `page2`
                                           )->get_parent(
                                            )->page(
                                              title = `third page`
                                              id    = `page3` ).

    dialog->get_parent( )->footer( )->overflow_toolbar(
                  )->toolbar_spacer(
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

    dialog->get_parent( )->footer( )->overflow_toolbar(
                  )->toolbar_spacer(
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
        text     = `Press the button to open a dialog; from there a second popup can be opened and navigated ` &&
                   `back to the first, demonstrating popup-to-popup navigation.`
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

    IF client->get( )-check_on_navigated = abap_true.

      view_display( ).
      RETURN.
    ENDIF.

    on_event( ).

  ENDMETHOD.

ENDCLASS.
