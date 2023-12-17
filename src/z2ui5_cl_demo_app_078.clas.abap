CLASS z2ui5_cl_demo_app_078 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

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
    DATA mt_token          TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.
    DATA check_initialized TYPE abap_bool.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_078 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).

      view = view->shell( )->page( id = `page_main`
               title          = 'abap2UI5 - Select-Options'
               navbuttonpress = client->_event( 'BACK' )
               shownavbutton  = abap_true
           )->header_content(
               )->link(
                   text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
          )->get_parent( ).


      view->multi_input( tokens           = client->_bind_edit( mt_token )
                                showclearicon    = abap_true
                                value            = client->_bind_edit( mv_value )
*                                submit           = client->_event( 'SUBMIT' )
*                                tokenupdate      = client->_event( 'SUBMIT' )
                                submit       = client->_event( val    = 'SUBMIT'
                                                    t_arg  = VALUE #(
                                                                ( `$source` )
                                                                ( `$event` )
*                                                                ( `$event.mParameters.type` )
*                                                                ( `$event.mParameters.addedTokens[0].mProperties.key` )
*                                                               ( `$event.mParameters.addedTokens[1].mProperties.key` )
*                                                               ( `$event.mParameters.addedTokens[2].mProperties.key` )
*                                                               ( `$event.mParameters.removedTokens[0].mProperties.key` )
*                                                               ( `$event.mParameters.removedTokens[1].mProperties.key` )
*                                                               ( `$event.mParameters.removedTokens[2].mProperties.key` )
*                                                               ( `$event.mParameters.removedTokens[3].mProperties.key` )


                                                              ) )


                                valuehelprequest = client->_event( 'FILTER_VALUE_HELP' )
                       )->item( key  = `{KEY}`
                                text = `{TEXT}`
                       )->tokens(
                           )->token( key      = `{KEY}`
                                     text     = `{TEXT}`
                                     visible  = `{VISIBLE}`
                                     selected = `{SELKZ}`
                                     editable = `{EDITABLE}` ).

      client->view_display( view->stringify( ) ).

    ENDIF.


    CASE client->get( )-event.

      WHEN 'SUBMIT'.

        DATA(lt_event_arg) = client->get( )-t_event_arg.
        IF lt_event_arg IS NOT INITIAL.


          DATA(lv_token_upd_type) = lt_event_arg[ 2 ].
          DATA(lv_token_key) = lt_event_arg[ 3 ].

          IF lv_token_upd_type = `removed`.
            DELETE mt_token WHERE key = lv_token_key.
          ELSE.


          ENDIF.

        ELSE.
          INSERT VALUE #( key = mv_value text = mv_value visible = abap_true editable = abap_true ) INTO TABLE mt_token.
        ENDIF.

        CLEAR mv_value.
        client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
