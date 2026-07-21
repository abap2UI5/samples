CLASS z2ui5_cl_demo_app_449 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_449 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `OPEN`.
        " open the popup-mode PDFViewer via the whitelisted open method -
        " the viewer brings its own dialog and close button.
        " t_arg is positional: id, method (the view defaults to cs_view-main
        " and can be omitted for a main-view control)
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                  t_arg = VALUE #( ( `demoPdf` )
                                                   ( `open` ) ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - PDF Viewer - Display via CONTROL_BY_ID`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    " a popup-mode PDFViewer kept as a dependent of the page; opened
    " imperatively from the backend, like a controller calling oViewer.open()
    page->dependents(
        )->_generic( name   = `PDFViewer`
                     t_prop = VALUE #( ( n = `id`     v = `demoPdf` )
                                       ( n = `title`  v = `Sample PDF` )
                                       ( n = `source` v = `https://sapui5.hana.ondemand.com/test-resources/sap/m/demokit/sample/PDFViewerPopup/sample1.pdf` )
                                       ( n = `height` v = `100%` ) ) ).

    page->message_strip(
        text     = `The button opens the popup-mode PDFViewer via the whitelisted open method ` &&
                   `(follow_up_action with cs_event-control_by_id), client-side after render.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->vbox( `sapUiSmallMargin`
        )->button( text  = `Open PDF`
                   icon  = `sap-icon://pdf-attachment`
                   press = client->_event( `OPEN` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
