CLASS Z2UI5_CL_DEMO_APP_038 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    TYPES:
      BEGIN OF ty_msg,
        type        TYPE string,
        title       TYPE string,
        subtitle    TYPE string,
        description TYPE string,
        group       TYPE string,
      END OF ty_msg.

    DATA t_msg TYPE STANDARD TABLE OF ty_msg WITH EMPTY KEY.
    DATA check_initialized TYPE abap_bool.

    METHODS Z2UI5_display_view.
    METHODS Z2UI5_display_popup.
    METHODS Z2UI5_display_popover
      IMPORTING
        id TYPE string.

  PROTECTED SECTION.

    DATA client TYPE REF TO Z2UI5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_038 IMPLEMENTATION.


  METHOD Z2UI5_display_popover.

    DATA(popup) = Z2UI5_cl_xml_view=>factory_popup( ).

*    popup = popup->popover(
*              placement = `Top`
*              title = `Messages`
*              contentheight = '50%'
*              contentwidth = '50%' ).

    popup->message_popover(
            items      = client->_bind_edit( t_msg )
            groupitems = abap_true
            placement = `Top`
            initiallyexpanded = abap_true
            beforeclose = client->_event( val = 'POPOVER_CLOSE' check_view_destroy = abap_false )
        )->message_item(
            type        = `{TYPE}`
            title       = `{TITLE}`
            subtitle    = `{SUBTITLE}`
            description = `{DESCRIPTION}`
            groupname   = `{GROUP}` ).

    client->popover_display( xml = popup->stringify( ) by_id = id ).

  ENDMETHOD.


  METHOD Z2UI5_display_popup.

*    DATA(popup) = Z2UI5_cl_xml_view=>factory_popup( client ).
*
*    popup = popup->dialog(
*          title = `Messages`
*          contentheight = '50%'
*          contentwidth = '50%' ).
*
*    popup->message_view(
*            items = client->_bind_edit( val = t_msg
*             )
*            groupitems = abap_true
*        )->message_item(
*            type        = `{TYPE}`
*            title       = `{TITLE}`
*            subtitle    = `{SUBTITLE}`
*            description = `{DESCRIPTION}`
*            groupname   = `{GROUP}` ).
*
*    popup->footer( )->overflow_toolbar(
*      )->toolbar_spacer(
*      )->button(
*          id    = `test2`
*          text  = 'test'
*          press = client->_event( `TEST` )
*      )->button(
*          text  = 'close'
*          press = client->_event_client( client->cs_event-popup_close ) ).
*
*    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = 'abap2UI5 - List'
            navbuttonpress = client->_event( val = 'BACK' check_view_destroy = abap_true )
              shownavbutton = abap_true
            )->header_content(
                )->link(
                    text = 'Demo'  target = '_blank'
                    href = `https://twitter.com/abap2UI5/status/1647246029828268032`
                )->link(
                    text = 'Source_Code'  target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
            )->get_parent( ).
*    page->button( text = 'Messages in Popup' press = client->_event( 'POPUP' )  ).
    page->message_view(
        items = client->_bind_edit( t_msg )
        groupitems = abap_true
        )->message_item(
            type        = `{TYPE}`
            title       = `{TITLE}`
            subtitle    = `{SUBTITLE}`
            description = `{DESCRIPTION}`
            groupname   = `{GROUP}` ).

    page->footer( )->overflow_toolbar(
         )->button(
             id = 'test'
             text  = 'Messages (6)'
             press = client->_event( 'POPOVER' )
             type  = 'Emphasized'
         )->toolbar_spacer(
         )->button(
             text  = 'Send to Server'
             press = client->_event( 'BUTTON_SEND' )
             type  = 'Success' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD Z2UI5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      t_msg = VALUE #(
          ( description = 'descr' subtitle = 'subtitle' title = 'title' type = 'Error'     group = 'group 01' )
          ( description = 'descr' subtitle = 'subtitle' title = 'title' type = 'Information' group = 'group 01' )
          ( description = 'descr' subtitle = 'subtitle' title = 'title' type = 'Information' group = 'group 02' )
          ( description = 'descr' subtitle = 'subtitle' title = 'title' type = 'Success' group = 'group 03' ) ).

      Z2UI5_display_view( ).

    ENDIF.

    CASE client->get( )-event.
      WHEN 'POPOVER_CLOSE'.
        client->popover_destroy( ).
*      WHEN 'POPUP'.
*        Z2UI5_display_popup( ).
        WHEN 'TEST'.
        Z2UI5_display_popover( `test2` ).
      WHEN 'POPOVER'.
        Z2UI5_display_popover( `test` ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
