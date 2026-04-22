CLASS z2ui5_cl_demo_app_143 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF t_data,
        field1 TYPE string,
        field2 TYPE string,
        field3 TYPE string,
      END OF t_data.
    TYPES ty_t_data TYPE STANDARD TABLE OF t_data WITH EMPTY KEY.

    DATA gt_data TYPE ty_t_data.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_143 IMPLEMENTATION.

  METHOD on_event.

    TRY.
        IF client->check_on_event( `ROW_ACTION_ITEM_ADD` ).
          client->message_toast_display( `Something` ).
          client->view_model_update( ).
        ENDIF.
      CATCH cx_root INTO DATA(x).
        client->message_box_display( text = x->get_text( )
                                     type = `error` ).
    ENDTRY.

  ENDMETHOD.


  METHOD on_init.

    gt_data = VALUE ty_t_data(
      ( field1 = `21` field2 = `T1` field3 = `TEXT1` )
      ( field1 = `22` field2 = `T1` field3 = `TEXT1` )
      ( field1 = `23` field2 = `T2` field3 = `TEXT1` )
      ( field1 = `24` field2 = `T2` field3 = `TEXT2` )
      ( field1 = `25` field2 = `T3` field3 = `TEXT2` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page1) = view->page( id = `page_main`
            title                = `Table Filters Reset after view Update`
            class                = `sapUiContentPadding` ).

    DATA(page) = page1->dynamic_page( headerexpanded = abap_true
                                      headerpinned   = abap_true ).
    page1->_z2ui5( )->uitableext( `Table1` ).

    DATA(header_title) = page->title( ns = `f` )->get( )->dynamic_page_title( ).
    header_title->heading( `f` )->hbox( )->title( `Table` ).
    header_title->expanded_content( `f` ).
    header_title->snapped_content( `f` ).

    DATA(cont) = page->content( `f` ).

    DATA(tab) = cont->vbox(
                  )->ui_table( rows                = client->_bind( val = gt_data )
                               id                  = `Table1`
                                editable           = abap_false
                                alternaterowcolors = abap_true
                                enablecellfilter   = abap_true
                                rowactioncount     = `1`
                                visiblerowcount    = `7`
                                enablegrouping     = abap_false
                                fixedcolumncount   = `1`
                                selectionmode      = `None`
                         )->ui_columns(
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
                                    press                 = client->_event( val = `ROW_ACTION_ITEM_ADD` t_arg = VALUE #( ( `${MATNR}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

    view_display( ).
    on_event( ).

  ENDMETHOD.

ENDCLASS.
