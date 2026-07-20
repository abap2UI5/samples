CLASS z2ui5_cl_demo_app_455 DEFINITION PUBLIC.

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



CLASS Z2UI5_CL_DEMO_APP_455 IMPLEMENTATION.


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
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell(
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
    
    CLEAR temp3.
    INSERT `productList` INTO TABLE temp3.
    INSERT `items` INTO TABLE temp3.
    INSERT `filter` INTO TABLE temp3.
    INSERT `NAME` INTO TABLE temp3.
    INSERT `Contains` INTO TABLE temp3.
    INSERT `${$parameters>/newValue}` INTO TABLE temp3.
    page->vbox( `sapUiSmallMargin`
        )->search_field( width      = `30%`
                         livechange = client->_event_client(
                             val   = z2ui5_if_client=>cs_event-binding_call
                             t_arg = temp3 ) ).

    page->list( id         = `productList`
                headertext = `Products`
                items      = client->_bind( t_products )
                class      = `sapUiSmallMargin`
        )->standard_list_item( title       = `{NAME}`
                               description = `{CATEGORY}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
