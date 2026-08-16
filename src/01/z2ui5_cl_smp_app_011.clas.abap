" @keywords edit input add row delete multiselect toolbar
" @summary An editable table: input cells, adding and deleting rows, multi-select and a toolbar over them.
" @docs https://abap2ui5.github.io/docs/get_started/full_example https://abap2ui5.github.io/docs/cookbook/model/tables
CLASS z2ui5_cl_smp_app_011 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        selkz    TYPE abap_bool,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        editable TYPE abap_bool,
        checkbox TYPE abap_bool,
      END OF ty_s_row.
    DATA t_tab                 TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.
    DATA check_editable_active TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_011 IMPLEMENTATION.


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
            )->a( n = `title`          v = `abap2UI5 - Table - Editable Cells, Add and Delete Rows`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `id`             v = `test2` ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A MultiSelect table whose input cells switch between display and edit mode via the ` &&
                   `toolbar, which also adds new rows and deletes the currently selected ones.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(tab) = page->ele( `Table`
        )->a( n = `items` v = |\{path: '{ client->_bind( val = t_tab path = abap_true ) }', templateShareable: false\}|
        )->a( n = `mode`  v = `MultiSelect`
        )->ele( `headerToolbar`
            )->ele( `OverflowToolbar`
                )->tag( `Title`
                    )->a( n = `text` v = `title of the table`
                )->tag( `Button`
                    " abap2ui5lint-disable-next-line event-without-handler -- shows an OverflowToolbar filling up - the press is a plain roundtrip
                    )->a( n = `press` v = client->_event( `BUTTON_TEST` )
                    )->a( n = `text`  v = `test`
                )->tag( `ToolbarSpacer`
                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `BUTTON_DELETE` )
                    )->a( n = `text`  v = `delete selected row`
                    )->a( n = `icon`  v = `sap-icon://delete`
                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `BUTTON_ADD` )
                    )->a( n = `text`  v = `add`
                    )->a( n = `icon`  v = `sap-icon://add`
                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `BUTTON_EDIT` )
                    )->a( n = `text`  v = SWITCH #( check_editable_active WHEN abap_true THEN `display` ELSE `edit` )
                    )->a( n = `icon`  v = `sap-icon://edit`
            )->end(
        )->end( ).

    tab->ele( `columns`
        )->ele( `Column`
            )->tag( `Text`
                )->a( n = `text` v = `Title`
        )->end(
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
                )->a( n = `text` v = `Checkbox` ).

    tab->ele( `items`
        )->ele( `ColumnListItem`
            )->a( n = `selected` v = `{SELKZ}`
            )->ele( `cells`
                )->tag( `Input`
                    )->a( n = `id`      v = `test`
                    )->a( n = `enabled` v = `{EDITABLE}`
                    )->a( n = `value`   v = `{TITLE}`
                )->tag( `Input`
                    )->a( n = `enabled` v = `{EDITABLE}`
                    )->a( n = `value`   v = `{VALUE}`
                )->tag( `Input`
                    )->a( n = `enabled` v = `{EDITABLE}`
                    )->a( n = `value`   v = `{INFO}`
                )->tag( `Input`
                    )->a( n = `enabled` v = `{EDITABLE}`
                    )->a( n = `value`   v = `{DESCR}`
                )->tag( `CheckBox`
                    )->a( n = `selected` v = `{CHECKBOX}`
                    )->a( n = `enabled`  v = `{EDITABLE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      check_editable_active = abap_false.
      t_tab                 = VALUE #(
          ( title = `entry 01` value = `red`    info = `completed` descr = `this is a description` checkbox = abap_true )
          ( title = `entry 02` value = `blue`   info = `completed` descr = `this is a description` checkbox = abap_true )
          ( title = `entry 03` value = `green`  info = `completed` descr = `this is a description` checkbox = abap_true )
          ( title = `entry 04` value = `orange` info = `completed` descr = `` checkbox = abap_true )
          ( title = `entry 05` value = `grey`   info = `completed` descr = `this is a description` checkbox = abap_true )
          ( ) ).

      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).

    ELSEIF client->check_on_event( `BUTTON_EDIT` ).
      check_editable_active = xsdbool( check_editable_active = abap_false ).
      LOOP AT t_tab REFERENCE INTO DATA(lr_tab).
        lr_tab->editable = check_editable_active.
      ENDLOOP.

    ELSEIF client->check_on_event( `BUTTON_DELETE` ).
      DELETE t_tab WHERE selkz = abap_true.

    ELSEIF client->check_on_event( `BUTTON_ADD` ).

      INSERT VALUE #( ) INTO TABLE t_tab.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
