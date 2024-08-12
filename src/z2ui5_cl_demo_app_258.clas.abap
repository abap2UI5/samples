class Z2UI5_CL_DEMO_APP_258 definition
  public
  final
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  data CHECK_INITIALIZED type ABAP_BOOL .
  data SELECTED_MENU_ENTRY type STRING .
protected section.

  data CLIENT type ref to Z2UI5_IF_CLIENT .

  methods ON_EVENT
    importing
      !CLIENT type ref to Z2UI5_IF_CLIENT .
  methods RENDER_MAIN_VIEW
    importing
      !CLIENT type ref to Z2UI5_IF_CLIENT .
  methods RENDER_SITE_CONTENT
    importing
      !CLIENT type ref to Z2UI5_IF_CLIENT
    changing
      !SITE_CONTENT type ref to Z2UI5_CL_XML_VIEW .
private section.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_258 IMPLEMENTATION.


  METHOD on_event.

    "The selected key of the side navigation does not change if the user presses on an menu entry
    "While the new page loads the key remains the same - After loading the element changes the key on the frontend
    "but we need it earlier

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'MENU_HOME'.
        client->message_toast_display( 'Home Button pressed' ).
        selected_menu_entry = 'Home'.
      WHEN 'MENU_HOME_1'.
        client->message_toast_display( 'Home Sub 1 Button pressed' ).
        selected_menu_entry = 'Home1'.
      WHEN 'MENU_HOME_2'.
        client->message_toast_display( 'Home Sub 2 Button pressed' ).
        selected_menu_entry = 'Home2'.
      WHEN 'MENU_HOME_3'.
        client->message_toast_display( 'Home Sub 3 Button pressed' ).
        selected_menu_entry = 'Home3'.
      WHEN 'MENU_CUSTOMER'.
        client->message_toast_display( 'Customer Button pressed' ).
        selected_menu_entry = 'Customers'.
      WHEN 'MENU_SUPPLIER'.
        client->message_toast_display( 'Supplier Button pressed' ).
        selected_menu_entry = 'Suppliers'.
      WHEN 'MENU_FIX1'.
        client->message_toast_display( 'Fixed Button 1 pressed' ).
        selected_menu_entry = 'Fix1'.
      WHEN 'MENU_FIX2'.
        client->message_toast_display( 'Fixed Button 2 pressed' ).
        selected_menu_entry = 'Fix2'.
      WHEN 'MENU_FIX3'.
        client->message_toast_display( 'Fixed Button 3 pressed' ).
        selected_menu_entry = 'Fix3'.
    ENDCASE.

  ENDMETHOD.


  METHOD RENDER_MAIN_VIEW.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    "Custom CSS
    view->_generic( ns = `html` name = `style` )->_cc_plain_xml( `.sapMPage>section { height: 100% }` &&
    `#mainView--site_content { border-radius: 0.75em }` ).

    DATA(page) = view->page(
            title          = 'abap2UI5 - Sample: Side Navigation'
            navbuttonpress = client->_event( 'BACK' )
            enablescrolling = abap_false
            class = 'sapUiResponsivePadding--header sapUiResponsivePadding--content sapUiResponsivePadding--footer'
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(content) = page->flex_box( width = '100%' height = '90%' alignitems = 'Start' ).

    DATA(navlist) = content->flex_box( width = '100%' height = '100%' direction = 'Column' )->layout_data( )->flex_item_data( growfactor = '1'
    basesize = '0' )->get_parent( )->side_navigation( id = 'sideNavigation' class = 'sapUiTinyMarginTop' selectedkey = client->_bind( selected_menu_entry ) height = '100%'
    )->navigation_list( ).

    "As per version 1.120.19 icons for sub menu entries are not possible
    "This part of the menu is scrollable if there are too many entries for the current screen size
    navlist->navigation_list_item( text = 'Home' icon = 'sap-icon://home' select = client->_event( 'MENU_HOME' ) key = 'Home'
     )->get_child( )->navigation_list_item( text = 'Home Sub 1' select = client->_event( 'MENU_HOME_1' ) key = 'Home1'
     )->navigation_list_item( text = 'Home Sub 2' select = client->_event( 'MENU_HOME_2' ) key = 'Home2'
     )->navigation_list_item( text = 'Home Sub 3' select = client->_event( 'MENU_HOME_3' ) key = 'Home3' ).

    navlist->navigation_list_item( text = 'Customers' icon = 'sap-icon://customer' select = client->_event( 'MENU_CUSTOMER' ) key = 'Customers' ).
    navlist->navigation_list_item( text = 'Suppliers' icon = 'sap-icon://supplier' select = client->_event( 'MENU_SUPPLIER' ) key = 'Suppliers' ).

    "This part of the menu is fixed and always visible
    navlist->get_parent( )->fixed_item( )->navigation_list(
    )->navigation_list_item( text = 'Fixed Entry 1' icon = 'sap-icon://heart' select = client->_event( 'MENU_FIX1' ) key = 'Fix1'
    )->navigation_list_item( text = 'Fixed Entry 2' icon = 'sap-icon://flight' select = client->_event( 'MENU_FIX2' ) key = 'Fix2'
    )->navigation_list_item( text = 'Fixed Entry 3' icon = 'sap-icon://email-read' select = client->_event( 'MENU_FIX3' ) key = 'Fix3'
    )->navigation_list_item( text = 'Link' icon = 'sap-icon://chain-link' href = 'https://github.com/abap2UI5/abap2UI5' ).

    DATA(site_content) = content->flex_box( id = 'site_content' class = 'sapUiTinyMarginTop sapUiTinyMarginBegin' width = '100%' height = '100%' backgrounddesign = 'Solid'
    alignitems = 'Center' justifycontent = 'Center' )->layout_data( )->flex_item_data( growfactor = '4' backgrounddesign = 'Solid' )->get_parent( ).

    "Render content depending on the current site
    me->render_site_content( EXPORTING client = client CHANGING site_content = site_content ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD render_site_content.

    CASE selected_menu_entry.

      WHEN 'Home'.
        site_content->text( 'Welcome to the Home Page' ).
      WHEN 'Home1'.
        site_content->text( 'Welcome to the Home Sub Page 1' ).
      WHEN 'Home2'.
        site_content->text( 'Welcome to the Home Sub Page 2' ).
      WHEN 'Home3'.
        site_content->text( 'Welcome to the Home Sub Page 3' ).
      WHEN 'Customers'.
        site_content->text( 'Welcome to the Customers Page' ).
      WHEN 'Suppliers'.
        site_content->text( 'Welcome to the Suppliers Page' ).
      WHEN 'Fix1'.
        site_content->text( 'Welcome to the first fixed Page' ).
      WHEN 'Fix2'.
        site_content->text( 'Welcome to the second fixed Page' ).
      WHEN 'Fix3'.
        site_content->text( 'Welcome to the third fixed Page' ).
    ENDCASE.

  ENDMETHOD.


  method Z2UI5_IF_APP~MAIN.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      selected_menu_entry = 'Home'.
    ENDIF.

    on_event( client ).
    render_main_view( client ).

  endmethod.
ENDCLASS.
