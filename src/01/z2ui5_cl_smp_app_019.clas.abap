" @keywords selectionmode none single multi segmentedbutton checkbox
" @summary The table selection modes - none, single and multi - side by side, and what each returns.
" @docs https://abap2ui5.github.io/docs/cookbook/model/tables
CLASS z2ui5_cl_smp_app_019 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        selkz TYPE abap_bool,
        title TYPE string,
        value TYPE string,
        descr TYPE string,
      END OF ty_s_row.
    TYPES ty_t_rows TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.
    DATA t_tab     TYPE ty_t_rows.
    DATA t_tab_sel TYPE ty_t_rows.
    DATA sel_mode  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_019 IMPLEMENTATION.

  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Table - Selection Modes: Single and Multi Select`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A SegmentedButton switches the table's selection mode (None, Single, Multi) at ` &&
                   `runtime; a second table below collects the rows selected in the first.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `SegmentedButton`
        )->a( n = `selectedKey`     v = client->_bind( sel_mode )
        )->a( n = `selectionChange` v = client->_event( `BUTTON_SEGMENT_CHANGE` )
        )->ele( `items`
            )->tag( `SegmentedButtonItem`
                )->a( n = `key`  v = `None`
                )->a( n = `text` v = `None`
            )->tag( `SegmentedButtonItem`
                )->a( n = `key`  v = `SingleSelect`
                )->a( n = `text` v = `SingleSelect`
            )->tag( `SegmentedButtonItem`
                )->a( n = `key`  v = `SingleSelectLeft`
                )->a( n = `text` v = `SingleSelectLeft`
            )->tag( `SegmentedButtonItem`
                )->a( n = `key`  v = `SingleSelectMaster`
                )->a( n = `text` v = `SingleSelectMaster`
            )->tag( `SegmentedButtonItem`
                )->a( n = `key`  v = `MultiSelect`
                )->a( n = `text` v = `MultiSelect` ).

    page->ele( `Table`
        )->a( n = `items`      v = client->_bind( t_tab )
        )->a( n = `headerText` v = `Table`
        )->a( n = `mode`       v = sel_mode
        )->ele( `columns`
            )->ele( `Column`
                )->tag( `Text`
                    )->a( n = `text` v = `Title`
            )->end(
            )->ele( `Column`
                )->tag( `Text`
                    )->a( n = `text` v = `Value`
            )->end(
            )->ele( `Column`
                )->tag( `Text`
                    )->a( n = `text` v = `Description`
            )->end(
        )->end(
        )->ele( `items`
            )->ele( `ColumnListItem`
                )->a( n = `selected` v = `{SELKZ}`
                )->ele( `cells`
                    )->tag( `Text`
                        )->a( n = `text` v = `{TITLE}`
                    )->tag( `Text`
                        )->a( n = `text` v = `{VALUE}`
                    )->tag( `Text`
                        )->a( n = `text` v = `{DESCR}` ).

    page->ele( `Table`
        )->a( n = `items` v = client->_bind( t_tab_sel )
        )->ele( `headerToolbar`
            )->ele( `OverflowToolbar`
                )->tag( `Title`
                    )->a( n = `text` v = `Selected Entries`
                )->tag( `Button`
                    )->a( n = `press` v = client->_event( `BUTTON_READ_SEL` )
                    )->a( n = `text`  v = `copy selected entries`
                    )->a( n = `icon`  v = `sap-icon://pull-down`
            )->end(
        )->end(
        )->ele( `columns`
            )->ele( `Column`
                )->tag( `Text`
                    )->a( n = `text` v = `Title`
            )->end(
            )->ele( `Column`
                )->tag( `Text`
                    )->a( n = `text` v = `Value`
            )->end(
            )->ele( `Column`
                )->tag( `Text`
                    )->a( n = `text` v = `Description`
            )->end(
        )->end(
        )->ele( `items`
            )->ele( `ColumnListItem`
                )->ele( `cells`
                    )->tag( `Text`
                        )->a( n = `text` v = `{TITLE}`
                    )->tag( `Text`
                        )->a( n = `text` v = `{VALUE}`
                    )->tag( `Text`
                        )->a( n = `text` v = `{DESCR}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE z2ui5_cl_smp_app_019=>ty_t_rows.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      sel_mode = `None`.
      
      CLEAR temp1.
      
      temp2-descr = `this is a description`.
      temp2-title = `title_01`.
      temp2-value = `value_01`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `title_02`.
      temp2-value = `value_02`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `title_03`.
      temp2-value = `value_03`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `title_04`.
      temp2-value = `value_04`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `title_05`.
      temp2-value = `value_05`.
      INSERT temp2 INTO TABLE temp1.
      t_tab    = temp1.
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).

    ELSEIF client->check_on_event( `BUTTON_SEGMENT_CHANGE` ) IS NOT INITIAL.
      client->message_toast_display( `Selection Mode changed` ).

    ELSEIF client->check_on_event( `BUTTON_READ_SEL` ) IS NOT INITIAL.

      t_tab_sel = t_tab.
      DELETE t_tab_sel WHERE selkz <> abap_true.
    ENDIF.

    view_display( ).

  ENDMETHOD.

ENDCLASS.
