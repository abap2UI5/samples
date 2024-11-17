CLASS z2ui5_cl_demo_app_044 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES Z2UI5_if_app.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_044 IMPLEMENTATION.

  METHOD Z2UI5_if_app~main.
    client->view_display( z2ui5_cl_xml_view=>factory( )->label( `Hello World!` )->stringify( ) ).
  ENDMETHOD.

ENDCLASS.
