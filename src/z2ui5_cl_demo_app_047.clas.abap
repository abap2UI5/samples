CLASS z2ui5_cl_demo_app_047 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_int1    TYPE i.
    DATA mv_int2    TYPE i.
    DATA mv_int_sum TYPE i.

    DATA mv_dec1    TYPE p LENGTH 10 DECIMALS 4.
    DATA mv_dec2    TYPE p LENGTH 10 DECIMALS 4.
    DATA mv_dec_sum TYPE p LENGTH 10 DECIMALS 4.

    DATA mv_date    TYPE d.
    DATA mv_time    TYPE t.

    TYPES:
      BEGIN OF ty_s_row,
        date TYPE d,
        time TYPE t,
      END OF ty_s_row.
    DATA mt_tab TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_047 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      mv_date = sy-datum.
      mv_time = sy-uzeit.
      mv_dec1 = - 1 / 3.
      mv_dec2 = 2 / 3.

      mt_tab = VALUE #( ( date = sy-datum time = sy-uzeit ) ).
      client->_bind_edit( mt_tab ).
    ENDIF.

    CASE client->get( )-event.
      WHEN `BUTTON_INT`.
        mv_int_sum = mv_int1 + mv_int2.
      WHEN `BUTTON_DEC`.
        mv_dec_sum = mv_dec1 + mv_dec2.
    ENDCASE.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
        )->page(
                title          = `abap2UI5 - Integer and Decimals`
                navbuttonpress = client->_event_nav_app_leave( )
                shownavbutton  = client->check_app_prev_stack( ) ).
    lo_page->simple_form( title    = `Integer and Decimals`
                       editable = abap_true
             )->content( `form`
                 )->title( `Input`
                 )->label( `integer`
                 )->input( value = client->_bind_edit( mv_int1 )
                 )->input( value = client->_bind_edit( mv_int2 )
                 )->input( enabled = abap_false
                           value   = client->_bind_edit( mv_int_sum )
                 )->button( text  = `calc sum`
                            press = client->_event( `BUTTON_INT` )
                 )->label( `decimals`
                 )->input( client->_bind_edit( mv_dec1 )
                 )->input( client->_bind_edit( mv_dec2 )
                 )->input( enabled = abap_false
                           value   = client->_bind_edit( mv_dec_sum )
                 )->button( text  = `calc sum`
                            press = client->_event( `BUTTON_DEC` )
                 )->label( `date`
                 )->input( client->_bind_edit( mv_date )
                 )->label( `time`
                 )->input( client->_bind_edit( mv_time ) ).

    DATA(lo_tab) = lo_page->scroll_container( height   = `70%`
                                        vertical = abap_true
        )->table(
            growing             = abap_true
            growingthreshold    = `20`
            growingscrolltoload = abap_true
            items               = client->_bind_edit( mt_tab )
            sticky              = `ColumnHeaders,HeaderToolbar` ).

    lo_tab->columns(
        )->column(
            )->text( `Date` )->get_parent(
        )->column(
            )->text( `Time` )->get_parent( ).

    lo_tab->items( )->column_list_item( )->cells(
       )->text( `{DATE}`
       )->text( `{TIME}` ).

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
