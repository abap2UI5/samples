class z2ui5_cl_demo_app_143 definition
  public
  final
  create public .

  public section.

    interfaces IF_SERIALIZABLE_OBJECT .
    interfaces Z2UI5_IF_APP .

  types:
    begin of t_data,
        field1 type string,
        field2 type string,
        field3 type string,
      end of t_data .

    types: ty_t_data TYPE STANDARD TABLE OF t_data WITH EMPTY KEY .
    data: gt_data type ty_t_data.


    data CLIENT type ref to Z2UI5_IF_CLIENT .
    data CHECK_INITIALIZED type ABAP_BOOL .

    methods UI5_ON_INIT .
    methods UI5_ON_EVENT .
    methods UI5_VIEW_MAIN_DISPLAY .
  protected section.
  private section.
ENDCLASS.



CLASS z2ui5_cl_demo_app_143 IMPLEMENTATION.


  METHOD UI5_ON_EVENT.

    TRY.
        DATA(OK_CODE) = client->get( )-event.
        CASE OK_CODE.
          when 'ROW_ACTION_ITEM_ADD'  .
            client->message_toast_display( 'Something'   ).
            client->view_model_update( ).
        endcase.
      CATCH cx_root INTO DATA(x).
        client->message_box_display( text = x->get_text( ) type = `error` ).
    ENDTRY.

  ENDMETHOD.

  METHOD UI5_ON_INIT.

    gt_data = VALUE ty_t_data(
      ( field1 = '21' field2 = 'T1' field3 = 'TEXT1' )
      ( field1 = '22' field2 = 'T1' field3 = 'TEXT1' )
      ( field1 = '23' field2 = 'T2' field3 = 'TEXT1' )
      ( field1 = '24' field2 = 'T2' field3 = 'TEXT2' )
      ( field1 = '25' field2 = 'T3' field3 = 'TEXT2' )
      ).

  ENDMETHOD.

  METHOD UI5_VIEW_MAIN_DISPLAY.
    DATA(view) = Z2UI5_cl_xml_view=>factory( client ).

    DATA(page1) = view->page( id = `page_main`
            title          = 'Table Filters Reset after view Update'
            class = 'sapUiContentPadding' ).

    DATA(page) = page1->dynamic_page( headerexpanded = abap_true headerpinned = abap_true ).

    DATA(header_title) = page->title( ns = 'f'  )->get( )->dynamic_page_title( ).
    header_title->heading( ns = 'f' )->hbox( )->title( `Table` ).
    header_title->expanded_content( 'f' ).
    header_title->snapped_content( ns = 'f' ).

    DATA(cont) = page->content( ns = 'f' ).

    DATA(tab) = cont->vbox(

                          )->ui_table( rows = client->_bind( val = gt_data ) id = 'Table1'
                                editable = abap_false
                                alternaterowcolors = abap_true
                                enableCellFilter = abap_true
                                rowactioncount = '1'
                                visibleRowCount = '7'
                                enablegrouping = abap_false
                                fixedcolumncount = '1'
                                selectionmode = 'None'
                         )->ui_columns(
                              )->ui_column( sortproperty = 'FIELD1'
                                            filterproperty = 'FIELD1'
                                            autoresizable = 'true'
                                             )->text( text = `Field1`
                                              )->ui_template( )->text( text = `{FIELD1}`
                               )->get_parent( )->get_parent(
                               )->ui_column( sortproperty = 'FIELD2'
                                             filterproperty = 'FIELD2'
                                             autoresizable = 'true'
                                              )->text( text = `Field2`
                                               )->ui_template( )->text( text = `{FIELD2}`
                               )->get_parent( )->get_parent(
                               )->ui_column( sortproperty = 'FIELD3'
                                             filterproperty = 'FIELD3'
                                             autoresizable = 'true'
                                              )->text( text = `Field3`
                                               )->ui_template( )->text( text = `{FIELD3}`
                         )->get_parent( )->get_parent( )->get_parent(
                              )->ui_row_action_template( )->ui_row_action(
                              )->ui_row_action_item( icon = 'sap-icon://add' text = 'Add'
                                    press = client->_event( val = 'ROW_ACTION_ITEM_ADD' t_arg = VALUE #( ( `${MATNR}`  ) ) )
                        ).

    client->view_display( view->stringify( ) ).
  ENDMETHOD.

  method Z2UI5_IF_APP~MAIN.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      ui5_on_init( ).
    ENDIF.

    ui5_view_main_display( ).
    ui5_on_event( ).
  ENDMETHOD.
ENDCLASS.

