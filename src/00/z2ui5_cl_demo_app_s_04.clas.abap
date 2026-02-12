CLASS z2ui5_cl_demo_app_s_04 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_unit              TYPE meins.
    DATA mo_numc              TYPE z2ui5_numc12.
    DATA mv_numc_out          TYPE c LENGTH 12.

  PROTECTED SECTION.
    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS set_data.

    METHODS display_view
      IMPORTING
        !mo_client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_s_04 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( mo_client ).
      set_data( ).
    ENDIF.

  ENDMETHOD.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

    mo_client->view_display( lo_view->shell(
           )->page( title          = `abap2UI5 - Conversion Exit`
                    navbuttonpress = mo_client->_event_nav_app_leave( )
                    shownavbutton  = mo_client->check_app_prev_stack( )
        )->simple_form( title    = `Form Title`
                        editable = abap_true
                   )->content( `form`
                       )->title( `Conversion`
                       )->label( `Numeric`
                       )->input( value   = mo_client->_bind_edit( mv_numc_out )
                                 enabled = abap_false
                       )->label( `Unit`
                       )->input( value   = mo_client->_bind_edit( mv_unit )
                                 enabled = abap_false
                       )->stringify( ) ).
  ENDMETHOD.

  METHOD set_data.

    mv_unit = `ST`.   " internal ST -> external PC (if logged in in english)
    mo_numc = 10.     " internal 0000000010 -> external 10

    TRY.
        CALL FUNCTION `CONVERSION_EXIT_CUNIT_OUTPUT`
          EXPORTING
            input  = mv_unit
          IMPORTING
            output = mv_unit
          EXCEPTIONS
            OTHERS = 99.

*        numc = |{ numc ALPHA = OUT }|.
        CALL FUNCTION `CONVERSION_EXIT_ALPHA_OUTPUT`
          EXPORTING
            input  = mo_numc
          IMPORTING
            output = mv_numc_out
          EXCEPTIONS
            OTHERS = 99.

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
