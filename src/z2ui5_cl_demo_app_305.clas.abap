CLASS z2ui5_cl_demo_app_305 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_row,
        title TYPE string,
        value TYPE string,
      END OF ty_row .

    DATA:
      t_tab             TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY,
      check_initialized TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS set_view.

ENDCLASS.


CLASS z2ui5_cl_demo_app_305 IMPLEMENTATION.

  METHOD set_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
                title          = 'abap2UI5 - Tables and cell colors'
                navbuttonpress = client->_event( 'BACK' )
                  shownavbutton = abap_true ).

    page->_generic(
        name   = `style`
        ns     = `html`
    )->_cc_plain_xml(
        `td:has([data-color="red"]){ `
     && `    background-color: red;`
     && `}`
     && ``
     && `td:has([data-color="green"]){`
     && `    background-color: green;`
     && `}`
     && ``
     && `td:has([data-color="blue"]){`
     && `    background-color: blue;`
     && `}`
     && ``
     && `td:has([data-color="orange"]){`
     && `    background-color: orange;`
     && `}`
     && ``
     && `td:has([data-color="grey"]){`
     && `    background-color: grey;`
     && `}`
     && ``
     && `td:has([data-color="yellow"]){`
     && `    background-color: yellow;`
     && `}`
    ).

    DATA(tab) = page->table(
            items = client->_bind_edit( t_tab )
            mode  = 'MultiSelect'
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( 'change cell color'
        )->get_parent( )->get_parent( ).

    tab->columns(
        )->column(
            )->text( 'Title' )->get_parent(
        )->column(
            )->text( 'Color' )->get_parent( ).

    tab->items( )->column_list_item(
      )->cells(
          )->text( text = '{TITLE}'
              )->get(
              )->custom_data(
              )->core_custom_data( key = 'color' value = '{VALUE}' writetodom = abap_true
              )->get_parent(
              )->get_parent(
          )->input( value = '{VALUE}' enabled = abap_true ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      t_tab = VALUE #(
          ( title = 'entry 01'  value = 'red'    )
          ( title = 'entry 02'  value = 'blue'   )
          ( title = 'entry 03'  value = 'green'  )
          ( title = 'entry 04'  value = 'yellow' )
          ( title = 'entry 05'  value = 'orange' )
          ( title = 'entry 06'  value = 'grey'   ) ).

      set_view( ).
      RETURN.

    ENDIF.


    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
