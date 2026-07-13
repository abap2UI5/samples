"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Panel/sample/sap.m.sample.Panel
"! Panels are helpful to group custom content. They can be decorated with header and info toolbars.
CLASS z2ui5_cl_demo_app_378 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_378 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( `CLICK_HINT_ICON` ).
      popover_display( `button_hint_id` ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the original uses the same Lorem ipsum text for the content of both panels
    DATA(lorem) = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
      `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
      `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
      `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Panel`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Panel/sample/sap.m.sample.Panel` ).

    " the accessibleRole property of the original is not available in the view API, therefore omitted
    DATA(panel_picture) = page->panel( width = `auto`
                                       class = `sapUiResponsiveMargin` ).
    panel_picture->header_toolbar(
        )->overflow_toolbar(
            )->title( `Panel with picture` ).
    " the original binds the image against the demo kit mock model - here the mock image URL is used directly
    panel_picture->horizontal_layout(
        )->image( src   = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`
                  width = `10em` ).
    panel_picture->text( lorem ).

    DATA(panel_header) = page->panel( width = `auto`
                                      class = `sapUiResponsiveMargin` ).
    panel_header->header_toolbar(
        )->overflow_toolbar(
            )->title( `Header`
            )->toolbar_spacer(
            )->button( icon = `sap-icon://settings`
            )->button( icon = `sap-icon://drop-down-list` ).
    panel_header->text( lorem ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Panels are helpful to group custom content. They can be decorated with a plain header text or a complete header toolbar.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.

ENDCLASS.
