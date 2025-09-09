CLASS z2ui5_cl_demo_app_336 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    METHODS ui5_view_display
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.


    DATA ms_struc        TYPE z2ui5_t_01.
    DATA mo_layout_obj   TYPE REF TO z2ui5_cl_demo_app_333.
    DATA mo_layout_obj_2 TYPE REF TO z2ui5_cl_demo_app_333.

    CLASS-METHODS factory
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_demo_app_336.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_336 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ) IS NOT INITIAL.

      DATA temp1 LIKE REF TO ms_struc.
      GET REFERENCE OF ms_struc INTO temp1.
mo_layout_obj = z2ui5_cl_demo_app_333=>factory( i_data = temp1 vis_cols = 3 ).
      DATA temp2 LIKE REF TO ms_struc.
      GET REFERENCE OF ms_struc INTO temp2.
mo_layout_obj_2 = z2ui5_cl_demo_app_333=>factory( i_data = temp2 vis_cols = 3 ).

      ui5_view_display( client ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'BACK'.

        client->nav_app_leave( ).

    ENDCASE.

    client->view_model_update( ).

  ENDMETHOD.

  METHOD ui5_view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell( )->page( title          = 'RTTI IV'
                                                                navbuttonpress = client->_event( 'BACK' )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    page->button( text  = 'BACK'
                  press = client->_event( 'BACK' )
                  type  = 'Success' ).

    client->view_display( page ).

  ENDMETHOD.



  METHOD factory.

    CREATE OBJECT result.

  ENDMETHOD.

ENDCLASS.
