" @keywords pdfviewer pdf document viewer popup control_by_id whitelisted
" @summary Opens the PDF viewer by calling it by ID, so a document can be shown from an event without rebuilding the view.
" @docs https://abap2ui5.github.io/docs/cookbook/device_capabilities/pdf https://abap2ui5.github.io/docs/cookbook/event_navigation/frontend
CLASS z2ui5_cl_smp_app_449 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_449 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
      DATA temp1 TYPE string_table.

    IF client->get_event( ) = `OPEN`.
      " open the popup-mode PDFViewer via the whitelisted open method -
      " the viewer brings its own dialog and close button.
      " t_arg is positional: id, method (the view defaults to cs_view-main
      " and can be omitted for a main-view control)
      
      CLEAR temp1.
      INSERT `demoPdf` INTO TABLE temp1.
      INSERT `open` INTO TABLE temp1.
      client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                t_arg = temp1 ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Control Behaviour - Open the PDF Viewer by ID`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    " a popup-mode PDFViewer kept as a dependent of the page; opened
    " imperatively from the backend, like a controller calling oViewer.open()
    page->ele( `dependents`
        )->ele( `PDFViewer`
            )->a( n = `id`     v = `demoPdf`
            )->a( n = `title`  v = `Sample PDF`
            )->a( n = `source` v = `https://sapui5.hana.ondemand.com/test-resources/sap/m/demokit/sample/PDFViewerPopup/sample1.pdf`
            )->a( n = `height` v = `100%` ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The button opens the popup-mode PDFViewer via the whitelisted open method ` &&
                   `(follow_up_action with cs_event-control_by_id), client-side after render.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `OPEN` )
            )->a( n = `text`  v = `Open PDF`
            )->a( n = `icon`  v = `sap-icon://pdf-attachment` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
