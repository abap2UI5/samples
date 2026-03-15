CLASS z2ui5_cl_demo_app_006 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        count      TYPE i,
        value      TYPE string,
        descr      TYPE string,
        icon       TYPE string,
        info       TYPE string,
        checkbox   TYPE abap_bool,
        percentage TYPE p LENGTH 5 DECIMALS 2,
        valuecolor TYPE string,
      END OF ty_s_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    DATA check_ui5 TYPE abap_bool.
    DATA key       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS refresh_data.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_006 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    refresh_data( ).
    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `SORT_ASCENDING`.
        SORT t_tab BY count ASCENDING.
        client->message_toast_display( `sort ascending` ).
      WHEN `SORT_DESCENDING`.
        SORT t_tab BY count DESCENDING.
        client->message_toast_display( `sort descending` ).
    ENDCASE.

    view_display( ).

  ENDMETHOD.


  METHOD refresh_data.

    t_tab = VALUE #( FOR i = 1 UNTIL i > 10000 (
        count      = i
        value      = `red`
        descr      = `this is a description`
        checkbox   = abap_true
        valuecolor = `Good` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Scroll Container with Table and Toolbar`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    DATA(tab) = page->scroll_container(
        height   = `70%`
        vertical = abap_true
        )->table(
            growing             = abap_true
            growingthreshold    = `20`
            growingscrolltoload = abap_true
            items               = client->_bind_edit( t_tab )
            sticky              = `ColumnHeaders,HeaderToolbar` ).

    tab->header_toolbar(
        )->toolbar(
            )->title( `title of the table`
            )->button(
                text  = `letf side button`
                icon  = `sap-icon://account`
                press = client->_event( `BUTTON_SORT` )
            )->segmented_button( key
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

    tab->columns(
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

    tab->items(
        )->column_list_item(
            )->cells(
                )->text( `{VALUE}`
                )->text( `{INFO}`
                )->text( `{DESCR}`
                )->checkbox(
                    selected = `{CHECKBOX}`
                    enabled  = abap_false
                )->text( `{COUNT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
