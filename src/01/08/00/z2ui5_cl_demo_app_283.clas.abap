"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FeedInput/sample/sap.m.sample.FeedInput
"! This sample shows a standalone feed input with different settings.
CLASS z2ui5_cl_demo_app_283 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_283 IMPLEMENTATION.

  METHOD view_display.

    " Define the base URL for the server
    DATA base_url TYPE string VALUE `https://sapui5.hana.ondemand.com/`.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp7 TYPE string_table.
    DATA temp9 TYPE string_table.
    DATA temp11 TYPE string_table.
    DATA temp13 TYPE string_table.
    page = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Feed Input`
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
           href   = base_url && `sdk/#/entity/sap.m.FeedInput/sample/sap.m.sample.FeedInput` ).

    page->label( text  = `Without Icon`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    
    CLEAR temp1.
    INSERT `${$source>/value}` INTO TABLE temp1.
    page->feed_input(
          post     = client->_event( val = `onPost` t_arg = temp1 )
          showicon = abap_false ).

    page->label( text  = `With Icon Placeholder`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    
    CLEAR temp3.
    INSERT `${$source>/value}` INTO TABLE temp3.
    page->feed_input(
           post     = client->_event( val = `onPost` t_arg = temp3 )
           showicon = abap_true ).

    page->label( text  = `With Icon Placeholder`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    
    CLEAR temp5.
    INSERT `${$source>/value}` INTO TABLE temp5.
    page->feed_input(
           post     = client->_event( val = `onPost` t_arg = temp5 )
           showicon = abap_true
           icon     = base_url && `test-resources/sap/m/images/george_washington.jpg` ).

    page->label( text  = `Disabled`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    
    CLEAR temp7.
    INSERT `${$source>/value}` INTO TABLE temp7.
    page->feed_input(
           post     = client->_event( val = `onPost` t_arg = temp7 )
           enabled  = abap_false
           showicon = abap_true
           icon     = base_url && `test-resources/sap/m/images/george_washington.jpg` ).

    page->label( text  = `Rows Set to 5`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    
    CLEAR temp9.
    INSERT `${$source>/value}` INTO TABLE temp9.
    page->feed_input(
           post = client->_event( val = `onPost` t_arg = temp9 )
           rows = `5` ).

    page->label( text  = `With Exceeded Text`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    
    CLEAR temp11.
    INSERT `${$source>/value}` INTO TABLE temp11.
    page->feed_input(
           post             = client->_event( val = `onPost` t_arg = temp11 )
           maxlength        = `20`
           showexceededtext = abap_true ).

    page->label( text  = `With Growing`
                 class = `sapUiSmallMarginTop sapUiTinyMarginBottom` ).
    
    CLEAR temp13.
    INSERT `${$source>/value}` INTO TABLE temp13.
    page->feed_input(
           post    = client->_event( val = `onPost` t_arg = temp13 )
           growing = abap_true ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `CLICK_HINT_ICON`.
        popover_display( `button_hint_id` ).
      WHEN `onPost`.
        client->message_toast_display( |Posted new feed entry: { client->get_event_arg( ) }| ).
    ENDCASE.

  ENDMETHOD.


  METHOD popover_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `This sample shows a standalone feed input with different settings.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

ENDCLASS.
