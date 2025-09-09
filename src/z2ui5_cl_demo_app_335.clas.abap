CLASS z2ui5_cl_demo_app_335 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA ms_struc        TYPE z2ui5_t_01.
    DATA mo_layout_obj   TYPE REF TO z2ui5_cl_demo_app_333.
    DATA mo_layout_obj_2 TYPE REF TO z2ui5_cl_demo_app_333.

    METHODS get_data.

    METHODS ui5_view_display
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS get_data_2.
ENDCLASS.


CLASS z2ui5_cl_demo_app_335 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ) IS NOT INITIAL.

      get_data( ).

      DATA temp1 LIKE REF TO ms_struc.
      GET REFERENCE OF ms_struc INTO temp1.
mo_layout_obj = z2ui5_cl_demo_app_333=>factory( i_data   = temp1
                                                      vis_cols = 3 ).
      DATA temp2 LIKE REF TO ms_struc.
      GET REFERENCE OF ms_struc INTO temp2.
mo_layout_obj_2 = z2ui5_cl_demo_app_333=>factory( i_data   = temp2
                                                        vis_cols = 3 ).

      ui5_view_display( client ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'BACK'.

        client->nav_app_leave( ).

      WHEN 'GO'.

        DATA app TYPE REF TO z2ui5_cl_demo_app_336.
        app = z2ui5_cl_demo_app_336=>factory( ).
        client->nav_app_call( app ).

      WHEN 'CHANGE'.

        get_data_2( ).

    ENDCASE.

    IF     client->get( )-check_on_navigated = abap_true
       AND client->check_on_init( )          = abap_false.
      ui5_view_display( client ).
    ENDIF.

    IF ms_struc IS INITIAL.
      client->message_toast_display( 'ERROR - MS_STRUC is initial!' ).
    ENDIF.

    IF mo_layout_obj->mr_data IS NOT BOUND.
      client->message_toast_display( 'ERROR - mo_layout_obj->mr_data is not bound!' ).
    ENDIF.

    IF mo_layout_obj_2->mr_data IS NOT BOUND.
      client->message_toast_display( 'ERROR - mo_layout_obj_2->mr_data  is not bound!' ).
    ENDIF.

    client->view_model_update( ).

  ENDMETHOD.

  METHOD ui5_view_display.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell( )->page( title          = 'RTTI IV'
                                                                navbuttonpress = client->_event( 'BACK' )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    page->button( text  = 'CALL Next App'
                  press = client->_event( 'GO' )
                  type  = 'Success' ).

    page->button( text  = 'Change Data'
                  press = client->_event( 'CHANGE' )
                  type  = 'Success' ).

    DATA form TYPE REF TO z2ui5_cl_xml_view.
    form = page->simple_form( editable        = abap_true
                                    layout          = `ResponsiveGridLayout`
                                    adjustlabelspan = abap_true
                              )->content( ns = `form` ).

    DATA index TYPE i.
    index = 0.

    DATA temp3 LIKE LINE OF mo_layout_obj->ms_data-t_layout.
    DATA layout LIKE REF TO temp3.
    LOOP AT mo_layout_obj->ms_data-t_layout REFERENCE INTO layout.

      index = index + 1.

      FIELD-SYMBOLS <val> TYPE data.
      ASSIGN mo_layout_obj->mr_data->* TO <val>.
      FIELD-SYMBOLS <value> TYPE any.
      ASSIGN COMPONENT layout->name OF STRUCTURE <val> TO <value>.
      " assign component layout->name of structure ms_struc to field-symbol(<value>).
      IF <value> IS NOT ASSIGNED.
        RETURN.
      ENDIF.

      DATA line TYPE REF TO z2ui5_cl_xml_view.
      line = form->label( wrapping = abap_false
                                text     = layout->name  ).

      line->input( value   = client->_bind( <value> )
                   visible = client->_bind( val       = layout->visible
                                            tab       = mo_layout_obj->ms_data-t_layout
                                            tab_index = index )
                   enabled = abap_false ).
    ENDLOOP.

    client->view_display( page ).

  ENDMETHOD.

  METHOD get_data.

    SELECT SINGLE * FROM z2ui5_t_01
      INTO CORRESPONDING FIELDS OF ms_struc.

  ENDMETHOD.

  METHOD get_data_2.

    SELECT SINGLE * FROM z2ui5_t_01 INTO CORRESPONDING FIELDS OF ms_struc
      WHERE id <> ms_struc-id
      .

  ENDMETHOD.

ENDCLASS.
