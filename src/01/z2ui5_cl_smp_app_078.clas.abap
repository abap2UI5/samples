" @keywords multiinput token tokens suggestion custom control
" @summary A MultiInput with tokens and suggestions bound to an internal table - the value help for a field that holds many values at once.
" @docs https://abap2ui5.github.io/docs/cookbook/expert_more/value_help
CLASS z2ui5_cl_smp_app_078 DEFINITION PUBLIC.

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

    DATA mt_token          TYPE STANDARD TABLE OF ty_s_token WITH DEFAULT KEY.
    DATA mt_tokens_added TYPE STANDARD TABLE OF ty_s_token WITH DEFAULT KEY.
    DATA mt_tokens_removed TYPE STANDARD TABLE OF ty_s_token WITH DEFAULT KEY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_078 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA tab TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA ls_token LIKE LINE OF mt_tokens_removed.
        DATA temp1 TYPE z2ui5_cl_smp_app_078=>ty_s_token.
      DATA temp2 LIKE mt_tokens_removed.
      DATA temp3 LIKE mt_tokens_added.

    IF client->check_on_navigated( ) IS NOT INITIAL.

      
      view = z2ui5_cl_ui5_view_builder=>factory(
          )->ele( n = `View` ns = `mvc`
              )->a( n = `displayBlock` v = `true`
              )->a( n = `height`       v = `100%`
              )->a( n = `xmlns`        v = `sap.m`
              )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
              )->a( n = `xmlns:core`   v = `sap.ui.core`
              )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc` ).

      view           = view->ele( `Shell`
          )->ele( `Page`
              )->a( n = `title`          v = `abap2UI5 - Control Behaviour - MultiInput with Tokens`
              )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
              )->a( n = `navButtonPress` v = client->_event_nav_app_leave( )
              )->a( n = `id`             v = `page_main` ).

      view->tag( `MessageStrip`
          )->a( n = `text` v = `The multiinput_ext custom control extends a sap.m.MultiInput so that added and removed ` &&
                     `tokens are reported back to ABAP, where the token table and the linked list are updated.`
          )->a( n = `type`     v = `Information`
          )->a( n = `showIcon` b = abap_true
          )->a( n = `class`    v = `sapUiSmallMargin` ).

      view->tag( n = `MultiInputExt` ns = `z2ui5`
          )->a( n = `MultiInputId`  v = `test`
          )->a( n = `change`        v = client->_event( `UPDATE_BACKEND` )
          )->a( n = `addedTokens`   v = client->_bind( mt_tokens_added )
          )->a( n = `removedTokens` v = client->_bind( mt_tokens_removed ) ).

      view->ele( `MultiInput`
          )->a( n = `tokens` v = client->_bind( mt_token )
          )->a( n = `id`     v = `test`
          )->ele( `tokens`
              )->tag( `Token`
                  )->a( n = `key`      v = `{KEY}`
                  )->a( n = `text`     v = `{TEXT}`
                  )->a( n = `selected` v = `{SELKZ}`
                  )->a( n = `visible`  v = `{VISIBLE}`
                  )->a( n = `editable` v = `{EDITABLE}` ).

      
      tab = view->ele( `Table`
          )->a( n = `items` v = client->_bind( mt_token )
          )->a( n = `mode`  v = `MultiSelect` ).

      tab->ele( `columns`
          )->ele( `Column`
              )->tag( `Text`
                  )->a( n = `text` v = `KEY`
          )->end(
          )->ele( `Column`
              )->tag( `Text`
                  )->a( n = `text` v = `TEXT` ).

      tab->ele( `items`
          )->ele( `ColumnListItem`
              )->a( n = `selected` v = `{SELKZ}`
              )->ele( `cells`
                  )->tag( `Input`
                      )->a( n = `enabled` v = `{EDITABLE}`
                      )->a( n = `value`   v = `{KEY}`
                  )->tag( `Input`
                      )->a( n = `enabled` v = `{EDITABLE}`
                      )->a( n = `value`   v = `{TEXT}` ).

      client->view_display( view->stringify( ) ).

    ENDIF.

    IF client->get_event( ) = `UPDATE_BACKEND`.
      
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
    ENDIF.

  ENDMETHOD.
ENDCLASS.
