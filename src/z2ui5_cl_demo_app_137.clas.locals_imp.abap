CLASS lcl_static_container DEFINITION FINAL CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-DATA counter TYPE i READ-ONLY.

    CLASS-METHODS increment
      RETURNING
        VALUE(result) TYPE i.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS lcl_static_container IMPLEMENTATION.

  METHOD increment.
    counter = counter + 1.
    result = counter.
  ENDMETHOD.

ENDCLASS.
