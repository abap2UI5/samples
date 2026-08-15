" @keywords filter server side form growing where
CLASS z2ui5_cl_smp_app_045 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        count    TYPE i,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        checkbox TYPE abap_bool,
      END OF ty_s_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    DATA mv_info_filter TYPE string.

    METHODS refresh_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_smp_app_045 IMPLEMENTATION.


  METHOD refresh_data.

    DO 1000 TIMES.
      DATA(ls_row) = VALUE ty_s_row( count = sy-index  value = `red`
        info = COND #( WHEN sy-index < 50 THEN `completed` ELSE `uncompleted` )
        descr = `this is a description` checkbox = abap_true ).
      INSERT ls_row INTO TABLE t_tab.
    ENDDO.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      refresh_data( ).
    ENDIF.

    CASE client->get_event( ).

      WHEN `FILTER_INFO`.
        refresh_data( ).
        IF mv_info_filter <> ``.
          DELETE t_tab WHERE info <> mv_info_filter.
        ENDIF.

      WHEN `BUTTON_POST`.
        client->message_box_display( `button post was pressed` ).
    ENDCASE.

    DATA(page) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `abap2UI5 - Table - Filter Rows in the Backend`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
                    )->ele( `headerContent`
                        )->tag( `Link`
                    )->end( ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A growing, scrollable table filtered on the backend: entering a value in the form and ` &&
                   `pressing filter deletes the non-matching rows server-side before re-rendering.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Form Title`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Title`
                )->a( n = `text` v = `Filter`
            )->tag( `Label`
                )->a( n = `text` v = `info`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( mv_info_filter )
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `FILTER_INFO` )
                )->a( n = `text`  v = `filter` ).

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
        )->ele( `OverflowToolbar`
            )->tag( `ToolbarSpacer` ).

    tab->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Color`
        )->end(
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Info`
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
                    )->a( n = `text` v = `{INFO}`
                )->tag( `Text`
                    )->a( n = `text` v = `{DESCR}`
                )->tag( `CheckBox`
                    )->a( n = `selected` v = `{CHECKBOX}`
                    )->a( n = `enabled`  b = abap_false
                )->tag( `Text`
                    )->a( n = `text` v = `{COUNT}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
