CLASS ltcl_subtotals DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    DATA cut TYPE REF TO z2ui5_cl_smp_app_544.

    METHODS setup.
    METHODS group_by
      IMPORTING
        t_group_by TYPE string_table
      CHANGING
        t_rows     TYPE z2ui5_cl_smp_app_544=>ty_t_sales.

    METHODS test_nothing_grouped FOR TESTING.
    METHODS test_unknown_column_ignored FOR TESTING.
    METHODS test_subtotal_per_group FOR TESTING.
    METHODS test_currencies_not_mixed FOR TESTING.
    METHODS test_two_levels FOR TESTING.

ENDCLASS.


CLASS ltcl_subtotals IMPLEMENTATION.

  METHOD setup.

    CREATE OBJECT cut.

  ENDMETHOD.


  METHOD group_by.

    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    CLEAR temp1.
    INSERT `AMOUNT` INTO TABLE temp1.
    INSERT `QUANTITY` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `CURRENCY` INTO TABLE temp2.
    cut->subtotals_add( EXPORTING group_by     = t_group_by
                                  value_fields = temp1
                                  unit_fields  = temp2
                                  kind_field   = `KIND`
                        CHANGING  rows         = t_rows ).

  ENDMETHOD.


  METHOD test_nothing_grouped.

    DATA temp3 TYPE z2ui5_cl_smp_app_544=>ty_t_sales.
    DATA temp4 LIKE LINE OF temp3.
    DATA t_rows LIKE temp3.
    DATA t_before LIKE t_rows.
    DATA temp5 TYPE string_table.
    CLEAR temp3.
    
    temp4-region = `B`.
    temp4-product = `P1`.
    temp4-amount = 5.
    temp4-currency = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    temp4-region = `A`.
    temp4-product = `P2`.
    temp4-amount = 10.
    temp4-currency = `EUR`.
    INSERT temp4 INTO TABLE temp3.
    
    t_rows = temp3.
    
    t_before = t_rows.

    
    CLEAR temp5.
    group_by( EXPORTING t_group_by = temp5
              CHANGING  t_rows     = t_rows ).

    cl_abap_unit_assert=>assert_equals( exp = t_before
                                        act = t_rows ).

  ENDMETHOD.


  METHOD test_unknown_column_ignored.

    DATA temp6 TYPE z2ui5_cl_smp_app_544=>ty_t_sales.
    DATA temp7 LIKE LINE OF temp6.
    DATA t_rows LIKE temp6.
    DATA t_before LIKE t_rows.
    DATA temp8 TYPE string_table.
    CLEAR temp6.
    
    temp7-region = `A`.
    temp7-product = `P1`.
    temp7-amount = 10.
    temp7-currency = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    
    t_rows = temp6.
    
    t_before = t_rows.

    
    CLEAR temp8.
    INSERT `NOPE` INTO TABLE temp8.
    group_by( EXPORTING t_group_by = temp8
              CHANGING  t_rows     = t_rows ).

    cl_abap_unit_assert=>assert_equals( exp = t_before
                                        act = t_rows ).

  ENDMETHOD.


  METHOD test_subtotal_per_group.

    DATA temp10 TYPE z2ui5_cl_smp_app_544=>ty_t_sales.
    DATA temp11 LIKE LINE OF temp10.
    DATA t_rows LIKE temp10.
    DATA temp12 TYPE string_table.
    DATA temp14 TYPE z2ui5_cl_smp_app_544=>ty_t_sales.
    DATA temp15 LIKE LINE OF temp14.
    CLEAR temp10.
    
    temp11-region = `A`.
    temp11-product = `P1`.
    temp11-quantity = 1.
    temp11-amount = 10.
    temp11-currency = `EUR`.
    INSERT temp11 INTO TABLE temp10.
    temp11-region = `B`.
    temp11-product = `P2`.
    temp11-quantity = 2.
    temp11-amount = 5.
    temp11-currency = `EUR`.
    INSERT temp11 INTO TABLE temp10.
    temp11-region = `A`.
    temp11-product = `P3`.
    temp11-quantity = 3.
    temp11-amount = 20.
    temp11-currency = `EUR`.
    INSERT temp11 INTO TABLE temp10.
    
    t_rows = temp10.

    " in lower case, as a column name may come from the browser
    
    CLEAR temp12.
    INSERT `region` INTO TABLE temp12.
    group_by( EXPORTING t_group_by = temp12
              CHANGING  t_rows     = t_rows ).

    " the rows keep the order they came in within a group
    
    CLEAR temp14.
    
    temp15-region = `A`.
    temp15-product = `P1`.
    temp15-quantity = 1.
    temp15-amount = 10.
    temp15-currency = `EUR`.
    temp15-kind = ``.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `A`.
    temp15-product = `P3`.
    temp15-quantity = 3.
    temp15-amount = 20.
    temp15-currency = `EUR`.
    temp15-kind = ``.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `A`.
    temp15-product = ``.
    temp15-quantity = 4.
    temp15-amount = 30.
    temp15-currency = `EUR`.
    temp15-kind = `S`.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `B`.
    temp15-product = `P2`.
    temp15-quantity = 2.
    temp15-amount = 5.
    temp15-currency = `EUR`.
    temp15-kind = ``.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = `B`.
    temp15-product = ``.
    temp15-quantity = 2.
    temp15-amount = 5.
    temp15-currency = `EUR`.
    temp15-kind = `S`.
    INSERT temp15 INTO TABLE temp14.
    temp15-region = ``.
    temp15-product = ``.
    temp15-quantity = 6.
    temp15-amount = 35.
    temp15-currency = `EUR`.
    temp15-kind = `T`.
    INSERT temp15 INTO TABLE temp14.
    cl_abap_unit_assert=>assert_equals(
        exp = temp14
        act = t_rows ).

  ENDMETHOD.


  METHOD test_currencies_not_mixed.

    DATA temp16 TYPE z2ui5_cl_smp_app_544=>ty_t_sales.
    DATA temp17 LIKE LINE OF temp16.
    DATA t_rows LIKE temp16.
    DATA temp18 TYPE string_table.
    DATA temp20 TYPE z2ui5_cl_smp_app_544=>ty_t_sales.
    DATA temp21 LIKE LINE OF temp20.
    CLEAR temp16.
    
    temp17-region = `A`.
    temp17-amount = 3.
    temp17-currency = `USD`.
    INSERT temp17 INTO TABLE temp16.
    temp17-region = `A`.
    temp17-amount = 10.
    temp17-currency = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    
    t_rows = temp16.

    
    CLEAR temp18.
    INSERT `REGION` INTO TABLE temp18.
    group_by( EXPORTING t_group_by = temp18
              CHANGING  t_rows     = t_rows ).

    " one subtotal and one grand total per currency
    
    CLEAR temp20.
    
    temp21-region = `A`.
    temp21-amount = 10.
    temp21-currency = `EUR`.
    temp21-kind = ``.
    INSERT temp21 INTO TABLE temp20.
    temp21-region = `A`.
    temp21-amount = 3.
    temp21-currency = `USD`.
    temp21-kind = ``.
    INSERT temp21 INTO TABLE temp20.
    temp21-region = `A`.
    temp21-amount = 10.
    temp21-currency = `EUR`.
    temp21-kind = `S`.
    INSERT temp21 INTO TABLE temp20.
    temp21-region = `A`.
    temp21-amount = 3.
    temp21-currency = `USD`.
    temp21-kind = `S`.
    INSERT temp21 INTO TABLE temp20.
    temp21-region = ``.
    temp21-amount = 10.
    temp21-currency = `EUR`.
    temp21-kind = `T`.
    INSERT temp21 INTO TABLE temp20.
    temp21-region = ``.
    temp21-amount = 3.
    temp21-currency = `USD`.
    temp21-kind = `T`.
    INSERT temp21 INTO TABLE temp20.
    cl_abap_unit_assert=>assert_equals(
        exp = temp20
        act = t_rows ).

  ENDMETHOD.


  METHOD test_two_levels.

    DATA temp22 TYPE z2ui5_cl_smp_app_544=>ty_t_sales.
    DATA temp23 LIKE LINE OF temp22.
    DATA t_rows LIKE temp22.
    DATA temp24 TYPE string_table.
    DATA temp26 TYPE z2ui5_cl_smp_app_544=>ty_t_sales.
    DATA temp27 LIKE LINE OF temp26.
    CLEAR temp22.
    
    temp23-region = `R2`.
    temp23-country = `A`.
    temp23-amount = 4.
    temp23-currency = `EUR`.
    INSERT temp23 INTO TABLE temp22.
    temp23-region = `R1`.
    temp23-country = `B`.
    temp23-amount = 2.
    temp23-currency = `EUR`.
    INSERT temp23 INTO TABLE temp22.
    temp23-region = `R1`.
    temp23-country = `A`.
    temp23-amount = 1.
    temp23-currency = `EUR`.
    INSERT temp23 INTO TABLE temp22.
    
    t_rows = temp22.

    
    CLEAR temp24.
    INSERT `REGION` INTO TABLE temp24.
    INSERT `COUNTRY` INTO TABLE temp24.
    group_by( EXPORTING t_group_by = temp24
              CHANGING  t_rows     = t_rows ).

    " R1/A, R1/B, R1, then R2/A, R2, and the grand total
    
    CLEAR temp26.
    
    temp27-region = `R1`.
    temp27-country = `A`.
    temp27-amount = 1.
    temp27-currency = `EUR`.
    temp27-kind = ``.
    INSERT temp27 INTO TABLE temp26.
    temp27-region = `R1`.
    temp27-country = `A`.
    temp27-amount = 1.
    temp27-currency = `EUR`.
    temp27-kind = `S`.
    INSERT temp27 INTO TABLE temp26.
    temp27-region = `R1`.
    temp27-country = `B`.
    temp27-amount = 2.
    temp27-currency = `EUR`.
    temp27-kind = ``.
    INSERT temp27 INTO TABLE temp26.
    temp27-region = `R1`.
    temp27-country = `B`.
    temp27-amount = 2.
    temp27-currency = `EUR`.
    temp27-kind = `S`.
    INSERT temp27 INTO TABLE temp26.
    temp27-region = `R1`.
    temp27-country = ``.
    temp27-amount = 3.
    temp27-currency = `EUR`.
    temp27-kind = `S`.
    INSERT temp27 INTO TABLE temp26.
    temp27-region = `R2`.
    temp27-country = `A`.
    temp27-amount = 4.
    temp27-currency = `EUR`.
    temp27-kind = ``.
    INSERT temp27 INTO TABLE temp26.
    temp27-region = `R2`.
    temp27-country = `A`.
    temp27-amount = 4.
    temp27-currency = `EUR`.
    temp27-kind = `S`.
    INSERT temp27 INTO TABLE temp26.
    temp27-region = `R2`.
    temp27-country = ``.
    temp27-amount = 4.
    temp27-currency = `EUR`.
    temp27-kind = `S`.
    INSERT temp27 INTO TABLE temp26.
    temp27-region = ``.
    temp27-country = ``.
    temp27-amount = 7.
    temp27-currency = `EUR`.
    temp27-kind = `T`.
    INSERT temp27 INTO TABLE temp26.
    cl_abap_unit_assert=>assert_equals(
        exp = temp26
        act = t_rows ).

  ENDMETHOD.

ENDCLASS.
