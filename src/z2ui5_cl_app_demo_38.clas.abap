CLASS z2ui5_cl_app_demo_38 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

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

    METHODS z2ui5_display_view.
    METHODS z2ui5_display_popup.
    METHODS z2ui5_display_popover
      IMPORTING
        id TYPE string.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_app_demo_38 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      t_msg = VALUE #(
          ( description = 'descr' subtitle = 'subtitle' title = 'title' type = 'Error'     group = 'group 01' )
          ( description = 'descr' subtitle = 'subtitle' title = 'title' type = 'Information' group = 'group 01' )
          ( description = 'descr' subtitle = 'subtitle' title = 'title' type = 'Information' group = 'group 02' )
          ( description = 'descr' subtitle = 'subtitle' title = 'title' type = 'Success' group = 'group 03' ) ).

      z2ui5_display_view( ).

    ENDIF.

    CASE client->get( )-event.
      WHEN 'POPUP'.
        z2ui5_display_popup( ).
        WHEN 'TEST'.
        z2ui5_display_popover( `test2` ).
      WHEN 'POPOVER'.
        z2ui5_display_popover( `test` ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.

  METHOD z2ui5_display_popover.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( client ).

    popup = popup->popover(
              placement = `Top`
              title = `Messages`
              contentheight = '50%'
              contentwidth = '50%' ).

    popup->message_view(
            items      = client->__bind_edit( t_msg )
            groupitems = abap_true
        )->message_item(
            type        = `{TYPE}`
            title       = `{TITLE}`
            subtitle    = `{SUBTITLE}`
            description = `{DESCRIPTION}`
            groupname   = `{GROUP}` ).

    client->set_popover( xml = popup->stringify( ) OPEN_BY_id = id ).

  ENDMETHOD.

  METHOD z2ui5_display_popup.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( client ).

    popup = popup->dialog(
          title = `Messages`
          contentheight = '50%'
          contentwidth = '50%' ).

    popup->message_view(
            items = client->__bind_edit( t_msg )
            groupitems = abap_true
        )->message_item(
            type        = `{TYPE}`
            title       = `{TITLE}`
            subtitle    = `{SUBTITLE}`
            description = `{DESCRIPTION}`
            groupname   = `{GROUP}` ).

    popup->footer( )->overflow_toolbar(
      )->toolbar_spacer(
      )->button(
          id    = `test2`
          text  = 'test'
          press = client->__event( `TEST` )
      )->button(
          text  = 'close'
          press = client->__event_frontend( client->cs_event-popup_close ) ).

    client->set_popup( popup->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( client ).

    DATA(page) = view->shell(
        )->page(
            title          = 'abap2UI5 - List'
            navbuttonpress = client->__event( val = 'BACK' check_view_transit = abap_true )
              shownavbutton = abap_true
            )->header_content(
                )->link(
                    text = 'Demo'  target = '_blank'
                    href = `https://twitter.com/abap2UI5/status/1647246029828268032`
                )->link(
                    text = 'Source_Code'  target = '_blank'
                    href = view->hlp_get_source_code_url(  )
            )->get_parent( ).
    page->button( text = 'Messages' press = client->__event( 'POPUP' )  ).
    page->message_view(
        items = client->__bind_edit( t_msg )
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
             press = client->__event( 'POPOVER' )
             type  = 'Emphasized'
         )->toolbar_spacer(
         )->button(
             text  = 'Send to Server'
             press = client->__event( 'BUTTON_SEND' )
             type  = 'Success' ).

    client->set_view( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
