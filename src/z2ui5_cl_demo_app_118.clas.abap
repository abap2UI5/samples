CLASS z2ui5_cl_demo_app_118 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF s_row,
             id    TYPE i,
             descr TYPE string,
             adate TYPE d,
             atime TYPE t,
           END OF s_row.
    TYPES t_rows TYPE STANDARD TABLE OF s_row WITH EMPTY KEY.

    DATA mv_problematic_rows TYPE t_rows.
    DATA mv_these_are_fine_rows TYPE t_rows.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_118 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      mv_problematic_rows = VALUE #(
        ( id = 1 descr = `filled with the actual date and time in correct format` adate = sy-datum atime = sy-uzeit )
        ( id = 2 descr = `correct init values` adate = `00000000` atime = `000000` )
        ( id = 3 descr = `correct init values by ignoring` )
        ( id = 4 descr = `filling with a zero leads to a correct init value` adate = 0 atime = 0 )
        ( id = 5 descr = `this raises an exception now` adate = ``  atime = `` )
        ( id = 6 descr = `Fifth row` adate = sy-datum atime = sy-uzeit ) ).

      mv_these_are_fine_rows = VALUE #(
        ( id = 1 descr = `First row` adate = sy-datum atime = sy-uzeit )
        ( id = 2 descr = `Second row` adate = 0 atime = 0 )
        ( id = 3 descr = `Third row` adate = 0 atime = 0 )
        ( id = 4 descr = `Fourth row` adate = 0 atime = 0 )
        ( id = 5 descr = `Fifth row` adate = sy-datum atime = sy-uzeit ) ).

    ENDIF.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_page) = lo_view->_z2ui5( )->title( `ABAP2UI5 Weird behavior showcase` )->shell(
        )->page(
            title          = `ABAP2UI5 Weird behavior showcase`
            navbuttonpress = client->_event_nav_app_leave( )
            showheader     = abap_true ).

    DATA(lo_tab_ko) = lo_page->table(
                        mode  = `MultiSelect`
                        items = client->_bind_edit( mv_problematic_rows ) ).

    lo_tab_ko->header_toolbar(
            )->toolbar(
                )->title( |This table has the weird behavior|
                )->toolbar_spacer(
                )->button(
                    text  = |Go|
                    icon  = `sap-icon://blur`
                    press = client->_event( `ON_BTN_GO` ) ).

    lo_tab_ko->columns(
            )->column( )->text( `ID` )->get_parent(
            )->column( )->text( `Description` )->get_parent(
            )->column( )->text( `Date ` )->get_parent(
            )->column( )->text( `Time` ).

    lo_tab_ko->items(
         )->column_list_item(
             )->cells(
                 )->object_identifier( title = `{ID}` )->get_parent(
                 )->text( `{DESCR}`
                 )->text( `{ADATE}`
                 )->text( `{ATIME}` ).

    DATA(lo_tab_ok) = lo_page->table(
                        mode  = `MultiSelect`
                        items = client->_bind_edit( mv_these_are_fine_rows ) ).

    lo_tab_ok->header_toolbar(
            )->toolbar(
                )->title( |This table is fine| ).

    lo_tab_ok->columns(
            )->column( )->text( `ID` )->get_parent(
            )->column( )->text( `Description` )->get_parent(
            )->column( )->text( `Date ` )->get_parent(
            )->column( )->text( `Time` ).

    lo_tab_ok->items(
         )->column_list_item(
             )->cells(
                 )->object_identifier( title = `{ID}` )->get_parent(
                 )->text( `{DESCR}`
                 )->text( `{ADATE}`
                 )->text( `{ATIME}` ).

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
