CLASS z2ui5_cl_demo_app_454 DEFINITION PUBLIC.

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



CLASS Z2UI5_CL_DEMO_APP_454 IMPLEMENTATION.


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

    CASE client->get( )-event.

      WHEN `SEARCH`.
        " apply a declarative filter to the list's items binding -
        " client-side after the response renders. The model data stays
        " untouched (no table copy, no view_model_update); an empty query
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
                                                   ( COND #( WHEN client->get( )-event = `SORT_DESC`
                                                             THEN `true`
                                                             ELSE `false` ) ) ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Binding Call - filter and sort`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Search and sort are applied to the list's items BINDING via follow_up_action ` &&
                   `with cs_event-binding_call - the UI5 controller pattern getBinding('items').filter(...). ` &&
                   `The model stays untouched.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->vbox( `sapUiSmallMargin`
        )->search_field( width  = `30%`
                         search = client->_event( val   = `SEARCH`
                                                  t_arg = VALUE #( ( `${$parameters>/query}` ) ) )
        )->hbox( class = `sapUiTinyMarginTop`
            )->button( text  = `Sort ascending`
                       icon  = `sap-icon://sort-ascending`
                       press = client->_event( `SORT_ASC` )
            )->button( text  = `Sort descending`
                       icon  = `sap-icon://sort-descending`
                       press = client->_event( `SORT_DESC` )
                       class = `sapUiTinyMarginBegin` ).

    page->list( id         = `productList`
                headertext = `Products`
                items      = client->_bind_edit( t_products )
                class      = `sapUiSmallMargin`
        )->standard_list_item( title       = `{NAME}`
                               description = `{CATEGORY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
