CLASS z2ui5_cl_demo_app_143 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_demo_app_143 IMPLEMENTATION.

  METHOD on_event.
        DATA x TYPE REF TO cx_root.

    TRY.
        IF client->check_on_event( `ROW_ACTION_ITEM_ADD` ) IS NOT INITIAL.
          client->message_toast_display( `Something` ).
          client->view_model_update( ).
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

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page1 TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA header_title TYPE REF TO z2ui5_cl_xml_view.
    DATA cont TYPE REF TO z2ui5_cl_xml_view.
    DATA table TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page1 = view->shell( )->page( id = `page_main`
            title                = `Table Filters Reset after view Update`
            class                = `sapUiContentPadding`
            navbuttonpress       = client->_event_nav_app_leave( )
            shownavbutton        = client->check_app_prev_stack( ) ).

    page1->message_strip(
        text     = `This sample uses the abap2UI5 uitableext custom control so the active sap.ui.table column ` &&
                   `filters are preserved across a view model update instead of being reset.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    
    page = page1->dynamic_page( headerexpanded = abap_true
                                      headerpinned   = abap_true ).
    page1->_z2ui5( )->uitableext( `Table1` ).

    
    header_title = page->title( ns = `f` )->get( )->dynamic_page_title( ).
    header_title->heading( `f` )->hbox( )->title( `Table` ).
    header_title->expanded_content( `f` ).
    header_title->snapped_content( `f` ).

    
    cont = page->content( `f` ).

    
    table = cont->vbox(
                  )->ui_table( rows               = client->_bind( val = gt_data )
                               id                 = `Table1`
                               editable           = abap_false
                               alternaterowcolors = abap_true
                               enablecellfilter   = abap_true
                               rowactioncount     = `1`
                               fixedcolumncount   = `1`
                               visiblerowcount    = `7`
                               selectionmode      = `None` ).

    
    CLEAR temp3.
    INSERT `${MATNR}` INTO TABLE temp3.
    table->ui_columns(
                              )->ui_column( sortproperty   = `FIELD1`
                                            filterproperty = `FIELD1`
                                            autoresizable  = `true`
                                             )->text( `Field1`
                                              )->ui_template( )->text( `{FIELD1}`
                               )->get_parent( )->get_parent(
                               )->ui_column( sortproperty   = `FIELD2`
                                             filterproperty = `FIELD2`
                                             autoresizable  = `true`
                                              )->text( `Field2`
                                               )->ui_template( )->text( `{FIELD2}`
                               )->get_parent( )->get_parent(
                               )->ui_column( sortproperty   = `FIELD3`
                                             filterproperty = `FIELD3`
                                             autoresizable  = `true`
                                              )->text( `Field3`
                                               )->ui_template( )->text( `{FIELD3}`
                         )->get_parent( )->get_parent( )->get_parent(
                              )->ui_row_action_template( )->ui_row_action(
                              )->ui_row_action_item( icon = `sap-icon://add`
                                                     text = `Add`
                                    press                 = client->_event( val = `ROW_ACTION_ITEM_ADD` t_arg = temp3 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ENDIF.

    view_display( ).
    on_event( ).

  ENDMETHOD.

ENDCLASS.
