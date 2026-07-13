"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderResponsiveII
"! This is a responsive Object Header with a Title, 2 Statuses/Attributes rendered below the title in
"! a Master/Detail mode (fullScreenOptimized = false).
CLASS z2ui5_cl_demo_app_464 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_464 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Object Header Responsive II`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderResponsiveII` ).

    DATA(header) = page->object_header(
        responsive          = abap_true
        fullscreenoptimized = abap_false
        intro               = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`
        title               = `Long title truncated to 80 chars on all devices and to 50 chars on phone portrait`
        number              = `956.00`
        numberunit          = `EUR`
        numberstate         = `Success`
        backgrounddesign    = `Translucent`
        class               = `sapUiResponsivePadding--header` ).

    header->object_attribute(
        title = `Manufacturer`
        text  = `Very Best Screens` ).

    header->_generic( `statuses`
        )->object_status(
            title = `Approval`
            text  = `Pending`
            state = `Warning` ).

    header->markers(
        )->object_marker( type = `Flagged` )->get_parent(
        )->object_marker( type = `Favorite` ).

    DATA(items) = header->_generic( `headerContainer`
        )->icon_tab_bar(
            id          = `itb1`
            selectedkey = `key3`
            uppercase   = abap_true
            class       = `sapUiResponsiveContentPadding`
        )->items( ).

    items->icon_tab_filter(
        text  = `Info`
        count = `10`
        key   = `key1`
        )->vertical_layout(
            class = `sapUiContentPadding`
            width = `100%`
            )->image( src = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`
            )->text( `30 x 18 x 3 cm` ).

    items->icon_tab_filter(
        text  = `Activities`
        count = `10`
        key   = `key2`
        )->vertical_layout(
            class = `sapUiContentPadding`
            width = `100%`
            )->text( `Activity content goes here ...` ).

    items->icon_tab_filter(
        text  = `Attachments`
        count = `1`
        key   = `key3`
        )->link(
            text  = `Attachment`
            press = client->_event( `LINK_PRESSED` ) ).

    items->icon_tab_filter(
        text  = `PartnerInfo`
        key   = `key4`
        count = `1`
        )->link(
            text   = `Partner SAP SE`
            target = `_blank`
            href   = `http://www.sap.com/` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `LINK_PRESSED` ).
      client->message_box_display( `Link was clicked!` ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
