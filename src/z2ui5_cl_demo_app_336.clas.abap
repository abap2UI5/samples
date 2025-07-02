CLASS z2ui5_cl_demo_app_336 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    METHODS ui5_view_display
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.


    CLASS-METHODS factory
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_demo_app_336.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_336 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      ui5_view_display( client ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'BACK'.

        client->nav_app_leave( ).

    ENDCASE.

    client->view_model_update( ).

  ENDMETHOD.

  METHOD ui5_view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell( )->page( title          = 'RTTI IV'
                                                                navbuttonpress = client->_event( 'BACK' )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    page->button( text  = 'BACK'
                  press = client->_event( 'BACK' )
                  type  = 'Success' ).

    client->view_display( page ).

  ENDMETHOD.



  METHOD factory.

    result = NEW #( ).

  ENDMETHOD.

ENDCLASS.
