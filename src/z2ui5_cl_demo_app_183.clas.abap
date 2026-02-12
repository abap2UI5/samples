CLASS z2ui5_cl_demo_app_183 DEFINITION PUBLIC.
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
      END OF ty_row .

    DATA
      mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY .
    DATA mv_key TYPE string .
    DATA mv_sortorder TYPE string VALUE `None`.

    METHODS refresh_data .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_183 IMPLEMENTATION.

  METHOD refresh_data.

    DO 100 TIMES.
      DATA ls_row TYPE ty_row.
      ls_row-count = sy-index.
      ls_row-value = `red`.
*        info = COND #( WHEN sy-index < 50 THEN 'completed' ELSE 'uncompleted' )
      ls_row-descr = `this is a description`.
      ls_row-checkbox = abap_true.
*        percentage = COND #( WHEN sy-index <= 100 THEN sy-index ELSE '100' )
      ls_row-valuecolor = `Good`.
      INSERT ls_row INTO TABLE mt_tab.
    ENDDO.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      refresh_data( ).
    ENDIF.

    CASE client->get( )-event.
      WHEN `GET_OPENED_COL`.
        DATA(lt_arg) = client->get( )-t_event_arg.
        RETURN.
      WHEN `ONSORT`.
        lt_arg = client->get( )-t_event_arg.
      WHEN `ONGROUP`.
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
            title          = `abap2UI5 - table with column menu (press a column header)`
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

*    column menu
    lo_tab->dependents(
      )->column_menu( id         = `menu`
                      beforeopen = client->_event( val = `GET_OPENED_COL` t_arg = VALUE #( ( `$event.mParameters.openBy.getId()` ) ) )
*      )->column_menu_quick_sort( change = client->_event( val = 'ONSORT' t_arg = VALUE #( ( `${$parameters>/item.getKey}` ) ) )
*      )->column_menu_quick_sort( change = client->_event( val = 'ONSORT' t_arg = VALUE #( ( `$event` ) ) )
       )->column_menu_quick_sort( change = client->_event( `ONSORT` )
         )->items( ns = `columnmenu`
           )->column_menu_quick_sort_item( sortorder = client->_bind_edit( mv_sortorder )
       )->get_parent( )->get_parent( )->get_parent(
       )->column_menu_quick_group( change = client->_event( `ONGROUP` )
         )->items( ns = `columnmenu`
           )->column_menu_quick_group_item(
       )->get_parent( )->get_parent( )->get_parent(
       )->items( ns = `columnmenu`
         )->column_menu_action_item( icon  = `sap-icon://sort`
                                     label = `Sort`
                                     press = client->_event( `ONSORTACTIONITEM` ) )->get_parent(
         )->column_menu_action_item( icon  = `sap-icon://group-2`
                                     label = `Group`
                                     press = client->_event( `ONSGROUPACTIONITEM` ) )->get_parent(
         )->column_menu_action_item( icon  = `sap-icon://filter`
                                     label = `Filter`
                                     press = client->_event( `ONSFILTERACTIONITEM` ) )->get_parent(
         )->column_menu_action_item( icon  = `sap-icon://table-column`
                                     label = `Columns`
                                     press = client->_event( `ONSCOLUMNSACTIONITEM` ) ).

    lo_tab->columns(
        )->column( headermenu = `menu`
                   id         = `color_col`
            )->text( `Color` )->get_parent(
        )->column( headermenu = `menu`
                   id         = `info_col`
            )->text( `Info` )->get_parent(
        )->column( headermenu = `menu`
                   id         = `description_col`
            )->text( `Description` )->get_parent(
        )->column( headermenu = `menu`
                   id         = `checkbox_col`
            )->text( `Checkbox` )->get_parent(
        )->column( headermenu = `menu`
                   id         = `counter_col`
            )->text( `Counter` )->get_parent(
        )->column( headermenu = `menu`
                   id         = `chart_col`
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
