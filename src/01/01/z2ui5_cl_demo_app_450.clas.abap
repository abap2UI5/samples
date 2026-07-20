CLASS z2ui5_cl_demo_app_450 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name    TYPE string,
        measure TYPE string,
        unit    TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_450 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      t_products = VALUE #(
          ( name = `Comfort Easy` measure = `0.2` unit = `KG` )
          ( name = `Notebook Basic 15` measure = `4.2` unit = `KG` )
          ( name = `Ergo Screen E-I` measure = `21` unit = `KG` ) ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    " require the framework's curated formatter module into the view, like an
    " original UI5 app requires its model/formatter - the weightState function
    " (weight -> ValueState) then works as a plain formatter in the binding.
    " z2ui5.Util is deprecated; z2ui5/model/formatter is the module to use.
    view->_generic_property( VALUE #( n = `core:require`
                                      v = `{Formatter: 'z2ui5/model/formatter'}` ) ).

    DATA(page) = view->shell(
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

    DATA(tab) = page->table( id    = `productTable`
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
