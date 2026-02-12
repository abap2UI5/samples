CLASS z2ui5_cl_demo_app_293 DEFINITION PUBLIC.
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

CLASS z2ui5_cl_demo_app_293 IMPLEMENTATION.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title          = `abap2UI5 - Sample: Link`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Link/sample/sap.m.sample.Link` ).

    lo_page->vertical_layout(
            class = `sapUiContentPadding`
            width = `100%`
            )->content( ns = `layout`
                )->link(
                    text  = `Open message box`
                    press = mo_client->_event( `handleLinkPress` )
                )->link(
                    text    = `Disabled link`
                    enabled = abap_false
                )->link(
                    text   = `Open SAP Homepage`
                    target = `_blank`
                    href   = `http://www.sap.com`
                )->get_parent( ).

    lo_page->vertical_layout(
           class = `sapUiContentPadding`
           width = `100%`
           )->content( ns = `layout`
               )->label( text     = `Links with Icons`
                         design   = `Bold`
                         wrapping = abap_true
                         class    = `sapUiSmallMarginTop`
                   )->link(
                       text    = `Show more information`
                       endicon = `sap-icon://inspect`
                       press   = mo_client->_event( `handleLinkPress` )
                   )->link(
                       text    = `Disabled link with icon`
                       icon    = `sap-icon://cart`
                       enabled = abap_false
                   )->link(
                       text = `Open SAP Homepage`
                       icon = `sap-icon://globe`
                       href = `http://www.sap.com`
           )->get_parent( ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `CLICK_HINT_ICON`.
        display_popover( `button_hint_id` ).
      WHEN `handleLinkPress`.
        mo_client->message_box_display( `Link was clicked!` ).
    ENDCASE.
  ENDMETHOD.

  METHOD display_popover.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory_popup( ).
    lo_view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `Here are some links. Typically links are used in user interfaces to trigger navigation to related content inside or outside of the current application.` ).

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
