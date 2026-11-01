" @keywords icon glyph placeholder text status expandinlineicons
" @summary Puts icons inside a text through placeholders that UI5 expands, so a status line can carry a glyph without its own control.
" @docs https://abap2ui5.github.io/docs/cookbook/model/formatter
CLASS z2ui5_cl_smp_app_466 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA status_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_466 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.

      status_text = `<strong>Deployment successful!</strong> %%icon:sap-icon://message-success%% All services ` &&
                    `%%icon:sap-icon://sys-enter-2%% are running. <em>Check status</em> ` &&
                    `%%icon:sap-icon://stethoscope%%`.

      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    " require the framework's curated formatter module into the view -
    " expandInlineIcons is the sap.m.MessageStripUtilities.getInlineIcon()
    " equivalent: a whole-string formatter that replaces every
    " %%icon:sap-icon://<name>%% placeholder with inline-icon markup (the
    " glyph resolved via IconPool), so the app never hardcodes icon-font
    " codepoints. Rendered by MessageStrip with enableFormattedText.
    view->a( n = `core:require` v = `{Formatter: 'z2ui5/model/formatter'}` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Formatter - Inline Icons in a Text`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `The status line below binds a plain string carrying %%icon:sap-icon://...%% placeholders ` &&
                   `through Formatter.expandInlineIcons - each placeholder becomes an inline icon glyph, ` &&
                   `no codepoints in the app.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->tag( `MessageStrip`
        )->a( n = `text`                v = |\{ path: '{ client->_bind( val = status_text path = abap_true ) }', | &&
                              |formatter: 'Formatter.expandInlineIcons' \}|
        )->a( n = `type`                v = `Success`
        )->a( n = `showIcon`            b = abap_true
        )->a( n = `class`               v = `sapUiSmallMargin`
        )->a( n = `enableFormattedText` b = abap_true ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
