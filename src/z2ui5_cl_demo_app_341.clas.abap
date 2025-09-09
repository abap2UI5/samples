CLASS z2ui5_cl_demo_app_341 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA client TYPE REF TO z2ui5_if_client.

    TYPES:
      BEGIN OF ty_s_table,
        value TYPE string,
        index TYPE string,
      END OF ty_s_table.
    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_table WITH DEFAULT KEY.

    DATA mo_layout1 TYPE REF TO z2ui5_cl_demo_app_333.
*    DATA mo_layout   type ref to z2ui5_cl_layo_manager .

    METHODS ui5_view_display.

    DATA mt_table TYPE ty_t_table.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_341 IMPLEMENTATION.

  METHOD ui5_view_display.

    DATA lo_main TYPE REF TO z2ui5_cl_xml_view.
    lo_main = z2ui5_cl_xml_view=>factory( )->shell( ).
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE xsdboolean.
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page = lo_main->page( title          = 'abap2UI5 - Popups'
                                navbuttonpress = client->_event( val = 'BACK' )
                                shownavbutton  = temp1 ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA grid TYPE REF TO z2ui5_cl_xml_view.
    grid = page->grid( 'L7 M12 S12' )->content( 'layout'
        )->simple_form( 'Popups' )->content( 'form'
            )->label( 'Demo'
            )->button( text  = 'Popup to Select'
                       press = client->_event( val = 'BUTTON_POPUP_01' )
            )->label( 'Demo'
            )->button( text  = 'other Popup'
                       press = client->_event( val = 'BUTTON_POPUP_02' ) ).

    client->view_display( lo_main->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->get( )-check_on_navigated = abap_true.
      ui5_view_display( ).

      DATA temp1 TYPE ty_t_table.
      CLEAR temp1.
      DATA temp2 LIKE LINE OF temp1.
      temp2-index = 1.
      temp2-value = 10.
      INSERT temp2 INTO TABLE temp1.
      INSERT temp2 INTO TABLE temp1.
      mt_table = temp1.

    ENDIF.

    CASE client->get( )-event.

      WHEN 'BUTTON_POPUP_01'.

        client->nav_app_call( z2ui5_cl_pop_to_select=>factory( i_tab             = mt_table
                                                               i_multiselect     = abap_false
                                                               i_event_confirmed = 'POPUP_CONFIRMED'
                                                               i_event_canceled  = 'POPUP_CANCEL' ) ).

      WHEN 'BUTTON_POPUP_02'.

*        mo_layout = z2ui5_cl_layo_manager=>factory( control = z2ui5_cl_layo_manager=>m_table
*                                                    data    = REF #( mt_table )  ).
*
*        client->nav_app_call( z2ui5_cl_layo_pop=>factory( layout = mo_layout ) ).

        DATA temp3 LIKE REF TO mt_table.
        GET REFERENCE OF mt_table INTO temp3.
mo_layout1 = z2ui5_cl_demo_app_333=>factory( i_data   = temp3
                                                    vis_cols = 5 ).

        DATA temp4 LIKE REF TO mt_table.
        GET REFERENCE OF mt_table INTO temp4.
client->nav_app_call( z2ui5_cl_demo_app_340=>factory( io_table  = temp4
                                                              io_layout = mo_layout1 ) ).

      WHEN 'BACK'.

        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
