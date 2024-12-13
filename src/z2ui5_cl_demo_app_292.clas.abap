CLASS z2ui5_cl_demo_app_292 DEFINITION
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



CLASS Z2UI5_CL_DEMO_APP_292 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: Breadcrumbs sample with current page link'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    page->header_content(
       )->button( id = `button_hint_id`
           icon      = `sap-icon://hint`
           tooltip   = `Sample information`
           press     = client->_event( 'CLICK_HINT_ICON' ) ).

    page->header_content(
       )->link(
           text   = 'UI5 Demo Kit'
           target = '_blank'
           href   = 'https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Breadcrumbs/sample/sap.m.sample.BreadcrumbsWithCurrentPageLink' ).

    page->vertical_layout(
            class = `sapUiContentPadding`
            width = `100%`
           )->title( text = `Breadcrumbs with current page aggregation set`
           )->breadcrumbs( id             = `idBreadcrumbs`
                           separatorstyle = `{/selected}`
                           currentlocationtext = `Page 7`
               )->link( text  = `Home`
                        press = client->_event( val = `onPress` t_arg = VALUE #( ( `${$source>/text}` ) ) )
               )->link( text  = `Page 1`
                        press = client->_event( val = `onPress` t_arg = VALUE #( ( `${$source>/text}` ) ) )
               )->link( text  = `Page 2`
                        press = client->_event( val = `onPress` t_arg = VALUE #( ( `${$source>/text}` ) ) )
               )->link( text  = `Page 3`
                        press = client->_event( val = `onPress` t_arg = VALUE #( ( `${$source>/text}` ) ) )
               )->link( text  = `Page 4`
                        press = client->_event( val = `onPress` t_arg = VALUE #( ( `${$source>/text}` ) ) )
               )->link( text  = `Page 5`
                        press = client->_event( val = `onPress` t_arg = VALUE #( ( `${$source>/text}` ) ) )
                   )->link( text  = `Page 6`
                            press = client->_event( val = `onPress` t_arg = VALUE #( ( `${$source>/text}` ) ) )
               )->get_parent(
           )->get_parent( ).

     page->hbox( alignitems = `Center`
                )->label( labelfor = `idSeparatorSelect`
                    text = `Change separator style`

          )->select( class = `sapUiSmallMarginBegin`
                       id = `idSeparatorSelect`
                       selectedkey = `{/selected}`
                       change = 'onChange'
                        )->item( key = `Slash` text = `Slash`
                        )->item( key = `BackSlash` text = `BackSlash`
                        )->item( key = `DoubleSlash` text = `DoubleSlash`
                        )->item( key = `DoubleBackSlash` text = `DoubleBackSlash`
                        )->item( key = `GreaterThan` text = `GreaterThan`
                        )->item( key = `DoubleGreaterThan` text = `DoubleGreaterThan`
                      ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'CLICK_HINT_ICON'.
        z2ui5_display_popover( `button_hint_id` ).
      WHEN 'onPress'.
        client->message_toast_display( client->get_event_arg( 1 ) && ` has been clicked` ).
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_display_popover.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Breadcrumbs sample with current page set as aggregation, resulting in a link` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

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
