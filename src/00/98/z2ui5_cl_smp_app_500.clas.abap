CLASS z2ui5_cl_smp_app_500 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        row_id   TYPE i,
        selkz    TYPE abap_bool,
        carrid   TYPE c LENGTH 3,
        connid   TYPE n LENGTH 4,
        cityfrom TYPE c LENGTH 20,
        cityto   TYPE c LENGTH 20,
      END OF ty_row,
      ty_t_rows TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA mt_table TYPE ty_t_rows.

  PROTECTED SECTION.
    DATA client     TYPE REF TO z2ui5_if_client.
    DATA mv_next_id TYPE i.

    METHODS on_init.
    METHODS render_main.
    METHODS on_event.
    METHODS on_after_popup.
    METHODS button_delete.
    METHODS button_save.
ENDCLASS.


CLASS z2ui5_cl_smp_app_500 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      on_init( ).
      render_main( ).
    ELSEIF client->check_on_navigated( ).
      on_after_popup( ).
      render_main( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    mt_table = VALUE #(
      ( row_id = 1 carrid = 'LH'  connid = '0400' cityfrom = 'FRANKFURT' cityto = 'NEW YORK' )
      ( row_id = 2 carrid = 'UA'  connid = '0941' cityfrom = 'FRANKFURT' cityto = 'SAN FRAN' )
      ( row_id = 3 carrid = 'AA'  connid = '0017' cityfrom = 'NEW YORK'  cityto = 'SAN FRAN' ) ).
    mv_next_id = 4.

  ENDMETHOD.


  METHOD render_main.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`         v = `abap2UI5 - Table - Simple Selection`
            )->a( n = `showNavButton` b = abap_false ).

    DATA(table) = page->ele( `Table`
        )->a( n = `growing` b = abap_true
        )->a( n = `width`   v = `auto`
        )->a( n = `items`   v = client->_bind( mt_table ) ).

    " the columns, hardcoded instead of driven by a layout manager
    DATA(columns) = table->ele( `columns` ).

    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Sel` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Carrier` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `Conn.` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `From` ).
    columns->ele( `Column`
        )->tag( `Text`
            )->a( n = `text` v = `To` ).

    " one row template; the row press opens the edit popup, carrying ROW_ID
    DATA(cells) = table->ele( `items`
        )->ele( `ColumnListItem`
            )->a( n = `type`  v = `Navigation`
            )->a( n = `press` v = client->_event( val   = `ROW_SELECT`
                                                  t_arg = VALUE #( ( `${ROW_ID}` ) ) )
            )->ele( `cells` ).

    cells->tag( `CheckBox`
        )->a( n = `selected` v = `{SELKZ}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{CARRID}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{CONNID}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{CITYFROM}` ).
    cells->tag( `Text`
        )->a( n = `text` v = `{CITYTO}` ).

    " footer buttons: Add / Delete / Refresh / Save
    page->ele( `footer`
        )->ele( `OverflowToolbar`
            )->tag( `ToolbarSpacer`

            )->tag( `Button`
                )->a( n = `text`  v = `Add`
                )->a( n = `icon`  v = `sap-icon://add`
                )->a( n = `press` v = client->_event( `BUTTON_ADD` )
            )->tag( `Button`
                )->a( n = `text`  v = `Delete`
                )->a( n = `type`  v = `Reject`
                )->a( n = `icon`  v = `sap-icon://delete`
                )->a( n = `press` v = client->_event( `BUTTON_DELETE` )
            )->tag( `Button`
                )->a( n = `text`  v = `Refresh`
                )->a( n = `icon`  v = `sap-icon://refresh`
                )->a( n = `press` v = client->_event( `BUTTON_REFRESH` )
            )->tag( `Button`
                )->a( n = `text`  v = `Save`
                )->a( n = `type`  v = `Accept`
                )->a( n = `press` v = client->_event( `BUTTON_SAVE` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `ROW_SELECT`.
        client->nav_app_call( z2ui5_cl_smp_app_501=>factory(
                                it_table  = mt_table
                                iv_row_id = CONV #( client->get_event_arg( ) )
                                iv_edit   = abap_true ) ).

      WHEN `BUTTON_ADD`.
        client->nav_app_call( z2ui5_cl_smp_app_501=>factory(
                                it_table  = mt_table
                                iv_row_id = mv_next_id
                                iv_edit   = abap_false ) ).
        mv_next_id = mv_next_id + 1.

      WHEN `BUTTON_DELETE`.
        button_delete( ).

      WHEN `BUTTON_REFRESH`.
        on_init( ).

      WHEN `BUTTON_SAVE`.
        button_save( ).

    ENDCASE.

  ENDMETHOD.


  METHOD button_delete.

    DELETE mt_table WHERE selkz = abap_true.

  ENDMETHOD.


  METHOD button_save.

    " no DB / no transport in the test version - just confirm
    client->message_toast_display( |{ lines( mt_table ) } rows "saved"| ).

  ENDMETHOD.


  METHOD on_after_popup.

    " same idea as the original: read the edited table back out of the app
    " that was called, which get_app_prev( ) hands over
    TRY.
        DATA(app) = CAST z2ui5_cl_smp_app_501( client->get_app_prev( ) ).
        mt_table = app->mt_table.

      CATCH cx_root ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
