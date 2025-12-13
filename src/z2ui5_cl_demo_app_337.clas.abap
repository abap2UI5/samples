CLASS z2ui5_cl_demo_app_337 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_data         TYPE STANDARD TABLE OF z2ui5_t_01.
    DATA ms_data         TYPE z2ui5_t_01.
    DATA mo_layout_obj   TYPE REF TO z2ui5_cl_demo_app_333.
    DATA mo_layout_obj_2 TYPE REF TO z2ui5_cl_demo_app_333.

    METHODS get_data.

    METHODS ui5_view_display
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS xml_table
      IMPORTING
        i_page   TYPE REF TO z2ui5_cl_xml_view
        i_client TYPE REF TO z2ui5_if_client.

    METHODS xml_form
      IMPORTING
        i_page   TYPE REF TO z2ui5_cl_xml_view
        i_client TYPE REF TO z2ui5_if_client.

ENDCLASS.


CLASS z2ui5_cl_demo_app_337 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      get_data( ).


      mo_layout_obj = z2ui5_cl_demo_app_333=>factory( i_data   = REF #( mt_data )
                                                      vis_cols = 5 ).
      mo_layout_obj_2 = z2ui5_cl_demo_app_333=>factory( i_data   = REF #( ms_data )
                                                        vis_cols = 3 ).
      ui5_view_display( client ).
    ENDIF.



    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'GO'.
        DATA(app) = z2ui5_cl_demo_app_336=>factory( ).
        client->nav_app_call( app ).
    ENDCASE.

*    " Kommen wir aus einer anderen APP
*    IF client->get( )-check_on_navigated = abap_true.
*      TRY.
*          " Kommen wir aus einer anderen APP
*          DATA(obj) = CAST z2ui5_cl_demo_app_336( client->get_app( client->get( )-s_draft-id_prev_app ) ).
*          get_data( ).
*        CATCH cx_root.
*      ENDTRY.
*    ENDIF.



    IF client->get( )-check_on_navigated = abap_true
        AND client->check_on_init( )          = abap_false.
      ui5_view_display( client ).
    ENDIF.



    IF mo_layout_obj->mr_data IS NOT BOUND.
      client->message_toast_display( 'ERROR - mo_layout_obj->mr_data is not bound!' ).
    ENDIF.
    IF mo_layout_obj_2->mr_data IS NOT BOUND.
      client->message_toast_display( 'ERROR - mo_layout_obj_2->mr_data  is not bound!' ).
    ENDIF.

    ASSIGN mo_layout_obj->mr_data->* TO FIELD-SYMBOL(<val>).
    IF <val> <> mt_data.
      client->message_toast_display( 'ERROR - mo_layout_obj_2->mr_data  <> mt_data!' ).
    ENDIF.
    ASSIGN mo_layout_obj_2->mr_data->* TO FIELD-SYMBOL(<val2>).
    IF <val2> <> ms_data.
      client->message_toast_display( 'ERROR - mo_layout_obj_2->mr_data  <> ms_data!' ).
    ENDIF.


    client->view_model_update( ).

  ENDMETHOD.

  METHOD ui5_view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell( )->page( title          = 'RTTI IV'
                                                                navbuttonpress = client->_event( 'BACK' )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    page->button( text  = 'CALL Next App'
                  press = client->_event( 'GO' )
                  type  = 'Success' ).

    xml_table( i_page   = page
               i_client = client ).

    xml_form( i_page   = page
              i_client = client ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

  METHOD xml_table.

    DATA(table) = i_page->table( width = 'auto'
                                 items = i_client->_bind_edit( val = mt_data ) ).

    DATA(columns) = table->columns( ).

    LOOP AT mo_layout_obj->ms_data-t_layout REFERENCE INTO DATA(layout).
      DATA(lv_index) = sy-tabix.

      columns->column( visible = i_client->_bind( val       = layout->visible
                                                  tab       = mo_layout_obj->ms_data-t_layout
                                                  tab_index = lv_index )
        )->text( layout->name ).

    ENDLOOP.

    DATA(column_list_item) = columns->get_parent( )->items(
                                       )->column_list_item( valign = 'Middle'
                                                            type   = `Inactive` ).

    DATA(cells) = column_list_item->cells( ).

    LOOP AT mo_layout_obj->ms_data-t_layout REFERENCE INTO layout.

      lv_index = sy-tabix.

      cells->object_identifier( text = |\{{ layout->name }\}| ).  "."|\{{ layout->fname }\}| ).

    ENDLOOP.

  ENDMETHOD.

  METHOD get_data.

    SELECT id,
           id_prev,
           id_prev_app,
           id_prev_app_stack,
           timestampl
      FROM z2ui5_t_01
      INTO CORRESPONDING FIELDS OF TABLE @mt_data
      UP TO 10 ROWS.

    ms_data = VALUE #( mt_data[ 1 ] OPTIONAL ).

  ENDMETHOD.

  METHOD xml_form.

    DATA(form) = i_page->simple_form( editable        = abap_true
                                      layout          = `ResponsiveGridLayout`
                                      adjustlabelspan = abap_true
                                 )->content( ns = `form` ).

    DATA(index) = 0.

    LOOP AT mo_layout_obj->ms_data-t_layout REFERENCE INTO DATA(layout).

      index = index + 1.

      ASSIGN COMPONENT layout->name OF STRUCTURE ms_data TO FIELD-SYMBOL(<value>).
      " assign component layout->name of structure ms_struc to field-symbol(<value>).
      IF <value> IS NOT ASSIGNED.
        RETURN.
      ENDIF.

      DATA(line) = form->label( wrapping = abap_false
                                text     = layout->name ).

      line->input( value   = i_client->_bind( <value> )
                   visible = i_client->_bind( val       = layout->visible
                                              tab       = mo_layout_obj->ms_data-t_layout
                                              tab_index = index )
                   enabled = abap_false ).
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
