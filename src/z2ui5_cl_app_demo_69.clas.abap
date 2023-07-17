CLASS z2ui5_cl_app_demo_69 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_t_tree3,
        is_selected TYPE abap_bool,
        text        TYPE string,
        prodh       TYPE string,
      END OF ty_t_tree3,
      BEGIN OF ty_t_tree2,
        is_selected TYPE abap_bool,
        text        TYPE string,
        prodh       TYPE string,
        nodes       TYPE STANDARD TABLE OF ty_t_tree3 WITH DEFAULT KEY,
      END OF ty_t_tree2,
      BEGIN OF ty_t_tree1,
        is_selected TYPE abap_bool,
        text        TYPE string,
        prodh       TYPE string,
        nodes       TYPE STANDARD TABLE OF ty_t_tree2 WITH DEFAULT KEY,
      END OF ty_t_tree1,
      ty_t_tree TYPE STANDARD TABLE OF ty_t_tree1 WITH DEFAULT KEY.

    DATA mt_tree TYPE ty_t_tree.

    DATA check_initialized TYPE abap_bool .

    DATA mv_check_enabled_01 TYPE abap_bool VALUE abap_true.
    DATA mv_check_enabled_02 TYPE abap_bool.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display_master.
    METHODS view_display_detail.

  PRIVATE SECTION.

ENDCLASS.



CLASS z2ui5_cl_app_demo_69 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      mt_tree = VALUE #( ( text = 'Apps'
                    prodh = '00100'
                    nodes = VALUE #( ( text  = 'Frontend'
                                       nodes = VALUE #( ( text = 'App_001' )
                                                        ( text = 'App_002' )
                  ) ) ) )
                  ( text = 'Configuration'
                    prodh = '00110'
                    nodes = VALUE #( ( text  = 'User Interface'
                                       nodes = VALUE #( ( text = 'Theme'   )
                                                        ( text = 'Library' )
                                     ) )
                                     ( text  = 'Database'
                                       nodes = VALUE #( ( text = 'HANA'   )
                                                         ( text = 'ANY DB' )
         ) ) ) ) ).

      view_display_master(  ).

    ENDIF.

    CASE client->get( )-event.

      WHEN `UPDATE_DETAIL`.
        view_display_detail(  ).

      WHEN `EVENT_ITEM`.
        DATA(lt_arg) = client->get( )-t_event_arg.
        client->message_box_display( `event ` && lt_arg[ 1 ] ).
        view_display_detail(  ).

      WHEN `NEST_TEST`.
        mv_check_enabled_01 = xsdbool( mv_check_enabled_01 = abap_false ).
        mv_check_enabled_02 = xsdbool( mv_check_enabled_01 = abap_false ).

        client->nest_view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.


  METHOD view_display_master.

    DATA(view) = z2ui5_cl_xml_view=>factory( client ).

    DATA(page) = view->shell( )->page(
          title          = 'abap2UI5 - Partial Rendering with nested Views'
          navbuttonpress = client->_event( 'BACK' )
            shownavbutton = abap_true
          )->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code'  target = '_blank' href = view->hlp_get_source_code_url(  )
         )->get_parent( ).

    DATA(lr_master) = page->flexible_column_layout( layout = 'TwoColumnsBeginExpanded' id ='test' )->begin_column_pages( ).

    lr_master->tree( items = client->_bind( mt_tree ) )->items(
        )->standard_tree_item(
            type = 'Active'
            title = '{TEXT}' press = client->_event( val = `EVENT_ITEM`
            t_arg = VALUE #( ( `${TEXT}`  )  ) ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD view_display_detail.

    DATA(lo_view_nested) = z2ui5_cl_xml_view=>factory( client ).

    DATA(page) = lo_view_nested->page( title = `Nested View` ).

    page->button( text = 'event' press = client->_event( 'UPDATE_DETAIL' )
    )->input( ).

    page->button(
          text = 'button 01'
          press   = client->_event( `NEST_TEST` )
          enabled = client->_bind( mv_check_enabled_01 ) ).

    page->button(
        text = 'button 02'
        press   = client->_event( `NEST_TEST` )
        enabled = client->_bind( mv_check_enabled_02 )
       ).

    client->nest_view_display(
      val            = lo_view_nested->stringify( )
      id             = `test`
      method_insert  = 'addMidColumnPage'
      method_destroy = 'removeAllMidColumnPages'
    ).

  ENDMETHOD.
ENDCLASS.
