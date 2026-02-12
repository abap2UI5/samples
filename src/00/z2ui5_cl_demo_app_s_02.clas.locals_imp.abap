CLASS lcl_static_container DEFINITION CREATE PRIVATE FINAL.
  PUBLIC SECTION.
    CLASS-DATA mv_counter TYPE i READ-ONLY.
    CLASS-METHODS increment
      RETURNING
        VALUE(result) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_static_container IMPLEMENTATION.
  METHOD increment.

    mv_counter = mv_counter + 1.
    result = mv_counter.
  ENDMETHOD.
ENDCLASS.
