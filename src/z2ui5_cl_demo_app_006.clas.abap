CLASS Z2UI5_CL_DEMO_APP_006 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES Z2UI5_if_app.

    TYPES:
      BEGIN OF ty_row,
        count    TYPE i,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        checkbox TYPE abap_bool,
        percentage(5) TYPE p DECIMALS 2,
        valueColor TYPE string,
      END OF ty_row.

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA check_initialized TYPE abap_bool.
    DATA mv_key TYPE string.
    METHODS refresh_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_006 IMPLEMENTATION.


  METHOD refresh_data.

    DO 5000 TIMES.
      DATA(ls_row) = VALUE ty_row( count = sy-index  value = 'red'
        info = COND #( WHEN sy-index < 50 THEN 'completed' ELSE 'uncompleted' )
        descr = 'this is a description' checkbox = abap_true
        percentage = COND #( WHEN sy-index <= 100 THEN sy-index ELSE '100' )
        valuecolor = `Good`
        ).
      INSERT ls_row INTO TABLE t_tab.
    ENDDO.

  ENDMETHOD.


  METHOD Z2UI5_if_app~main.

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

      WHEN 'BUTTON_POST'.
        client->message_box_display( 'button post was pressed' ).

      WHEN 'MENU_DEFAULT'.
        client->message_box_display( 'menu default pressed' ).

           WHEN 'MENU_01'.
        client->message_box_display( 'menu 01 pressed' ).

           WHEN 'MENU_02'.
        client->message_box_display( 'menu 02 pressed' ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

    data(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = 'abap2UI5 - Scroll Container with Table and Toolbar'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            )->header_content(
                )->link(
                    text = 'Source_Code'  target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
        )->get_parent( ).

    DATA(tab) = page->scroll_container( height = '70%' vertical = abap_true
        )->table(
            growing             = abap_true
            growingthreshold    = '20'
            growingscrolltoload = abap_true
            items               = client->_bind_edit( t_tab )
            sticky              = 'ColumnHeaders,HeaderToolbar' ).

    tab->header_toolbar(
        )->overflow_toolbar(
            )->title( 'title of the table'
            )->button(
                text  = 'letf side button'
                icon  = 'sap-icon://account'
                press = client->_event( 'BUTTON_SORT' )
            )->segmented_button( selected_key = mv_key
                )->items(
                    )->segmented_button_item(
                        key = 'BLUE'
                        icon = 'sap-icon://accept'
                        text = 'blue'
                    )->segmented_button_item(
                        key = 'GREEN'
                        icon = 'sap-icon://add-favorite'
                        text = 'green'
            )->get_parent( )->get_parent(
            )->toolbar_spacer(
            )->generic_tag(
                    arialabelledby = 'genericTagLabel'
                    text           = 'Project Cost'
                    design         = 'StatusIconHidden'
                    status         = 'Error'
                    class          = 'sapUiSmallMarginBottom'
                )->object_number(
                    state      = 'Error'
                    emphasized = 'false'
                    number     = '3.5M'
                    unit       = 'EUR'
            )->get_parent(
            )->toolbar_spacer(
            )->overflow_toolbar_toggle_button(
                icon = 'sap-icon://sort-descending'
                press = client->_event( 'SORT_DESCENDING' )
            )->overflow_toolbar_toggle_button(
                icon = 'sap-icon://sort-ascending'
                press = client->_event( 'SORT_ASCENDING' )

            )->overflow_toolbar_menu_button(
        text          = `Export`
        type          = `Transparent`
        tooltip       = `Export`
        defaultaction = client->_event( 'MENU_DEFAULT' )
        icon = `sap-icon://share`
         buttonMode  = `Split`
     )->_generic( `menu` )->_generic( `Menu`
        )->menu_item(
            press  = client->_event( 'MENU_01' )
            text   = `Export as PDF`
            icon   = `sap-icon://pdf-attachment`
      )->menu_item(
            press  = client->_event( 'MENU_02' )
            text   = `Export to Excel`
            icon   = `sap-icon://excel-attachment`
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
       )->checkbox( selected = '{CHECKBOX}' enabled = abap_false
       )->text( '{COUNT}'
       )->radial_micro_chart( size = `Responsive` height = `35px` percentage = `{PERCENTAGE}` valueColor = `{VALUECOLOR}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
