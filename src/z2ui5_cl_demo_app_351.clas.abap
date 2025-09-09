CLASS z2ui5_cl_demo_app_351 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_351 IMPLEMENTATION.

    METHOD z2ui5_if_app~main.
        DATA temp3 TYPE REF TO zcl_2ui5_start.
        CREATE OBJECT temp3 TYPE zcl_2ui5_start.
        client->nav_app_call( temp3 ).
    ENDMETHOD.

ENDCLASS.
