"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.ToolHeader/sample/sap.tnt.sample.ToolHeaderIconTabHeader
"! ToolHeader can contain IconTabHeader. When both controls are combined, the IconTabHeader supports
"! only inline text. No icons can be used.
CLASS z2ui5_cl_demo_app_500 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_key TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_500 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      selected_key = `invalidKey`.

      view_display( ).

    ELSEIF client->check_on_event( `HOME` ).

      selected_key = `invalidKey`.
      client->view_model_update( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: ToolHeader with IconTabHeader`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.ToolHeader/sample/sap.tnt.sample.ToolHeaderIconTabHeader` ).

    page->text(
        text  = `Simple IconTabHeader`
        class = `sapUiTinyMarginTop sapUiSmallMarginBegin` ).

    " The sample variants with nested sub-items are omitted - nested IconTabFilter items (since 1.77) and interactionMode (since 1.121) came after UI5 1.71
    page->tool_header(
        )->_generic_property( VALUE #( n = `class` v = `sapUiTinyMarginTop sapUiTinyMarginEnd sapUiTinyMarginBegin` )
        )->button(
            icon  = `sap-icon://home`
            type  = `Transparent`
            press = client->_event( `HOME` ) )->get(
            )->layout_data(
                )->overflow_toolbar_layout_data( priority = `NeverOverflow` )->get( `ToolHeader`
        )->icon_tab_header(
            selectedkey      = client->_bind_edit( selected_key )
            backgrounddesign = `Transparent`
            mode             = `Inline`
            )->layout_data(
                )->_generic( name   = `OverflowToolbarLayoutData`
                             t_prop = VALUE #( ( n = `priority`   v = `NeverOverflow` )
                                               ( n = `shrinkable` v = `true` ) ) )->get( `IconTabHeader`
            )->items(
                )->icon_tab_filter( text = `Documentation` )->get_parent(
                )->icon_tab_filter( text = `Explored` )->get_parent(
                )->icon_tab_filter( text = `API Reference` )->get_parent(
                )->icon_tab_filter( text = `Demo Apps` )->get( `ToolHeader`
        )->button(
            icon = `sap-icon://search`
            type = `Transparent` )->get(
            )->layout_data(
                )->overflow_toolbar_layout_data( priority = `NeverOverflow` )->get( `ToolHeader`
        )->button(
            icon = `sap-icon://comment`
            type = `Transparent` )->get(
            )->layout_data(
                )->overflow_toolbar_layout_data( priority = `NeverOverflow` )->get( `ToolHeader`
        )->menu_button( type = `Transparent`
        )->_generic_property( VALUE #( n = `icon` v = `sap-icon://hint` )
            )->layout_data(
                )->overflow_toolbar_layout_data( priority = `NeverOverflow` )->get( `MenuButton`
            )->menu(
                )->menu_item(
                    text = `Edit`
                    icon = `sap-icon://edit`
                )->menu_item(
                    text = `Save`
                    icon = `sap-icon://save` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
