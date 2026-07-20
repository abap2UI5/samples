CLASS z2ui5_cl_demo_app_078 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_token,
        key      TYPE string,
        text     TYPE string,
        visible  TYPE abap_bool,
        selkz    TYPE abap_bool,
        editable TYPE abap_bool,
      END OF ty_s_token.

    DATA mv_value          TYPE string.
    DATA mt_token          TYPE STANDARD TABLE OF ty_s_token WITH DEFAULT KEY.
    DATA mt_tokens_added TYPE STANDARD TABLE OF ty_s_token WITH DEFAULT KEY.
    DATA mt_tokens_removed TYPE STANDARD TABLE OF ty_s_token WITH DEFAULT KEY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_078 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA view TYPE REF TO z2ui5_cl_xml_view.
      DATA tab TYPE REF TO z2ui5_cl_xml_view.
        DATA ls_token LIKE LINE OF mt_tokens_removed.
          DATA temp1 TYPE z2ui5_cl_demo_app_078=>ty_s_token.
        DATA temp2 LIKE mt_tokens_removed.
        DATA temp3 LIKE mt_tokens_added.

    IF client->check_on_init( ) IS NOT INITIAL.

      
      view = z2ui5_cl_xml_view=>factory( ).

      view           = view->shell( )->page( id = `page_main`
      title          = `abap2UI5 - Multi Input (Select-Options)`
      navbuttonpress = client->_event_nav_app_leave( )
      shownavbutton  = client->check_app_prev_stack( ) ).

      view->message_strip(
          text     = `The multiinput_ext custom control extends a sap.m.MultiInput so that added and removed ` &&
                     `tokens are reported back to ABAP, where the token table and the linked list are updated.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiSmallMargin` ).

      view->_z2ui5( )->multiinput_ext(
                            addedtokens   = client->_bind( mt_tokens_added )
                            removedtokens = client->_bind( mt_tokens_removed )
                            change        = client->_event( `UPDATE_BACKEND` )
                            multiinputid  = `test` ).

      view->multi_input(
                            id            = `test`
                            tokens        = client->_bind( mt_token )
                            showclearicon = abap_true
                       )->tokens(
                           )->token( key      = `{KEY}`
                                     text     = `{TEXT}`
                                     visible  = `{VISIBLE}`
                                     selected = `{SELKZ}`
                                     editable = `{EDITABLE}` ).

      
      tab = view->table(
        items = client->_bind( mt_token )
        mode  = `MultiSelect` ).

      tab->columns(
        )->column(
           )->text( `KEY` )->get_parent(
        )->column(
           )->text( `TEXT` ).

      tab->items( )->column_list_item( selected = `{SELKZ}`
        )->cells(
            )->input( value   = `{KEY}`
                      enabled = `{EDITABLE}`
            )->input( value   = `{TEXT}`
                      enabled = `{EDITABLE}`).

      client->view_display( view->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.

      WHEN `UPDATE_BACKEND`.

        
        LOOP AT mt_tokens_removed INTO ls_token.
          DELETE mt_token WHERE key = ls_token-key.
        ENDLOOP.

        LOOP AT mt_tokens_added INTO ls_token.
          
          CLEAR temp1.
          temp1-key = ls_token-key.
          temp1-text = ls_token-text.
          temp1-visible = abap_true.
          temp1-editable = abap_true.
          INSERT temp1 INTO TABLE mt_token.
        ENDLOOP.

        
        CLEAR temp2.
        mt_tokens_removed = temp2.
        
        CLEAR temp3.
        mt_tokens_added   = temp3.
        client->view_model_update( ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
