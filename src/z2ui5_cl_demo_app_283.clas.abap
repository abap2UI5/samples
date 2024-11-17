CLASS z2ui5_cl_demo_app_283 DEFINITION
 PUBLIC
 CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

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


CLASS z2ui5_cl_demo_app_283 IMPLEMENTATION.

  METHOD display_view.
    " Define the base URL for the server
    DATA base_url TYPE string VALUE 'https://sapui5.hana.ondemand.com/'.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page( title          = 'abap2UI5 - Sample: Feed Input'
                  navbuttonpress = client->_event( 'BACK' )
                  shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
       )->button( id      = `button_hint_id`
                  icon    = `sap-icon://hint`
                  tooltip = `Sample information`
                  press   = client->_event( 'CLICK_HINT_ICON' ) ).

    page->header_content(
       )->link( text   = 'UI5 Demo Kit'
                target = '_blank'
                href   = |{ base_url }sdk/#/entity/sap.m.FeedInput/sample/sap.m.sample.FeedInput| ).

    page->label( text  = `Without Icon`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    page->feed_input( post     = client->_event( val   = `onPost`
                                                 t_arg = VALUE #( ( `${$source>/value}` ) ) )
                      showicon = abap_false ).

    page->label( text  = `With Icon Placeholder`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    page->feed_input( post     = client->_event( val   = `onPost`
                                                 t_arg = VALUE #( ( `${$source>/value}` ) ) )
                      showicon = abap_true ).

    page->label( text  = `With Icon Placeholder`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    page->feed_input( post     = client->_event( val   = `onPost`
                                                 t_arg = VALUE #( ( `${$source>/value}` ) ) )
                      showicon = abap_true
                      icon     = |{ base_url }test-resources/sap/m/images/george_washington.jpg| ).

    page->label( text  = `Disabled`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    page->feed_input( post     = client->_event( val   = `onPost`
                                                 t_arg = VALUE #( ( `${$source>/value}` ) ) )
                      enabled  = abap_false
                      showicon = abap_true
                      icon     = |{ base_url }test-resources/sap/m/images/george_washington.jpg| ).

    page->label( text  = `Rows Set to 5`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    page->feed_input( post = client->_event( val   = `onPost`
                                             t_arg = VALUE #( ( `${$source>/value}` ) ) )
                      rows = `5` ).

    page->label( text  = `With Exceeded Text`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    page->feed_input( post             = client->_event( val   = `onPost`
                                                         t_arg = VALUE #( ( `${$source>/value}` ) ) )
                      maxlength        = `20`
                      showexceededtext = abap_true ).

    page->label( text  = `With Growing`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    page->feed_input( post    = client->_event( val   = `onPost`
                                                t_arg = VALUE #( ( `${$source>/value}` ) ) )
                      growing = abap_true ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'CLICK_HINT_ICON'.
        z2ui5_display_popover( `button_hint_id` ).
      WHEN 'onPost'.
        client->message_toast_display( |Posted new feed entry: { client->get_event_arg( 1 ) }| ).
    ENDCASE.

  ENDMETHOD.

  METHOD z2ui5_display_popover.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `This sample shows a standalone feed input with different settings.` ).

    client->popover_display( xml   = view->stringify( )
                             by_id = id
    ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
