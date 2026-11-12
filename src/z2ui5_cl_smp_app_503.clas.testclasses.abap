CLASS ltcl_gross_amount DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT.

  PRIVATE SECTION.
    DATA cut TYPE REF TO z2ui5_cl_smp_app_503.

    METHODS setup.
    METHODS test_nineteen_percent FOR TESTING.
    METHODS test_rounds_the_half_up FOR TESTING.
    METHODS test_zero_changes_nothing FOR TESTING.
    METHODS test_negative_half_away FOR TESTING.

ENDCLASS.


CLASS ltcl_gross_amount IMPLEMENTATION.

  METHOD setup.

    " the app class instantiated like any other class - the test needs no
    " client, no HTTP handler and no frontend to build one
    CREATE OBJECT cut.

  ENDMETHOD.

  METHOD test_nineteen_percent.

    cl_abap_unit_assert=>assert_equals( exp = 119
                                        act = cut->gross_amount( net     = 100
                                                                 percent = 19 ) ).

  ENDMETHOD.

  METHOD test_rounds_the_half_up.

    " 7% of 10 is 0.7 - gross_amount( ) rounds 10.7 to a whole unit
    cl_abap_unit_assert=>assert_equals( exp = 11
                                        act = cut->gross_amount( net     = 10
                                                                 percent = 7 ) ).

  ENDMETHOD.

  METHOD test_zero_changes_nothing.

    cl_abap_unit_assert=>assert_equals( exp = 42
                                        act = cut->gross_amount( net     = 42
                                                                 percent = 0 ) ).

  ENDMETHOD.

  METHOD test_negative_half_away.

    " a credit note: -10.5 rounds away from zero, like 10.5 does
    cl_abap_unit_assert=>assert_equals( exp = -11
                                        act = cut->gross_amount( net     = -10
                                                                 percent = 5 ) ).

  ENDMETHOD.

ENDCLASS.
