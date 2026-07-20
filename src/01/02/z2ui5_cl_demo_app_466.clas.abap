CLASS z2ui5_cl_demo_app_466 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA status_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_466 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      status_text = `<strong>Deployment successful!</strong> %%icon:sap-icon://message-success%% All services ` &&
                    `%%icon:sap-icon://sys-enter-2%% are running. <em>Check status</em> ` &&
                    `%%icon:sap-icon://stethoscope%%`.

      view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    " require the framework's curated formatter module into the view -
    " expandInlineIcons is the sap.m.MessageStripUtilities.getInlineIcon()
    " equivalent: a whole-string formatter that replaces every
    " %%icon:sap-icon://<name>%% placeholder with inline-icon markup (the
    " glyph resolved via IconPool), so the app never hardcodes icon-font
    " codepoints. Rendered by MessageStrip with enableFormattedText.
    view->_generic_property( VALUE #( n = `core:require`
                                      v = `{Formatter: 'z2ui5/model/formatter'}` ) ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - MessageStrip - inline icons via Formatter`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `The status line below binds a plain string carrying %%icon:sap-icon://...%% placeholders ` &&
                   `through Formatter.expandInlineIcons - each placeholder becomes an inline icon glyph, ` &&
                   `no codepoints in the app.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->message_strip(
        text                = |\{ path: '{ client->_bind( val = status_text path = abap_true ) }', | &&
                              |formatter: 'Formatter.expandInlineIcons' \}|
        type                = `Success`
        enableformattedtext = abap_true
        showicon            = abap_true
        class               = `sapUiSmallMargin` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
