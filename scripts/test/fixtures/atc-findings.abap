CLASS zcl_fixture_atc DEFINITION PUBLIC.
  PUBLIC SECTION.
    "! Reads a value.
    "! @raising cx_sy_conversion_error | never declared below
    METHODS read
      RETURNING
        VALUE(result) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_fixture_atc IMPLEMENTATION.

  METHOD read.

    DATA lt_rows TYPE STANDARD TABLE OF t100 WITH EMPTY KEY.
    SELECT * FROM t100 INTO TABLE @lt_rows ORDER BY PRIMARY KEY.
    ASSIGN (`LT_ROWS`) TO FIELD-SYMBOL(<rows>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    result = to_upper( 'Save'(001) ).

  ENDMETHOD.

ENDCLASS.
