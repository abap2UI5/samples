CLASS z2ui5_cl_demo_app_311 DEFINITION PUBLIC.

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

    DATA mt_msg TYPE STANDARD TABLE OF ty_msg WITH EMPTY KEY.

    METHODS display_view.
    METHODS display_popup.
    METHODS display_popover
      IMPORTING
        id TYPE string.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_311 IMPLEMENTATION.

  METHOD display_popover.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    lo_popup->message_popover(
            items             = mo_client->_bind( mt_msg )
            groupitems        = abap_true
            placement         = `Top`
            initiallyexpanded = abap_true
            beforeclose       = mo_client->_event( `POPOVER_CLOSE` )
        )->message_item(
            type        = `{TYPE}`
            title       = `{TITLE}`
            subtitle    = `{SUBTITLE}`
            description = `{DESCRIPTION}`
            groupname   = `{GROUP}` ).

    mo_client->popover_display( xml   = lo_popup->stringify( )
                             by_id = id ).
  ENDMETHOD.

  METHOD display_popup.

    DATA(lo_popup) = z2ui5_cl_xml_view=>factory_popup( ).

    lo_popup = lo_popup->dialog(
          title         = `Messages`
          contentheight = `50%`
          contentwidth  = `50%` ).

    lo_popup->message_view(
            items      = mo_client->_bind( mt_msg )
            groupitems = abap_true
        )->message_item(
            type        = `{TYPE}`
            title       = `{TITLE}`
            subtitle    = `{SUBTITLE}`
            description = `{DESCRIPTION}`
            groupname   = `{GROUP}` ).

    lo_popup->footer( )->overflow_toolbar(
      )->toolbar_spacer(
      )->button(
          id    = `test2`
          text  = `test`
          press = mo_client->_event( `TEST` )
      )->button(
          text  = `close`
          press = mo_client->_event_client( mo_client->cs_event-popup_close ) ).

    mo_client->popup_display( lo_popup->stringify( ) ).
  ENDMETHOD.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->_generic( ns   = `html`
                    name = `style` )->_cc_plain_xml( `.sapMDialogScroll { height:100%; }` ).
    DATA(lo_page) = lo_view->shell(
        )->page(
            title           = `abap2UI5 - List`
            navbuttonpress  = mo_client->_event_nav_app_leave( )
              shownavbutton = abap_true ).
    lo_page->button( text  = `Messages in Popup`
                  press = mo_client->_event( `POPUP` ) ).
    lo_page->message_view(
        items      = mo_client->_bind( mt_msg )
        groupitems = abap_true
        )->message_item(
            type        = `{TYPE}`
            title       = `{TITLE}`
            subtitle    = `{SUBTITLE}`
            description = `{DESCRIPTION}`
            groupname   = `{GROUP}` ).

    lo_page->footer( )->overflow_toolbar(
         )->button(
             id    = `test`
             text  = `Messages (6)`
             press = mo_client->_event( `POPOVER` )
             type  = `Emphasized`
         )->toolbar_spacer(
         )->button(
             text  = `Send to Server`
             press = mo_client->_event( `BUTTON_SEND` )
             type  = `Success` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      mt_msg = VALUE #(
          ( description = `descr` subtitle = `subtitle` title = `title` type = `Error`     group = `group 01` )
          ( description = `descr` subtitle = `subtitle` title = `title` type = `Information` group = `group 01` )
          ( description = `descr` subtitle = `subtitle` title = `title` type = `Information` group = `group 02` )
          ( description = `descr` subtitle = `subtitle` title = `title` type = `Success` group = `group 03` ) ).

      display_view( ).

    ENDIF.

    CASE mo_client->get( )-event.
      WHEN `POPOVER_CLOSE`.
        mo_client->popover_destroy( ).
      WHEN `POPUP`.
        display_popup( ).
      WHEN `TEST`.
        display_popover( `test2` ).
      WHEN `POPOVER`.
        display_popover( `test` ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
