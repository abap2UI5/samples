CLASS z2ui5_cl_smp_app_333 DEFINITION PUBLIC.

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

    TYPES:
      BEGIN OF ty_s_layout,
        name    TYPE string,
        visible TYPE abap_bool,
        s_test  TYPE ty_s_test,
      END OF ty_s_layout.
    TYPES ty_t_layout TYPE STANDARD TABLE OF ty_s_layout WITH EMPTY KEY.

    TYPES: BEGIN OF ty_s_data,
             guid     TYPE sysuuid_c32,
             t_layout TYPE ty_t_layout,
             s_test   TYPE ty_s_test,
           END OF ty_s_data.

    DATA ms_data TYPE ty_s_data.
    DATA mr_data TYPE REF TO data.

    CLASS-METHODS factory
      IMPORTING
        i_data        TYPE REF TO data
        vis_cols      TYPE int4
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_smp_app_333.

  PROTECTED SECTION.
    " CL_SYSTEM_UUID is the ABAP Cloud way, GUID_CREATE the classic one.
    " Called dynamically so the one that is missing on a system is a caught
    " runtime error instead of a syntax error at activation.
    CLASS-METHODS uuid_get_c32
      RETURNING
        VALUE(result) TYPE sysuuid_c32.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_333 IMPLEMENTATION.


  METHOD factory.

    DATA lo_struct TYPE REF TO cl_abap_structdescr.

    result = NEW #( ).

    " the factory is called with a reference to a structure or to a table -
    " in both cases the layout describes the components of ONE line
    DATA(lo_type) = cl_abap_typedescr=>describe_by_data_ref( i_data ).
    IF lo_type->kind = cl_abap_typedescr=>kind_table.
      lo_struct = CAST #( CAST cl_abap_tabledescr( lo_type )->get_table_line_type( ) ).
    ELSE.
      lo_struct = CAST #( lo_type ).
    ENDIF.

    DATA(t_comp) = lo_struct->get_components( ).

    DATA(index) = 0.

    LOOP AT t_comp INTO DATA(comp).

      index = index + 1.

      APPEND INITIAL LINE TO result->ms_data-t_layout REFERENCE INTO DATA(layout).

      layout->name = comp-name.

      IF index <= vis_cols.
        layout->visible = abap_true.
      ENDIF.

    ENDLOOP.

    TRY.
        result->ms_data-guid = uuid_get_c32( ).
      CATCH cx_root.
    ENDTRY.

    result->mr_data = i_data.

  ENDMETHOD.


  METHOD uuid_get_c32.

    DATA lv_uuid  TYPE c LENGTH 32.
    DATA lv_class TYPE string.
    DATA lv_fm    TYPE string.

    TRY.
        lv_class = `CL_SYSTEM_UUID`.
        CALL METHOD (lv_class)=>if_system_uuid_static~create_uuid_c32
          RECEIVING
            uuid = lv_uuid.

      CATCH cx_root.
        lv_fm = `GUID_CREATE`.
        CALL FUNCTION lv_fm
          IMPORTING
            ev_guid_32 = lv_uuid.
    ENDTRY.

    result = lv_uuid.

  ENDMETHOD.
ENDCLASS.
