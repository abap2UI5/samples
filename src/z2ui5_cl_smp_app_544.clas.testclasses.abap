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

    cut = NEW #( ).

  ENDMETHOD.


  METHOD group_by.

    cut->subtotals_add( EXPORTING group_by     = t_group_by
                                  value_fields = VALUE #( ( `AMOUNT` ) ( `QUANTITY` ) )
                                  unit_fields  = VALUE #( ( `CURRENCY` ) )
                                  kind_field   = `KIND`
                        CHANGING  rows         = t_rows ).

  ENDMETHOD.


  METHOD test_nothing_grouped.

    DATA(t_rows) = VALUE z2ui5_cl_smp_app_544=>ty_t_sales(
        ( region = `B` product = `P1` amount = 5  currency = `EUR` )
        ( region = `A` product = `P2` amount = 10 currency = `EUR` ) ).
    DATA(t_before) = t_rows.

    group_by( EXPORTING t_group_by = VALUE #( )
              CHANGING  t_rows     = t_rows ).

    cl_abap_unit_assert=>assert_equals( exp = t_before
                                        act = t_rows ).

  ENDMETHOD.


  METHOD test_unknown_column_ignored.

    DATA(t_rows) = VALUE z2ui5_cl_smp_app_544=>ty_t_sales(
        ( region = `A` product = `P1` amount = 10 currency = `EUR` ) ).
    DATA(t_before) = t_rows.

    group_by( EXPORTING t_group_by = VALUE #( ( `NOPE` ) )
              CHANGING  t_rows     = t_rows ).

    cl_abap_unit_assert=>assert_equals( exp = t_before
                                        act = t_rows ).

  ENDMETHOD.


  METHOD test_subtotal_per_group.

    DATA(t_rows) = VALUE z2ui5_cl_smp_app_544=>ty_t_sales(
        ( region = `A` product = `P1` quantity = 1 amount = 10 currency = `EUR` )
        ( region = `B` product = `P2` quantity = 2 amount = 5  currency = `EUR` )
        ( region = `A` product = `P3` quantity = 3 amount = 20 currency = `EUR` ) ).

    " in lower case, as a column name may come from the browser
    group_by( EXPORTING t_group_by = VALUE #( ( `region` ) )
              CHANGING  t_rows     = t_rows ).

    " the rows keep the order they came in within a group
    cl_abap_unit_assert=>assert_equals(
        exp = VALUE z2ui5_cl_smp_app_544=>ty_t_sales(
            ( region = `A` product = `P1` quantity = 1 amount = 10 currency = `EUR` kind = `` )
            ( region = `A` product = `P3` quantity = 3 amount = 20 currency = `EUR` kind = `` )
            ( region = `A` product = ``   quantity = 4 amount = 30 currency = `EUR` kind = `S` )
            ( region = `B` product = `P2` quantity = 2 amount = 5  currency = `EUR` kind = `` )
            ( region = `B` product = ``   quantity = 2 amount = 5  currency = `EUR` kind = `S` )
            ( region = ``  product = ``   quantity = 6 amount = 35 currency = `EUR` kind = `T` ) )
        act = t_rows ).

  ENDMETHOD.


  METHOD test_currencies_not_mixed.

    DATA(t_rows) = VALUE z2ui5_cl_smp_app_544=>ty_t_sales(
        ( region = `A` amount = 3  currency = `USD` )
        ( region = `A` amount = 10 currency = `EUR` ) ).

    group_by( EXPORTING t_group_by = VALUE #( ( `REGION` ) )
              CHANGING  t_rows     = t_rows ).

    " one subtotal and one grand total per currency
    cl_abap_unit_assert=>assert_equals(
        exp = VALUE z2ui5_cl_smp_app_544=>ty_t_sales(
            ( region = `A` amount = 10 currency = `EUR` kind = `` )
            ( region = `A` amount = 3  currency = `USD` kind = `` )
            ( region = `A` amount = 10 currency = `EUR` kind = `S` )
            ( region = `A` amount = 3  currency = `USD` kind = `S` )
            ( region = ``  amount = 10 currency = `EUR` kind = `T` )
            ( region = ``  amount = 3  currency = `USD` kind = `T` ) )
        act = t_rows ).

  ENDMETHOD.


  METHOD test_two_levels.

    DATA(t_rows) = VALUE z2ui5_cl_smp_app_544=>ty_t_sales(
        ( region = `R2` country = `A` amount = 4 currency = `EUR` )
        ( region = `R1` country = `B` amount = 2 currency = `EUR` )
        ( region = `R1` country = `A` amount = 1 currency = `EUR` ) ).

    group_by( EXPORTING t_group_by = VALUE #( ( `REGION` ) ( `COUNTRY` ) )
              CHANGING  t_rows     = t_rows ).

    " R1/A, R1/B, R1, then R2/A, R2, and the grand total
    cl_abap_unit_assert=>assert_equals(
        exp = VALUE z2ui5_cl_smp_app_544=>ty_t_sales(
            ( region = `R1` country = `A` amount = 1 currency = `EUR` kind = `` )
            ( region = `R1` country = `A` amount = 1 currency = `EUR` kind = `S` )
            ( region = `R1` country = `B` amount = 2 currency = `EUR` kind = `` )
            ( region = `R1` country = `B` amount = 2 currency = `EUR` kind = `S` )
            ( region = `R1` country = ``  amount = 3 currency = `EUR` kind = `S` )
            ( region = `R2` country = `A` amount = 4 currency = `EUR` kind = `` )
            ( region = `R2` country = `A` amount = 4 currency = `EUR` kind = `S` )
            ( region = `R2` country = ``  amount = 4 currency = `EUR` kind = `S` )
            ( region = ``   country = ``  amount = 7 currency = `EUR` kind = `T` ) )
        act = t_rows ).

  ENDMETHOD.

ENDCLASS.
