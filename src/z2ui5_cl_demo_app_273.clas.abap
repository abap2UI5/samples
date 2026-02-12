CLASS z2ui5_cl_demo_app_273 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        mo_client TYPE REF TO z2ui5_if_client.
    METHODS display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_273 IMPLEMENTATION.

  METHOD display_view.

    " Define the base URL for the server
    DATA lv_base_url TYPE string VALUE `https://sapui5.hana.ondemand.com/`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: LightBox`
            navbuttonpress = mo_client->_event_nav_app_leave( )
            shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = mo_client->_event( `CLICK_HINT_ICON` ) ).

    lo_page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = lv_base_url && `sdk/#/entity/sap.m.LightBox/sample/sap.m.sample.LightBox` ).

    lo_page->message_strip( text                                                                                                             = `Clicking on each of the images will open a LightBox, showing the real size of the image. ` &&
                                `Images will be scaled down if their size is bigger than the window size." class="sapUiSmallMargin` class = `sapUiSmallMargin`
          )->list(
              )->custom_list_item(
                  )->hbox( class = `sapUiSmallMargin`
                      )->image(
                          src          = lv_base_url && `test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`
                          decorative   = abap_false
                          width        = `170px`
                          densityaware = abap_false )->get(
                          )->detail_box(
                             )->light_box(
                                 )->light_box_item(
                                     imagesrc = lv_base_url && `test-resources/sap/ui/documentation/sdk/images/HT-6100-large.jpg`
                                     alt      = `Beamer`
                                     title    = `This is a beamer`
                                     subtitle = `This is beamer's description` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
                          )->vbox( class = `sapUiSmallMarginBegin`
                              )->title( text = `Beamer`
                                  )->text( text = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam interdum lectus et tempus blandit.`    &&
                                                  `Sed porta ex quis tortor gravida, ut suscipit felis dignissim. Ut iaculis elit vel ligula scelerisque,` &&
                                                  `et porttitor est pretium. Suspendisse purus dolor, fermentum in tortor eu, semper finibus velit.`       &&
                                                  `Proin vel lobortis leo, vel eleifend lorem. Etiam ac erat sollicitudin, condimentum magna ac,`          &&
                                                  `venenatis lacus. Pellentesque non mauris consectetur, tristique arcu id, aliquet tortor.` )->get_parent( )->get_parent(
      )->custom_list_item(
                  )->hbox( class = `sapUiSmallMargin`
                      )->image(
                          src          = lv_base_url && `test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`
                          decorative   = abap_false
                          width        = `170px`
                          densityaware = abap_false )->get(
                          )->detail_box(
                             )->light_box(
                                 )->light_box_item(
                                     imagesrc = lv_base_url && `test-resources/sap/ui/documentation/sdk/images/HT-6120-large.jpg`
                                     alt      = `USB`
                                     title    = `This is a USB`
                                     subtitle = `This is USB's description` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
                          )->vbox( class = `sapUiSmallMarginBegin`
                              )->title( text = `USB`
                                  )->text( text = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam interdum lectus et tempus blandit.`    &&
                                                  `Sed porta ex quis tortor gravida, ut suscipit felis dignissim. Ut iaculis elit vel ligula scelerisque,` &&
                                                  `et porttitor est pretium. Suspendisse purus dolor, fermentum in tortor eu, semper finibus velit.`       &&
                                                  `Proin vel lobortis leo, vel eleifend lorem. Etiam ac erat sollicitudin, condimentum magna ac,`          &&
                                                  `venenatis lacus. Pellentesque non mauris consectetur, tristique arcu id, aliquet tortor.` )->get_parent( )->get_parent(
      )->custom_list_item(
                  )->hbox( class = `sapUiSmallMargin`
                      )->image(
                          src          = lv_base_url && `test-resources/sap/ui/documentation/sdk/images/HT-7777.jpg`
                          decorative   = abap_false
                          width        = `170px`
                          densityaware = abap_false )->get(
                          )->detail_box(
                             )->light_box(
                                 )->light_box_item(
                                     imagesrc = lv_base_url && `test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`
                                     alt      = `Speakers`
                                     title    = `These are speakers`
                                     subtitle = `This is speakers' description` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
                          )->vbox( class = `sapUiSmallMarginBegin`
                              )->title( text = `Speakers`
                                  )->text( text = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam interdum lectus et tempus blandit.`    &&
                                                  `Sed porta ex quis tortor gravida, ut suscipit felis dignissim. Ut iaculis elit vel ligula scelerisque,` &&
                                                  `et porttitor est pretium. Suspendisse purus dolor, fermentum in tortor eu, semper finibus velit.`       &&
                                                  `Proin vel lobortis leo, vel eleifend lorem. Etiam ac erat sollicitudin, condimentum magna ac,`          &&
                                                  `venenatis lacus. Pellentesque non mauris consectetur, tristique arcu id, aliquet tortor.` )->get_parent( )->get_parent(
      )->custom_list_item(
                  )->hbox( class = `sapUiSmallMargin`
                      )->image(
                          src          = lv_base_url && `test-resources/sap/ui/documentation/sdk/images/nature/ALotOfElephants_small.jpg`
                          decorative   = abap_false
                          width        = `170px`
                          densityaware = abap_false )->get(
                          )->detail_box(
                             )->light_box(
                                 )->light_box_item(
                                     imagesrc = lv_base_url && `test-resources/sap/ui/documentation/sdk/images/nature/ALotOfElephants.jpg`
                                     alt      = `Nature image`
                                     title    = `This is a sample image`
                                     subtitle = `This is a place for description` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
                          )->vbox( class = `sapUiSmallMarginBegin`
                              )->title( text = `Nature image`
                                  )->text( text = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam interdum lectus et tempus blandit.`    &&
                                                  `Sed porta ex quis tortor gravida, ut suscipit felis dignissim. Ut iaculis elit vel ligula scelerisque,` &&
                                                  `et porttitor est pretium. Suspendisse purus dolor, fermentum in tortor eu, semper finibus velit.`       &&
                                                  `Proin vel lobortis leo, vel eleifend lorem. Etiam ac erat sollicitudin, condimentum magna ac,`          &&
                                                  `venenatis lacus. Pellentesque non mauris consectetur, tristique arcu id, aliquet tortor.` )->get_parent( )->get_parent(
      )->custom_list_item(
                  )->hbox( class = `sapUiSmallMargin`
                      )->image(
                          src          = lv_base_url && `test-resources/sap/ui/documentation/sdk/images/nature/flatFish.jpg`
                          decorative   = abap_false
                          width        = `170px`
                          densityaware = abap_false )->get(
                          )->detail_box(
                             )->light_box(
                                 )->light_box_item(
                                     imagesrc = lv_base_url && `test-resources/sap/ui/documentation/sdk/images/nature/flatFish.jpg`
                                     alt      = `Nature image`
                                     title    = `This is a sample image`
                                     subtitle = `This is a place for description` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
                          )->vbox( class = `sapUiSmallMarginBegin`
                              )->title( text = `Nature image`
                                  )->text( text = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam interdum lectus et tempus blandit.`    &&
                                                  `Sed porta ex quis tortor gravida, ut suscipit felis dignissim. Ut iaculis elit vel ligula scelerisque,` &&
                                                  `et porttitor est pretium. Suspendisse purus dolor, fermentum in tortor eu, semper finibus velit.`       &&
                                                  `Proin vel lobortis leo, vel eleifend lorem. Etiam ac erat sollicitudin, condimentum magna ac,`          &&
                                                  `venenatis lacus. Pellentesque non mauris consectetur, tristique arcu id, aliquet tortor.` )->get_parent( )->get_parent(
      )->custom_list_item(
                  )->hbox( class = `sapUiSmallMargin`
                      )->image(
                          src          = lv_base_url && `test-resources/sap/ui/documentation/sdk/images/nature/horses.jpg`
                          decorative   = abap_false
                          width        = `170px`
                          densityaware = abap_false )->get(
                          )->detail_box(
                             )->light_box(
                                 )->light_box_item(
                                     imagesrc = lv_base_url && `test-resources/sap/ui/documentation/sdk/images/nature/horses.jpg`
                                     alt      = `Nature image`
                                     title    = `This is a sample image`
                                     subtitle = `This is a place for description` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
                          )->vbox( class = `sapUiSmallMarginBegin`
                              )->title( text = `Nature image`
                                  )->text( text = `Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam interdum lectus et tempus blandit.`    &&
                                                  `Sed porta ex quis tortor gravida, ut suscipit felis dignissim. Ut iaculis elit vel ligula scelerisque,` &&
                                                  `et porttitor est pretium. Suspendisse purus dolor, fermentum in tortor eu, semper finibus velit.`       &&
                                                  `Proin vel lobortis leo, vel eleifend lorem. Etiam ac erat sollicitudin, condimentum magna ac,`          &&
                                                  `venenatis lacus. Pellentesque non mauris consectetur, tristique arcu id, aliquet tortor.` )->get_parent( )->get_parent(
      )->custom_list_item(
                  )->hbox( class = `sapUiSmallMargin`
                      )->image(
                          src          = lv_base_url && `test-resources/sap/ui/documentation/sdk/images/nature/elephant.jpg`
                          decorative   = abap_false
                          width        = `170px`
                          densityaware = abap_false )->get(
                          )->detail_box(
                             )->light_box(
                                 )->light_box_item(
                                     imagesrc = lv_base_url && `test-resources/sap/ui/documentation/sdk/images/nature/image_does_not_exist.jpg`
                                     alt      = `Nature image`
                                     title    = `This is a sample image`
                                     subtitle = `This is a place for description` )->get_parent( )->get_parent( )->get_parent( )->get_parent(
                          )->vbox( class = `sapUiSmallMarginBegin`
                              )->title( text = `Unavailable image`
                                  )->text( text = `Shows an error when an image could not be loaded, or when it takes too much time to load it.` )->get_parent( )->get_parent( ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `CLICK_HINT_ICON` ).
      display_popover( `button_hint_id` ).
    ENDIF.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Displays several image thumbnails. Clicking on each of them will open a LightBox.` ).

    mo_client->popover_display(
      xml   = lo_view->stringify( )
      by_id = id ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).
    ENDIF.

    on_event( mo_client ).
  ENDMETHOD.
ENDCLASS.
