"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectIdentifier/sample/sap.m.sample.ObjectIdentifier
"! The object identifier is a small building block representing an object by a title and short
"! description. Often it is used in the first column of a table.
CLASS z2ui5_cl_demo_app_466 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_466 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Object Identifier`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectIdentifier/sample/sap.m.sample.ObjectIdentifier` ).

    " data of /ProductCollection/0 of the mock model sap/ui/demo/mock/products.json used by the original sample
    page->vertical_layout(
        class = `sapUiContentPadding`
        width = `100%`
        )->object_identifier(
            title       = `Power Projector 4713`
            text        = `A very powerful projector with special features for Internet usability, USB`
            titleactive = abap_true
            titlepress  = client->_event( `TITLE_PRESSED` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `TITLE_PRESSED` ).
      client->message_box_display( `Title was clicked!` ).
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
