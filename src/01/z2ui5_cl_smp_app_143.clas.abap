" @keywords column filter reset refresh uitableext grid alv
" @summary Keeps the active sap.ui.table column filters across a view model update, through the abap2UI5 uitableext custom control - without it they are reset.
" @docs https://abap2ui5.github.io/docs/cookbook/model/tables
CLASS z2ui5_cl_smp_app_143 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_data,
        field1 TYPE string,
        field2 TYPE string,
        field3 TYPE string,
      END OF ty_s_data.
    TYPES ty_t_data TYPE STANDARD TABLE OF ty_s_data WITH DEFAULT KEY.

    DATA gt_data TYPE ty_t_data.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_143 IMPLEMENTATION.

  METHOD on_event.
        DATA x TYPE REF TO cx_root.

    TRY.
        IF client->check_on_event( `ROW_ACTION_ITEM_ADD` ) IS NOT INITIAL.
          client->message_toast_display( `Something` ).
        ENDIF.
        
      CATCH cx_root INTO x.
        client->message_box_display( text = x->get_text( )
                                     type = `error` ).
    ENDTRY.

  ENDMETHOD.


  METHOD on_init.

    DATA temp1 TYPE ty_t_data.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-field1 = `21`.
    temp2-field2 = `T1`.
    temp2-field3 = `TEXT1`.
    INSERT temp2 INTO TABLE temp1.
    temp2-field1 = `22`.
    temp2-field2 = `T1`.
    temp2-field3 = `TEXT1`.
    INSERT temp2 INTO TABLE temp1.
    temp2-field1 = `23`.
    temp2-field2 = `T2`.
    temp2-field3 = `TEXT1`.
    INSERT temp2 INTO TABLE temp1.
    temp2-field1 = `24`.
    temp2-field2 = `T2`.
    temp2-field3 = `TEXT2`.
    INSERT temp2 INTO TABLE temp1.
    temp2-field1 = `25`.
    temp2-field2 = `T3`.
    temp2-field3 = `TEXT2`.
    INSERT temp2 INTO TABLE temp1.
    gt_data = temp1.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page1 TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA header_title TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA cont TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA table TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:f`      v = `sap.f`
            )->a( n = `xmlns:table`  v = `sap.ui.table`
            )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc` ).

    
    page1 = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Grid Table - Keep Column Filters on Refresh`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
            )->a( n = `class`          v = `sapUiContentPadding`
            )->a( n = `id`             v = `page_main` ).

    page1->tag( `MessageStrip`
        )->a( n = `text` v = `This sample uses the abap2UI5 uitableext custom control so the active sap.ui.table column ` &&
                   `filters are preserved across a view model update instead of being reset.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    page = page1->ele( n = `DynamicPage` ns = `f`
        )->a( n = `headerExpanded` b = abap_true ).
    page1->tag( n = `UITableExt` ns = `z2ui5`
        )->a( n = `tableId` v = `Table1` ).

    
    header_title = page->ele( n = `title` ns = `f`
        )->ele( n = `DynamicPageTitle` ns = `f` ).
    header_title->ele( n = `heading` ns = `f`
        )->ele( `HBox`
            )->tag( `Title`
                )->a( n = `text` v = `Table` ).
    header_title->ele( n = `expandedContent` ns = `f` ).
    header_title->ele( n = `snappedContent` ns = `f` ).

    
    cont = page->ele( n = `content` ns = `f` ).

    
    table = cont->ele( `VBox`
        )->ele( n = `Table` ns = `table`
            )->a( n = `rows`               v = client->_bind( gt_data )
            )->a( n = `alternateRowColors` b = abap_true
            )->a( n = `enableCellFilter`   b = abap_true
            )->a( n = `fixedColumnCount`   v = `1`
            )->a( n = `rowActionCount`     v = `1`
            )->a( n = `selectionMode`      v = `None`
            )->a( n = `id`                 v = `Table1` ).

    
    CLEAR temp3.
    INSERT `${MATNR}` INTO TABLE temp3.
    table->ele( n = `columns` ns = `table`
        )->ele( n = `Column` ns = `table`
            )->a( n = `sortProperty`   v = `FIELD1`
            )->a( n = `autoResizable`  v = `true`
            )->a( n = `filterProperty` v = `FIELD1`
            )->tag( `Text`
                )->a( n = `text` v = `Field1`
            )->ele( n = `template` ns = `table`
                )->tag( `Text`
                    )->a( n = `text` v = `{FIELD1}`
            )->end(
        )->end(
        )->ele( n = `Column` ns = `table`
            )->a( n = `sortProperty`   v = `FIELD2`
            )->a( n = `autoResizable`  v = `true`
            )->a( n = `filterProperty` v = `FIELD2`
            )->tag( `Text`
                )->a( n = `text` v = `Field2`
            )->ele( n = `template` ns = `table`
                )->tag( `Text`
                    )->a( n = `text` v = `{FIELD2}`
            )->end(
        )->end(
        )->ele( n = `Column` ns = `table`
            )->a( n = `sortProperty`   v = `FIELD3`
            )->a( n = `autoResizable`  v = `true`
            )->a( n = `filterProperty` v = `FIELD3`
            )->tag( `Text`
                )->a( n = `text` v = `Field3`
            )->ele( n = `template` ns = `table`
                )->tag( `Text`
                    )->a( n = `text` v = `{FIELD3}`
            )->end(
        )->end(
    )->end(
        )->ele( n = `rowActionTemplate` ns = `table`
            )->ele( n = `RowAction` ns = `table`
                )->ele( n = `RowActionItem` ns = `table`
                    )->a( n = `icon`  v = `sap-icon://add`
                    )->a( n = `text`  v = `Add`
                    )->a( n = `press` v = client->_event( val = `ROW_ACTION_ITEM_ADD` t_arg = temp3 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

    view_display( ).
    on_event( ).

  ENDMETHOD.

ENDCLASS.
