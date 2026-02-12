CLASS z2ui5_cl_demo_app_006 DEFINITION PUBLIC.

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

    DATA mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA mv_key TYPE string.
    METHODS refresh_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_006 IMPLEMENTATION.

  METHOD refresh_data.

    DO 10000 TIMES.
      DATA ls_row TYPE ty_row.
      ls_row-count = sy-index.
      ls_row-value = `red`.
      ls_row-descr = `this is a description`.
      ls_row-checkbox = abap_true.
      ls_row-valuecolor = `Good`.
      INSERT ls_row INTO TABLE mt_tab.
    ENDDO.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      refresh_data( ).
    ENDIF.

    CASE client->get( )-event.
      WHEN `SORT_ASCENDING`.
        SORT mt_tab BY count ASCENDING.
        client->message_toast_display( `sort ascending` ).
      WHEN `SORT_DESCENDING`.
        SORT mt_tab BY count DESCENDING.
        client->message_toast_display( `sort descending` ).
    ENDCASE.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
        )->page(
            title          = `abap2UI5 - Scroll Container with Table and Toolbar`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(lo_tab) = lo_page->scroll_container( height   = `70%`
                                        vertical = abap_true
        )->table(
            growing             = abap_true
            growingthreshold    = `20`
            growingscrolltoload = abap_true
            items               = client->_bind_edit( mt_tab )
            sticky              = `ColumnHeaders,HeaderToolbar` ).

    lo_tab->header_toolbar(
        )->toolbar(
            )->title( `title of the table`
            )->button(
                text  = `letf side button`
                icon  = `sap-icon://account`
                press = client->_event( `BUTTON_SORT` )
            )->segmented_button( selected_key = mv_key
                )->items(
                    )->segmented_button_item(
                        key  = `BLUE`
                        icon = `sap-icon://accept`
                        text = `blue`
                    )->segmented_button_item(
                        key  = `GREEN`
                        icon = `sap-icon://add-favorite`
                        text = `green`
            )->get_parent( )->get_parent(
            )->toolbar_spacer(
            )->button(
                icon  = `sap-icon://sort-descending`
                press = client->_event( `SORT_DESCENDING` )
            )->button(
                icon  = `sap-icon://sort-ascending`
                press = client->_event( `SORT_ASCENDING` ) ).

    lo_tab->columns(
        )->column(
            )->text( `Color` )->get_parent(
        )->column(
            )->text( `Info` )->get_parent(
        )->column(
            )->text( `Description` )->get_parent(
        )->column(
            )->text( `Checkbox` )->get_parent(
        )->column(
            )->text( `Counter` )->get_parent(
        )->column(
            )->text( `Radial Micro Chart` ).

    lo_tab->items( )->column_list_item( )->cells(
       )->text( `{VALUE}`
       )->text( `{INFO}`
       )->text( `{DESCR}`
       )->checkbox( selected = `{CHECKBOX}`
                    enabled  = abap_false
       )->text( `{COUNT}` ).

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
