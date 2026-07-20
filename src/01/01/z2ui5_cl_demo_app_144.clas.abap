CLASS z2ui5_cl_demo_app_144 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_144 IMPLEMENTATION.

  METHOD set_view.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 LIKE LINE OF t_tab.
    DATA lr_row LIKE REF TO temp1.
      DATA lv_tabix LIKE sy-tabix.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    DATA temp2 LIKE LINE OF t_tab.
    DATA temp3 LIKE sy-tabix.
    DATA temp4 LIKE LINE OF t_tab.
    DATA temp5 LIKE sy-tabix.
    DATA temp6 LIKE LINE OF t_tab.
    DATA temp7 LIKE sy-tabix.
    DATA temp8 LIKE LINE OF t_tab.
    DATA temp9 LIKE sy-tabix.
    view = z2ui5_cl_xml_view=>factory( ).
    
    page = view->shell(
        )->page(
                title          = `abap2UI5 - Binding Cell Level`
                navbuttonpress = client->_event_nav_app_leave( )
                shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `This sample demonstrates cell-level binding: each input is bound to one ` &&
                   `cell of an internal table via tab_index, so edits target exactly that row and field.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    
    
    LOOP AT t_tab REFERENCE INTO lr_row.
      
      lv_tabix = sy-tabix.
      page->input( client->_bind( val = lr_row->title tab = t_tab tab_index = lv_tabix ) ).
      page->input( client->_bind( val = lr_row->value tab = t_tab tab_index = lv_tabix ) ).
    ENDLOOP.

    
    tab = page->table(
            items = client->_bind( t_tab )
            mode  = `MultiSelect`
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( `title of the table`
        )->get_parent( )->get_parent(
      )->columns(
        )->column( )->text( `Title` )->get_parent(
        )->column( )->text( `Value` )->get_parent( )->get_parent(
      )->items( )->column_list_item( selected = `{SELKZ}`
      )->cells(
          )->input( `{TITLE}`
          )->input( `{VALUE}` ).

    
    
    temp3 = sy-tabix.
    READ TABLE t_tab INDEX 1 INTO temp2.
    sy-tabix = temp3.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    page->input( client->_bind( val = temp2-title tab = t_tab tab_index = 1 ) ).
    
    
    temp5 = sy-tabix.
    READ TABLE t_tab INDEX 1 INTO temp4.
    sy-tabix = temp5.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    page->input( client->_bind( val = temp4-value tab = t_tab tab_index = 1 ) ).
    
    
    temp7 = sy-tabix.
    READ TABLE t_tab INDEX 2 INTO temp6.
    sy-tabix = temp7.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    page->input( client->_bind( val = temp6-title tab = t_tab tab_index = 2 ) ).
    
    
    temp9 = sy-tabix.
    READ TABLE t_tab INDEX 2 INTO temp8.
    sy-tabix = temp9.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    page->input( client->_bind( val = temp8-value tab = t_tab tab_index = 2 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
        DATA temp10 LIKE t_tab.
        DATA temp11 LIKE LINE OF temp10.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      DO 1 TIMES.
        
        CLEAR temp10.
        temp10 = t_tab.
        
        temp11-title = `entry 01`.
        temp11-value = `red`.
        INSERT temp11 INTO TABLE temp10.
        temp11-title = `entry 02`.
        temp11-value = `blue`.
        INSERT temp11 INTO TABLE temp10.
        t_tab = temp10.
      ENDDO.
      set_view( ).
    ENDIF.
    client->view_model_update( ).

  ENDMETHOD.

ENDCLASS.
