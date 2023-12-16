CLASS z2ui5_cl_demo_app_144 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        selkz    TYPE abap_bool,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        editable TYPE abap_bool,
        checkbox TYPE abap_bool,
      END OF ty_row.

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA check_editable_active TYPE abap_bool.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS set_view.
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
                    text = 'Demo' target = '_blank'
                    href = 'https://twitter.com/abap2UI5/status/1630240894581608448'
                )->link(
                    text = 'Source_Code' target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->get_parent( ).

    page->input( value = client->_bind_edit( val = t_tab[ 1 ]-title tab = t_tab tab_index = 1 ) ).
    page->input( value = client->_bind_edit( val = t_tab[ 2 ]-title tab = t_tab tab_index = 2 ) ).

    DATA(tab) = page->table(
            items = client->_bind_edit( t_tab )
            mode  = 'MultiSelect'
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( 'title of the table'
                )->toolbar_spacer(
                )->button(
                    icon  = 'sap-icon://delete'
                    text  = 'delete selected row'
                    press = client->_event( 'BUTTON_DELETE' )
                )->button(
                    icon  = 'sap-icon://add'
                    text  = 'add'
                    press = client->_event( 'BUTTON_ADD' )
                )->button(
                    icon  = 'sap-icon://edit'
                    text  = SWITCH #( check_editable_active WHEN abap_true THEN |display| ELSE |edit| )
                    press = client->_event( 'BUTTON_EDIT' )
        )->get_parent( )->get_parent( ).

    tab->columns(
        )->column(
            )->text( 'Title' )->get_parent(
        )->column(
            )->text( 'Color' )->get_parent(
        )->column(
            )->text( 'Info' )->get_parent(
        )->column(
            )->text( 'Description' )->get_parent(
        )->column(
            )->text( 'Checkbox' ).

    tab->items( )->column_list_item( selected = '{SELKZ}'
      )->cells(
          )->input( value = '{TITLE}' enabled = `{EDITABLE}`
          )->input( value = '{VALUE}' enabled = `{EDITABLE}`
          )->input( value = '{INFO}' enabled = `{EDITABLE}`
          )->input( value = '{DESCR}' enabled = `{EDITABLE}`
          )->checkbox( selected = '{CHECKBOX}' enabled = `{EDITABLE}` ).


    LOOP AT t_tab REFERENCE INTO DATA(lr_row).
      DATA(lv_tabix) = sy-tabix.
      page->input( value = client->_bind_edit( val = lr_row->title tab = t_tab tab_index = lv_tabix ) ).
    ENDLOOP.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      check_editable_active = abap_false.
      DO 1 TIMES.
        t_tab = VALUE #( BASE t_tab
            ( title = 'entry 01'  value = 'red'    info = 'completed'  descr = 'this is a description' checkbox = abap_true )
            ( title = 'entry 02'  value = 'blue'   info = 'completed'  descr = 'this is a description' checkbox = abap_true )
            ( title = 'entry 03'  value = 'green'  info = 'completed'  descr = 'this is a description' checkbox = abap_true )
            ( title = 'entry 04'  value = 'orange' info = 'completed'  descr = 'this is a description' checkbox = abap_true )
            ( title = 'entry 05'  value = 'grey'   info = 'completed'  descr = 'this is a description' checkbox = abap_true ) ).
      ENDDO.

      set_view(  ).

    ENDIF.


    CASE client->get( )-event.

      WHEN 'BUTTON_EDIT'.
        check_editable_active = xsdbool( check_editable_active = abap_false ).
        LOOP AT t_tab REFERENCE INTO DATA(lr_tab).
          lr_tab->editable = check_editable_active.
        ENDLOOP.


      WHEN 'BUTTON_DELETE'.
        DELETE t_tab WHERE selkz = abap_true.

      WHEN 'BUTTON_ADD'.
        INSERT VALUE #( ) INTO TABLE t_tab.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

    client->view_model_update( ).

  ENDMETHOD.
ENDCLASS.
