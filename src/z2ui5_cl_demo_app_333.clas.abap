CLASS z2ui5_cl_demo_app_333 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.

    TYPES:
      BEGIN OF ty_s_test,
        v1 TYPE abap_bool,
        BEGIN OF test2,
          v2 TYPE abap_bool,
          BEGIN OF test3,
            v3 TYPE abap_bool,
            BEGIN OF test4,
              v4 TYPE abap_bool,
            END OF test4,
          END OF test3,
        END OF test2,
      END OF ty_s_test.
    TYPES ty_t_test TYPE STANDARD TABLE OF ty_s_test WITH DEFAULT KEY.

    TYPES:
      BEGIN OF ty_s_layout,
        name    TYPE string,
        visible TYPE abap_bool,
        s_test  TYPE ty_s_test,
      END OF ty_s_layout.
    TYPES ty_t_layout TYPE STANDARD TABLE OF ty_s_layout WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_s_DATA,
             guid     TYPE sysuuid_c32,
             t_layout TYPE ty_t_layout,
             s_test   TYPE ty_s_test,
           END OF ty_s_DATA.
    TYPES ty_t_DATA TYPE STANDARD TABLE OF ty_s_DATA WITH DEFAULT KEY.

    DATA ms_DATA TYPE ty_s_data.
    DATA mr_data TYPE REF TO data.

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

    CREATE OBJECT result.

    DATA t_comp TYPE abap_component_tab.
    t_comp = z2ui5_cl_util=>rtti_get_t_attri_by_any( i_data  ).

    DATA index TYPE i.
    index = 0.

    DATA comp LIKE LINE OF t_comp.
    LOOP AT t_comp INTO comp.

      index = index + 1.

      DATA layout TYPE REF TO z2ui5_cl_demo_app_333=>ty_s_layout.
      APPEND INITIAL LINE TO result->ms_data-t_layout REFERENCE INTO layout.

      layout->name = comp-name.
      IF index <= vis_cols.
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
