CLASS z2ui5_cl_demo_app_332 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA ms_struc     TYPE z2ui5_t_01.
    DATA mo_table_obj TYPE REF TO z2ui5_cl_demo_app_333.

    METHODS get_data.

    METHODS view_display
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_332 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      get_data( ).

      mo_table_obj = z2ui5_cl_demo_app_333=>factory( i_data   = REF #( ms_struc )
                                                     vis_cols = 3 ).

      view_display( client ).

    ENDIF.
    IF ms_struc IS INITIAL.
      client->message_toast_display( `ERROR - MS_STRUC is initial!` ).
    ENDIF.

    client->view_model_update( ).
  ENDMETHOD.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell( )->page( title          = `RTTI IV`
                                                                navbuttonpress = client->_event_nav_app_leave( )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    lo_page->button( text  = `GO`
                  press = client->_event( `GO` )
                  type  = `Success` ).

    DATA(lo_form) = lo_page->simple_form( editable        = abap_true
                                    layout          = `ResponsiveGridLayout`
                                    adjustlabelspan = abap_true
                              )->content( ns = `form` ).

    DATA(lv_index) = 0.

    LOOP AT mo_table_obj->ms_data-t_layout REFERENCE INTO DATA(layout).

      lv_index = lv_index + 1.

      ASSIGN mo_table_obj->mr_data->* TO FIELD-SYMBOL(<val>).
      ASSIGN COMPONENT layout->name OF STRUCTURE <val> TO FIELD-SYMBOL(<value>).
      IF <value> IS NOT ASSIGNED.
        RETURN.
      ENDIF.

      DATA(lo_line) = lo_form->label( wrapping = abap_false
                                text     = layout->name ).

      lo_line->input( value   = client->_bind( <value> )
                   visible = client->_bind( val       = layout->visible
                                            tab       = mo_table_obj->ms_data-t_layout
                                            tab_index = lv_index )
                   enabled = abap_false ).
    ENDLOOP.

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD get_data.

    SELECT SINGLE * FROM z2ui5_t_01
      INTO CORRESPONDING FIELDS OF @ms_struc.
  ENDMETHOD.
ENDCLASS.
