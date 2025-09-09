CLASS z2ui5_cl_demo_app_343 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_data1       TYPE REF TO data.

    METHODS get_data.

    METHODS render_main
      IMPORTING
        !client TYPE REF TO z2ui5_if_client.

    METHODS get_comp
      RETURNING
        VALUE(result) TYPE abap_component_tab.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS z2ui5_cl_demo_app_343 IMPLEMENTATION.


  METHOD get_comp.

    TRY.
        TRY.

            DATA typedesc TYPE REF TO cl_abap_typedescr.
            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = 'Z2UI5_T_01'
                                                 RECEIVING  p_descr_ref    = typedesc
                                                 EXCEPTIONS type_not_found = 1
                                                            OTHERS         = 2 ).

            DATA temp1 TYPE REF TO cl_abap_structdescr.
            temp1 ?= typedesc.
            DATA structdesc LIKE temp1.
            structdesc = temp1.

            DATA comp TYPE abap_component_tab.
            comp = structdesc->get_components( ).

            DATA com LIKE LINE OF comp.
            LOOP AT comp INTO com.

              IF com-as_include = abap_false.

                APPEND com TO result.

              ENDIF.

            ENDLOOP.

          CATCH cx_root.
        ENDTRY.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD get_data.

    FIELD-SYMBOLS <table1> TYPE STANDARD TABLE.

    DATA t_comp TYPE abap_component_tab.
    t_comp = get_comp( ).
    TRY.

        DATA new_struct_desc TYPE REF TO cl_abap_structdescr.
        new_struct_desc = cl_abap_structdescr=>create( t_comp ).
        DATA new_table_desc TYPE REF TO cl_abap_tabledescr.
        new_table_desc = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_data1 TYPE HANDLE new_table_desc.
        ASSIGN mt_data1->* TO <table1>.

        SELECT * FROM Z2ui5_t_01
          INTO TABLE <table1>
          UP TO 5 ROWS.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD render_main.

    DATA page TYPE REF TO z2ui5_cl_xml_view.
    page = z2ui5_cl_xml_view=>factory( )->shell( )->page( title          = 'RTTI IV'
                                                                navbuttonpress = client->_event( 'BACK' )
                                                                shownavbutton  = client->check_app_prev_stack( ) ).

    TRY.

        DATA table TYPE REF TO z2ui5_cl_xml_view.
        table = page->table( width = 'auto'
                                     items = client->_bind( mt_data1 ) ).

        client->message_box_display( `error - reference processed in binding without error` ).
      CATCH cx_root.
        client->message_box_display( `success - reference not allowed for binding throwed` ).
    ENDTRY.


    client->view_display( page ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ) IS NOT INITIAL.
      get_data( ).
      render_main( client ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

    IF client->get( )-check_on_navigated = abap_true
       AND client->check_on_init( )          = abap_false.
      render_main( client ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
