CLASS z2ui5_cl_demo_app_170 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mo_client TYPE REF TO z2ui5_if_client .
    DATA mv_selected_key TYPE string .

    METHODS display .
    METHODS event .
    METHODS simple_popup1 .
    METHODS simple_popup2.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_170 IMPLEMENTATION.

  METHOD simple_popup1.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(lo_dialog) = lo_popup->dialog( stretch = abap_true
            afterclose                    = mo_client->_event( `BTN_OK_1ND` )
         )->content( ).

    DATA(lo_content) = lo_dialog->icon_tab_bar( selectedkey        = mo_client->_bind_edit( mv_selected_key )
                                                  select     = mo_client->_event_client( val = `POPUP_NAV_CONTAINER_TO` t_arg  = VALUE #( ( `NavCon` ) ( `${$parameters>/selectedKey}` ) ) )
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

    lo_dialog->get_parent( )->footer( )->overflow_toolbar(
                  )->toolbar_spacer(
                  )->button(
                      text  = `OK`
                      press = mo_client->_event( `BTN_OK_1ND` )
                      type  = `Emphasized` ).

    mo_client->popup_display( lo_popup->stringify( ) ).
  ENDMETHOD.

  METHOD simple_popup2.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(lo_dialog) = lo_popup->dialog(
        afterclose = mo_client->_event( `BTN_OK_2ND` )
         )->content( ).

    DATA(lo_content) = lo_dialog->label( text = `this is a second popup` ).

    lo_dialog->get_parent( )->footer( )->overflow_toolbar(
                  )->toolbar_spacer(
                  )->button(
                      text  = `GOTO 1ST POPUP`
                      press = mo_client->_event( `BTN_OK_2ND` )
                      type  = `Emphasized` ).

    mo_client->popup_display( lo_popup->stringify( ) ).
  ENDMETHOD.

  METHOD display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->shell(
        )->page(
                title          = `abap2UI5 - Popup To Popup`
                navbuttonpress = mo_client->_event_nav_app_leave( )
                shownavbutton  = mo_client->check_app_prev_stack( )
           )->button(
            text  = `Open Popup...`
            press = mo_client->_event( `POPUP` ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD event.

    CASE mo_client->get( )-event.
      WHEN `GOTO_2ND`.
        simple_popup2( ).
      WHEN `BTN_OK_2ND`.
        mo_client->popup_destroy( ).
        simple_popup1( ).
      WHEN `BTN_OK_1ND`.
        mo_client->popup_destroy( ).
      WHEN `POPUP`.
        simple_popup1( ).
    ENDCASE.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->get( )-check_on_navigated = abap_true.
      display( ).
      RETURN.
    ENDIF.

    event( ).
  ENDMETHOD.
ENDCLASS.
