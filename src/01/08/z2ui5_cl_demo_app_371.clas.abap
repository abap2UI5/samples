"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Carousel/sample/sap.m.sample.Carousel
"! A sample of a Carousel that contains images.
CLASS z2ui5_cl_demo_app_371 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_371 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " Image URLs of the mock model sap/ui/demo/mock/img.json used by the original sample
    DATA(base_url) = `https://sapui5.hana.ondemand.com/test-resources/sap/ui/documentation/sdk/images/`.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Carousel`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Carousel/sample/sap.m.sample.Carousel` ).

    page->title( id    = `carouselTitle`
                 class = `sapUiSmallMarginTop`
                 text  = `Image Gallery Carousel` ).

    " ariaLabelledBy of the original sample is omitted here (available only since UI5 1.125)
    page->carousel( class = `sapUiContentPadding`
                    loop  = abap_true
        )->image( src = base_url && `HT-7777-large.jpg`
                  alt = `Example picture of speakers`
        )->image( src = base_url && `HT-6120-large.jpg`
                  alt = `Example picture of USB flash drive`
        )->image( src = base_url && `HT-6100-large.jpg`
                  alt = `Example picture of spotlight`
        )->image( src = base_url && `screw.jpg`
                  alt = `Example picture of screw` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->check_on_event( `CLICK_HINT_ICON` ).
      popover_display( `button_hint_id` ).
    ENDIF.

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `The carousel allows the user to browse through a set of pages by swiping or with the paging controls. Here each page is an image; any control can be a page.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.

ENDCLASS.
