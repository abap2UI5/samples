CLASS ltcl_tree DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    DATA cut TYPE REF TO z2ui5_cl_smp_app_545.

    METHODS setup.

    METHODS test_no_sales FOR TESTING.
    METHODS test_sums_per_level FOR TESTING.
    METHODS test_currencies_not_mixed FOR TESTING.

ENDCLASS.


CLASS ltcl_tree IMPLEMENTATION.

  METHOD setup.

    cut = NEW #( ).

  ENDMETHOD.


  METHOD test_no_sales.

    cl_abap_unit_assert=>assert_initial( cut->tree_build( VALUE #( ) ) ).

  ENDMETHOD.


  METHOD test_sums_per_level.

    DATA(t_tree) = cut->tree_build( VALUE #(
        ( region = `R1` country = `A` product = `P1` quantity = 1 amount = 10 currency = `EUR` )
        ( region = `R2` country = `C` product = `P2` quantity = 2 amount = 5  currency = `EUR` )
        ( region = `R1` country = `B` product = `P3` quantity = 3 amount = 20 currency = `EUR` )
        ( region = `R1` country = `A` product = `P4` quantity = 4 amount = 1  currency = `EUR` ) ) ).

    " every node sums the sales below it; the children keep the order of
    " their first sale
    cl_abap_unit_assert=>assert_equals(
        exp = VALUE z2ui5_cl_smp_app_545=>ty_t_tree(
            ( name = `Grand Total` quantity = 10 amount = 36 currency = `EUR` kind = `T` nodes = VALUE #(
                ( name = `R1` quantity = 8 amount = 31 currency = `EUR` kind = `S` nodes = VALUE #(
                    ( name = `A` quantity = 5 amount = 11 currency = `EUR` kind = `S` nodes = VALUE #(
                        ( name = `P1` quantity = 1 amount = 10 currency = `EUR` kind = `` )
                        ( name = `P4` quantity = 4 amount = 1  currency = `EUR` kind = `` ) ) )
                    ( name = `B` quantity = 3 amount = 20 currency = `EUR` kind = `S` nodes = VALUE #(
                        ( name = `P3` quantity = 3 amount = 20 currency = `EUR` kind = `` ) ) ) ) )
                ( name = `R2` quantity = 2 amount = 5 currency = `EUR` kind = `S` nodes = VALUE #(
                    ( name = `C` quantity = 2 amount = 5 currency = `EUR` kind = `S` nodes = VALUE #(
                        ( name = `P2` quantity = 2 amount = 5 currency = `EUR` kind = `` ) ) ) ) ) ) ) )
        act = t_tree ).

  ENDMETHOD.


  METHOD test_currencies_not_mixed.

    DATA(t_tree) = cut->tree_build( VALUE #(
        ( region = `R1` country = `A` product = `P1` quantity = 1 amount = 3  currency = `USD` )
        ( region = `R1` country = `A` product = `P2` quantity = 1 amount = 10 currency = `EUR` ) ) ).

    " one grand total per currency, in alphabetical order, and the region
    " under each of them
    cl_abap_unit_assert=>assert_equals(
        exp = VALUE z2ui5_cl_smp_app_545=>ty_t_tree(
            ( name = `Grand Total` quantity = 1 amount = 10 currency = `EUR` kind = `T` nodes = VALUE #(
                ( name = `R1` quantity = 1 amount = 10 currency = `EUR` kind = `S` nodes = VALUE #(
                    ( name = `A` quantity = 1 amount = 10 currency = `EUR` kind = `S` nodes = VALUE #(
                        ( name = `P2` quantity = 1 amount = 10 currency = `EUR` kind = `` ) ) ) ) ) ) )
            ( name = `Grand Total` quantity = 1 amount = 3 currency = `USD` kind = `T` nodes = VALUE #(
                ( name = `R1` quantity = 1 amount = 3 currency = `USD` kind = `S` nodes = VALUE #(
                    ( name = `A` quantity = 1 amount = 3 currency = `USD` kind = `S` nodes = VALUE #(
                        ( name = `P1` quantity = 1 amount = 3 currency = `USD` kind = `` ) ) ) ) ) ) ) )
        act = t_tree ).

  ENDMETHOD.

ENDCLASS.
