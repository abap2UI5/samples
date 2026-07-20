CLASS z2ui5_cl_demo_app_071 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_combobox,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_combobox.

    DATA mv_set_size_limit TYPE i VALUE 100.
    DATA mv_combo_number TYPE i VALUE 105.
    DATA t_combo TYPE STANDARD TABLE OF ty_s_combobox WITH DEFAULT KEY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_071 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
        DATA temp1 TYPE string_table.
        DATA temp2 TYPE string.
        DATA temp3 LIKE t_combo.
          DATA temp4 TYPE z2ui5_cl_demo_app_071=>ty_s_combobox.
      DATA temp5 TYPE z2ui5_cl_demo_app_071=>ty_s_combobox.
    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.

    CASE client->get( )-event.
      WHEN `UPDATE`.
        
        CLEAR temp1.
        
        temp2 = mv_set_size_limit.
        INSERT temp2 INTO TABLE temp1.
        INSERT client->cs_view-main INTO TABLE temp1.
        client->follow_up_action(
            val   = `SET_SIZE_LIMIT`
            t_arg = temp1 ).
        client->message_toast_display( `SizeLimitUpdated` ).
        RETURN.

      WHEN `UPDATE_MODEL`.
        
        CLEAR temp3.
        t_combo = temp3.
        DO mv_combo_number TIMES.
          
          CLEAR temp4.
          temp4-key = sy-index.
          temp4-text = sy-index.
          INSERT temp4 INTO TABLE t_combo.
        ENDDO.
        client->message_toast_display( `update number of entries` ).
        client->view_model_update( ).
        RETURN.

    ENDCASE.

    mv_combo_number = 105.
    DO mv_combo_number TIMES.
      
      CLEAR temp5.
      temp5-key = sy-index.
      temp5-text = sy-index.
      INSERT temp5 INTO TABLE t_combo.
    ENDDO.

    
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell(
        )->page(
            title          = `abap2UI5 - First Example`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `A ComboBox bound to a large internal table: adjust the model's setSizeLimit to ` &&
                   `control how many of the entries the control actually renders.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->simple_form( title = `Form Title` editable = abap_true
        )->content( `form`
            )->title( `Input`
            )->label( `Link`
            )->label( `setSizeLimit`
            )->input( client->_bind( mv_set_size_limit )
            )->button(
                text  = `update size limit`
                press = client->_event( val = `UPDATE` )
            )->label( `Number of Entries`
            )->input( client->_bind( mv_combo_number )
            )->button(
                text  = `update number entries`
                press = client->_event( val = `UPDATE_MODEL` )
            )->label( `demo`
            )->combobox( items = client->_bind( t_combo )
               )->item( key = `{KEY}` text = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
