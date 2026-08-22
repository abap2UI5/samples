" @keywords binding_call getbinding sorter filter follow_up_action
" @summary Sorts and filters a bound list from ABAP by calling getBinding on the control - the binding does the work, not a rebuilt table.
CLASS z2ui5_cl_smp_app_454 DEFINITION PUBLIC.

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
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_454 IMPLEMENTATION.


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
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE string_table.
        DATA temp5 TYPE string_table.
        DATA temp1 TYPE string.

    CASE client->get_event( ).

      WHEN `SEARCH`.
        " apply a declarative filter to the list's items binding -
        " client-side after the response renders. The model data stays
        " untouched (no table copy, no model change); an empty query
        " clears the filter again.
        " t_arg is positional: id, aggregation, method, params
        
        CLEAR temp3.
        INSERT `productList` INTO TABLE temp3.
        INSERT `items` INTO TABLE temp3.
        INSERT `filter` INTO TABLE temp3.
        INSERT `NAME` INTO TABLE temp3.
        INSERT `Contains` INTO TABLE temp3.
        INSERT client->get_event_arg( ) INTO TABLE temp3.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-binding_call
                                  t_arg = temp3 ).

      WHEN `SORT_ASC` OR `SORT_DESC`.
        
        CLEAR temp5.
        INSERT `productList` INTO TABLE temp5.
        INSERT `items` INTO TABLE temp5.
        INSERT `sort` INTO TABLE temp5.
        INSERT `NAME` INTO TABLE temp5.
        
        IF client->get_event( ) = `SORT_DESC`.
          temp1 = `true`.
        ELSE.
          temp1 = `false`.
        ENDIF.
        INSERT temp1 INTO TABLE temp5.
        client->follow_up_action( val   = z2ui5_if_client=>cs_event-binding_call
                                  t_arg = temp5 ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp7 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    
    page = view->ele( `Shell`
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

    
    CLEAR temp7.
    INSERT `${$parameters>/query}` INTO TABLE temp7.
    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `SearchField`
            )->a( n = `width`       v = `30%`
            )->a( n = `search`      v = client->_event( val   = `SEARCH`
                                                       t_arg = temp7 )
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
