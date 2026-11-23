" @keywords edit input add row delete multiselect toolbar _bind_path
" @summary An editable table: input cells, adding and deleting rows, multi-select and a toolbar over them.
" @docs https://abap2ui5.github.io/docs/cookbook/model/tables https://abap2ui5.github.io/docs/tutorials/step-8 https://abap2ui5.github.io/docs/tutorials/step-10
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
    DATA t_tab            TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.
    DATA edit_button_text TYPE string VALUE `edit`.

  PROTECTED SECTION.
    DATA check_editable_active TYPE abap_bool.
    DATA client                TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_011 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_tab.
      DATA temp2 LIKE LINE OF temp1.
      DATA temp6 TYPE xsdboolean.
      DATA temp3 LIKE LINE OF t_tab.
      DATA lr_tab LIKE REF TO temp3.
      DATA temp4 TYPE string.
      DATA temp5 TYPE z2ui5_cl_smp_app_011=>ty_s_row.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      check_editable_active = abap_false.
      
      CLEAR temp1.
      
      temp2-title = `entry 01`.
      temp2-value = `red`.
      temp2-info = `completed`.
      temp2-descr = `this is a description`.
      temp2-checkbox = abap_true.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `entry 02`.
      temp2-value = `blue`.
      temp2-info = `completed`.
      temp2-descr = `this is a description`.
      temp2-checkbox = abap_true.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `entry 03`.
      temp2-value = `green`.
      temp2-info = `completed`.
      temp2-descr = `this is a description`.
      temp2-checkbox = abap_true.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `entry 04`.
      temp2-value = `orange`.
      temp2-info = `completed`.
      temp2-descr = ``.
      temp2-checkbox = abap_true.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `entry 05`.
      temp2-value = `grey`.
      temp2-info = `completed`.
      temp2-descr = `this is a description`.
      temp2-checkbox = abap_true.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = ``.
      temp2-value = ``.
      temp2-info = ``.
      temp2-descr = ``.
      temp2-checkbox = abap_false.
      INSERT temp2 INTO TABLE temp1.
      t_tab                 = temp1.

      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( `BUTTON_EDIT` ) IS NOT INITIAL.
      
      temp6 = boolc( check_editable_active = abap_false ).
      check_editable_active = temp6.
      
      
      LOOP AT t_tab REFERENCE INTO lr_tab.
        lr_tab->editable = check_editable_active.
      ENDLOOP.
      
      CASE check_editable_active.
        WHEN abap_true.
          temp4 = `display`.
        WHEN OTHERS.
          temp4 = `edit`.
      ENDCASE.
      edit_button_text = temp4.

    ELSEIF client->check_on_event( `BUTTON_DELETE` ) IS NOT INITIAL.
      DELETE t_tab WHERE selkz = abap_true.

    ELSEIF client->check_on_event( `BUTTON_ADD` ) IS NOT INITIAL.

      
      CLEAR temp5.
      temp5-editable = check_editable_active.
      INSERT temp5 INTO TABLE t_tab.
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ).
    
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

    
    tab = page->ele( `Table`
        )->a( n = `items` v = |\{path: '{ client->_bind_path( t_tab ) }', templateShareable: false\}|
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
                    )->a( n = `text`  v = client->_bind( edit_button_text )
                    )->a( n = `tooltip` v = `Switch the cells between display and edit mode`
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
ENDCLASS.
