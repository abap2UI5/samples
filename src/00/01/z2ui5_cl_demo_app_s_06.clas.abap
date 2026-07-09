CLASS z2ui5_cl_demo_app_s_06 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_s_06 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    client->nav_app_call( NEW zcl_2ui5_start( ) ).

  ENDMETHOD.

ENDCLASS.
