CLASS z2ui5_cl_demo_app_144 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        title TYPE string,
        value TYPE string,
      END OF ty_row .

    DATA mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY .

    DATA mo_client TYPE REF TO z2ui5_if_client.
    METHODS set_view.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_144 IMPLEMENTATION.

  METHOD set_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
        )->page(
                title          = `abap2UI5 - Binding Cell Level`
                navbuttonpress = mo_client->_event_nav_app_leave( )
                shownavbutton  = mo_client->check_app_prev_stack( ) ).

    LOOP AT mt_tab REFERENCE INTO DATA(lr_row).
      DATA(lv_tabix) = sy-tabix.
      lo_page->input( value = mo_client->_bind_edit( val = lr_row->title tab = mt_tab tab_index = lv_tabix ) ).
      lo_page->input( value = mo_client->_bind_edit( val = lr_row->value tab = mt_tab tab_index = lv_tabix ) ).
    ENDLOOP.

    DATA(lo_tab) = lo_page->table(
            items = mo_client->_bind_edit( mt_tab )
            mode  = `MultiSelect`
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( `title of the table`
        )->get_parent( )->get_parent(
      )->columns(
        )->column( )->text( `Title` )->get_parent(
        )->column( )->text( `Value` )->get_parent( )->get_parent(
      )->items( )->column_list_item( selected = `{SELKZ}`
      )->cells(
          )->input( value = `{TITLE}`
          )->input( value = `{VALUE}` ).

    lo_page->input( value = mo_client->_bind_edit( val = mt_tab[ 1 ]-title tab = mt_tab tab_index = 1 ) ).
    lo_page->input( value = mo_client->_bind_edit( val = mt_tab[ 1 ]-value tab = mt_tab tab_index = 1 ) ).
    lo_page->input( value = mo_client->_bind_edit( val = mt_tab[ 2 ]-title tab = mt_tab tab_index = 2 ) ).
    lo_page->input( value = mo_client->_bind_edit( val = mt_tab[ 2 ]-value tab = mt_tab tab_index = 2 ) ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      DO 1 TIMES.
        mt_tab = VALUE #( BASE mt_tab
            ( title = `entry 01`  value = `red` )
            ( title = `entry 02`  value = `blue` ) ).
      ENDDO.
      set_view( ).
    ENDIF.
    mo_client->view_model_update( ).
  ENDMETHOD.
ENDCLASS.
