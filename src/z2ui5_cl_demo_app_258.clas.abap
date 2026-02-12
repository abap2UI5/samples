CLASS z2ui5_cl_demo_app_258 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_selected_menu_entry TYPE string .
  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client .

    METHODS on_event
      IMPORTING
      !mo_client TYPE REF TO z2ui5_if_client .
    METHODS render_main_view
      IMPORTING
      !mo_client TYPE REF TO z2ui5_if_client .
    METHODS render_site_content
      IMPORTING
      !mo_client       TYPE REF TO z2ui5_if_client
      CHANGING
      !lo_site_content TYPE REF TO z2ui5_cl_xml_view .
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_258 IMPLEMENTATION.

  METHOD on_event.

    "The selected key of the side navigation does not change if the user presses on an menu entry
    "While the new page loads the key remains the same - After loading the element changes the key on the frontend
    "but we need it earlier

    CASE mo_client->get( )-event.
      WHEN `MENU_HOME`.
        mo_client->message_toast_display( `Home Button pressed` ).
        mv_selected_menu_entry = `Home`.
      WHEN `MENU_HOME_1`.
        mo_client->message_toast_display( `Home Sub 1 Button pressed` ).
        mv_selected_menu_entry = `Home1`.
      WHEN `MENU_HOME_2`.
        mo_client->message_toast_display( `Home Sub 2 Button pressed` ).
        mv_selected_menu_entry = `Home2`.
      WHEN `MENU_HOME_3`.
        mo_client->message_toast_display( `Home Sub 3 Button pressed` ).
        mv_selected_menu_entry = `Home3`.
      WHEN `MENU_CUSTOMER`.
        mo_client->message_toast_display( `Customer Button pressed` ).
        mv_selected_menu_entry = `Customers`.
      WHEN `MENU_SUPPLIER`.
        mo_client->message_toast_display( `Supplier Button pressed` ).
        mv_selected_menu_entry = `Suppliers`.
      WHEN `MENU_FIX1`.
        mo_client->message_toast_display( `Fixed Button 1 pressed` ).
        mv_selected_menu_entry = `Fix1`.
      WHEN `MENU_FIX2`.
        mo_client->message_toast_display( `Fixed Button 2 pressed` ).
        mv_selected_menu_entry = `Fix2`.
      WHEN `MENU_FIX3`.
        mo_client->message_toast_display( `Fixed Button 3 pressed` ).
        mv_selected_menu_entry = `Fix3`.
    ENDCASE.
  ENDMETHOD.

  METHOD render_main_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    "Custom CSS
    lo_view->_generic( ns   = `html`
                    name = `style` )->_cc_plain_xml( `.sapMPage>section { height: 100% }` &&
      `#mainView--site_content { border-radius: 0.75em }` ).

    DATA(lo_page) = lo_view->page(
            title           = `abap2UI5 - Sample: Side Navigation`
            navbuttonpress  = mo_client->_event_nav_app_leave( )
            enablescrolling = abap_false
            class           = `sapUiResponsivePadding--header sapUiResponsivePadding--content sapUiResponsivePadding--footer`
            shownavbutton   = mo_client->check_app_prev_stack( ) ).

    DATA(lo_content) = lo_page->flex_box( width      = `100%`
                                    height     = `90%`
                                    alignitems = `Start` ).

    DATA(lo_navlist) = lo_content->flex_box( width     = `100%`
                                       height    = `100%`
                                       direction = `Column` )->layout_data( )->flex_item_data( growfactor = `1`
      basesize                                                                                            = `0` )->get_parent( )->side_navigation( id                                           = `sideNavigation`
                                                                                                                                                                                    class       = `sapUiTinyMarginTop`
                                                                                                                                                                                    selectedkey = mo_client->_bind( mv_selected_menu_entry )
      )->navigation_list( ).

    "As per version 1.120.19 icons for sub menu entries are not possible
    "This part of the menu is scrollable if there are too many entries for the current screen size
    lo_navlist->navigation_list_item( text   = `Home`
                                   icon   = `sap-icon://home`
                                   select = mo_client->_event( `MENU_HOME` )
                                   key    = `Home`
      )->get_child( )->navigation_list_item( text   = `Home Sub 1`
                                             select = mo_client->_event( `MENU_HOME_1` )
                                             key    = `Home1`
      )->navigation_list_item( text   = `Home Sub 2`
                               select = mo_client->_event( `MENU_HOME_2` )
                               key    = `Home2`
      )->navigation_list_item( text   = `Home Sub 3`
                               select = mo_client->_event( `MENU_HOME_3` )
                               key    = `Home3` ).

    lo_navlist->navigation_list_item( text   = `Customers`
                                   icon   = `sap-icon://customer`
                                   select = mo_client->_event( `MENU_CUSTOMER` )
                                   key    = `Customers` ).
    lo_navlist->navigation_list_item( text   = `Suppliers`
                                   icon   = `sap-icon://supplier`
                                   select = mo_client->_event( `MENU_SUPPLIER` )
                                   key    = `Suppliers` ).

    "This part of the menu is fixed and always visible
    lo_navlist->get_parent( )->fixed_item( )->navigation_list(
      )->navigation_list_item( text   = `Fixed Entry 1`
                               icon   = `sap-icon://heart`
                               select = mo_client->_event( `MENU_FIX1` )
                               key    = `Fix1`
      )->navigation_list_item( text   = `Fixed Entry 2`
                               icon   = `sap-icon://flight`
                               select = mo_client->_event( `MENU_FIX2` )
                               key    = `Fix2`
      )->navigation_list_item( text   = `Fixed Entry 3`
                               icon   = `sap-icon://email-read`
                               select = mo_client->_event( `MENU_FIX3` )
                               key    = `Fix3`
      )->navigation_list_item( text = `Link`
                               icon = `sap-icon://chain-link`
                               href = `https://github.com/abap2UI5/abap2UI5` ).

    DATA(lo_site_content) = lo_content->flex_box( id               = `site_content`
                                            class            = `sapUiTinyMarginTop sapUiTinyMarginBegin`
                                            width            = `100%`
                                            height           = `100%`
                                            backgrounddesign = `Solid`
      alignitems                                             = `Center`
                                            justifycontent   = `Center` )->layout_data( )->flex_item_data( growfactor     = `4`
                                                                                                         backgrounddesign = `Solid` )->get_parent( ).

    "Render content depending on the current site
    render_site_content( EXPORTING mo_client = mo_client CHANGING lo_site_content = lo_site_content ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD render_site_content.

    CASE mv_selected_menu_entry.
      WHEN `Home`.
        lo_site_content->text( `Welcome to the Home Page` ).
      WHEN `Home1`.
        lo_site_content->text( `Welcome to the Home Sub Page 1` ).
      WHEN `Home2`.
        lo_site_content->text( `Welcome to the Home Sub Page 2` ).
      WHEN `Home3`.
        lo_site_content->text( `Welcome to the Home Sub Page 3` ).
      WHEN `Customers`.
        lo_site_content->text( `Welcome to the Customers Page` ).
      WHEN `Suppliers`.
        lo_site_content->text( `Welcome to the Suppliers Page` ).
      WHEN `Fix1`.
        lo_site_content->text( `Welcome to the first fixed Page` ).
      WHEN `Fix2`.
        lo_site_content->text( `Welcome to the second fixed Page` ).
      WHEN `Fix3`.
        lo_site_content->text( `Welcome to the third fixed Page` ).
    ENDCASE.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      mv_selected_menu_entry = `Home`.
    ENDIF.

    on_event( mo_client ).
    render_main_view( mo_client ).
  ENDMETHOD.
ENDCLASS.
