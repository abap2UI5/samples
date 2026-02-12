CLASS z2ui5_cl_demo_app_272 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_272 IMPLEMENTATION.

  METHOD display_view.

    " Define the base URL for the server
    DATA lv_base_url TYPE string VALUE `https://sapui5.hana.ondemand.com/`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Object Header - with Circle-shaped Image`
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
           href   = lv_base_url && `sdk/#/entity/sap.m.ObjectHeader/sample/sap.m.sample.ObjectHeaderCircleImage` ).

    lo_page->object_header(
           icon             = lv_base_url && `test-resources/sap/m/images/Woman_04.png`
           icondensityaware = abap_false
           iconalt          = `Denise Smith`
           imageshape       = `Circle`
           responsive       = abap_true
           title            = `Denise Smith`
           intro            = `Senior Developer`
           class            = `sapUiResponsivePadding--header`
             )->object_attribute( title  = `Email address`
                                  text   = `DeniseSmith@sap.com`
                                  active = abap_true
             )->object_attribute( title = `Office Phone`
                                  text  = `+33 6 453 564`
             )->object_attribute( title = `Functional Area`
                                  text  = `Development` ).

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
                                  description = `An Object Header can set shape of the image by using 'imageShape' property.`                      &&
                                                `The shapes could be Square (by default) and Circle.`                                              &&
                                                `Note: This example shows the image inside ObjectHeader with the responsive property set to true.` &&
                                                `On phone in portrait mode, the image is hidden.` ).

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
