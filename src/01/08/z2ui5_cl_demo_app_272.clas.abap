CLASS z2ui5_cl_demo_app_272 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_272 IMPLEMENTATION.

  METHOD view_display.

    " Define the base URL for the server
    DATA base_url TYPE string VALUE `https://sapui5.hana.ondemand.com/`.

    " sap.m.ObjectHeader is deprecated since 1.42 - use sap.uxap.ObjectPageHeader instead
    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->object_page_layout( showtitleinheadercontent = abap_true ).

    DATA(header) = page->header_title(
        )->object_page_header(
            objecttitle             = `Denise Smith`
            objectsubtitle          = `Senior Developer`
            objectimageuri          = base_url && `test-resources/sap/m/images/Woman_04.png`
            objectimageshape        = `Circle`
            objectimagedensityaware = abap_false
            objectimagealt          = `Denise Smith` ).

    header->attributes( `uxap`
        )->object_attribute(
            title  = `Email address`
            text   = `DeniseSmith@sap.com`
            active = abap_true
        )->object_attribute(
            title = `Office Phone`
            text  = `+33 6 453 564`
        )->object_attribute(
            title = `Functional Area`
            text  = `Development` ).

    header->actions( `uxap`
        )->object_page_header_action_btn(
            icon    = `sap-icon://nav-back`
            text    = `Go Back`
            visible = client->check_app_prev_stack( )
            press   = client->_event_nav_app_leave( ) ).

    page->header_content( `uxap`
        )->button(
            id      = `button_hint_id`
            icon    = `sap-icon://hint`
            tooltip = `Sample information`
            press   = client->_event( `CLICK_HINT_ICON` ) ).

    page->header_content( `uxap`
        )->link(
            text   = `UI5 Demo Kit`
            target = `_blank`
            href   = base_url && `sdk/#/api/sap.uxap.ObjectPageHeader` ).

    client->view_display( view->stringify( ) ).

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
                                  description = `sap.uxap.ObjectPageHeader is the successor of the deprecated sap.m.ObjectHeader. ` &&
                                                `The image shape is set via the 'objectImageShape' property (Square by default or ` &&
                                                `Circle). The object attributes are provided through the 'attributes' aggregation.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
