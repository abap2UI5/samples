CLASS z2ui5_cl_demo_app_330 DEFINITION PUBLIC.

  PUBLIC SECTION.

  INTERFACES if_serializable_object.

  DATA mr_table_data type ref to data.

    CLASS-METHODS factory
      IMPORTING
        i_TABLE_data        TYPE ref to data
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_demo_app_330.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_330 IMPLEMENTATION.

  METHOD factory.

    result = NEW #( ).

    result->mr_table_data = i_table_data.

  ENDMETHOD.

ENDCLASS.
