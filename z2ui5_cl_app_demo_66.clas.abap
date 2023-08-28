class Z2UI5_CL_APP_DEMO_66 definition
  public
  final
  create public .

public section.

  interfaces IF_SERIALIZABLE_OBJECT .
  interfaces Z2UI5_IF_APP .

  types:
    BEGIN OF ts_tree_row_base,
             object TYPE string,
             col2   TYPE string,
             col3   TYPE string,
             col4   TYPE string,
           END OF ts_tree_row_base .
  types:
    BEGIN OF ts_tree_level3.
             INCLUDE TYPE ts_tree_row_base.
    TYPES END OF ts_tree_level3 .
  types:
    tt_tree_level3 TYPE STANDARD TABLE OF ts_tree_level3 WITH KEY object .
  types:
    BEGIN OF ts_tree_level2.
             INCLUDE TYPE ts_tree_row_base.
    TYPES   categories TYPE tt_tree_level3.
    TYPES END OF ts_tree_level2 .
  types:
    tt_tree_level2 TYPE STANDARD TABLE OF ts_tree_level2 WITH KEY object .
  types:
    BEGIN OF ts_tree_level1.
             INCLUDE TYPE ts_tree_row_base.
    TYPES   categories TYPE tt_tree_level2.
    TYPES END OF ts_tree_level1 .
  types:
    tt_tree_level1 TYPE STANDARD TABLE OF ts_tree_level1 WITH KEY object .

  data MT_TREE type TT_TREE_LEVEL1 .
  data CHECK_INITIALIZED type ABAP_BOOL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_APP_DEMO_66 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

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
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack ) ).
    ENDCASE.

    DATA(lr_view) = z2ui5_cl_xml_view=>factory( client ).

* ---------- Set dynamic page ---------------------------------------------------------------------
    DATA(lr_dyn_page) =  lr_view->dynamic_page(
        showfooter = abap_false
       "  headerExpanded = abap_true
      "   toggleHeaderOnTitleClick = client->_event( 'ON_TITLE' )
     ).

* ---------- Get header title ---------------------------------------------------------------------
    DATA(lr_header_title) = lr_dyn_page->title( ns = 'f' )->get( )->dynamic_page_title( ).

* ---------- Set header title text ----------------------------------------------------------------
    lr_header_title->heading( ns = 'f' )->title( 'Flexible Column Layout' ).

* ---------- Get page content area ----------------------------------------------------------------
    DATA(lr_content) = lr_dyn_page->content( ns = 'f' ).

* ---------- Get Flex page layout -----------------------------------------------------------------
    DATA(lr_flex_page) = lr_content->flexible_column_layout( layout = 'TwoColumnsBeginExpanded' ).

* ---------- Get master page ----------------------------------------------------------------------
    DATA(lr_master_page) = lr_flex_page->begin_column_pages( ).

* ---------- Get detail page ----------------------------------------------------------------------
* ---------- use property (n = `id` v = `test`) inside  mid_column_pages( ). ----------------------
    DATA(lr_detail_page) = lr_flex_page->mid_column_pages( ).

* ---------- Set tree to master page --------------------------------------------------------------
    client->_bind( mt_tree ).
    DATA(tab) = lr_master_page->tree_table(
      rows = `{path:'/MT_TREE', parameters: {arrayNames:['CATEGORIES']}}` ).
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


* ---------- Set detail view ----------------------------------------------------------------------
    DATA(lo_view_nested) = z2ui5_cl_xml_view=>factory( client
          )->page( title = `Nested View`
              )->button( text = 'event' press = client->_event( 'TEST' ) ).

* ---------- Set views ----------------------------------------------------------------------------
    client->view_display( lr_view->stringify( ) ).
    client->view_display_nested( val = lo_view_nested->stringify( ) id = `test` ).
  ENDMETHOD.
ENDCLASS.
