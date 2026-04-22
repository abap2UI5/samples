CLASS z2ui5_cl_demo_app_132 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_view_display TYPE abap_bool.
    DATA mo_parent_view  TYPE REF TO z2ui5_cl_xml_view.
    DATA mv_perc         TYPE string.

    METHODS set_app_data
      IMPORTING
        count TYPE string
        table TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

    METHODS get_comp
      RETURNING
        VALUE(result) TYPE abap_component_tab.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_132 IMPLEMENTATION.

  METHOD get_comp.

    DATA index TYPE int4.

    TRY.

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

        DATA(component) = VALUE cl_abap_structdescr=>component_table(
                                    ( name = `ROW_ID`
                                      type = CAST #( cl_abap_datadescr=>describe_by_data( index ) ) ) ).

        APPEND LINES OF component TO result.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD view_display.

    IF mo_parent_view IS INITIAL.
      DATA(page) = z2ui5_cl_xml_view=>factory( ).

    ELSE.
      page = mo_parent_view->get( `Page` ).

    ENDIF.

*    DATA(layout) = page->vertical_layout( class = `sapUiContentPadding`
*                                          width = `100%` ).
    page->label( `ProgressIndicator`
        )->progress_indicator( percentvalue = mv_perc
                               displayvalue = `0,44GB of 32GB used`
                               showvalue    = abap_true
                               state        = `Success` ).

    IF mo_parent_view IS INITIAL.
      client->view_display( page->stringify( ) ).

    ELSE.
      mv_view_display = abap_true.

    ENDIF.

  ENDMETHOD.


  METHOD set_app_data.

    mv_perc = count.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
