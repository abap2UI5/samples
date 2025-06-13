CLASS z2ui5_cl_demo_app_329 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    CLASS-METHODS factory
      IMPORTING
        i_data        TYPE REF TO z2ui5_cl_demo_app_330
      RETURNING
        VALUE(result) TYPE REF TO z2ui5_cl_demo_app_329.

    DATA mo_data TYPE REF TO z2ui5_cl_demo_app_330.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_329 IMPLEMENTATION.

  METHOD factory.

    result = NEW #( ).

    result->mo_data = i_data.

  ENDMETHOD.

  METHOD z2ui5_if_app~main.


    IF mo_data->mr_table_data IS NOT INITIAL.
      client->message_toast_display( 'Success - Ref works.' ).
      client->nav_app_leave( ).
    ELSE.

      client->message_toast_display( 'Error - Ref not working' ).
      client->nav_app_leave( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
