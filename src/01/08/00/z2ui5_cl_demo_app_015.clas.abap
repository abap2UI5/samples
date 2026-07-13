"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FormattedText/sample/sap.m.sample.FormattedText
"! The control can be used for embedding formatted HTML text into your application.
CLASS z2ui5_cl_demo_app_015 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA html_text TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_015 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      html_text = `<h3>subheader</h3><p>link: <a href="https://www.sap.com" style="color:green; font-weight:600;">link to sap.com</a> - links open in ` &&
        `a new window.</p><p>paragraph: <strong>strong</strong> and <em>emphasized</em>.</p><p>list:</p><ul` &&
        `><li>list item 1</li><li>list item 2<ul><li>sub item 1</li><li>sub item 2</li></ul></li></ul><p>pre:</p><pre>abc    def    ghi` &&
        `</pre><p>code: <code>var el = document.getElementById("myId");</code></p><p>cite: <cite>a reference to a source</cite></p>` &&
        `<dl><dt>definition:</dt><dd>definition list of terms and descriptions</dd>`.
    ENDIF.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page(
            title          = `abap2UI5 - Formatted Text`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
            )->header_content(
                )->link(
                    text   = `UI5 Demo Kit`
                    target = `_blank`
                    href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.FormattedText/sample/sap.m.sample.FormattedText`
            )->get_parent(
            )->vbox( `sapUiSmallMargin`
                )->formatted_text( html_text ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
