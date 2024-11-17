CLASS z2ui5_cl_demo_app_287 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_name,
        title         TYPE string,
        desc          TYPE string,
        icon          TYPE string,
        highlight     TYPE string,
        info          TYPE string,
        wrapCharLimit TYPE i,
      END OF ty_name.

    DATA lt_o_model        TYPE TABLE OF ty_name.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS z2ui5_display_popover
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_287 IMPLEMENTATION.

  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page( title          = 'abap2UI5 - Sample: Standard List Item - Wrapping'
                  navbuttonpress = client->_event( 'BACK' )
                  shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
       )->button( id      = `button_hint_id`
                  icon    = `sap-icon://hint`
                  tooltip = `Sample information`
                  press   = client->_event( 'CLICK_HINT_ICON' ) ).

    page->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemWrapping' ).

    page->list( id         = `myList`
                mode       = `MultiSelect`
                headertext = `Wrapping texts`
                items      = client->_bind( lt_o_model )
           )->items(
               )->standard_list_item( title         = '{TITLE}'
                                      description   = '{DESC}'
                                      icon          = '{ICON}'
                                      iconinset     = abap_false
                                      highlight     = '{HIGHLIGHT}'
                                      info          = '{INFO}'
                                      infostate     = '{HIGHLIGHT}'
                                      type          = `Detail`
                                      wrapping      = abap_true
                                      wrapcharlimit = '{WRAPCHARLIMIT}'
          ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'CLICK_HINT_ICON'.
        z2ui5_display_popover( `button_hint_id` ).
    ENDCASE.

  ENDMETHOD.

  METHOD z2ui5_display_popover.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page(
                  pageid      = `sampleInformationId`
                  header      = `Sample information`
                  description = |This sample demonstrates the wrapping behavior of the title text and the description text. | &&
                                |In desktop mode, the character limit is set to 300 characters, whereas in the phone mode, the character limit is set to 100 characters.| ).

    client->popover_display( xml   = view->stringify( )
                             by_id = id
    ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).

      lt_o_model = VALUE #(
          ( title         = |wrapCharLimit is set to Default. Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. | &&
                            |At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. | &&
                            |Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. | &&
                            |Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.|
            desc          = |Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. | &&
                            |At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. | &&
                            |Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. | &&
                            |Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.|
            icon          = `sap-icon://favorite`
            highlight     = `Success`
            info          = `Completed`
          )
          ( title         = |wrapCharLimit is set to 100. Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. | &&
                            |At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. | &&
                            |Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.|
            desc          = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.`
            icon          = `sap-icon://employee`
            highlight     = `Error`
            info          = `Incomplete`
            wrapcharlimit = 100
          )
          ( title         = `Title text`
            desc          = `Description text`
            icon          = `sap-icon://accept`
            highlight     = `Information`
            info          = `Information`
            wrapcharlimit = 10
          )
      ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
