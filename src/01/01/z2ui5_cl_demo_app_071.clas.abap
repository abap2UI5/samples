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
    DATA t_combo TYPE STANDARD TABLE OF ty_s_combobox WITH EMPTY KEY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_071 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    CASE client->get( )-event.
      WHEN `UPDATE`.
        client->follow_up_action(
            val   = `SET_SIZE_LIMIT`
            t_arg = VALUE #( ( CONV #( mv_set_size_limit ) ) ( client->cs_view-main ) ) ).
        client->message_toast_display( `SizeLimitUpdated` ).
        RETURN.

      WHEN `UPDATE_MODEL`.
        t_combo = VALUE #( ).
        DO mv_combo_number TIMES.
          INSERT VALUE #( key = sy-index text = sy-index ) INTO TABLE t_combo.
        ENDDO.
        client->message_toast_display( `update number of entries` ).
        client->view_model_update( ).
        RETURN.

    ENDCASE.

    mv_combo_number = 105.
    DO mv_combo_number TIMES.
      INSERT VALUE #( key = sy-index text = sy-index ) INTO TABLE t_combo.
    ENDDO.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
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
