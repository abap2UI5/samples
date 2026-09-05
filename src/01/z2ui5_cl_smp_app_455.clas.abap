" @keywords binding_call live search client side no roundtrip filter
" @summary Filters a list live on the client as the user types - no roundtrip, no backend, the same binding_call from the view chain.
CLASS z2ui5_cl_smp_app_455 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        category TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_455 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_products.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      
      CLEAR temp1.
      
      temp2-name = `Notebook Basic 15`.
      temp2-category = `Laptops`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Notebook Basic 17`.
      temp2-category = `Laptops`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Ergo Screen E-I`.
      temp2-category = `Screens`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Flat Basic`.
      temp2-category = `Screens`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Comfort Easy`.
      temp2-category = `PDAs`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `ITelO Vault`.
      temp2-category = `PDAs`.
      INSERT temp2 INTO TABLE temp1.
      t_products = temp1.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    
    page = view->ele( `Shell`
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
    
    CLEAR temp3.
    INSERT `productList` INTO TABLE temp3.
    INSERT `items` INTO TABLE temp3.
    INSERT `filter` INTO TABLE temp3.
    INSERT `NAME` INTO TABLE temp3.
    INSERT `Contains` INTO TABLE temp3.
    INSERT `${$parameters>/newValue}` INTO TABLE temp3.
    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `SearchField`
            )->a( n = `width`       v = `30%`
            )->a( n = `placeholder` v = `Search products`
            )->a( n = `liveChange`  v = client->follow_up_action(
                             val   = z2ui5_if_client=>cs_event-binding_call
                             t_arg = temp3 ) ).

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
