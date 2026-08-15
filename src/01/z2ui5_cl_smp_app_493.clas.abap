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

      DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
          )->ele( n = `View` ns = `mvc`
              )->a( n = `displayBlock` v = `true`
              )->a( n = `height`       v = `100%`
              )->a( n = `xmlns`        v = `sap.m`
              )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
              )->a( n = `xmlns:core`   v = `sap.ui.core` ).
      DATA(page) = view->ele( `Shell`
          )->ele( `Page`
              )->a( n = `title`          v = `abap2UI5 - Basics I - Hello World, the Smallest App`
              )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
              )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

      page->tag( `MessageStrip`
          )->a( n = `text`     v = `The whole app is what you see below: a class implementing z2ui5_if_app, ` &&
                     `one main( ) method, a view built as XML and handed to client->view_display( ). ` &&
                     `abap2UI5 calls main( ) on every roundtrip - here only the first one matters, ` &&
                     `which is what check_on_init( ) asks. Copy this class as the starting point ` &&
                     `for your own app.`
          )->a( n = `type`     v = `Information`
          )->a( n = `showIcon` b = abap_true
          )->a( n = `class`    v = `sapUiSmallMargin` ).

      page->tag( `Title`
          )->a( n = `text`  v = `Hello World`
          )->a( n = `class` v = `sapUiSmallMargin`
          )->a( n = `level` v = `H2` ).
      client->view_display( view->stringify( ) ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
