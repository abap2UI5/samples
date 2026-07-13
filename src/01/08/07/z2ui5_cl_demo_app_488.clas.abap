"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.ContainerPadding/sample/sap.m.sample.ContainerNoPadding
"! Many UI5 containers support the standard container content padding CSS classes. Apply the CSS
"! class 'sapUiNoContentPadding' on a UI5 container control to remove the default padding around the
"! container content area.
CLASS z2ui5_cl_demo_app_488 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_488 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: No Container Content Padding`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.ui.core.ContainerPadding/sample/sap.m.sample.ContainerNoPadding` ).

    page->message_strip(
        text  = `The IconTabBar and other container controls have a content padding by default.` &&
                ` You can override default container content paddings by setting the CSS class` &&
                ` 'sapUiNoContentPadding' to the container control`
        class = `sapUiTinyMargin` ).

    " the counts come from the ProductCollectionStats of the demo kit mock data - hardcoded here
    page->icon_tab_bar(
            id    = `idIconTabBar`
            class = `sapUiNoContentPadding`
            )->content(
                )->text( `IconTabBar content without padding`
            )->get_parent(
            )->items(
                )->icon_tab_filter(
                    showall = abap_true
                    count   = `123`
                    text    = `Products`
                    key     = `All`
                )->get_parent(
                )->icon_tab_separator(
                )->get_parent(
                )->icon_tab_filter(
                    icon      = `sap-icon://begin`
                    iconcolor = `Positive`
                    count     = `53`
                    text      = `Ok`
                    key       = `Ok`
                )->get_parent(
                )->icon_tab_filter(
                    icon      = `sap-icon://compare`
                    iconcolor = `Critical`
                    count     = `51`
                    text      = `Heavy`
                    key       = `Heavy`
                )->get_parent(
                )->icon_tab_filter(
                    icon      = `sap-icon://inventory`
                    iconcolor = `Negative`
                    count     = `19`
                    text      = `Overweight`
                    key       = `Overweight` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
