" @keywords binding_call live search client side no roundtrip filter
CLASS z2ui5_cl_smp_app_455 DEFINITION PUBLIC.

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



CLASS z2ui5_cl_smp_app_455 IMPLEMENTATION.


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

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - List - Live Filter on the Client, No Roundtrip`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Every keystroke filters the list's items binding purely client-side ` &&
                   `(cs_event-binding_call via follow_up_action) - no backend roundtrip, exactly like ` &&
                   `the original UI5 controller's oBinding.filter(...). Clearing the field clears the filter.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    " t_arg order: control id, aggregation, method, then the filter params
    " path / operator / value - the ${...} argument is resolved client-side
    " against the liveChange event, so the current query reaches the filter
    " without any server contact.
    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `SearchField`
            )->a( n = `width`       v = `30%`
            )->a( n = `placeholder` v = `Search products`
            )->a( n = `liveChange`  v = client->follow_up_action(
                             val   = z2ui5_if_client=>cs_event-binding_call
                             t_arg = VALUE #( ( `productList` )
                                              ( `items` )
                                              ( `filter` )
                                              ( `NAME` )
                                              ( `Contains` )
                                              ( `${$parameters>/newValue}` ) ) ) ).

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
