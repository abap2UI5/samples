"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Text/sample/sap.m.sample.Text
"! The text control can be used for embedding longer paragraphs of text into your application, that
"! need text wrapping.
CLASS z2ui5_cl_demo_app_408 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_408 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
          )->page(
              title          = `abap2UI5 - Sample: Text`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      page->header_content(
         )->link(
             text   = `UI5 Demo Kit`
             target = `_blank`
             href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Text/sample/sap.m.sample.Text` ).

      page->vbox( `sapUiSmallMargin`
          )->text( `Lorem ipsum dolor st amet, consetetur sadipscing elitr, ` &&
                   `sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                   `At vero eos et accusam et justo duo dolores et ea rebum. ` &&
                   `Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                   `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, ` &&
                   `sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                   `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, ` &&
                   `sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat` ).

      client->view_display( view->stringify( ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
