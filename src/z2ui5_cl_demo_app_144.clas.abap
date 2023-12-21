CLASS z2ui5_cl_demo_app_144 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        title TYPE string,
        value TYPE string,
      END OF ty_row .

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY .
    DATA check_initialized TYPE abap_bool.
    DATA client TYPE REF TO z2ui5_if_client.
    METHODS set_view.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_144 IMPLEMENTATION.


  METHOD set_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
                title          = 'abap2UI5 - Binding Cell Level'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton = abap_true
            )->header_content(
                )->link(
                    text = 'Source_Code' target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->get_parent( ).


    LOOP AT t_tab REFERENCE INTO DATA(lr_row).
      DATA(lv_tabix) = sy-tabix.
      page->input( value = client->_bind_edit( val = lr_row->title tab = t_tab tab_index = lv_tabix ) ).
      page->input( value = client->_bind_edit( val = lr_row->value tab = t_tab tab_index = lv_tabix ) ).
    ENDLOOP.

    DATA(tab) = page->table(
            items = client->_bind_edit( t_tab )
            mode  = 'MultiSelect'
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( 'title of the table'
        )->get_parent( )->get_parent(
    )->columns(
        )->column( )->text( 'Title' )->get_parent(
        )->column( )->text( 'Value' )->get_parent( )->get_parent(
    )->items( )->column_list_item( selected = '{SELKZ}'
      )->cells(
          )->input( value = '{TITLE}'
          )->input( value = '{VALUE}' ).

    page->input( value = client->_bind_edit( val = t_tab[ 1 ]-title tab = t_tab tab_index = 1 ) ).
    page->input( value = client->_bind_edit( val = t_tab[ 1 ]-value tab = t_tab tab_index = 1 ) ).
    page->input( value = client->_bind_edit( val = t_tab[ 2 ]-title tab = t_tab tab_index = 2 ) ).
    page->input( value = client->_bind_edit( val = t_tab[ 2 ]-value tab = t_tab tab_index = 2 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      DO 1 TIMES.
        t_tab = VALUE #( BASE t_tab
            ( title = 'entry 01'  value = 'red'   )
            ( title = 'entry 02'  value = 'blue'  ) ).
      ENDDO.
      set_view(  ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

    client->view_model_update( ).

  ENDMETHOD.
ENDCLASS.
