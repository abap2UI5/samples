CLASS Z2UI5_CL_DEMO_APP_007 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    TYPES: BEGIN OF ts_tree_row_base,
             object TYPE string,
             col2   TYPE string,
             col3   TYPE string,
             col4   TYPE string,
           END OF ts_tree_row_base.

    TYPES BEGIN OF ts_tree_level3.
             INCLUDE TYPE ts_tree_row_base.
    TYPES END OF ts_tree_level3.

    TYPES tt_tree_level3 TYPE STANDARD TABLE OF ts_tree_level3 WITH KEY object.

    TYPES BEGIN OF ts_tree_level2.
             INCLUDE TYPE ts_tree_row_base.
    TYPES   categories TYPE tt_tree_level3.
    TYPES END OF ts_tree_level2.

    TYPES tt_tree_level2 TYPE STANDARD TABLE OF ts_tree_level2 WITH KEY object.

    TYPES BEGIN OF ts_tree_level1.
             INCLUDE TYPE ts_tree_row_base.
    TYPES   categories TYPE tt_tree_level2.
    TYPES END OF ts_tree_level1.

    TYPES tt_tree_level1 TYPE STANDARD TABLE OF ts_tree_level1 WITH KEY object.

    DATA mt_tree TYPE tt_tree_level1.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_007 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      mt_tree = VALUE #( ( object = '1' categories = VALUE #( ( object = '1.1' categories = VALUE #( ( object = '1.1.1')
                                                                                                     ( object = '1.1.2') ) )
                                                                               ( object = '1.2' ) ) )
                         ( object = '2' categories = VALUE #( ( object = '2.1' )
                                                              ( object = '2.2' ) ) )
                         ( object = '3' categories = VALUE #( ( object = '3.1' )
                                                              ( object = '3.2' ) ) ) ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = 'abap2UI5 - TreeTable'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true
            )->header_content(
               )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1673320288983842820`
               )->link(
                    text = 'Source_Code'  target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
            )->get_parent( ).

    DATA(tab) = page->tree_table(
      rows = `{path:'` && client->_bind( val = mt_tree path = abap_true ) && `', parameters: {arrayNames:['CATEGORIES']}}` ).
    tab->tree_columns(
    )->tree_column( label = 'Object'
        )->tree_template(
        )->text( text = '{OBJECT}')->get_parent( )->get_parent(
        )->tree_column( label = 'Column2'
        )->tree_template(
        )->text( text = '{COL2}')->get_parent( )->get_parent(
        )->tree_column( label = 'Column3'
        )->tree_template(
        )->text( text = '{COL3}')->get_parent( )->get_parent(
        )->tree_column( label = 'Column4'
        )->tree_template(
        )->text( text = '{COL4}').

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
