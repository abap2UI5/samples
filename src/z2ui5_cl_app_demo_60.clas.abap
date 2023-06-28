CLASS z2ui5_cl_app_demo_60 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mt_draft TYPE STANDARD TABLE OF z2ui5_t_draft.

    TYPES:
      BEGIN OF ty_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        checkbox TYPE abap_bool,
      END OF ty_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA mv_Counter TYPE i.
    DATA mv_key TYPE string.

    TYPES:
      BEGIN OF s_suggestion_items,
        value TYPE string,
        descr TYPE string,
      END OF s_suggestion_items.
    DATA mt_suggestion TYPE STANDARD TABLE OF s_suggestion_items WITH EMPTY KEY.

    DATA input TYPE string.
  PROTECTED SECTION.


    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.


    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_app_demo_60 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client     = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).
      z2ui5_view_display( ).
    ENDIF.

    IF client->get( )-event IS NOT INITIAL.
      z2ui5_on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.

      when 'SUGGEST'.

           SELECT FROM z2ui5_t_draft
        FIELDS uname, uuid, uuid_prev, uuid_prev_app, timestampl
*         where timestampl cs @input.

            INTO CORRESPONDING FIELDS OF TABLE @mt_draft.


      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-id_prev_app_stack ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

  ENDMETHOD.


  METHOD z2ui5_view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( client )->shell(
      )->page(
         title          = 'abap2UI5 - Selection-Screen Example'
         navbuttonpress = client->_event( 'BACK' )
           shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code'  target = '_blank' href = page->hlp_get_source_code_url(  )
         )->get_parent( ).

    DATA(grid) = page->grid( 'L6 M12 S12'
        )->content( 'layout' ).

    DATA(input) = grid->simple_form( 'Input'
        )->content( 'form'
            )->label( 'Input with value help'
            )->input(
                    value           = client->_bind_edit( input )
                    placeholder     = 'fill in your favorite name'
                    suggest         = client->_event( 'SUGGEST' )
                    showTableSuggestionValueHelp = abap_false
*                    valueHelpRequest = client->_event( 'SUGGEST' )
                    suggestionrows  = client->_bind( mt_draft )
                    showsuggestion  = abap_true
                 )->get( ).

    input->suggestion_columns(

          )->Column(  )->label( text = 'TIME'
            )->get_parent(
        )->Column(  )->label( text = 'UNAME'
        )->get_parent(
             )->Column(  )->label( text = 'UUID'
        )->get_parent(
        )->Column(  )->label( text = 'UUID_PREV'
     ).

    input->suggestion_rows(
        )->column_list_item(
            )->label( text = '{TIMESTAMPL}'
            )->label( text = '{UNAME}'
            )->label( text = '{UUID}'
            )->label( text = '{UUID_PREV}'
            )->label( text = '{UUID_PREV}'
    ).
*                    )->list_item(
*                        text = '{UNAME}'
*                        additionaltext = '{UNAME}'
*                         ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
