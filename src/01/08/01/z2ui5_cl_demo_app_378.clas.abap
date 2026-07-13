CLASS z2ui5_cl_demo_app_378 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_display
      IMPORTING
        id TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_378 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).

    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Panel`
            class          = `sapUiContentPadding`
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
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.Panel` ).

    page->panel( headertext = `Fixed Panel`
                 class      = `sapUiSmallMarginBottom`
        )->text( `A basic panel with a header text and content. It cannot be collapsed.` ).

    page->panel( expandable = abap_true
                 expanded   = abap_true
                 headertext = `Expandable Panel (initially expanded)`
                 class      = `sapUiSmallMarginBottom`
                 expand     = client->_event( val = `EXPAND` t_arg = VALUE #( ( `${$source>/expanded}` ) ) )
        )->text( `Collapse or expand this panel with the arrow in the header. The expand event is sent to the backend.` ).

    page->panel( expandable = abap_true
                 expanded   = abap_false
                 headertext = `Expandable Panel (initially collapsed)`
                 class      = `sapUiSmallMarginBottom`
        )->text( `This content is hidden until the panel is expanded.` ).

    DATA(panel) = page->panel( expandable = abap_true
                               expanded   = abap_true ).
    panel->header_toolbar(
        )->toolbar(
            )->title( `Panel with Header Toolbar`
            )->toolbar_spacer(
            )->button( icon    = `sap-icon://settings`
                       type    = `Transparent`
                       tooltip = `Settings`
                       press   = client->_event( `SETTINGS` ) ).
    panel->text( `Instead of a plain header text the panel can host a complete toolbar with actions.` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `EXPAND`.
        client->message_toast_display( |Panel expanded: { client->get_event_arg( 1 ) }| ).

      WHEN `SETTINGS`.
        client->message_toast_display( `Settings pressed` ).

      WHEN `CLICK_HINT_ICON`.
        popover_display( `button_hint_id` ).
    ENDCASE.

  ENDMETHOD.


  METHOD popover_display.

    DATA(view) = z2ui5_cl_xml_view=>factory_popup( ).
    view->quick_view( placement = `Bottom`
                      width     = `auto`
              )->quick_view_page( pageid      = `sampleInformationId`
                                  header      = `Sample information`
                                  description = `The panel groups content under a header. It can be expandable and its header can be a plain text or a full toolbar.` ).

    client->popover_display(
      xml   = view->stringify( )
      by_id = id ).

  ENDMETHOD.

ENDCLASS.
