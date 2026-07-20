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
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE string_table.

    CASE client->get( )-event.

      WHEN `OPEN`.
        " open the popup-mode PDFViewer via the whitelisted open method -
        " the viewer brings its own dialog and close button.
        " t_arg is positional: id, view (`` = global lookup), method
        
        CLEAR temp1.
        INSERT `demoPdf` INTO TABLE temp1.
        INSERT `` INTO TABLE temp1.
        INSERT `open` INTO TABLE temp1.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-control_by_id
                                  t_arg = temp1 ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE z2ui5_if_types=>ty_t_name_value.
    DATA temp4 LIKE LINE OF temp3.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell(
        )->page(
            title          = `abap2UI5 - PDF Viewer - Display via CONTROL_BY_ID`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    " a popup-mode PDFViewer kept as a dependent of the page; opened
    " imperatively from the backend, like a controller calling oViewer.open()
    
    CLEAR temp3.
    
    temp4-n = `id`.
    temp4-v = `demoPdf`.
    INSERT temp4 INTO TABLE temp3.
    temp4-n = `title`.
    temp4-v = `Sample PDF`.
    INSERT temp4 INTO TABLE temp3.
    temp4-n = `source`.
    temp4-v = `https://sapui5.hana.ondemand.com/test-resources/sap/m/demokit/sample/PDFViewerPopup/sample1.pdf`.
    INSERT temp4 INTO TABLE temp3.
    temp4-n = `height`.
    temp4-v = `100%`.
    INSERT temp4 INTO TABLE temp3.
    page->dependents(
        )->_generic( name   = `PDFViewer`
                     t_prop = temp3 ).

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
