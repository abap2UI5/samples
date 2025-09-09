CLASS z2ui5_cl_demo_app_331 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA ms_struc     TYPE z2ui5_t_01.
    DATA mo_table_obj TYPE REF TO z2ui5_cl_demo_app_329.

    METHODS get_data.

    METHODS ui5_view_display
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_331 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ) IS NOT INITIAL.
      get_data( ).
      DATA temp1 LIKE REF TO ms_struc.
      GET REFERENCE OF ms_struc INTO temp1.
mo_table_obj = z2ui5_cl_demo_app_329=>factory( temp1 ).
      ui5_view_display( client ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

    IF ms_struc IS INITIAL.
      client->message_toast_display( 'ERROR - MS_STRUC is initial!' ).
    ENDIF.

    client->view_model_update( ).

  ENDMETHOD.

  METHOD ui5_view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell( )->page( title          = 'RTTI IV'
                                                                navbuttonpress = client->_event( 'BACK' )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    page->button( text  = 'GO'
                  press = client->_event( 'GO' )
                  type  = 'Success' ).

    DATA form TYPE REF TO z2ui5_cl_xml_view.
    form = page->simple_form( editable        = abap_true
                                    layout          = `ResponsiveGridLayout`
                                    adjustlabelspan = abap_true
                              )->content( ns = `form` ).

    FIELD-SYMBOLS <val> TYPE data.
    ASSIGN mo_table_obj->mr_data->* TO <val>.
    FIELD-SYMBOLS <value> TYPE any.
    ASSIGN COMPONENT 'ID' OF STRUCTURE <val> TO <value>.
    IF <value> IS NOT ASSIGNED.
      RETURN.
    ENDIF.

    DATA line TYPE REF TO z2ui5_cl_xml_view.
    line = form->label( wrapping = abap_false
                              text     = 'ID'  ).

    line->input( value = client->_bind( <value> ) ).

    client->view_display( page ).

  ENDMETHOD.

  METHOD get_data.

*    DATA selkz TYPE abap_bool.
*
*    DATA(t_comp) = z2ui5_cl_util=>rtti_get_t_attri_by_table_name( 'Z2UI5_T_01' ).
*
*    APPEND LINES OF VALUE cl_abap_structdescr=>component_table(
*                              ( name = 'SELKZ'
*                                type = CAST #( cl_abap_datadescr=>describe_by_data( selkz ) ) ) ) TO t_comp.
*
*    TRY.
*
*        DATA(new_struct_desc) = cl_abap_structdescr=>create( t_comp ).
*
*        CREATE DATA ms_struc TYPE HANDLE new_struct_desc.
*
*        ASSIGN ms_struc->* TO FIELD-SYMBOL(<struc>).

    SELECT SINGLE * FROM z2ui5_t_01
      INTO CORRESPONDING FIELDS OF ms_struc.

*      CATCH cx_root.

*    ENDTRY.

  ENDMETHOD.

ENDCLASS.
