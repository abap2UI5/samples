CLASS z2ui5_cl_demo_app_335 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA ms_struc        TYPE z2ui5_t_01.
    DATA mo_layout_obj   TYPE REF TO z2ui5_cl_demo_app_333.
    DATA mo_layout_obj_2 TYPE REF TO z2ui5_cl_demo_app_333.

    METHODS get_data.

    METHODS view_display
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS get_data_2.
ENDCLASS.

CLASS z2ui5_cl_demo_app_335 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      get_data( ).

      mo_layout_obj = z2ui5_cl_demo_app_333=>factory( i_data   = REF #( ms_struc )
                                                      vis_cols = 3 ).
      mo_layout_obj_2 = z2ui5_cl_demo_app_333=>factory( i_data   = REF #( ms_struc )
                                                        vis_cols = 3 ).

      view_display( client ).

    ENDIF.

    CASE client->get( )-event.
      WHEN `GO`.

        DATA(lo_app) = z2ui5_cl_demo_app_336=>factory( ).
        client->nav_app_call( lo_app ).
      WHEN `CHANGE`.

        get_data_2( ).
    ENDCASE.

    IF client->get( )-check_on_navigated = abap_true
        AND client->check_on_init( )          = abap_false.
      view_display( client ).
    ENDIF.

    IF ms_struc IS INITIAL.
      client->message_toast_display( `ERROR - MS_STRUC is initial!` ).
    ENDIF.

    IF mo_layout_obj->mr_data IS NOT BOUND.
      client->message_toast_display( `ERROR - mo_layout_obj->mr_data is not bound!` ).
    ENDIF.

    IF mo_layout_obj_2->mr_data IS NOT BOUND.
      client->message_toast_display( `ERROR - mo_layout_obj_2->mr_data  is not bound!` ).
    ENDIF.

    client->view_model_update( ).
  ENDMETHOD.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell( )->page( title          = `RTTI IV`
                                                                navbuttonpress = client->_event_nav_app_leave( )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    lo_page->button( text  = `CALL Next App`
                  press = client->_event( `GO` )
                  type  = `Success` ).

    lo_page->button( text  = `Change Data`
                  press = client->_event( `CHANGE` )
                  type  = `Success` ).

    DATA(lo_form) = lo_page->simple_form( editable        = abap_true
                                    layout          = `ResponsiveGridLayout`
                                    adjustlabelspan = abap_true
                              )->content( ns = `form` ).

    DATA(lv_index) = 0.

    LOOP AT mo_layout_obj->ms_data-t_layout REFERENCE INTO DATA(layout).

      lv_index = lv_index + 1.

      ASSIGN mo_layout_obj->mr_data->* TO FIELD-SYMBOL(<val>).
      ASSIGN COMPONENT layout->name OF STRUCTURE <val> TO FIELD-SYMBOL(<value>).
      IF <value> IS NOT ASSIGNED.
        RETURN.
      ENDIF.

      DATA(lo_line) = lo_form->label( wrapping = abap_false
                                text     = layout->name ).

      lo_line->input( value   = client->_bind( <value> )
                   visible = client->_bind( val       = layout->visible
                                            tab       = mo_layout_obj->ms_data-t_layout
                                            tab_index = lv_index )
                   enabled = abap_false ).
    ENDLOOP.

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD get_data.

    SELECT SINGLE * FROM z2ui5_t_01
      INTO CORRESPONDING FIELDS OF @ms_struc.
  ENDMETHOD.

  METHOD get_data_2.

    SELECT SINGLE * FROM z2ui5_t_01
      WHERE id <> @ms_struc-id
      INTO CORRESPONDING FIELDS OF @ms_struc.
  ENDMETHOD.
ENDCLASS.
