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
    DATA mt_tokens_added TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.
    DATA mt_tokens_removed TYPE STANDARD TABLE OF ty_s_token WITH EMPTY KEY.
    DATA check_initialized TYPE abap_bool.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_078 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).

      view = view->shell( )->page( id = `page_main`
               title          = 'abap2UI5 - Select-Options'
               navbuttonpress = client->_event( 'BACK' )
               shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
           )->header_content(
               )->link(
                   text = 'Source_Code' target = '_blank' href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
          )->get_parent( ).


      view->_z2ui5( )->multiinput_ext(
                            addedtokens      = client->_bind_edit( mt_tokens_added )
                            removedtokens    = client->_bind_edit( mt_tokens_removed )
                            change    = client->_event( 'UPDATE_BACKEND' )
                            MultiInputId    = `test`  ).

      view->multi_input(
                            id = `test`
                           tokens           = client->_bind_edit( mt_token )
                            showclearicon    = abap_true
                       )->tokens(
                           )->token( key      = `{KEY}`
                                     text     = `{TEXT}`
                                     visible  = `{VISIBLE}`
                                     selected = `{SELKZ}`
                                     editable = `{EDITABLE}`
                                      ).

      DATA(tab) = view->table(
        items = client->_bind_edit( mt_token )
        mode  = 'MultiSelect' ).

      tab->columns(
       )->column(
           )->text( 'KEY' )->get_parent(
       )->column(
           )->text( 'TEXT' ).

      tab->items( )->column_list_item( selected = '{SELKZ}'
        )->cells(
            )->input( value = '{KEY}' enabled = `{EDITABLE}`
            )->input( value = '{TEXT}' enabled = `{EDITABLE}`).

      client->view_display( view->stringify( ) ).

    ENDIF.


    CASE client->get( )-event.

      WHEN 'UPDATE_BACKEND'.

        LOOP AT mt_tokens_removed INTO DATA(ls_token).
          DELETE mt_token WHERE key = ls_token-key.
        ENDLOOP.

        LOOP AT mt_tokens_added INTO ls_token.
          INSERT VALUE #( key = ls_token-key text = ls_token-text visible = abap_true editable = abap_true ) INTO TABLE mt_token.
        ENDLOOP.

        CLEAR mt_tokens_removed.
        CLEAR mt_tokens_added.
        client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
