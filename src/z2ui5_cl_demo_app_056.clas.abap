CLASS z2ui5_cl_demo_app_056 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        selkz            TYPE abap_bool,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
      END OF ty_s_tab.
    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    DATA mt_table TYPE ty_t_table.
    DATA mt_token TYPE z2ui5_cl_util=>ty_t_token.

    DATA mt_tokens_added TYPE z2ui5_cl_util=>ty_t_token.
    DATA mt_tokens_removed TYPE z2ui5_cl_util=>ty_t_token.

  PROTECTED SECTION.
    DATA mo_client TYPE REF TO z2ui5_if_client.
    DATA mv_check_initialized TYPE abap_bool.
    METHODS on_event.
    METHODS view_display.
    METHODS set_data.

  PRIVATE SECTION.
    DATA mt_range TYPE z2ui5_cl_pop_get_range=>ty_s_result-t_range.
ENDCLASS.

CLASS z2ui5_cl_demo_app_056 IMPLEMENTATION.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `BUTTON_START`.
        set_data( ).
        mo_client->view_model_update( ).
      WHEN `UPDATE_TOKENS`.
        LOOP AT mt_tokens_removed INTO DATA(ls_token).
          DELETE mt_token WHERE key = ls_token-key.
        ENDLOOP.

        LOOP AT mt_tokens_added INTO ls_token.
          INSERT VALUE #( key = ls_token-key text = ls_token-text visible = abap_true editable = abap_true ) INTO TABLE mt_token.
        ENDLOOP.

        CLEAR mt_tokens_removed.
        CLEAR mt_tokens_added.

        mt_range = z2ui5_cl_util=>filter_get_range_t_by_token_t( mt_token ).
        set_data( ).
        mo_client->view_model_update( ).
      WHEN `FILTER_VALUE_HELP`.
        mo_client->nav_app_call( z2ui5_cl_pop_get_range=>factory( mt_range ) ).
    ENDCASE.
  ENDMETHOD.

  METHOD set_data.

    mt_table = VALUE #(
        ( product = `table`    create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `chair`    create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `sofa`     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `computer` create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `oven`     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = `table2`   create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 ) ).

    DELETE mt_table WHERE product NOT IN mt_range.
  ENDMETHOD.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    lo_view = lo_view->shell( )->page( id = `page_main`
             title                  = `abap2UI5 - Select-Options`
             navbuttonpress         = mo_client->_event_nav_app_leave( )
             shownavbutton          = mo_client->check_app_prev_stack( )
        )->get_parent( ).

    DATA(lo_vbox) = lo_view->vbox( ).
    lo_vbox->_z2ui5( )->multiinput_ext(
                       addedtokens   = mo_client->_bind_edit( mt_tokens_added )
                       removedtokens = mo_client->_bind_edit( mt_tokens_removed )
                       change        = mo_client->_event( `UPDATE_TOKENS` )
                       multiinputid  = `MultiInput` ).

    DATA(lo_tab) = lo_vbox->table(
        items = mo_client->_bind( mt_table )
           )->header_toolbar(
             )->overflow_toolbar(
             )->text( `Product:`
             )->multi_input(
                width            = `30%`
                id               = `MultiInput`
                tokens           = mo_client->_bind( mt_token )
                showclearicon    = abap_true
                valuehelprequest = mo_client->_event( `FILTER_VALUE_HELP` )
            )->item(
                    key  = `{KEY}`
                    text = `{TEXT}`
            )->tokens(
                )->token(
                    key      = `{KEY}`
                    text     = `{TEXT}`
                    visible  = `{VISIBLE}`
                    selected = `{SELKZ}`
                    editable = `{EDITABLE}`
                )->get_parent( )->get_parent(
                 )->toolbar_spacer(
               )->button(
        text  = `Go`
        press = mo_client->_event( `BUTTON_START` )
        type  = `Emphasized`
            )->get_parent( )->get_parent( ).

    DATA(lo_columns) = lo_tab->columns( ).
    lo_columns->column( )->text( text = `Product` ).
    lo_columns->column( )->text( text = `Date` ).
    lo_columns->column( )->text( text = `Name` ).
    lo_columns->column( )->text( text = `Location` ).
    lo_columns->column( )->text( text = `Quantity` ).

    DATA(lo_cells) = lo_tab->items( )->column_list_item( ).
    lo_cells->text( `{PRODUCT}` ).
    lo_cells->text( `{CREATE_DATE}` ).
    lo_cells->text( `{CREATE_BY}` ).
    lo_cells->text( `{STORAGE_LOCATION}` ).
    lo_cells->text( `{QUANTITY}` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mv_check_initialized = abap_false.
      mv_check_initialized = abap_true.
      view_display( ).
      RETURN.
    ENDIF.

    IF mo_client->get( )-check_on_navigated = abap_true.
      TRY.
          DATA(lo_value_help) = CAST z2ui5_cl_pop_get_range( mo_client->get_app( mo_client->get( )-s_draft-id_prev_app ) ).
          IF lo_value_help->result( )-check_confirmed = abap_false.
            RETURN.
          ENDIF.

          mt_range = lo_value_help->result( )-t_range.
          mt_token = z2ui5_cl_util=>filter_get_token_t_by_range_t( mt_range ).
          set_data( ).
          mo_client->view_model_update( ).

        CATCH cx_root.
      ENDTRY.
      RETURN.
    ENDIF.

    IF mo_client->get( )-event IS NOT INITIAL.
      on_event( ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
