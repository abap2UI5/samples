CLASS z2ui5_cl_demo_app_333 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.

    TYPES:
      BEGIN OF ty_s_layout,
        name    TYPE string,
        visible TYPE abap_bool,
      END OF ty_s_layout.
    TYPES ty_t_layout TYPE STANDARD TABLE OF ty_s_layout WITH EMPTY KEY.

    TYPES: BEGIN OF ty_s_DATA,
             guid TYPE sysuuid_c32,
           END OF ty_s_DATA.
    TYPES ty_t_DATA TYPE STANDARD TABLE OF ty_s_DATA WITH EMPTY KEY.

    DATA mt_layout TYPE ty_t_layout.
    DATA ms_DATA TYPE ty_s_data.
    DATA mr_data   TYPE REF TO data.

    CLASS-METHODS factory
      IMPORTING
        i_data        TYPE REF TO data
        vis_cols      TYPE int4
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_demo_app_333.

    CLASS-DATA cv_value TYPE c LENGTH 10 VALUE 'STRUCT'.

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
      IF sy-tabix <= vis_cols.
        layout->visible = abap_true.
      ENDIF.

    ENDLOOP.

    TRY.
        result->ms_data-guid = z2ui5_cl_util=>uuid_get_c32( ).
      CATCH cx_root.
    ENDTRY.

    result->mr_data = i_data.

  ENDMETHOD.

ENDCLASS.
