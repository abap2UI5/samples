"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.NavigationList/sample/sap.tnt.sample.NavigationList
"! Navigation List in a Page
CLASS z2ui5_cl_demo_app_498 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA expanded TYPE abap_bool.
    DATA sub_item_visible TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_498 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      expanded         = abap_true.
      sub_item_visible = abap_true.

      view_display( ).

    ELSEIF client->check_on_event( `TOGGLE_EXPANDED` ).

      expanded = xsdbool( expanded = abap_false ).
      client->view_model_update( ).

    ELSEIF client->check_on_event( `TOGGLE_SUB_ITEM` ).

      sub_item_visible = xsdbool( sub_item_visible = abap_false ).
      client->view_model_update( ).

    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Navigation List`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.tnt.NavigationList/sample/sap.tnt.sample.NavigationList` ).

    page->overflow_toolbar(
        )->button(
            text  = `Toggle Collapse/Expand`
            icon  = `sap-icon://menu2`
            press = client->_event( `TOGGLE_EXPANDED` )
        )->button(
            text  = `Show/Hide SubItem 3`
            icon  = `sap-icon://menu2`
            press = client->_event( `TOGGLE_SUB_ITEM` ) ).

    page->_generic( name   = `NavigationList`
                    ns     = `tnt`
                    t_prop = VALUE #( ( n = `width`       v = `320px` )
                                      ( n = `selectedKey` v = `subItem3` )
                                      ( n = `expanded`    v = client->_bind( expanded ) ) )
        )->_generic( name   = `NavigationListItem`
                     ns     = `tnt`
                     t_prop = VALUE #( ( n = `text` v = `Item 1` )
                                       ( n = `key`  v = `rootItem1` )
                                       ( n = `icon` v = `sap-icon://employee` ) )
            )->navigation_list_item( text = `Sub Item 1`
            )->navigation_list_item( text = `Sub Item 2`
            )->_generic( name   = `NavigationListItem`
                         ns     = `tnt`
                         t_prop = VALUE #( ( n = `text`    v = `Sub Item 3` )
                                           ( n = `key`     v = `subItem3` )
                                           ( n = `visible` v = client->_bind( sub_item_visible ) ) )
            )->get_parent(
            )->navigation_list_item( text = `Sub Item 4`
            )->_generic( name   = `NavigationListItem`
                         ns     = `tnt`
                         t_prop = VALUE #( ( n = `text`    v = `Invisible Sub Item 5` )
                                           ( n = `visible` v = `false` ) )
            )->get_parent(
            )->_generic( name   = `NavigationListItem`
                         ns     = `tnt`
                         t_prop = VALUE #( ( n = `text`    v = `Invisible Sub Item 6` )
                                           ( n = `visible` v = `false` ) )
            )->get_parent( )->get_parent(
        )->_generic( name   = `NavigationListItem`
                     ns     = `tnt`
                     t_prop = VALUE #( ( n = `text`    v = `Invisible Section` )
                                       ( n = `icon`    v = `sap-icon://employee` )
                                       ( n = `visible` v = `false` ) )
            )->navigation_list_item( text = `Sub Item 1`
            )->navigation_list_item( text = `Sub Item 2`
            )->navigation_list_item( text = `Sub Item 3`
            )->navigation_list_item( text = `Sub Item 4` )->get_parent(
        )->_generic( name   = `NavigationListItem`
                     ns     = `tnt`
                     t_prop = VALUE #( ( n = `text` v = `Item 2` )
                                       ( n = `icon` v = `sap-icon://building` ) )
            )->navigation_list_item( text = `Sub Item 1`
            )->navigation_list_item( text = `Sub Item 2`
            )->navigation_list_item( text = `Sub Item 3`
            )->navigation_list_item( text = `Sub Item 4` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
