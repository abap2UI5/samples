"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderMarkers
"! This sample shows the different states of an Object Header, which can be set using the markers.
CLASS z2ui5_cl_demo_app_463 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_463 IMPLEMENTATION.

  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: Object Header - markers aggregation`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderMarkers` ).

    " the inner sap.m.Page wrapper of the original view is omitted - the app page is used instead
    DATA(header) = page->object_header(
        title      = `Notebook Basic 15`
        number     = `956.00`
        numberunit = `EUR`
        responsive = abap_true
        class      = `sapUiResponsivePadding--header` ).

    header->object_attribute( text = `4.2 KG`
        )->object_attribute( text = `30 x 18 x 3 cm` ).

    header->markers(
        )->object_marker( type = `Favorite` )->get_parent(
        )->object_marker( type = `Flagged` )->get_parent(
        )->object_marker( type = `Draft` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
