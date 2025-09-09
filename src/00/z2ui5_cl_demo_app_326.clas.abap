CLASS z2ui5_cl_demo_app_326 DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA unit              TYPE meins.
    DATA numc              TYPE z2ui5_numc12.


  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS z2ui5_set_data.

    METHODS display_view
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

    METHODS on_event
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_326 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.
      display_view( client ).
      z2ui5_set_data( ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.

  METHOD display_view.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    DATA temp1 TYPE xsdboolean.
    temp1 = boolc( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    client->view_display( val = view->shell(
           )->page( title          = 'abap2UI5 - Conversion Exit'
                    navbuttonpress = client->_event( 'BACK' )
                    shownavbutton  = temp1
        )->simple_form( title    = 'Form Title'
                        editable = abap_true
                   )->content( 'form'
                       )->title( 'Conversion'
                       )->label( 'Numeric'
                       )->input( value   = client->_bind_edit( numc )
                                 enabled = abap_false
                       )->label( `Unit`
                       )->input( value   = client->_bind_edit( unit )
                                 enabled = abap_false
                       )->stringify( ) ).

  ENDMETHOD.

  METHOD on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.

  METHOD z2ui5_set_data.

    unit = 'ST'.   " internal ST -> external PC (if logged in in english)
    numc = 10.     " internal 0000000010 -> external 10

    TRY.
        CALL FUNCTION `CONVERSION_EXIT_CUNIT_OUTPUT`
          EXPORTING  input  = unit
          IMPORTING  output = unit
          EXCEPTIONS OTHERS = 99.

        CALL FUNCTION `CONVERSION_EXIT_ALPHA_OUTPUT`
          EXPORTING  input  = numc
          IMPORTING  output = numc
          EXCEPTIONS OTHERS = 99.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
