" @keywords edit input add row delete multiselect toolbar
" @summary An editable table: input cells, adding and deleting rows, multi-select and a toolbar over them.
" @docs https://abap2ui5.github.io/docs/cookbook/model/tables https://abap2ui5.github.io/docs/tutorials/walkthrough/step-8 https://abap2ui5.github.io/docs/tutorials/walkthrough/step-10
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
    DATA t_tab                 TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.
    DATA check_editable_active TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_011 IMPLEMENTATION.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    
    page = view->ele( `Shell`
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

    
    CASE check_editable_active.
      WHEN abap_true.
        temp1 = `display`.
      WHEN OTHERS.
        temp1 = `edit`.
    ENDCASE.
    
    tab = page->ele( `Table`
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
                    )->a( n = `text`  v = temp1
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
      DATA temp2 LIKE t_tab.
      DATA temp3 LIKE LINE OF temp2.
      DATA temp1 TYPE xsdboolean.
      DATA temp4 LIKE LINE OF t_tab.
      DATA lr_tab LIKE REF TO temp4.
      DATA temp5 TYPE z2ui5_cl_smp_app_011=>ty_s_row.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      check_editable_active = abap_false.
      
      CLEAR temp2.
      
      temp3-title = `entry 01`.
      temp3-value = `red`.
      temp3-info = `completed`.
      temp3-descr = `this is a description`.
      temp3-checkbox = abap_true.
      INSERT temp3 INTO TABLE temp2.
      temp3-title = `entry 02`.
      temp3-value = `blue`.
      temp3-info = `completed`.
      temp3-descr = `this is a description`.
      temp3-checkbox = abap_true.
      INSERT temp3 INTO TABLE temp2.
      temp3-title = `entry 03`.
      temp3-value = `green`.
      temp3-info = `completed`.
      temp3-descr = `this is a description`.
      temp3-checkbox = abap_true.
      INSERT temp3 INTO TABLE temp2.
      temp3-title = `entry 04`.
      temp3-value = `orange`.
      temp3-info = `completed`.
      temp3-descr = ``.
      temp3-checkbox = abap_true.
      INSERT temp3 INTO TABLE temp2.
      temp3-title = `entry 05`.
      temp3-value = `grey`.
      temp3-info = `completed`.
      temp3-descr = `this is a description`.
      temp3-checkbox = abap_true.
      INSERT temp3 INTO TABLE temp2.
      INSERT temp3 INTO TABLE temp2.
      t_tab                 = temp2.

      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( `BUTTON_EDIT` ) IS NOT INITIAL.
      
      temp1 = boolc( check_editable_active = abap_false ).
      check_editable_active = temp1.
      
      
      LOOP AT t_tab REFERENCE INTO lr_tab.
        lr_tab->editable = check_editable_active.
      ENDLOOP.

    ELSEIF client->check_on_event( `BUTTON_DELETE` ) IS NOT INITIAL.
      DELETE t_tab WHERE selkz = abap_true.

    ELSEIF client->check_on_event( `BUTTON_ADD` ) IS NOT INITIAL.

      
      CLEAR temp5.
      INSERT temp5 INTO TABLE t_tab.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
