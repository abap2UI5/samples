CLASS lcl_locking DEFINITION CREATE PRIVATE FINAL.
  PUBLIC SECTION.
    CLASS-METHODS acquire_lock.
    CLASS-METHODS get_lock_counter
      RETURNING
        VALUE(result) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_locking IMPLEMENTATION.

  METHOD acquire_lock.

    CALL FUNCTION 'ENQUEUE_E_TABLE'
      EXPORTING
        tabname        = 'ZTEST'
        varkey         = 'Z100'
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(error_text).
      RAISE EXCEPTION TYPE z2ui5_cx_util_error EXPORTING val = error_text.
    ENDIF.

  ENDMETHOD.


  METHOD get_lock_counter.
    DATA: enqueue_table TYPE STANDARD TABLE OF seqg3.

    DATA(argument) = CONV eqegraarg( |ZTEST                         Z100*| ).

    CALL FUNCTION 'ENQUEUE_READ'
      EXPORTING
        garg                  = argument
        guname                = sy-uname
      TABLES
        enq                   = enqueue_table
      EXCEPTIONS
        communication_failure = 1
        system_failure        = 2
        OTHERS                = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(error_text).
      RAISE EXCEPTION TYPE z2ui5_cx_util_error EXPORTING val = error_text.
    ENDIF.

    result = VALUE #( enqueue_table[ 1 ]-gusevb OPTIONAL ).

  ENDMETHOD.

ENDCLASS.
