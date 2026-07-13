"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Image/sample/sap.m.sample.Image
"! Images are faster than words and attract people's attention. Images can also have an active state or
"! be used in SVG format.
CLASS z2ui5_cl_demo_app_379 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_379 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(base_url) = `https://sapui5.hana.ondemand.com/test-resources/`.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Image`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( `CLICK_HINT_ICON` ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Image/sample/sap.m.sample.Image` ).

    DATA(hbox) = page->vbox( `sapUiSmallMarginTopBottom sapUiLargeMarginBeginEnd`
        )->hbox( justifycontent = `SpaceBetween` ).

    hbox->vbox(
        )->text(
            text  = `Image:`
            class = `sapUiSmallMarginBottom`
        )->image(
            src   = base_url && `sap/ui/documentation/sdk/images/HT-7777-large.jpg`
            width = `10em` ).

    " ariaDetails of the original sample is omitted here (available only since UI5 1.79)
    hbox->vbox(
        )->text(
            text  = `Active state image:`
            class = `sapUiSmallMarginBottom`
        )->image(
            src        = base_url && `sap/ui/documentation/sdk/images/HT-6100-large.jpg`
            width      = `10em`
            decorative = abap_false
            press      = client->_event( `IMAGE_PRESS` ) ).

    hbox->vbox(
        )->text(
            text  = `Image using SVG format:`
            class = `sapUiSmallMarginBottom`
        )->image( src = base_url && `sap/m/demokit/sample/Image/images/sap-logo.svg` ).

    " mode InlineSvg of the original sample is omitted here (available only in newer UI5 versions)
    hbox->vbox(
        )->text(
            text  = `Image displaying inline SVG:`
            class = `sapUiSmallMarginBottom`
        )->image( src = base_url && `sap/m/demokit/sample/Image/images/sap-logo.svg` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `IMAGE_PRESS`.
        client->message_toast_display( `The image has been pressed` ).

      WHEN `CLICK_HINT_ICON`.
        popover_display( `button_hint_id` ).
    ENDCASE.

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `The image control embeds a picture with control over sizing, density awareness, accessibility (alt text or decorative) and an optional press event.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.

ENDCLASS.
