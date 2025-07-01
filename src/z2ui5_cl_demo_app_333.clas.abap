CLASS z2ui5_cl_demo_app_333 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.

    TYPES:
      BEGIN OF ty_s_layout,
        name    TYPE string,
        visible TYPE abap_bool,
      END OF ty_s_layout.
    TYPES ty_t_layout TYPE STANDARD TABLE OF ty_s_layout WITH EMPTY KEY.

    DATA mt_layout TYPE ty_t_layout.
    DATA mr_data   TYPE REF TO data.

    CLASS-METHODS factory
      IMPORTING
        i_data        TYPE REF TO data
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_demo_app_333.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_333 IMPLEMENTATION.

  METHOD factory.

    result = NEW #( ).

    DATA(t_comp) = z2ui5_cl_util=>rtti_get_t_attri_by_any( i_data  ).

    LOOP AT t_comp INTO DATA(comp).

      APPEND INITIAL LINE TO result->mt_layout REFERENCE INTO DATA(layout).

      layout->name = comp-name.
      IF sy-tabix < 4.
        layout->visible = abap_true.
      ENDIF.

    ENDLOOP.

    result->mr_data = i_data.

  ENDMETHOD.

ENDCLASS.
