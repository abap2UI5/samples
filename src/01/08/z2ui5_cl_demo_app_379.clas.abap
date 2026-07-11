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

    DATA(base_url) = `https://sapui5.hana.ondemand.com/test-resources/sap/m/images/`.

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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Image` ).

    DATA(vbox) = page->vbox( `sapUiSmallMargin` ).

    vbox->label( `Fixed width (150px), with alternative text:` ).
    vbox->image( src          = base_url && `SAPLogo.jpg`
                 alt          = `SAP logo`
                 width        = `150px`
                 densityaware = abap_false ).

    vbox->label( text  = `Clickable image with press event:`
                 class = `sapUiSmallMarginTop` ).
    vbox->image( src          = base_url && `SAPLogo.jpg`
                 alt          = `SAP logo (clickable)`
                 width        = `75px`
                 densityaware = abap_false
                 press        = client->_event( `IMAGE_PRESS` ) ).

    vbox->label( text  = `Decorative image (ignored by screen readers):`
                 class = `sapUiSmallMarginTop` ).
    vbox->image( src          = base_url && `SAPUI5.png`
                 decorative   = abap_true
                 width        = `150px`
                 densityaware = abap_false ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `IMAGE_PRESS`.
        client->message_toast_display( `Image pressed` ).

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
