CLASS z2ui5_cl_demo_app_185 DEFINITION
  PUBLIC
    INHERITING FROM Z2UI5_CL_DEMO_APP_131
  CREATE PUBLIC.

  PUBLIC SECTION.

  PROTECTED SECTION.

METHODS on_init REDEFINITION.

  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_185 IMPLEMENTATION.

  METHOD on_init.

    mt_t002 = VALUE #( ( id = '1' class = 'Z2UI5_CL_DEMO_APP_184'  count = '10' table = 'Z2UI5_T001')
                       ( id = '2' class = 'Z2UI5_CL_DEMO_APP_184'  count = '12' table = 'Z2UI5_T002')
                       ).

    mv_selectedkey = '1'.

  ENDMETHOD.

ENDCLASS.
