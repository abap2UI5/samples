CLASS z2ui5_cl_demo_app_118 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES: BEGIN OF s_row,
             id    TYPE i,
             descr TYPE string,
             adate TYPE d,
             atime TYPE t,
           END OF s_row.
    TYPES: t_rows TYPE STANDARD TABLE OF s_row WITH EMPTY KEY.

    DATA: problematic_rows TYPE t_rows.
    DATA: these_are_fine_rows TYPE t_rows.

    DATA: check_initialized TYPE abap_bool.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_118 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      problematic_rows = VALUE #(
        ( id = 1 descr = 'filled with the actual date and time in correct format' adate = sy-datum atime = sy-uzeit )
        ( id = 2 descr = 'correct init values' adate = '00000000' atime = '000000' )
        ( id = 3 descr = 'correct init values by ignoring'  )
        ( id = 4 descr = 'filling with a zero leads to a correct init value' adate = 0 atime = 0  )
        ( id = 5 descr = 'this raises an exception now' adate = ''  atime = '' )
        ( id = 6 descr = 'Fifth row' adate = sy-datum atime = sy-uzeit )
      ).

      these_are_fine_rows = VALUE #(
        ( id = 1 descr = 'First row' adate = sy-datum atime = sy-uzeit )
        ( id = 2 descr = 'Second row' adate = 0 atime = 0 )
        ( id = 3 descr = 'Third row' adate = 0 atime = 0 )
        ( id = 4 descr = 'Fourth row' adate = 0 atime = 0 )
        ( id = 5 descr = 'Fifth row' adate = sy-datum atime = sy-uzeit )
      ).

    ENDIF.


    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->_z2ui5( )->title( 'ABAP2UI5 Weird behavior showcase' )->shell(
        )->page(
            title          = 'ABAP2UI5 Weird behavior showcase'
            navbuttonpress = client->_event( 'BACK' )
            showheader     = abap_true ).

    DATA(tab_ko) = page->table(
                        mode = 'MultiSelect'
                        items = client->_bind_edit( problematic_rows ) ).

    tab_ko->header_toolbar(
            )->toolbar(
                )->title( |This table has the weird behavior|
                )->toolbar_spacer(
                )->button(
                    text = |Go|
                    icon = 'sap-icon://blur'
                    press = client->_event( 'ON_BTN_GO' ) ).

    tab_ko->columns(
            )->column(  )->text( 'ID' )->get_parent(
            )->column( )->text( 'Description' )->get_parent(
            )->column( )->text( 'Date ' )->get_parent(
            )->column( )->text( 'Time' ).

    tab_ko->items(
         )->column_list_item(
             )->cells(
                 )->object_identifier( title = '{ID}' )->get_parent(
                 )->text( '{DESCR}'
                 )->text( '{ADATE}'
                 )->text( '{ATIME}' ).


    DATA(tab_ok) = page->table(
                        mode = 'MultiSelect'
                        items = client->_bind_edit( these_are_fine_rows ) ).

    tab_ok->header_toolbar(
            )->toolbar(
                )->title( |This table is fine| ).

    tab_ok->columns(
            )->column(  )->text( 'ID' )->get_parent(
            )->column( )->text( 'Description' )->get_parent(
            )->column( )->text( 'Date ' )->get_parent(
            )->column( )->text( 'Time' ).

    tab_ok->items(
         )->column_list_item(
             )->cells(
                 )->object_identifier( title = '{ID}' )->get_parent(
                 )->text( '{DESCR}'
                 )->text( '{ADATE}'
                 )->text( '{ATIME}' ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
