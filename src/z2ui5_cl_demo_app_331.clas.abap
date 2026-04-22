CLASS z2ui5_cl_demo_app_331 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA ms_struc     TYPE z2ui5_t_01.
    DATA mo_table_obj TYPE REF TO z2ui5_cl_demo_app_329.

    METHODS get_data.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_331 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      get_data( ).
      mo_table_obj = z2ui5_cl_demo_app_329=>factory( REF #( ms_struc ) ).
      view_display( client ).
    ENDIF.

    IF ms_struc IS INITIAL.
      client->message_toast_display( `ERROR - MS_STRUC is initial!` ).
    ENDIF.

    client->view_model_update( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell( )->page( title          = `RTTI IV`
                                                                navbuttonpress = client->_event_nav_app_leave( )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    page->button( text  = `GO`
                  press = client->_event( `GO` )
                  type  = `Success` ).

    DATA(form) = page->simple_form( editable        = abap_true
                                    layout          = `ResponsiveGridLayout`
                                    adjustlabelspan = abap_true
                              )->content( `form` ).

    ASSIGN mo_table_obj->mr_data->* TO FIELD-SYMBOL(<val>).
    ASSIGN COMPONENT `ID` OF STRUCTURE <val> TO FIELD-SYMBOL(<value>).

    IF <value> IS NOT ASSIGNED.
      RETURN.
    ENDIF.

    DATA(line) = form->label( wrapping = abap_false
                              text     = `ID` ).

    line->input( client->_bind( <value> ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD get_data.

    SELECT SINGLE * FROM z2ui5_t_01
      INTO CORRESPONDING FIELDS OF @ms_struc.

  ENDMETHOD.

ENDCLASS.
