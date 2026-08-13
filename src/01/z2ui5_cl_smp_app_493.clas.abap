" @keywords hello world smallest first app minimal start here template
CLASS z2ui5_cl_smp_app_493 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_493 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
          )->page(
              title          = `abap2UI5 - Basics I - Hello World, the Smallest App`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      page->message_strip(
          text     = `The whole app is what you see below: a class implementing z2ui5_if_app, ` &&
                     `one main( ) method, a view built as XML and handed to client->view_display( ). ` &&
                     `abap2UI5 calls main( ) on every roundtrip - here only the first one matters, ` &&
                     `which is what check_on_init( ) asks. Copy this class as the starting point ` &&
                     `for your own app.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiSmallMargin` ).

      page->title(
          text  = `Hello World`
          level = `H2`
          class = `sapUiSmallMargin` ).
      client->view_display( view->stringify( ) ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
