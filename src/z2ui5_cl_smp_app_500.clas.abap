" @keywords table edit row popup app nav_app_call get_app_prev add delete save master detail
" @summary A table whose rows are edited by a SECOND app shown as a popup - the caller reads the edited table back out of it with get_app_prev( ) when it returns.
CLASS z2ui5_cl_smp_app_500 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        row_id   TYPE i,
        selkz    TYPE abap_bool,
        carrid   TYPE string,
        connid   TYPE string,
        cityfrom TYPE string,
        cityto   TYPE string,
      END OF ty_s_row.
    TYPES ty_t_row TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.
    DATA t_table TYPE ty_t_row.

    " the id the next added row gets - kept so a delete cannot hand an id out
    " twice, which the popup app matches rows by
    DATA next_id TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS read_back_from_popup.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_500 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      " the popup app handed control back - take what it edited, then
      " re-display, because the view slot is this app's again
      read_back_from_popup( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_table = VALUE #( ( row_id = 1 carrid = `LH` connid = `0400` cityfrom = `FRANKFURT` cityto = `NEW YORK` )
                       ( row_id = 2 carrid = `UA` connid = `0941` cityfrom = `FRANKFURT` cityto = `SAN FRANCISCO` )
                       ( row_id = 3 carrid = `AA` connid = `0017` cityfrom = `NEW YORK`  cityto = `SAN FRANCISCO` ) ).
    next_id = 4.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `ROW_SELECT`.
        " the row press carries its ROW_ID, so the popup app is handed the
        " row to edit rather than a screen position
        client->nav_app_call( z2ui5_cl_smp_app_501=>factory( t_table = t_table
                                                             row_id  = CONV #( client->get_event_arg( ) )
                                                             edit    = abap_true ) ).

      WHEN `BUTTON_ADD`.
        client->nav_app_call( z2ui5_cl_smp_app_501=>factory( t_table = t_table
                                                             row_id  = next_id
                                                             edit    = abap_false ) ).
        next_id = next_id + 1.

      WHEN `BUTTON_DELETE`.
        DELETE t_table WHERE selkz = abap_true.
        view_display( ).

      WHEN `BUTTON_REFRESH`.
        on_init( ).
        view_display( ).

      WHEN `BUTTON_SAVE`.
        client->message_toast_display( |{ lines( t_table ) } row(s) saved| ).

    ENDCASE.

  ENDMETHOD.


  METHOD read_back_from_popup.

    " get_app_prev( ) hands over the INSTANCE that was called, so its edited
    " table is read straight off it - no payload has to travel back
    TRY.
        DATA(app) = CAST z2ui5_cl_smp_app_501( client->get_app_prev( ) ).
        t_table = app->t_table.

      CATCH cx_root ##NO_HANDLER.
    ENDTRY.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Popup - Edit a Row in a Second App`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `Press a row and a SECOND app opens as a popup to edit it. It hands control back with ` &&
                   `nav_app_leave( ), and this app reads the edited table straight off that instance with ` &&
                   `get_app_prev( ) - the edit lives in the app that owns the dialog, not in a payload.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(table) = page->ele( `Table`
        )->a( n = `items`   v = client->_bind( t_table )
        )->a( n = `growing` b = abap_true
        )->a( n = `width`   v = `auto` ).

    table->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Sel`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Carrier`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Conn.`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `From`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `To` ).

    table->ele( `items`
        )->ele( `ColumnListItem`
            )->a( n = `type`  v = `Navigation`
            )->a( n = `press` v = client->_event( val   = `ROW_SELECT`
                                                  t_arg = VALUE #( ( `${ROW_ID}` ) ) )
            )->ele( `cells`
                )->tag( `CheckBox`
                    )->a( n = `selected` v = `{SELKZ}`
                )->tag( `Text`
                    )->a( n = `text` v = `{CARRID}`
                )->tag( `Text`
                    )->a( n = `text` v = `{CONNID}`
                )->tag( `Text`
                    )->a( n = `text` v = `{CITYFROM}`
                )->tag( `Text`
                    )->a( n = `text` v = `{CITYTO}` ).

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

ENDCLASS.
