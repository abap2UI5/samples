CLASS z2ui5_cl_demo_app_069 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_t_tree3,
        is_selected TYPE abap_bool,
        text        TYPE string,
      END OF ty_t_tree3,
      BEGIN OF ty_t_tree2,
        is_selected TYPE abap_bool,
        text        TYPE string,
        nodes       TYPE STANDARD TABLE OF ty_t_tree3 WITH DEFAULT KEY,
      END OF ty_t_tree2,
      BEGIN OF ty_t_tree1,
        is_selected TYPE abap_bool,
        text        TYPE string,
        nodes       TYPE STANDARD TABLE OF ty_t_tree2 WITH DEFAULT KEY,
      END OF ty_t_tree1,
      ty_t_tree TYPE STANDARD TABLE OF ty_t_tree1 WITH DEFAULT KEY.

    DATA mt_tree TYPE ty_t_tree.
    DATA mv_check_enabled_01 TYPE abap_bool VALUE abap_true.
    DATA mv_check_enabled_02 TYPE abap_bool.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display_master.
    METHODS view_display_app_01.
    METHODS view_display_app_02.

  PRIVATE SECTION.

ENDCLASS.



CLASS z2ui5_cl_demo_app_069 IMPLEMENTATION.


  METHOD view_display_app_01.

    DATA lo_view_nested TYPE REF TO z2ui5_cl_xml_view.
    lo_view_nested = z2ui5_cl_xml_view=>factory( ).
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = lo_view_nested->page( title = `APP_01` ).

    page->button( text  = 'Update this view'
                  press = client->_event( 'UPDATE_DETAIL' ) ).

    client->nest_view_display(
      val            = lo_view_nested->stringify( )
      id             = `test`
      method_insert  = 'addMidColumnPage'
      method_destroy = 'removeAllMidColumnPages' ).

  ENDMETHOD.


  METHOD view_display_app_02.

    DATA lo_view_nested TYPE REF TO z2ui5_cl_xml_view.
    lo_view_nested = z2ui5_cl_xml_view=>factory( ).
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = lo_view_nested->page( title = `APP_02` ).

    page->button( text  = 'Update this view'
                  press = client->_event( 'UPDATE_DETAIL' )
      )->input( ).

    page->button(
          text    = 'button 01'
          press   = client->_event( `NEST_TEST` )
          enabled = client->_bind( mv_check_enabled_01 ) ).

    page->button(
          text    = 'button 01'
          press   = client->_event( `NEST_TEST` )
          enabled = client->_bind( mv_check_enabled_01 ) ).

    page->button(
        text    = 'button 02'
        press   = client->_event( `NEST_TEST` )
        enabled = client->_bind( mv_check_enabled_02 ) ).

    client->nest_view_display(
      val            = lo_view_nested->stringify( )
      id             = `test`
      method_insert  = 'addMidColumnPage'
      method_destroy = 'removeAllMidColumnPages' ).

  ENDMETHOD.


  METHOD view_display_master.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = view->shell( )->page(
          title          = 'abap2UI5 - Master-Detail View with Nested Views'
          navbuttonpress = client->_event( 'BACK' )
          shownavbutton  = abap_true ).

    DATA lr_master TYPE REF TO z2ui5_cl_xml_view.
    lr_master = page->flexible_column_layout( layout = 'TwoColumnsBeginExpanded'
                                                    id     ='test' )->begin_column_pages( ).

    DATA temp1 TYPE string_table.
    CLEAR temp1.
    INSERT `${TEXT}` INTO TABLE temp1.
    lr_master->tree( items = client->_bind( mt_tree ) )->items(
        )->standard_tree_item(
            type  = 'Active'
            title = '{TEXT}'
            press = client->_event( val = `EVENT_ITEM`
                t_arg = temp1
                 ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      DATA temp3 TYPE z2ui5_cl_demo_app_069=>ty_t_tree.
      CLEAR temp3.
      DATA temp4 LIKE LINE OF temp3.
      temp4-text = 'Apps'.
      DATA temp1 TYPE z2ui5_cl_demo_app_069=>ty_t_tree1-nodes.
      CLEAR temp1.
      DATA temp2 LIKE LINE OF temp1.
      temp2-text = 'Frontend'.
      DATA temp7 TYPE z2ui5_cl_demo_app_069=>ty_t_tree2-nodes.
      CLEAR temp7.
      DATA temp8 LIKE LINE OF temp7.
      temp8-text = 'App_001'.
      INSERT temp8 INTO TABLE temp7.
      temp8-text = 'App_002'.
      INSERT temp8 INTO TABLE temp7.
      temp2-nodes = temp7.
      INSERT temp2 INTO TABLE temp1.
      temp4-nodes = temp1.
      INSERT temp4 INTO TABLE temp3.
      temp4-text = 'Configuration'.
      DATA temp5 TYPE z2ui5_cl_demo_app_069=>ty_t_tree1-nodes.
      CLEAR temp5.
      DATA temp6 LIKE LINE OF temp5.
      temp6-text = 'User Interface'.
      DATA temp9 TYPE z2ui5_cl_demo_app_069=>ty_t_tree2-nodes.
      CLEAR temp9.
      DATA temp10 LIKE LINE OF temp9.
      temp10-text = 'Theme'.
      INSERT temp10 INTO TABLE temp9.
      temp10-text = 'Library'.
      INSERT temp10 INTO TABLE temp9.
      temp6-nodes = temp9.
      INSERT temp6 INTO TABLE temp5.
      temp6-text = 'Database'.
      DATA temp11 TYPE z2ui5_cl_demo_app_069=>ty_t_tree2-nodes.
      CLEAR temp11.
      DATA temp12 LIKE LINE OF temp11.
      temp12-text = 'HANA'.
      INSERT temp12 INTO TABLE temp11.
      temp12-text = 'ANY DB'.
      INSERT temp12 INTO TABLE temp11.
      temp6-nodes = temp11.
      INSERT temp6 INTO TABLE temp5.
      temp4-nodes = temp5.
      INSERT temp4 INTO TABLE temp3.
      mt_tree = temp3.

      view_display_master( ).

    ENDIF.

    CASE client->get( )-event.

      WHEN `UPDATE_DETAIL`.
        view_display_app_01( ).

      WHEN `EVENT_ITEM`.
        CASE client->get_event_arg( 1 ).
          WHEN 'App_001'.
            view_display_app_01( ).
          WHEN 'App_002'.
            view_display_app_02( ).
        ENDCASE.

      WHEN `NEST_TEST`.
        DATA temp13 TYPE xsdboolean.
        temp13 = boolc( mv_check_enabled_01 = abap_false ).
        mv_check_enabled_01 = temp13.
        DATA temp14 TYPE xsdboolean.
        temp14 = boolc( mv_check_enabled_01 = abap_false ).
        mv_check_enabled_02 = temp14.

        client->nest_view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
