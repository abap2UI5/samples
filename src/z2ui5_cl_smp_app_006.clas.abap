" @keywords growing 10000 rows sticky toolbar sort performance
" @summary 10.000 rows in one table: growing with scroll-to-load, a sticky header toolbar and sorting in the backend.
" @docs https://abap2ui5.github.io/docs/cookbook/model/tables
CLASS z2ui5_cl_smp_app_006 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        count    TYPE i,
        value    TYPE string,
        descr    TYPE string,
        checkbox TYPE abap_bool,
      END OF ty_s_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA key    TYPE string.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS refresh_data.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_006 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    refresh_data( ).
    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    " the sorted table reaches the view with the model push - no re-render
    " of the 10,000 rows is needed
    CASE client->get_event( ).
      WHEN `SORT_ASCENDING`.
        SORT t_tab BY count ASCENDING.
        client->message_toast_display( `sort ascending` ).
      WHEN `SORT_DESCENDING`.
        SORT t_tab BY count DESCENDING.
        client->message_toast_display( `sort descending` ).
    ENDCASE.

  ENDMETHOD.


  METHOD refresh_data.

    t_tab = VALUE #( FOR i = 1 UNTIL i > 10000 (
      count    = i
      value    = `red`
      descr    = `this is a description`
      checkbox = abap_true ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Table - Large Table with Growing and ScrollContainer`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A large table (10,000 rows) is rendered inside a ScrollContainer using growing / ` &&
                   `scroll-to-load, with a sticky header toolbar: a segmented button and two sort buttons that ` &&
                   `sort the table in the backend and push the new order to the client.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(tab) = page->ele( `ScrollContainer`
        )->a( n = `height`   v = `70%`
        )->a( n = `vertical` b = abap_true
        )->ele( `Table`
            )->a( n = `items`               v = client->_bind( t_tab )
            )->a( n = `growing`             b = abap_true
            )->a( n = `growingThreshold`    v = `20`
            )->a( n = `growingScrollToLoad` b = abap_true
            )->a( n = `sticky`              v = `ColumnHeaders,HeaderToolbar` ).

    tab->ele( `headerToolbar`
        )->ele( `Toolbar`
            )->tag( `Title`
                )->a( n = `text` v = `title of the table`
            )->ele( `SegmentedButton`
                )->a( n = `selectedKey` t = key
                )->ele( `items`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://accept`
                        )->a( n = `key`  v = `BLUE`
                        )->a( n = `text` v = `blue`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `icon` v = `sap-icon://add-favorite`
                        )->a( n = `key`  v = `GREEN`
                        )->a( n = `text` v = `green`
                )->end(
            )->end(
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `press`   v = client->_event( `SORT_DESCENDING` )
                )->a( n = `icon`    v = `sap-icon://sort-descending`
                )->a( n = `tooltip` v = `Sort descending`
            )->tag( `Button`
                )->a( n = `press`   v = client->_event( `SORT_ASCENDING` )
                )->a( n = `icon`    v = `sap-icon://sort-ascending`
                )->a( n = `tooltip` v = `Sort ascending` ).

    tab->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Color`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Description`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Checkbox`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Counter` ).

    tab->ele( `items`
        )->ele( `ColumnListItem`
            )->ele( `cells`
                )->tag( `Text`
                    )->a( n = `text` v = `{VALUE}`
                )->tag( `Text`
                    )->a( n = `text` v = `{DESCR}`
                )->tag( `CheckBox`
                    )->a( n = `selected` v = `{CHECKBOX}`
                    )->a( n = `enabled`  b = abap_false
                )->tag( `Text`
                    )->a( n = `text` v = `{COUNT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
