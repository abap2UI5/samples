*"* use this source file for your ABAP unit test classes
CLASS ltcl_unit_test DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      first_test FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_unit_test IMPLEMENTATION.

  METHOD first_test.

*    data(lv_result) = `my test`.
*    data(lv_x) = cl_http_utility=>encode_utf8( lv_result ).
*    DATA(lv_frontend) = cl_http_utility=>encode_x_base64( unencoded = lv_x ).
*
*    "send it to the frontend here...
*
*    DATA(lv_x2) = cl_http_utility=>decode_x_base64( encoded = lv_frontend ).
*    DATA(lv_result2) = cl_http_utility=>decode_utf8( encoded = lv_x2 ).
*
*    assert lv_result = lv_result2.

  ENDMETHOD.

ENDCLASS.
