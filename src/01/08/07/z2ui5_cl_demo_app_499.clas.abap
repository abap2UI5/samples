"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.SideNavigation/sample/sap.tnt.sample.SideNavigation
"! SideNavigation in container with fixed width.
CLASS z2ui5_cl_demo_app_499 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA expanded TYPE abap_bool.
    DATA walked_visible TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_499 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      expanded       = abap_false.
      walked_visible = abap_true.

      view_display( ).

    ELSEIF client->check_on_event( `TOGGLE_EXPANDED` ).

      expanded = xsdbool( expanded = abap_false ).
      client->view_model_update( ).

    ELSEIF client->check_on_event( `TOGGLE_WALKED` ).

      walked_visible = xsdbool( walked_visible = abap_false ).
      client->view_model_update( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Side Navigation`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.SideNavigation/sample/sap.tnt.sample.SideNavigation` ).

    " NavigationListGroup (since 1.121) and the selectable property (since 1.116) came after UI5 1.71 and are omitted - group items are rendered top-level
    page->vbox(
        rendertype = `Bare`
        alignitems = `Start`
        height     = `100%`
        )->button(
            text  = `Toggle Collapse/Expand`
            icon  = `sap-icon://menu2`
            press = client->_event( `TOGGLE_EXPANDED` )
        )->button(
            text  = `Show/Hide "Walked"`
            icon  = `sap-icon://menu2`
            press = client->_event( `TOGGLE_WALKED` )
        )->side_navigation( selectedkey = `walked`
        )->_generic_property( VALUE #( n = `expanded` v = client->_bind( expanded ) )
            )->navigation_list(
                )->navigation_list_item(
                    text = `Home`
                    icon = `sap-icon://home`
                )->navigation_list_item(
                    text = `People`
                    icon = `sap-icon://people-connected`
                )->_generic( name   = `NavigationListItem`
                             ns     = `tnt`
                             t_prop = VALUE #( ( n = `text` v = `Building` )
                                               ( n = `icon` v = `sap-icon://building` ) )
                    )->navigation_list_item( text = `Office 01`
                    )->navigation_list_item( text = `Office 02` )->get_parent(
                )->_generic( name   = `NavigationListItem`
                             ns     = `tnt`
                             t_prop = VALUE #( ( n = `text` v = `Mileage` )
                                               ( n = `icon` v = `sap-icon://mileage` ) )
                    )->navigation_list_item( text = `Driven`
                    )->_generic( name   = `NavigationListItem`
                                 ns     = `tnt`
                                 t_prop = VALUE #( ( n = `text`    v = `Walked` )
                                                   ( n = `key`     v = `walked` )
                                                   ( n = `visible` v = client->_bind( walked_visible ) ) )
                    )->get_parent( )->get_parent(
                )->navigation_list_item(
                    text = `Managing My Area`
                    icon = `sap-icon://kpi-managing-my-area`
                )->navigation_list_item(
                    text = `Flight`
                    icon = `sap-icon://flight`
                )->navigation_list_item(
                    text = `Map`
                    icon = `sap-icon://map-2`
                )->navigation_list_item(
                    text = `Running`
                    icon = `sap-icon://physical-activity`
                )->navigation_list_item(
                    text = `Scissors`
                    icon = `sap-icon://scissors`
                )->navigation_list_item(
                    text = `Transport`
                    icon = `sap-icon://passenger-train` )->get_parent(
            )->fixed_item(
                )->navigation_list(
                    )->navigation_list_item(
                        text = `Bar Chart`
                        icon = `sap-icon://bar-chart`
                    )->_generic( name   = `NavigationListItem`
                                 ns     = `tnt`
                                 t_prop = VALUE #( ( n = `text`   v = `External Link` )
                                                   ( n = `icon`   v = `sap-icon://attachment` )
                                                   ( n = `href`   v = `https://sap.com` )
                                                   ( n = `target` v = `_blank` ) )
                    )->get_parent(
                    )->_generic( name   = `NavigationListItem`
                                 ns     = `tnt`
                                 t_prop = VALUE #( ( n = `text`   v = `External Link _top` )
                                                   ( n = `icon`   v = `sap-icon://attachment` )
                                                   ( n = `href`   v = `https://sap.com` )
                                                   ( n = `target` v = `_top` ) )
                    )->get_parent(
                    )->navigation_list_item(
                        text = `Compare`
                        icon = `sap-icon://compare` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
