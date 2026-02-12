CLASS z2ui5_cl_demo_app_341 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    TYPES:
      BEGIN OF ty_s_table,
        value TYPE string,
        index TYPE string,
      END OF ty_s_table.
    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_table WITH EMPTY KEY.

    DATA mo_layout1 TYPE REF TO z2ui5_cl_demo_app_333.
*    DATA mo_layout   type ref to z2ui5_cl_layo_manager .

    METHODS view_display.

    DATA mt_table TYPE ty_t_table.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_341 IMPLEMENTATION.

  METHOD view_display.

    DATA(lo_main) = z2ui5_cl_xml_view=>factory( )->shell( ).
    DATA(lo_page) = lo_main->page( title          = `abap2UI5 - Popups`
                                navbuttonpress = mo_client->_event_nav_app_leave( )
                                shownavbutton  = mo_client->check_app_prev_stack( ) ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lo_grid) = lo_page->grid( `L7 M12 S12` )->content( `layout`
        )->simple_form( `Popups` )->content( `form`
            )->label( `Demo`
            )->button( text  = `Popup to Select`
                       press = mo_client->_event( `BUTTON_POPUP_01` )
            )->label( `Demo`
            )->button( text  = `other Popup`
                       press = mo_client->_event( `BUTTON_POPUP_02` ) ).

    mo_client->view_display( lo_main->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->get( )-check_on_navigated = abap_true.
      view_display( ).

      mt_table = VALUE ty_t_table( index = 1
                                   value = 10
                                   ( )
                                   ( ) ).

    ENDIF.

    CASE mo_client->get( )-event.
      WHEN `BUTTON_POPUP_01`.

        mo_client->nav_app_call( z2ui5_cl_pop_to_select=>factory( i_tab             = mt_table
                                                               i_multiselect     = abap_false
                                                               i_event_confirmed = `POPUP_CONFIRMED`
                                                               i_event_canceled  = `POPUP_CANCEL` ) ).
      WHEN `BUTTON_POPUP_02`.

*        mo_layout = z2ui5_cl_layo_manager=>factory( control = z2ui5_cl_layo_manager=>m_table
*                                                    data    = REF #( mt_table )  ).
*
*        client->nav_app_call( z2ui5_cl_layo_pop=>factory( layout = mo_layout ) ).

        mo_layout1 = z2ui5_cl_demo_app_333=>factory( i_data  = REF #( mt_table )
                                                    vis_cols = 5 ).

        mo_client->nav_app_call( z2ui5_cl_demo_app_340=>factory( io_table  = REF #( mt_table )
                                                              io_layout = mo_layout1 ) ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
