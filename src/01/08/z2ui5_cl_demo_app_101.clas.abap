"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FeedListItem/sample/sap.m.sample.Feed
"! This sample shows you how to build a complete feed user interface by combining a FeedInput with a
"! list of FeedListItems.
CLASS z2ui5_cl_demo_app_101 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_entry,
        author    TYPE string,
        authorpic TYPE string,
        type      TYPE string,
        date      TYPE string,
        text      TYPE string,
      END OF ty_s_entry.
    DATA t_feed TYPE STANDARD TABLE OF ty_s_entry.
    DATA value TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS set_data.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_101 IMPLEMENTATION.

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

    IF client->check_on_event( `POST` ).

      IF value IS INITIAL.
        RETURN.
      ENDIF.

      " Like the original controller the new entry is posted as Alexandrina Victoria with the current date
      INSERT VALUE #( author    = `Alexandrina Victoria`
                      authorpic = `http://upload.wikimedia.org/wikipedia/commons/a/aa/Dronning_victoria.jpg`
                      type      = `Reply`
                      date      = |{ sy-datum DATE = ISO } { sy-uzeit TIME = ISO }|
                      text      = value ) INTO t_feed INDEX 1.
      value = VALUE #( ).
      client->view_model_update( ).

    ELSEIF client->check_on_event( `SENDER_PRESS` ).
      client->message_toast_display( |Clicked on Link: { client->get_event_arg( 1 ) }| ).

    ELSEIF client->check_on_event( `ICON_PRESS` ).
      client->message_toast_display( |Clicked on Image: { client->get_event_arg( 1 ) }| ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA base_url TYPE string VALUE `https://sapui5.hana.ondemand.com/`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell( )->page(
        title          = `abap2UI5 - Sample: Feed`
        navbuttonpress = client->_event_nav_app_leave( )
        shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FeedListItem/sample/sap.m.sample.Feed` ).

    page->feed_input(
        post  = client->_event( `POST` )
        icon  = base_url && `test-resources/sap/m/images/dronning_victoria.jpg`
        value = client->_bind_edit( value )
        class = `sapUiSmallMarginTopBottom` ).

    page->list(
        showseparators = `Inner`
        items          = client->_bind( t_feed )
        )->feed_list_item(
            sender                   = `{AUTHOR}`
            icon                     = `{AUTHORPIC}`
            senderpress              = client->_event( val   = `SENDER_PRESS`
                                                       t_arg = VALUE #( ( `${$source>/sender}` ) ) )
            iconpress                = client->_event( val   = `ICON_PRESS`
                                                       t_arg = VALUE #( ( `${$source>/sender}` ) ) )
            info                     = `{TYPE}`
            timestamp                = `{DATE}`
            text                     = `{TEXT}`
            convertlinkstoanchortags = `All` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD set_data.

    DATA base_url TYPE string VALUE `https://sapui5.hana.ondemand.com/`.

    t_feed = VALUE #(
      ( author    = `Alexandrina Victoria`
        authorpic = base_url && `test-resources/sap/m/images/dronning_victoria.jpg`
        type      = `Request`
        date      = `March 03 2013`
        text      = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                    `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                    ` Lorem ipsum dolor sit amet, consetetur sadipscing elitr, seddiamnonumyeirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                    ` Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                    ` Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` &&
                    ` Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.` )
      ( author    = `George Washington`
        authorpic = base_url && `test-resources/sap/m/images/george_washington.jpg`
        type      = `Reply`
        date      = `March 04 2013`
        text      = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore` )
      ( author    = `Alexandrina Victoria`
        authorpic = base_url && `test-resources/sap/m/images/dronning_victoria.jpg`
        type      = `Request`
        date      = `March 05 2013`
        text      = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat` )
      ( author    = `George Washington`
        authorpic = base_url && `test-resources/sap/m/images/george_washington.jpg`
        type      = `Rejection`
        date      = `March 07 2013`
        text      = `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.` ) ).

  ENDMETHOD.

ENDCLASS.
