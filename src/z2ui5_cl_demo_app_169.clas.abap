CLASS z2ui5_cl_demo_app_169 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_169 IMPLEMENTATION.

  METHOD set_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
                title          = 'abap2UI5 - JSON Export ITAB'
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

    DATA(tab) = page->table(
            items = client->_bind_edit( t_tab )
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( 'title of the table'
                )->toolbar_spacer(
                )->button(
                    icon  = 'sap-icon://download'
                    text  = `JSON Export`
                    press = client->_event( 'EXPORT' )
        )->get_parent( )->get_parent( ).

    tab->columns(
        )->column(
            )->text( 'Title' )->get_parent(
        )->column(
            )->text( 'Color' )->get_parent(
        )->column(
            )->text( 'Info' )->get_parent(
        )->column(
            )->text( 'Description' ).

    tab->items( )->column_list_item(
      )->cells(
          )->input( value = '{TITLE}'
          )->input( value = '{VALUE}'
          )->input( value = '{INFO}'
          )->input( value = '{DESCR}' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      check_editable_active = abap_false.
      t_tab = VALUE #(
          ( title = 'entry 01'  value = 'red'    info = 'completed'  descr = 'this is a description' checkbox = abap_true )
          ( title = 'entry 02'  value = 'blue'   info = 'completed'  descr = 'this is a description' checkbox = abap_true )
          ( title = 'entry 03'  value = 'green'  info = 'completed'  descr = 'this is a description' checkbox = abap_true )
          ( title = 'entry 04'  value = 'orange' info = 'completed'  descr = '' checkbox = abap_true )
          ( title = 'entry 05'  value = 'grey'   info = 'completed'  descr = 'this is a description' checkbox = abap_true )
          ( )
          ).

      set_view(  ).

    ENDIF.


    CASE client->get( )-event.

      WHEN 'EXPORT'.
        client->nav_app_call( z2ui5_cl_popup_itab_json_dl=>factory( t_tab ) ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
