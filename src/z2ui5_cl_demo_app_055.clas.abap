CLASS z2ui5_cl_demo_app_055 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        count    TYPE i,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        checkbox TYPE abap_bool,
      END OF ty_row.

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    METHODS refresh_data.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_055 IMPLEMENTATION.


  METHOD refresh_data.

    DO 100 TIMES.
      DATA(ls_row) = VALUE ty_row( count = sy-index  value = 'red'
        info = COND #( WHEN sy-index < 50 THEN 'completed' ELSE 'uncompleted' )
        descr = 'this is a description' checkbox = abap_true ).
      INSERT ls_row INTO TABLE t_tab.
    ENDDO.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.



  ENDMETHOD.
ENDCLASS.
