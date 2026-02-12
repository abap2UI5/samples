CLASS z2ui5_cl_demo_app_069 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

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

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS view_display_master.
    METHODS view_display_app_01.
    METHODS view_display_app_02.

  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_069 IMPLEMENTATION.

  METHOD view_display_app_01.

    DATA(lo_view_nested) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view_nested->page( title = `APP_01` ).

    lo_page->button( text  = `Update this view`
                  press = mo_client->_event( `UPDATE_DETAIL` ) ).

    mo_client->nest_view_display(
      val            = lo_view_nested->stringify( )
      id             = `test`
      method_insert  = `addMidColumnPage`
      method_destroy = `removeAllMidColumnPages` ).
  ENDMETHOD.

  METHOD view_display_app_02.

    DATA(lo_view_nested) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view_nested->page( title = `APP_02` ).

    lo_page->button( text  = `Update this view`
                  press = mo_client->_event( `UPDATE_DETAIL` )
      )->input( ).

    lo_page->button(
          text    = `button 01`
          press   = mo_client->_event( `NEST_TEST` )
          enabled = mo_client->_bind( mv_check_enabled_01 ) ).

    lo_page->button(
          text    = `button 01`
          press   = mo_client->_event( `NEST_TEST` )
          enabled = mo_client->_bind( mv_check_enabled_01 ) ).

    lo_page->button(
        text    = `button 02`
        press   = mo_client->_event( `NEST_TEST` )
        enabled = mo_client->_bind( mv_check_enabled_02 ) ).

    mo_client->nest_view_display(
      val            = lo_view_nested->stringify( )
      id             = `test`
      method_insert  = `addMidColumnPage`
      method_destroy = `removeAllMidColumnPages` ).
  ENDMETHOD.

  METHOD view_display_master.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_page) = lo_view->shell( )->page(
          title          = `abap2UI5 - Master-Detail View with Nested Views`
          navbuttonpress = mo_client->_event_nav_app_leave( )
          shownavbutton  = mo_client->check_app_prev_stack( ) ).

    DATA(lr_master) = lo_page->flexible_column_layout( layout = `TwoColumnsBeginExpanded`
                                                    id     =`test` )->begin_column_pages( ).

    lr_master->tree( items = mo_client->_bind( mt_tree ) )->items(
        )->standard_tree_item(
            type  = `Active`
            title = `{TEXT}`
            press = mo_client->_event( val = `EVENT_ITEM`
                t_arg                   = VALUE #( ( `${TEXT}` ) )
                 ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      mt_tree = VALUE #( ( text = `Apps`
                    nodes       = VALUE #( ( text = `Frontend`
                                       nodes      = VALUE #( ( text = `App_001` )
                                                        ( text = `App_002` )
                  ) ) ) )
                  ( text  = `Configuration`
                    nodes = VALUE #( ( text  = `User Interface`
                                       nodes = VALUE #( ( text = `Theme` )
                                                        ( text = `Library` )
                                     ) )
                                     ( text  = `Database`
                                       nodes = VALUE #( ( text = `HANA` )
                                                         ( text = `ANY DB` )
         ) ) ) ) ).

      view_display_master( ).

    ENDIF.

    CASE mo_client->get( )-event.
      WHEN `UPDATE_DETAIL`.
        view_display_app_01( ).
      WHEN `EVENT_ITEM`.
        CASE mo_client->get_event_arg( 1 ).
          WHEN `App_001`.
            view_display_app_01( ).
          WHEN `App_002`.
            view_display_app_02( ).
        ENDCASE.
      WHEN `NEST_TEST`.
        mv_check_enabled_01 = xsdbool( mv_check_enabled_01 = abap_false ).
        mv_check_enabled_02 = xsdbool( mv_check_enabled_01 = abap_false ).

        mo_client->nest_view_model_update( ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
