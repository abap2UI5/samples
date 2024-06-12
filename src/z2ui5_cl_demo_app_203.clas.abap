CLASS z2ui5_cl_demo_app_203 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    DATA check_initialized TYPE abap_bool .
    DATA ls_validation_schema TYPE z2ui5_cl_cc_validator=>ty_validation_schema .
    DATA mv_email TYPE string .
    DATA mv_number TYPE int4 .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS display_view.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_203 IMPLEMENTATION.


  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_validator=>get_js( is_validation = ls_validation_schema iv_view = 'MAIN' ) )->get_parent( ).

    DATA(page) = view->shell( )->page( showheader = abap_false ).
    page->simple_form( title    = 'Validator' editable = abap_true
                   )->content( 'form'
                       )->label( `email`
                       )->input( value = client->_bind_edit( mv_email ) width = `15rem` id = `email`
                       )->label( `number  > 0`
                       )->input( value = client->_bind_edit( mv_number ) width = `15rem` id = `number`
                       )->button( text = `Submit` press = client->_event( 'CHECK_FORM' )
                      ).


    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.


      ls_validation_schema-properties-number-type = `number`.
      ls_validation_schema-properties-number-minimum = 1.
      ls_validation_schema-properties-number-max_length = 999999.

      ls_validation_schema-properties-email-type = `string`.
      ls_validation_schema-properties-email-format = `email`.
      ls_validation_schema-properties-email-min_length = 0.


      client->view_display( z2ui5_cl_xml_view=>factory(
        )->_z2ui5( )->timer( finished = client->_event( `START` ) delayms = `0`
           )->_generic( ns = `html` name = `script` )->_cc_plain_xml( z2ui5_cl_cc_validator=>load_ajv( )
        )->stringify( ) ).

      RETURN.
    ENDIF.


    CASE client->get( )-event.
      WHEN 'START'.
        display_view( ).
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'CHECK_FORM'.
        client->follow_up_action( z2ui5_cl_cc_validator=>validate_fields( ) ).
    ENDCASE.
    client->view_model_update( ).
  ENDMETHOD.
ENDCLASS.
