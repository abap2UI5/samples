CLASS z2ui5_cl_demo_app_087 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        count      TYPE i,
        value      TYPE string,
        descr      TYPE string,
        icon       TYPE string,
        info       TYPE string,
        checkbox   TYPE abap_bool,
        percentage TYPE p LENGTH 5 DECIMALS 2,
        valuecolor TYPE string,
      END OF ty_row.

    DATA t_tab             TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA check_initialized TYPE abap_bool.
    DATA check_ui5         TYPE abap_bool.
    DATA mv_key            TYPE string.

    METHODS refresh_data.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_087 IMPLEMENTATION.

  METHOD refresh_data.

    DO 100 TIMES.
      DATA ls_row TYPE ty_row.
      ls_row-count      = sy-index.
      ls_row-value      = 'red'.
*        info = COND #( WHEN sy-index < 50 THEN 'completed' ELSE 'uncompleted' )
      ls_row-descr      = 'this is a description'.
      ls_row-checkbox   = abap_true.
*        percentage = COND #( WHEN sy-index <= 100 THEN sy-index ELSE '100' )
      ls_row-valuecolor = `Good`.
      INSERT ls_row INTO TABLE t_tab.
    ENDDO.

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      refresh_data( ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'SORT_ASCENDING'.
        SORT t_tab BY count ASCENDING.
        client->message_toast_display( 'sort ascending' ).

      WHEN 'SORT_DESCENDING'.
        SORT t_tab BY count DESCENDING.
        client->message_toast_display( 'sort descending' ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page( title          = 'abap2UI5 - Table with Cell Copy'
                 navbuttonpress = client->_event( 'BACK' )
                 shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
        ).

    DATA(tab) = page->table( growing             = abap_true
                             growingthreshold    = '20'
                             growingscrolltoload = abap_true
                             items               = client->_bind_edit( t_tab )
                             sticky              = 'ColumnHeaders,HeaderToolbar' ).

    tab->header_toolbar(
        )->toolbar(
            )->title( 'title of the table'
            )->button( text  = 'letf side button'
                       icon  = 'sap-icon://account'
                       press = client->_event( 'BUTTON_SORT' )
            )->toolbar_spacer(
            )->button( icon  = 'sap-icon://sort-descending'
                       press = client->_event( 'SORT_DESCENDING' )
            )->button( icon  = 'sap-icon://sort-ascending'
                       press = client->_event( 'SORT_ASCENDING' )
        ).

    tab->columns(
        )->column(
            )->text( 'Color' )->get_parent(
        )->column(
            )->text( 'Info' )->get_parent(
        )->column(
            )->text( 'Description' )->get_parent(
        )->column(
            )->text( 'Checkbox' )->get_parent(
        )->column(
            )->text( 'Counter' )->get_parent(
        )->column(
            )->text( 'Radial Micro Chart' ).

    tab->items( )->column_list_item( )->cells(
       )->text( '{VALUE}'
       )->text( '{INFO}'
       )->text( '{DESCR}'
       )->checkbox( selected = '{CHECKBOX}'
                    enabled  = abap_false
       )->text( '{COUNT}'
        ).

    tab->dependents(
*        )->p_cell_selector( id     = `cellSelector`
*        )->p_copy_provider(
*      EXPORTING
*         id           = `copyProvider`
*        extract_data  =  `.eB('test', 'test3')`
*        copy          = `.eB`
    ).
*      EXPORTING
*
*      RECEIVING
*        result =
    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
