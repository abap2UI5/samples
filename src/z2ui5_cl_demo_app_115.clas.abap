CLASS z2ui5_cl_demo_app_115 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_output TYPE string.

    METHODS display_demo_output
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS Z2UI5_CL_DEMO_APP_115 IMPLEMENTATION.


  METHOD display_demo_output.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    client->view_display( view->shell(
          )->page(
                  title          = 'abap2UI5 - CL_DEMO_OUTPUT - TODO uncomment the source code'
                  navbuttonpress = client->_event( val = 'BACK' )
                  shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
            )->_z2ui5( )->demo_output( mv_output
            )->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.


  ENDMETHOD.
ENDCLASS.
