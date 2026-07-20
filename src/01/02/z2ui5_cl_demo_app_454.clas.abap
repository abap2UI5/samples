CLASS z2ui5_cl_demo_app_454 DEFINITION PUBLIC.

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



CLASS Z2UI5_CL_DEMO_APP_454 IMPLEMENTATION.


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
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 TYPE string_table.
        DATA temp5 TYPE string_table.
        DATA temp1 TYPE string.

    CASE client->get( )-event.

      WHEN `SEARCH`.
        " apply a declarative filter to the list's items binding -
        " client-side after the response renders. The model data stays
        " untouched (no table copy, no view_model_update); an empty query
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
        
        IF client->get( )-event = `SORT_DESC`.
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

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp7 TYPE string_table.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell(
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

    
    CLEAR temp7.
    INSERT `${$parameters>/query}` INTO TABLE temp7.
    page->vbox( `sapUiSmallMargin`
        )->search_field( width  = `30%`
                         search = client->_event( val   = `SEARCH`
                                                  t_arg = temp7 )
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
                items      = client->_bind( t_products )
                class      = `sapUiSmallMargin`
        )->standard_list_item( title       = `{NAME}`
                               description = `{CATEGORY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
