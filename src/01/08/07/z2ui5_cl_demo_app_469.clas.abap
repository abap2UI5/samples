"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PDFViewer/sample/sap.m.sample.PDFViewerPopup
"! A PDF viewer opening as a popup dialog.
CLASS z2ui5_cl_demo_app_469 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA pdf_source TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS popup_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_469 IMPLEMENTATION.

  METHOD view_display.

    " images and PDF files of the original sample sap/m/demokit/sample/PDFViewerPopup
    DATA(base_url) = `https://sapui5.hana.ondemand.com/test-resources/sap/m/demokit/sample/PDFViewerPopup/`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Sample: PDF Viewer - Popup`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.PDFViewer/sample/sap.m.sample.PDFViewerPopup` ).

    page->carousel(
        class = `sapUiContentPadding`
        loop  = abap_true
        )->image(
            id    = `image1`
            src   = base_url && `sample1.jpg`
            alt   = `Example Picture 1`
            press = client->_event( val = `SHOW_PDF` t_arg = VALUE #( ( `sample1.pdf` ) ) )
        )->image(
            id    = `image2`
            src   = base_url && `sample2.jpg`
            alt   = `Example Picture 2`
            press = client->_event( val = `SHOW_PDF` t_arg = VALUE #( ( `sample2.pdf` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `SHOW_PDF` ).

      pdf_source = `https://sapui5.hana.ondemand.com/test-resources/sap/m/demokit/sample/PDFViewerPopup/` && client->get_event_arg( 1 ).

      popup_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD popup_display.

    " the original opens the PDFViewer in popup mode via JavaScript - here the PDF viewer is embedded into a dialog
    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).
    DATA(dialog) = popup->dialog(
        title         = `My Custom Title`
        contentwidth  = `760px`
        contentheight = `600px`
        afterclose    = client->_event_client( client->cs_event-popup_close ) ).

    " property isTrustedSource of the original omitted - available only in UI5 releases higher than 1.71
    dialog->_generic(
        name   = `PDFViewer`
        t_prop = VALUE #( ( n = `source` v = pdf_source )
                          ( n = `height` v = `100%` ) ) ).

    dialog->end_button( )->button(
        text  = `Close`
        press = client->_event_client( client->cs_event-popup_close ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
