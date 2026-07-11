CLASS z2ui5_cl_demo_app_375 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_375 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Notification List Item`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( `CLICK_HINT_ICON` ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.NotificationListItem` ).

    page->list(
        )->notification_list_item(
            title           = `New order #2201 received`
            description     = `A new order was created and is waiting for approval.`
            datetime        = `2 hours`
            unread          = abap_true
            priority        = `High`
            authorinitials  = `JS`
            authorname      = `John Smith`
            showclosebutton = abap_true
            close           = client->_event( val = `CLOSE` t_arg = VALUE #( ( `${$source>/title}` ) ) )
        )->notification_list_item(
            title           = `Delivery #98 delayed`
            description     = `The delivery date moved to next week.`
            datetime        = `1 day`
            unread          = abap_true
            priority        = `Medium`
            authorinitials  = `AB`
            authorname      = `Anna Bauer`
            showclosebutton = abap_true
            close           = client->_event( val = `CLOSE` t_arg = VALUE #( ( `${$source>/title}` ) ) )
        )->notification_list_item(
            title           = `Weekly report available`
            description     = `The weekly sales report is ready for download.`
            datetime        = `3 days`
            unread          = abap_false
            priority        = `None`
            authorinitials  = `SR`
            authorname      = `Sara Rossi`
            showclosebutton = abap_false ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `CLOSE`.
        client->message_toast_display( |Notification closed: { client->get_event_arg( 1 ) }| ).

      WHEN `CLICK_HINT_ICON`.
        popover_display( `button_hint_id` ).
    ENDCASE.

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `The notification list item shows a notification with title, description, author, age, priority and an optional close button.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.

ENDCLASS.
