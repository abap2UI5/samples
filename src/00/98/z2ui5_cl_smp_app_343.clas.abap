CLASS z2ui5_cl_smp_app_343 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mt_data1       TYPE REF TO data.

    METHODS get_data.

    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS get_comp
      RETURNING
        VALUE(result) TYPE abap_component_tab.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS Z2UI5_CL_SMP_APP_343 IMPLEMENTATION.


  METHOD get_comp.

    TRY.

            cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = `Z2UI5_T_01`
                                                 RECEIVING p_descr_ref     = DATA(typedesc)
                                                 EXCEPTIONS type_not_found = 1
                                                            OTHERS         = 2 ).

            DATA(structdesc) = CAST cl_abap_structdescr( typedesc ).

            DATA(comp) = structdesc->get_components( ).

            LOOP AT comp INTO DATA(com).

              IF com-as_include = abap_false.
                APPEND com TO result.

              ENDIF.

            ENDLOOP.

          CATCH cx_root.
        ENDTRY.


  ENDMETHOD.


  METHOD get_data.

    FIELD-SYMBOLS <table1> TYPE STANDARD TABLE.

    DATA(t_comp) = get_comp( ).
    TRY.

        DATA(new_struct_desc) = cl_abap_structdescr=>create( t_comp ).
        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = new_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA mt_data1 TYPE HANDLE new_table_desc.
        ASSIGN mt_data1->* TO <table1>.

        SELECT * FROM z2ui5_t_01
          ORDER BY PRIMARY KEY
          INTO TABLE @<table1>
          UP TO 5 ROWS.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `RTTI IV`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    TRY.

        " The binding below is WRONG ON PURPOSE and this app exists to prove
        " it stays wrong: mt_data1 is TYPE REF TO data, and the framework has
        " to refuse it rather than serialize a reference. If _bind( ) ever
        " stops raising, the first message_box below fires and the test fails.
        " abap2ui5lint-disable-next-line missing-required-aggregation -- the chain never gets as far as `columns`: the line below is expected to raise
        page->ele( `Table`
            " abap2ui5lint-disable-next-line binding-to-reference -- this is the assertion, not a mistake
            )->a( n = `items` v = client->_bind( mt_data1 )
            )->a( n = `width` v = `auto` ).

        client->message_box_display( `error - reference processed in binding without error` ).
      CATCH cx_root.
        client->message_box_display( `success - reference not allowed for binding thrown` ).
    ENDTRY.

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      get_data( ).
      view_display( client ).

    ELSEIF client->check_on_navigated( ).
      view_display( client ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
