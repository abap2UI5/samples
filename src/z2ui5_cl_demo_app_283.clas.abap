CLASS z2ui5_cl_demo_app_283 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_283 IMPLEMENTATION.

  METHOD display_view.

    " Define the base URL for the server
    DATA lv_base_url TYPE string VALUE `https://sapui5.hana.ondemand.com/`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Feed Input`
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
           href   = lv_base_url && `sdk/#/entity/sap.m.FeedInput/sample/sap.m.sample.FeedInput` ).

    lo_page->label( text  = `Without Icon`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    lo_page->feed_input(
          post      = mo_client->_event( val = `onPost` t_arg = VALUE #( ( `${$source>/value}` ) ) )
           showicon = abap_false ).

    lo_page->label( text  = `With Icon Placeholder`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    lo_page->feed_input(
           post     = mo_client->_event( val = `onPost` t_arg = VALUE #( ( `${$source>/value}` ) ) )
           showicon = abap_true ).

    lo_page->label( text  = `With Icon Placeholder`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    lo_page->feed_input(
           post     = mo_client->_event( val = `onPost` t_arg = VALUE #( ( `${$source>/value}` ) ) )
           showicon = abap_true
           icon     = lv_base_url && `test-resources/sap/m/images/george_washington.jpg` ).

    lo_page->label( text  = `Disabled`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    lo_page->feed_input(
           post     = mo_client->_event( val = `onPost` t_arg = VALUE #( ( `${$source>/value}` ) ) )
           enabled  = abap_false
           showicon = abap_true
           icon     = lv_base_url && `test-resources/sap/m/images/george_washington.jpg` ).

    lo_page->label( text  = `Rows Set to 5`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    lo_page->feed_input(
           post = mo_client->_event( val = `onPost` t_arg = VALUE #( ( `${$source>/value}` ) ) )
           rows = `5` ).

    lo_page->label( text  = `With Exceeded Text`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    lo_page->feed_input(
           post             = mo_client->_event( val = `onPost` t_arg = VALUE #( ( `${$source>/value}` ) ) )
           maxlength        = `20`
           showexceededtext = abap_true ).

    lo_page->label( text  = `With Growing`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    lo_page->feed_input(
           post    = mo_client->_event( val = `onPost` t_arg = VALUE #( ( `${$source>/value}` ) ) )
           growing = abap_true ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `CLICK_HINT_ICON`.
        display_popover( `button_hint_id` ).
      WHEN `onPost`.
        mo_client->message_toast_display( `Posted new feed entry: ` && mo_client->get_event_arg( 1 ) ).
    ENDCASE.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `This sample shows a standalone feed input with different settings.` ).

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
