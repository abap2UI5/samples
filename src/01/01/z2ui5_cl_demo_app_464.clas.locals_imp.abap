"! Local exception of this demo - the sample keeps its own error type so it
"! stays self-contained and does not depend on any other sample class.
CLASS lcx_error DEFINITION INHERITING FROM cx_no_check FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        val TYPE string OPTIONAL
          PREFERRED PARAMETER val.

    METHODS if_message~get_text REDEFINITION.

  PRIVATE SECTION.
    DATA mv_text TYPE string.
ENDCLASS.


CLASS lcx_error IMPLEMENTATION.

  METHOD constructor.

    super->constructor( ).
    CLEAR textid.
    mv_text = val.

  ENDMETHOD.

  METHOD if_message~get_text.

    result = COND #( WHEN mv_text IS INITIAL THEN `UNKNOWN_ERROR` ELSE mv_text ).

  ENDMETHOD.

ENDCLASS.
