CLASS z2ui5_cl_demo_app_455 DEFINITION PUBLIC.

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

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_455 IMPLEMENTATION.


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
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Binding Call - live filter, no roundtrip`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Every keystroke filters the list's items binding purely client-side ` &&
                   `(cs_event-binding_call via _event_client) - no backend roundtrip, exactly like ` &&
                   `the original UI5 controller's oBinding.filter(...). Clearing the field clears the filter.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    " t_arg order: control id, aggregation, method, then the filter params
    " path / operator / value - the ${...} argument is resolved client-side
    " against the liveChange event, so the current query reaches the filter
    " without any server contact.
    page->vbox( `sapUiSmallMargin`
        )->search_field( width      = `30%`
                         livechange = client->_event_client(
                             val   = z2ui5_if_client=>cs_event-binding_call
                             t_arg = VALUE #( ( `productList` )
                                              ( `items` )
                                              ( `filter` )
                                              ( `NAME` )
                                              ( `Contains` )
                                              ( `${$parameters>/newValue}` ) ) ) ).

    page->list( id         = `productList`
                headertext = `Products`
                items      = client->_bind( t_products )
                class      = `sapUiSmallMargin`
        )->standard_list_item( title       = `{NAME}`
                               description = `{CATEGORY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
