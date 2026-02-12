CLASS z2ui5_cl_demo_app_305 DEFINITION PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.
    TYPES:
      BEGIN OF ty_row,
        title TYPE string,
        value TYPE string,
      END OF ty_row.
    DATA mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA mo_client TYPE REF TO z2ui5_if_client.
    METHODS set_view.

ENDCLASS.

CLASS z2ui5_cl_demo_app_305 IMPLEMENTATION.

  METHOD set_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
                    )->page(
                      title          = `abap2UI5 - Tables and cell colors`
                      navbuttonpress = mo_client->_event_nav_app_leave( )
                      shownavbutton  = mo_client->check_app_prev_stack( ) ).

    lo_page->_generic(
            name = `style`
            ns   = `html`
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
        && `}` ).

    DATA(lo_tab) = lo_page->table(
            items = mo_client->_bind_edit( mt_tab )
            mode  = `MultiSelect`
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( `change cell color`
        )->get_parent( )->get_parent( ).

    lo_tab->columns(
        )->column(
            )->text( `Title` )->get_parent(
        )->column(
            )->text( `Color` )->get_parent( ).

    lo_tab->items( )->column_list_item(
      )->cells(
        )->text( text = `{TITLE}`
          )->get(
            )->custom_data(
              )->core_custom_data( key        = `color`
                                   value      = `{VALUE}`
                                   writetodom = abap_true
            )->get_parent(
          )->get_parent(
        )->input( value   = `{VALUE}`
                  enabled = abap_true ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      mt_tab = VALUE #(
          ( title = `entry 01`  value = `red` )
          ( title = `entry 02`  value = `blue` )
          ( title = `entry 03`  value = `green` )
          ( title = `entry 04`  value = `yellow` )
          ( title = `entry 05`  value = `orange` )
          ( title = `entry 06`  value = `grey` ) ).

      set_view( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
