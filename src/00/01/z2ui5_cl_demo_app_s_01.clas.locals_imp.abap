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


CLASS lcl_locking DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_seqg3,
        gname    TYPE c LENGTH 30,   " Elementary Lock of Lock Entry (Table Name)
        garg     TYPE c LENGTH 150,  " Argument String (=Key Fields) of Lock Entry
        gmode    TYPE c LENGTH 1,    " Lock Mode (Shared/Exclusive) of a Lock Entry
        gusr     TYPE c LENGTH 58,   " Lock Owner, ID of Logical Unit of Work (LUW)
        gusrvb   TYPE c LENGTH 58,   " Lock Owner, ID of Logical Unit of Work (LUW) / Update Task
        guse     TYPE int4,          " Cumulative Counter for Lock Entry / Dialog
        gusevb   TYPE int4,          " Cumulative Counter for Lock Entry / Update Task
        gobj     TYPE c LENGTH 16,   " Name of Lock Object in the Lock Entry
        gclient  TYPE c LENGTH 3,    " Client in the lock entry
        guname   TYPE c LENGTH 12,   " User name in lock entry
        gtarg    TYPE c LENGTH 50,   " Argument String of Lock Entry (Table Key Fields)
        gtcode   TYPE c LENGTH 20,   " Transaction Code in the Lock Entry
        gbcktype TYPE c LENGTH 1,    " Backup flag for lock entry
        gthost   TYPE c LENGTH 32,   " Host Name in the Lock Owner ID
        gtwp     TYPE n LENGTH 2,         " Work Process Number in Lock Owner ID
        gtsysnr  TYPE n LENGTH 2,         " SAP System Number in Lock Owner ID
        gtdate   TYPE d,          " Date within lock owner ID
        gttime   TYPE t,          " Time in Lock Owner ID
        gtusec   TYPE n LENGTH 6,         " Time/Microseconds Share in Lock Owner ID
        gtmark   TYPE c LENGTH 1,    " Selection Indicator of Lock Entry
        gusetxt  TYPE n LENGTH 10,        " Cumulative Counter for Lock Entry
        gusevbt  TYPE n LENGTH 10,        " Cumulative Counter for Lock Entry / Update Task
      END OF ty_seqg3.

    CLASS-METHODS acquire_lock.

    CLASS-METHODS get_lock_counter
      RETURNING
        VALUE(result) TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS lcl_locking IMPLEMENTATION.

  METHOD acquire_lock.

    DATA(lv_fm) = 'ENQUEUE_E_TABLE'.
    CALL FUNCTION lv_fm
      EXPORTING
        tabname        = 'ZTEST'
        varkey         = 'Z100'
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(error_text).
      RAISE EXCEPTION TYPE lcx_error EXPORTING val = error_text.
    ENDIF.

  ENDMETHOD.


  METHOD get_lock_counter.
    DATA enqueue_table TYPE STANDARD TABLE OF ty_seqg3.

    DATA argument TYPE c LENGTH 150.
    argument = |ZTEST                         Z100*|.

    DATA(lv_fm) = 'ENQUEUE_READ'.
    CALL FUNCTION lv_fm
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
      RAISE EXCEPTION TYPE lcx_error EXPORTING val = error_text.
    ENDIF.

    result = VALUE #( enqueue_table[ 1 ]-gusevb OPTIONAL ).

  ENDMETHOD.

ENDCLASS.
