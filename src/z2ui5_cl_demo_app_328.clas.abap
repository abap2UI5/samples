CLASS z2ui5_cl_demo_app_328 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_table TYPE STANDARD TABLE OF z2ui5_t_01.

    DATA mo_table_obj   TYPE REF TO z2ui5_cl_demo_app_330.

    DATA client   TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS ui5_view_display.
ENDCLASS.


CLASS z2ui5_cl_demo_app_328 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      ui5_view_display( ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'BUTTON_POPUP'.

        SELECT * FROM z2ui5_t_01 INTO TABLE @mt_table UP TO 10 ROWS.

        mo_table_obj = z2ui5_cl_demo_app_330=>factory( REF #( mt_table ) ).

        client->nav_app_call( z2ui5_cl_demo_app_329=>factory( mo_table_obj ) ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.

  METHOD ui5_view_display.

    DATA(lo_main) = z2ui5_cl_xml_view=>factory( )->shell( ).
    DATA(page) = lo_main->page( title          = 'abap2UI5 - Popups'
                                navbuttonpress = client->_event( val = 'BACK' )
                                shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(grid) = page->grid( 'L7 M12 S12' )->content( 'layout'
        )->simple_form( 'Popup in new App' )->content( 'form'
        )->label( 'Demo'
        )->button( text  = 'popup with gernic Ref to prev. App'
                   press = client->_event( 'BUTTON_POPUP' ) ).

    client->view_display( lo_main->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
