" @keywords cell input internal table row field level
" @summary Edits one cell of an internal table: tab_index addresses the row, so the Input writes back to a single field instead of the whole line.
" @docs https://abap2ui5.github.io/docs/cookbook/model/binding
CLASS z2ui5_cl_smp_app_144 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        title TYPE string,
        value TYPE string,
      END OF ty_s_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.

    METHODS set_view.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS Z2UI5_CL_SMP_APP_144 IMPLEMENTATION.


  METHOD set_view.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 LIKE LINE OF t_tab.
    DATA lr_row LIKE REF TO temp1.
      DATA lv_tabix LIKE sy-tabix.
    DATA temp2 LIKE LINE OF t_tab.
    DATA temp3 LIKE sy-tabix.
    DATA temp4 LIKE LINE OF t_tab.
    DATA temp5 LIKE sy-tabix.
    DATA temp6 LIKE LINE OF t_tab.
    DATA temp7 LIKE sy-tabix.
    DATA temp8 LIKE LINE OF t_tab.
    DATA temp9 LIKE sy-tabix.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).
    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Binding - Single Table Cell (tab_index)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `This sample demonstrates cell-level binding: each input is bound to one ` &&
                   `cell of an internal table via tab_index, so edits target exactly that row and field.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    
    LOOP AT t_tab REFERENCE INTO lr_row.
      
      lv_tabix = sy-tabix.
      page->tag( `Input`
          )->a( n = `value` v = client->_bind( val = lr_row->title tab = t_tab tab_index = lv_tabix ) ).
      page->tag( `Input`
          )->a( n = `value` v = client->_bind( val = lr_row->value tab = t_tab tab_index = lv_tabix ) ).
    ENDLOOP.

    page->ele( `Table`
        )->a( n = `items` v = client->_bind( t_tab )
        )->ele( `headerToolbar`
            )->ele( `OverflowToolbar`
                )->tag( `Title`
                    )->a( n = `text` v = `title of the table`
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
        )->end(
        )->ele( `items`
            )->ele( `ColumnListItem`
                )->ele( `cells`
                    )->tag( `Input`
                        )->a( n = `value` v = `{TITLE}`
                    )->tag( `Input`
                        )->a( n = `value` v = `{VALUE}` ).

    
    
    temp3 = sy-tabix.
    READ TABLE t_tab INDEX 1 INTO temp2.
    sy-tabix = temp3.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = temp2-title tab = t_tab tab_index = 1 ) ).
    
    
    temp5 = sy-tabix.
    READ TABLE t_tab INDEX 1 INTO temp4.
    sy-tabix = temp5.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = temp4-value tab = t_tab tab_index = 1 ) ).
    
    
    temp7 = sy-tabix.
    READ TABLE t_tab INDEX 2 INTO temp6.
    sy-tabix = temp7.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = temp6-title tab = t_tab tab_index = 2 ) ).
    
    
    temp9 = sy-tabix.
    READ TABLE t_tab INDEX 2 INTO temp8.
    sy-tabix = temp9.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    page->tag( `Input`
        )->a( n = `value` v = client->_bind( val = temp8-value tab = t_tab tab_index = 2 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
        DATA temp10 LIKE t_tab.
        DATA temp11 LIKE LINE OF temp10.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

        
        CLEAR temp10.
        temp10 = t_tab.
        
        temp11-title = `entry 01`.
        temp11-value = `red`.
        INSERT temp11 INTO TABLE temp10.
        temp11-title = `entry 02`.
        temp11-value = `blue`.
        INSERT temp11 INTO TABLE temp10.
        t_tab = temp10.
      set_view( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      set_view( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
