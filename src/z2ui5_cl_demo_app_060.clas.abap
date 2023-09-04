CLASS z2ui5_cl_demo_app_060 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mt_suggestion TYPE STANDARD TABLE OF I_CurrencyText.
    DATA input TYPE string.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_event.
    METHODS z2ui5_view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_cl_demo_app_060 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_view_display( ).
    ENDIF.

    IF client->get( )-event IS NOT INITIAL.
      z2ui5_on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.

      WHEN 'ON_SUGGEST'.

        DATA lt_range TYPE RANGE OF string.
        lt_range = VALUE #( (  sign = 'I' option = 'CP' low = `*` && input && `*` ) ).

        SELECT FROM I_CurrencyText
          FIELDS *
          WHERE CurrencyName IN @lt_range
          AND  Language = 'E'
          INTO CORRESPONDING FIELDS OF TABLE @mt_suggestion.

       client->view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( client )->shell( )->page(
       title          = 'abap2UI5 - Live Suggestion Event'
       navbuttonpress = client->_event( 'BACK' )
       shownavbutton  = abap_true ).

    page->header_content(
             )->link( text = 'Demo'        target = '_blank' href = `https://twitter.com/abap2UI5/status/1675074394710765568`
             )->link( text = 'Source_Code' target = '_blank' href = page->hlp_get_source_code_url( )
         )->get_parent( ).

    DATA(grid) = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).

    DATA(input) = grid->simple_form( 'Input'
        )->content( 'form'
            )->label( 'Input with value help'
            )->input(
                    value           = client->_bind_edit( input )
                    suggest         = client->_event( 'ON_SUGGEST' )
                    showTableSuggestionValueHelp = abap_false
                    suggestionrows  = client->_bind( mt_suggestion )
                    showsuggestion  = abap_true
                    valueLiveUpdate = abap_true
                    autocomplete    = abap_false
                 )->get( ).

    input->suggestion_columns(
        )->Column(  )->label( text = 'Name' )->get_parent(
        )->Column(  )->label( text = 'Currency' ).

    input->suggestion_rows(
        )->column_list_item(
            )->label( text = '{CURRENCYNAME}'
            )->label( text = '{CURRENCY}' ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
