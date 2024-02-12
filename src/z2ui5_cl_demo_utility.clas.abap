CLASS z2ui5_cl_demo_utility DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS factory
      IMPORTING
        client          TYPE REF TO z2ui5_if_client optional
      RETURNING
        VALUE(r_result) TYPE REF TO z2ui5_cl_demo_utility.

    METHODS app_get_url_source_code
      RETURNING
        VALUE(result) TYPE string.

    METHODS app_get_url
      IMPORTING
        classname TYPE string OPTIONAL
      RETURNING
        VALUE(result)    TYPE string.



  PROTECTED SECTION.

    DATA mi_client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_utility IMPLEMENTATION.

  METHOD factory.

    r_result = new #( ).
    r_result->mi_client = client.

  ENDMETHOD.

  METHOD app_get_url.

    result = z2ui5_cl_util=>app_get_url( classname = classname client = mi_client ).

  ENDMETHOD.

  METHOD app_get_url_source_code.

    result = z2ui5_cl_util=>app_get_url_source_code( mi_client ).

  ENDMETHOD.

ENDCLASS.
