" @keywords binding_call getbinding sorter filter follow_up_action
CLASS z2ui5_cl_smp_app_454 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        category TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_smp_app_454 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      t_products = VALUE #(
          ( name = `Notebook Basic 15`  category = `Laptops` )
          ( name = `Notebook Basic 17`  category = `Laptops` )
          ( name = `Ergo Screen E-I`    category = `Screens` )
          ( name = `Flat Basic`         category = `Screens` )
          ( name = `Comfort Easy`       category = `PDAs` )
          ( name = `ITelO Vault`        category = `PDAs` ) ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SEARCH`.
        " apply a declarative filter to the list's items binding -
        " client-side after the response renders. The model data stays
        " untouched (no table copy, no model change); an empty query
        " clears the filter again.
        " t_arg is positional: id, aggregation, method, params
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-binding_call
                                  t_arg = VALUE #( ( `productList` )
                                                   ( `items` )
                                                   ( `filter` )
                                                   ( `NAME` )
                                                   ( `Contains` )
                                                   ( client->get_event_arg( ) ) ) ).

      WHEN `SORT_ASC` OR `SORT_DESC`.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-binding_call
                                  t_arg = VALUE #( ( `productList` )
                                                   ( `items` )
                                                   ( `sort` )
                                                   ( `NAME` )
                                                   ( COND #( WHEN client->get_event( ) = `SORT_DESC`
                                                             THEN `true`
                                                             ELSE `false` ) ) ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - List - Filter and Sort the Binding from ABAP`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Search and sort are applied to the list's items BINDING via follow_up_action ` &&
                   `with cs_event-binding_call - the UI5 controller pattern getBinding('items').filter(...). ` &&
                   `The model stays untouched.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `SearchField`
            )->a( n = `width`       v = `30%`
            )->a( n = `search`      v = client->_event( val   = `SEARCH`
                                                       t_arg = VALUE #( ( `${$parameters>/query}` ) ) )
            )->a( n = `placeholder` v = `Search products`
        )->ele( `HBox`
            )->a( n = `class` v = `sapUiTinyMarginTop`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `SORT_ASC` )
                )->a( n = `text`  v = `Sort ascending`
                )->a( n = `icon`  v = `sap-icon://sort-ascending`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `SORT_DESC` )
                )->a( n = `text`  v = `Sort descending`
                )->a( n = `icon`  v = `sap-icon://sort-descending`
                )->a( n = `class` v = `sapUiTinyMarginBegin` ).

    page->ele( `List`
        )->a( n = `headerText` v = `Products`
        )->a( n = `items`      v = client->_bind( t_products )
        )->a( n = `class`      v = `sapUiSmallMargin`
        )->a( n = `id`         v = `productList`
        )->tag( `StandardListItem`
            )->a( n = `title`       v = `{NAME}`
            )->a( n = `description` v = `{CATEGORY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
