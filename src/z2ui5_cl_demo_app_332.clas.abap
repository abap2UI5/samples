CLASS z2ui5_cl_demo_app_332 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA ms_struc     TYPE z2ui5_t_01.
    DATA mo_table_obj TYPE REF TO z2ui5_cl_demo_app_333.

    METHODS get_data.

    METHODS ui5_view_display
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_332 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      get_data( ).

      mo_table_obj = z2ui5_cl_demo_app_333=>factory( i_data = REF #( ms_struc ) vis_cols = 3 ).

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

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell( )->page( title          = 'RTTI IV'
                                                                navbuttonpress = client->_event( 'BACK' )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    page->button( text  = 'GO'
                  press = client->_event( 'GO' )
                  type  = 'Success' ).

    DATA(form) = page->simple_form( editable        = abap_true
                                    layout          = `ResponsiveGridLayout`
                                    adjustlabelspan = abap_true
                              )->content( ns = `form` ).

    DATA(index) = 0.

    LOOP AT mo_table_obj->ms_data-t_layout REFERENCE INTO DATA(layout).

      index = index + 1.

      ASSIGN COMPONENT layout->name OF STRUCTURE mo_table_obj->mr_data->* TO FIELD-SYMBOL(<value>).
      " assign component layout->name of structure ms_struc to field-symbol(<value>).
      IF <value> IS NOT ASSIGNED.
        RETURN.
      ENDIF.

      DATA(line) = form->label( wrapping = abap_false
                                text     = layout->name  ).

      line->input( value   = client->_bind( <value> )
                   visible = client->_bind( val       = layout->visible
                                            tab       = mo_table_obj->ms_data-t_layout
                                            tab_index = index )
                   enabled = abap_false ).
    ENDLOOP.

    client->view_display( page ).

  ENDMETHOD.

  METHOD get_data.

    SELECT SINGLE * FROM z2ui5_t_01
      INTO CORRESPONDING FIELDS OF @ms_STRUC.

  ENDMETHOD.

ENDCLASS.
