CLASS z2ui5_cl_demo_app_193 DEFINITION PUBLIC.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_s_key_value,
        fname   TYPE char30,
        value   TYPE string,
        tabname TYPE char30,
        comp    TYPE abap_componentdescr,
      END OF ty_s_key_value,
      ty_t_key_values TYPE STANDARD TABLE OF ty_s_key_value WITH EMPTY KEY.

    DATA:
      mt_kopf  TYPE REF TO data,
      mt_pos   TYPE REF TO data,
      mt_keyva TYPE ty_t_key_values.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_193 IMPLEMENTATION.


ENDCLASS.
