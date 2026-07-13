"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarStretchContent
"! In this example, the IconTabBar height is stretched to the maximum height of the page content.
"! Note: The height of the parent container must be defined as a fixed value. Also, applyContentPadding
"! property is set to false and backgroundDesign property is set to Transparent.
CLASS z2ui5_cl_demo_app_433 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        quantity TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_433 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = `abap2UI5 - Sample: Icon Tab Bar - Stretch Content Height`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->header_content(
       )->link(
           text   = `UI5 Demo Kit`
           target = `_blank`
           href   = `https://sapui5.hana.ondemand.com/sdk/#/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarStretchContent` ).

    " property expanded="{device>/isNoPhone}" omitted - device model binding not available in abap2UI5
    DATA(items) = page->icon_tab_bar( id                   = `idIconTabBarStretchContent`
                                      stretchcontentheight = abap_true
                                      backgrounddesign     = `Transparent`
                                      applycontentpadding  = abap_false
                                      class                = `sapUiResponsiveContentPadding`
                       )->items( ).

    items->icon_tab_filter( text = `Products`
                            key  = `products`
        )->scroll_container( height     = `100%`
                             width      = `100%`
                             horizontal = abap_false
                             vertical   = abap_true
            )->list( client->_bind( t_products )
                )->standard_list_item( title   = `{NAME}`
                                       counter = `{QUANTITY}` ).

    items->icon_tab_filter( text = `Attachments`
                            key  = `attachments`
        )->text( `Attachments go here ...` ).

    items->icon_tab_filter( text = `Notes`
                            key  = `notes`
        )->text( `Notes go here ...` ).

    items->icon_tab_filter( text = `People`
                            key  = `people`
        )->text( `People content goes here ...` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      t_products = VALUE #(
          ( name = `Notebook Basic 15`        quantity = `10` )
          ( name = `Notebook Basic 17`        quantity = `20` )
          ( name = `Notebook Basic 18`        quantity = `10` )
          ( name = `Notebook Basic 19`        quantity = `15` )
          ( name = `ITelO Vault`              quantity = `15` )
          ( name = `Notebook Professional 15` quantity = `16` )
          ( name = `Notebook Professional 17` quantity = `17` )
          ( name = `ITelO Vault Net`          quantity = `14` ) ).

      view_display( client ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
