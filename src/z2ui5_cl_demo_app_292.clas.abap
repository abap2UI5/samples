CLASS z2ui5_cl_demo_app_292 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_292 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Breadcrumbs sample with current page link`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Breadcrumbs/sample/sap.m.sample.BreadcrumbsWithCurrentPageLink` ).

    lo_page->vertical_layout(
            class = `sapUiContentPadding`
            width = `100%`
           )->title( text = `Breadcrumbs with current page aggregation set`
           )->breadcrumbs( id                  = `idBreadcrumbs`
                           separatorstyle      = `{/selected}`
                           currentlocationtext = `Page 7`
               )->link( text  = `Home`
                        press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/text}` ) ) )
               )->link( text  = `Page 1`
                        press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/text}` ) ) )
               )->link( text  = `Page 2`
                        press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/text}` ) ) )
               )->link( text  = `Page 3`
                        press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/text}` ) ) )
               )->link( text  = `Page 4`
                        press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/text}` ) ) )
               )->link( text  = `Page 5`
                        press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/text}` ) ) )
                   )->link( text  = `Page 6`
                            press = mo_client->_event( val = `ON_PRESS` t_arg = VALUE #( ( `${$source>/text}` ) ) )
               )->get_parent(
           )->get_parent( ).

    lo_page->hbox( alignitems = `Center`
                )->label( labelfor = `idSeparatorSelect`
                    text           = `Change separator style`

          )->select( class         = `sapUiSmallMarginBegin`
                       id          = `idSeparatorSelect`
                       selectedkey = `{/selected}`
                       change      = `onChange`
                        )->item( key  = `Slash`
                                 text = `Slash`
                        )->item( key  = `BackSlash`
                                 text = `BackSlash`
                        )->item( key  = `DoubleSlash`
                                 text = `DoubleSlash`
                        )->item( key  = `DoubleBackSlash`
                                 text = `DoubleBackSlash`
                        )->item( key  = `GreaterThan`
                                 text = `GreaterThan`
                        )->item( key  = `DoubleGreaterThan`
                                 text = `DoubleGreaterThan` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `CLICK_HINT_ICON`.
        display_popover( `button_hint_id` ).
      WHEN `ON_PRESS`.
        mo_client->message_toast_display( mo_client->get_event_arg( 1 ) && ` has been clicked` ).
    ENDCASE.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Breadcrumbs sample with current page set as aggregation, resulting in a link` ).

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
