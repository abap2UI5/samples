"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.NotificationListItem/sample/sap.m.sample.NotificationListItem
"! A list item suitable for showing notifications to the user.
CLASS z2ui5_cl_demo_app_375 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_item,
        title              TYPE string,
        description        TYPE string,
        datetime           TYPE string,
        unread             TYPE abap_bool,
        priority           TYPE string,
        authorname         TYPE string,
        authorpicture      TYPE string,
        showclosebutton    TYPE abap_bool,
        truncate           TYPE string,
        hideshowmorebutton TYPE string,
        showbuttons        TYPE string,
        buttons            TYPE string,
      END OF ty_s_item.
    DATA t_items TYPE STANDARD TABLE OF ty_s_item.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS set_data.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_375 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    set_data( ).
    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `CLOSE`.

        DATA(closed_title) = client->get_event_arg( 1 ).
        DELETE t_items WHERE title = closed_title.
        client->message_toast_display( |Item Closed: { closed_title }| ).
        view_display( ).

      WHEN `ITEM_PRESS`.
        client->message_toast_display( |Item Pressed: { client->get_event_arg( 1 ) }| ).

      WHEN `ACCEPT`.
        client->message_toast_display( `Accept Button Pressed` ).

      WHEN `REJECT`.
        client->message_toast_display( `Reject Button Pressed` ).

      WHEN `CLICK_HINT_ICON`.
        popover_display( `button_hint_id` ).
    ENDCASE.

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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.NotificationListItem/sample/sap.m.sample.NotificationListItem` ).

    " The original sample uses a sap.m.NotificationList (available since UI5 1.90) with a
    " FlexItemData maxWidth - a sap.m.List is used here instead
    DATA(list) = page->vbox( `sapUiSmallMargin`
        )->list( ).

    LOOP AT t_items INTO DATA(s_item).

      " The properties `authorInitials` and `authorAvatarColor` of the original items are not available in UI5 1.71 and therefore omitted here
      DATA(list_item) = list->notification_list_item(
          title              = s_item-title
          description        = s_item-description
          datetime           = s_item-datetime
          unread             = s_item-unread
          priority           = s_item-priority
          authorname         = s_item-authorname
          authorpicture      = s_item-authorpicture
          showclosebutton    = s_item-showclosebutton
          truncate           = s_item-truncate
          hideshowmorebutton = s_item-hideshowmorebutton
          showbuttons        = s_item-showbuttons
          close              = client->_event( val   = `CLOSE`
                                               t_arg = VALUE #( ( `${$source>/title}` ) ) )
          press              = client->_event( val   = `ITEM_PRESS`
                                               t_arg = VALUE #( ( `${$source>/title}` ) ) ) ).

      CASE s_item-buttons.
        WHEN `ACCEPT_REJECT_LONG`.

          list_item->buttons(
              )->button(
                  text  = `Accept All Requested Information`
                  press = client->_event( `ACCEPT` )
              )->button(
                  text  = `Reject All Requested Information`
                  press = client->_event( `REJECT` ) ).

        WHEN `ACCEPT_REJECT_ICON`.

          list_item->buttons(
              )->button(
                  text  = `Accept`
                  icon  = `sap-icon://accept`
                  press = client->_event( `ACCEPT` )
              )->button(
                  text  = `Reject`
                  icon  = `sap-icon://sys-cancel`
                  press = client->_event( `REJECT` ) ).

        WHEN `ACCEPT_REJECT`.

          list_item->buttons(
              )->button(
                  text  = `Accept`
                  press = client->_event( `ACCEPT` )
              )->button(
                  text  = `Reject`
                  press = client->_event( `REJECT` ) ).

        WHEN `ACCEPT`.
          list_item->buttons(
              )->button(
                  text  = `Accept`
                  press = client->_event( `ACCEPT` ) ).
      ENDCASE.

    ENDLOOP.

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD set_data.

    DATA base_url TYPE string VALUE `https://sapui5.hana.ondemand.com/`.

    " The `Get Error` button of the original eighth item sets a MessageStrip via the `processingMessage`
    " aggregation, which is not available in the view API - the button is omitted here
    t_items = VALUE #(
      ( title           = `New order (#2525) With a very long title - Lorem ipsum dolor sit amet, consectetur adipiscing elit. ` &&
                          `Praesent feugiat, turpis vel scelerisque pharetra, tellus odio vehicula dolor, nec elementum lectus turpis at nunc.`
        description     = `And with a very long description and long labels of the action buttons - Lorem ipsum dolor sit amet, consectetur adipiscing elit. ` &&
                          `Praesent feugiat, turpis vel scelerisque pharetra, tellus odio vehicula dolor, nec elementum lectus turpis at nunc.`
        showclosebutton = abap_true
        datetime        = `1 hour`
        unread          = abap_true
        priority        = `None`
        authorname      = `Jean Doe`
        authorpicture   = base_url && `test-resources/sap/m/images/Woman_04.png`
        buttons         = `ACCEPT_REJECT_LONG` )
      ( title           = `New order (#2524), without action buttons`
        description     = `Short description`
        showclosebutton = abap_true
        datetime        = `3 days`
        unread          = abap_true
        priority        = `High`
        authorname      = `Office Notification`
        authorpicture   = `sap-icon://group` )
      ( title           = `New order (#2523) With a long title - Lorem ipsum dolor sit amet, consectetur adipiscing elit.`
        description     = `And short description`
        showclosebutton = abap_false
        unread          = abap_false
        datetime        = `3 days`
        priority        = `High`
        authorname      = `Patricia Clark`
        buttons         = `ACCEPT_REJECT_ICON` )
      ( title           = `New order (#2522)`
        description     = `With a very long description - Lorem ipsum dolor sit amet, consectetur adipiscing elit. ` &&
                          `Praesent feugiat, turpis vel scelerisque pharetra, tellus odio vehicula dolor, nec elementum lectus turpis at nunc.`
        showclosebutton = abap_true
        datetime        = `3 days`
        unread          = abap_true
        priority        = `Medium`
        authorname      = `John Smith` )
      ( title           = `New order (#2521)`
        description     = `With a very long description and no action buttons below - Lorem ipsum dolor sit amet, consectetur adipiscing elit. ` &&
                          `Praesent feugiat, turpis vel scelerisque pharetra, tellus odio vehicula dolor, nec elementum lectus turpis at nunc.`
        showclosebutton = abap_true
        datetime        = `3 days`
        unread          = abap_true
        priority        = `Low`
        authorname      = `John Smith`
        authorpicture   = base_url && `test-resources/sap/m/images/headerImg2.jpg` )
      ( title           = `New order (#2525) With a very long title and truncation disabled by default! Lorem ipsum dolor sit amet, consectetur adipiscing elit. ` &&
                          `Praesent feugiat, turpis vel scelerisque pharetra, tellus odio vehicula dolor, nec elementum lectus turpis at nunc.`
        description     = `And a very long description and long labels of the action buttons - Lorem ipsum dolor sit amet, consectetur adipiscing elit. ` &&
                          `Praesent feugiat, turpis vel scelerisque pharetra, tellus odio vehicula dolor, nec elementum lectus turpis at nunc.`
        showclosebutton = abap_true
        datetime        = `2 day`
        unread          = abap_false
        priority        = `Low`
        authorname      = `Jean Doe`
        authorpicture   = base_url && `test-resources/sap/m/images/Woman_04.png`
        truncate        = `false`
        buttons         = `ACCEPT` )
      ( title              = `New order (#2525) With a very long title and with truncation enabled but 'Show More' hidden! Lorem ipsum dolor sit amet, consectetur adipiscing elit. ` &&
                             `Praesent feugiat, turpis vel scelerisque pharetra, tellus odio vehicula dolor, nec elementum lectus turpis at nunc.`
        description        = `And a very long description and long labels of the action buttons - Lorem ipsum dolor sit amet, consectetur adipiscing elit. ` &&
                             `Praesent feugiat, turpis vel scelerisque pharetra, tellus odio vehicula dolor, nec elementum lectus turpis at nunc.`
        showclosebutton    = abap_true
        datetime           = `2 day`
        unread             = abap_false
        priority           = `Low`
        authorname         = `Jean Doe`
        authorpicture      = base_url && `test-resources/sap/m/images/Woman_04.png`
        hideshowmorebutton = `true`
        showbuttons        = `false`
        buttons            = `ACCEPT_REJECT` )
      ( title           = `New order (#2523) With a long title without description - Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet`
        showclosebutton = abap_false
        unread          = abap_false
        datetime        = `3 days`
        priority        = `High`
        authorname      = `Patricia Clark`
        authorpicture   = base_url && `test-resources/sap/m/images/female_BaySu.jpg`
        buttons         = `ACCEPT_REJECT_ICON` )
      ( title           = `New order (#2523) With a long title without description`
        showclosebutton = abap_true
        unread          = abap_false
        datetime        = `3 days`
        priority        = `High` ) ).

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
