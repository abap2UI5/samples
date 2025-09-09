CLASS z2ui5_cl_demo_app_329 DEFINITION PUBLIC.

  PUBLIC SECTION.

  INTERFACES if_serializable_object.

  DATA mr_data type ref to data.

    CLASS-METHODS factory
      IMPORTING
        i_data        TYPE ref to data
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_demo_app_329.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_329 IMPLEMENTATION.

  METHOD factory.

    CREATE OBJECT result.

    result->mr_data = i_data.


  ENDMETHOD.

ENDCLASS.

