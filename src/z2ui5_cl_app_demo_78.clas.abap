CLASS z2ui5_cl_app_demo_78 DEFINITION
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
      END OF ty_S_token.

    DATA mv_value          TYPE string.
    DATA mt_token          TYPE STANDARD TABLE OF ty_S_token WITH EMPTY KEY.
    DATA check_initialized TYPE abap_bool.
protected section.
private section.
ENDCLASS.



CLASS Z2UI5_CL_APP_DEMO_78 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      DATA(view) = z2ui5_cl_xml_view=>factory( client )->page( title = 'Multi Input'
               )->multi_input( tokens           = client->_bind_edit( mt_token )
                               showclearicon    = abap_true
                               value            = client->_bind_edit( mv_value )
                               submit           = client->_event( 'SUBMIT' )
                               tokenupdate      = client->_event( 'SUBMIT' )
*                               valueHelpRequest = client->_event( 'FILTER_VALUE_HELP' )
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
        INSERT VALUE #( key = mv_value text = mv_value visible = abap_true editable = abap_true ) INTO TABLE mt_token.
        CLEAR mv_value.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
