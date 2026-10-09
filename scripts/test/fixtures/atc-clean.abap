CLASS zcl_fixture_atc_clean DEFINITION PUBLIC.
  PUBLIC SECTION.
    "! Reads a value.
    "! @raising cx_sy_conversion_error | declared below
    METHODS read
      RETURNING
        VALUE(result) TYPE string
      RAISING
        cx_sy_conversion_error.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_fixture_atc_clean IMPLEMENTATION.

  METHOD read.

    DATA lt_rows TYPE STANDARD TABLE OF t100 WITH EMPTY KEY.
    DATA ls_row TYPE t100.
    SELECT * FROM t100 INTO TABLE @lt_rows ORDER BY PRIMARY KEY. "#EC CI_NOWHERE
    SELECT * FROM t100 WHERE sprsl = @sy-langu INTO TABLE @lt_rows ORDER BY PRIMARY KEY.
    ASSIGN COMPONENT `TEXT`
      OF STRUCTURE ls_row TO FIELD-SYMBOL(<text>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    DATA(lv_text) = 'Save'(001).
    result = |{ 'Save'(001) }| && lv_text.

  ENDMETHOD.

ENDCLASS.
