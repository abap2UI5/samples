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

    CREATE OBJECT cut.

  ENDMETHOD.


  METHOD test_no_sales.

    DATA temp1 TYPE z2ui5_cl_smp_app_545=>ty_t_sales.
    CLEAR temp1.
    cl_abap_unit_assert=>assert_initial( cut->tree_build( temp1 ) ).

  ENDMETHOD.


  METHOD test_sums_per_level.

    DATA temp2 TYPE z2ui5_cl_smp_app_545=>ty_t_sales.
    DATA temp3 LIKE LINE OF temp2.
    DATA t_tree TYPE z2ui5_cl_smp_app_545=>ty_t_tree.
    DATA temp4 TYPE z2ui5_cl_smp_app_545=>ty_t_tree.
    DATA temp5 LIKE LINE OF temp4.
    DATA temp1 TYPE z2ui5_cl_smp_app_545=>ty_s_total-nodes.
    DATA temp6 LIKE LINE OF temp1.
    DATA temp7 TYPE z2ui5_cl_smp_app_545=>ty_s_region-nodes.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp11 TYPE z2ui5_cl_smp_app_545=>ty_s_country-nodes.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp13 TYPE z2ui5_cl_smp_app_545=>ty_s_country-nodes.
    DATA temp14 LIKE LINE OF temp13.
    DATA temp9 TYPE z2ui5_cl_smp_app_545=>ty_s_region-nodes.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp15 TYPE z2ui5_cl_smp_app_545=>ty_s_country-nodes.
    DATA temp16 LIKE LINE OF temp15.
    CLEAR temp2.
    
    temp3-region = `R1`.
    temp3-country = `A`.
    temp3-product = `P1`.
    temp3-quantity = 1.
    temp3-amount = 10.
    temp3-currency = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-region = `R2`.
    temp3-country = `C`.
    temp3-product = `P2`.
    temp3-quantity = 2.
    temp3-amount = 5.
    temp3-currency = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-region = `R1`.
    temp3-country = `B`.
    temp3-product = `P3`.
    temp3-quantity = 3.
    temp3-amount = 20.
    temp3-currency = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-region = `R1`.
    temp3-country = `A`.
    temp3-product = `P4`.
    temp3-quantity = 4.
    temp3-amount = 1.
    temp3-currency = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    
    t_tree = cut->tree_build( temp2 ).

    " every node sums the sales below it; the children keep the order of
    " their first sale
    
    CLEAR temp4.
    
    temp5-name = `Grand Total`.
    temp5-quantity = 10.
    temp5-amount = 36.
    temp5-currency = `EUR`.
    temp5-kind = `T`.
    
    CLEAR temp1.
    
    temp6-name = `R1`.
    temp6-quantity = 8.
    temp6-amount = 31.
    temp6-currency = `EUR`.
    temp6-kind = `S`.
    
    CLEAR temp7.
    
    temp8-name = `A`.
    temp8-quantity = 5.
    temp8-amount = 11.
    temp8-currency = `EUR`.
    temp8-kind = `S`.
    
    CLEAR temp11.
    
    temp12-name = `P1`.
    temp12-quantity = 1.
    temp12-amount = 10.
    temp12-currency = `EUR`.
    temp12-kind = ``.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `P4`.
    temp12-quantity = 4.
    temp12-amount = 1.
    temp12-currency = `EUR`.
    temp12-kind = ``.
    INSERT temp12 INTO TABLE temp11.
    temp8-nodes = temp11.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `B`.
    temp8-quantity = 3.
    temp8-amount = 20.
    temp8-currency = `EUR`.
    temp8-kind = `S`.
    
    CLEAR temp13.
    
    temp14-name = `P3`.
    temp14-quantity = 3.
    temp14-amount = 20.
    temp14-currency = `EUR`.
    temp14-kind = ``.
    INSERT temp14 INTO TABLE temp13.
    temp8-nodes = temp13.
    INSERT temp8 INTO TABLE temp7.
    temp6-nodes = temp7.
    INSERT temp6 INTO TABLE temp1.
    temp6-name = `R2`.
    temp6-quantity = 2.
    temp6-amount = 5.
    temp6-currency = `EUR`.
    temp6-kind = `S`.
    
    CLEAR temp9.
    
    temp10-name = `C`.
    temp10-quantity = 2.
    temp10-amount = 5.
    temp10-currency = `EUR`.
    temp10-kind = `S`.
    
    CLEAR temp15.
    
    temp16-name = `P2`.
    temp16-quantity = 2.
    temp16-amount = 5.
    temp16-currency = `EUR`.
    temp16-kind = ``.
    INSERT temp16 INTO TABLE temp15.
    temp10-nodes = temp15.
    INSERT temp10 INTO TABLE temp9.
    temp6-nodes = temp9.
    INSERT temp6 INTO TABLE temp1.
    temp5-nodes = temp1.
    INSERT temp5 INTO TABLE temp4.
    cl_abap_unit_assert=>assert_equals(
        exp = temp4
        act = t_tree ).

  ENDMETHOD.


  METHOD test_currencies_not_mixed.

    DATA temp6 TYPE z2ui5_cl_smp_app_545=>ty_t_sales.
    DATA temp7 LIKE LINE OF temp6.
    DATA t_tree TYPE z2ui5_cl_smp_app_545=>ty_t_tree.
    DATA temp8 TYPE z2ui5_cl_smp_app_545=>ty_t_tree.
    DATA temp9 LIKE LINE OF temp8.
    DATA temp10 TYPE z2ui5_cl_smp_app_545=>ty_s_total-nodes.
    DATA temp11 LIKE LINE OF temp10.
    DATA temp14 TYPE z2ui5_cl_smp_app_545=>ty_s_region-nodes.
    DATA temp15 LIKE LINE OF temp14.
    DATA temp18 TYPE z2ui5_cl_smp_app_545=>ty_s_country-nodes.
    DATA temp19 LIKE LINE OF temp18.
    DATA temp12 TYPE z2ui5_cl_smp_app_545=>ty_s_total-nodes.
    DATA temp13 LIKE LINE OF temp12.
    DATA temp16 TYPE z2ui5_cl_smp_app_545=>ty_s_region-nodes.
    DATA temp17 LIKE LINE OF temp16.
    DATA temp20 TYPE z2ui5_cl_smp_app_545=>ty_s_country-nodes.
    DATA temp21 LIKE LINE OF temp20.
    CLEAR temp6.
    
    temp7-region = `R1`.
    temp7-country = `A`.
    temp7-product = `P1`.
    temp7-quantity = 1.
    temp7-amount = 3.
    temp7-currency = `USD`.
    INSERT temp7 INTO TABLE temp6.
    temp7-region = `R1`.
    temp7-country = `A`.
    temp7-product = `P2`.
    temp7-quantity = 1.
    temp7-amount = 10.
    temp7-currency = `EUR`.
    INSERT temp7 INTO TABLE temp6.
    
    t_tree = cut->tree_build( temp6 ).

    " one grand total per currency, in alphabetical order, and the region
    " under each of them
    
    CLEAR temp8.
    
    temp9-name = `Grand Total`.
    temp9-quantity = 1.
    temp9-amount = 10.
    temp9-currency = `EUR`.
    temp9-kind = `T`.
    
    CLEAR temp10.
    
    temp11-name = `R1`.
    temp11-quantity = 1.
    temp11-amount = 10.
    temp11-currency = `EUR`.
    temp11-kind = `S`.
    
    CLEAR temp14.
    
    temp15-name = `A`.
    temp15-quantity = 1.
    temp15-amount = 10.
    temp15-currency = `EUR`.
    temp15-kind = `S`.
    
    CLEAR temp18.
    
    temp19-name = `P2`.
    temp19-quantity = 1.
    temp19-amount = 10.
    temp19-currency = `EUR`.
    temp19-kind = ``.
    INSERT temp19 INTO TABLE temp18.
    temp15-nodes = temp18.
    INSERT temp15 INTO TABLE temp14.
    temp11-nodes = temp14.
    INSERT temp11 INTO TABLE temp10.
    temp9-nodes = temp10.
    INSERT temp9 INTO TABLE temp8.
    temp9-name = `Grand Total`.
    temp9-quantity = 1.
    temp9-amount = 3.
    temp9-currency = `USD`.
    temp9-kind = `T`.
    
    CLEAR temp12.
    
    temp13-name = `R1`.
    temp13-quantity = 1.
    temp13-amount = 3.
    temp13-currency = `USD`.
    temp13-kind = `S`.
    
    CLEAR temp16.
    
    temp17-name = `A`.
    temp17-quantity = 1.
    temp17-amount = 3.
    temp17-currency = `USD`.
    temp17-kind = `S`.
    
    CLEAR temp20.
    
    temp21-name = `P1`.
    temp21-quantity = 1.
    temp21-amount = 3.
    temp21-currency = `USD`.
    temp21-kind = ``.
    INSERT temp21 INTO TABLE temp20.
    temp17-nodes = temp20.
    INSERT temp17 INTO TABLE temp16.
    temp13-nodes = temp16.
    INSERT temp13 INTO TABLE temp12.
    temp9-nodes = temp12.
    INSERT temp9 INTO TABLE temp8.
    cl_abap_unit_assert=>assert_equals(
        exp = temp8
        act = t_tree ).

  ENDMETHOD.

ENDCLASS.
