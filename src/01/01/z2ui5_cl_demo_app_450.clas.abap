CLASS z2ui5_cl_demo_app_450 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name    TYPE string,
        measure TYPE string,
        unit    TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_450 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_products.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      
      CLEAR temp1.
      
      temp2-name = `Comfort Easy`.
      temp2-measure = `0.2`.
      temp2-unit = `KG`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Notebook Basic 15`.
      temp2-measure = `4.2`.
      temp2-unit = `KG`.
      INSERT temp2 INTO TABLE temp1.
      temp2-name = `Ergo Screen E-I`.
      temp2-measure = `21`.
      temp2-unit = `KG`.
      INSERT temp2 INTO TABLE temp1.
      t_products = temp1.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE z2ui5_if_types=>ty_s_name_value.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    " require the framework's curated formatter module into the view, like an
    " original UI5 app requires its model/formatter - the weightState function
    " (weight -> ValueState) then works as a plain formatter in the binding.
    " z2ui5.Util is deprecated; z2ui5/model/formatter is the module to use.
    
    CLEAR temp3.
    temp3-n = `core:require`.
    temp3-v = `{Formatter: 'z2ui5/model/formatter'}`.
    view->_generic_property( temp3 ).

    
    page = view->shell(
        )->page(
            title          = `abap2UI5 - Formatter - weightState via core:require`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `The Weight column's state is formatted client-side by ` &&
                   `Formatter.weightState from z2ui5/model/formatter, wired via core:require.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    
    tab = page->table( id    = `productTable`
                             items = client->_bind( t_products ) ).

    tab->columns(
        )->column( )->text( `Product` )->get_parent(
        )->column( )->text( `Weight` )->get_parent( ).

    tab->items(
        )->column_list_item(
            )->cells(
                )->text( `{NAME}`
                )->object_number(
                    number = `{MEASURE}`
                    unit   = `{UNIT}`
                    state  = |\{ parts: [\{path: 'MEASURE'\}, \{path: 'UNIT'\}], formatter: 'Formatter.weightState' \}| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
