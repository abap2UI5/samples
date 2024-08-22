CLASS z2ui5_cl_demo_app_300 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA ms_DATA   TYPE z2ui5_s_deep_structure.
    DATA ms_layout TYPE z2ui5_cl_pop_layout_v2=>ty_s_layout.

  PROTECTED SECTION.
    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS on_init.
    METHODS on_event.

    METHODS render_main.

    METHODS init_layout
      IMPORTING
        r_data        TYPE REF TO data
      RETURNING
        VALUE(result) TYPE z2ui5_cl_pop_layout_v2=>ty_s_layout.

    METHODS xml_build_simple_form
      IMPORTING
        i_DATA    TYPE REF TO data
        i_title   TYPE string OPTIONAL
        i_xml     TYPE REF TO z2ui5_cl_xml_view
      CHANGING
        cs_layout TYPE z2ui5_cl_pop_layout_v2=>ty_s_layout.

  PRIVATE SECTION.

ENDCLASS.


CLASS z2ui5_cl_demo_app_300 IMPLEMENTATION.

  METHOD xml_build_simple_form.

    cs_layout = init_layout( i_data ).

    i_xml->button( icon  = 'sap-icon://action-settings'
                   press = client->_event( val = cs_layout-s_head-guid  ) ).

    FINAL(form) = i_xml->simple_form( title                   = i_title
                                      editable                = abap_true
                                      layout                  = `ResponsiveGridLayout`
                                      labelspans              = '3'
                                      labelspanm              = '3'
                                      labelspanl              = '3'
                                      labelspanxl             = '3'
                                      adjustlabelspan         = abap_false
                                      emptyspanxl             = '4'
                                      emptyspanl              = '4'
                                      emptyspanm              = '2'
                                      emptyspans              = '0'
                                      columnsxl               = '1'
                                      columnsl                = '1'
                                      columnsm                = '1'
                                      singlecontainerfullsize = abap_false
                               )->content( ns = `form` ).

    LOOP AT cs_layout-t_layout REFERENCE INTO DATA(layout).

      FINAL(lv_index) = sy-tabix.

      ASSIGN COMPONENT layout->fname OF STRUCTURE i_data->* TO FIELD-SYMBOL(<value>).
      IF <value> IS NOT ASSIGNED.
        CONTINUE.
      ENDIF.

      " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
      FINAL(line) = form->label( text = client->_bind( val       = layout->tlabel
                                                       tab       = cs_layout-t_layout
                                                       tab_index = lv_index )

              )->input( visible = client->_bind( val       = layout->visible
                                                 tab       = cs_layout-t_layout
                                                 tab_index = lv_index )
                        value   = client->_bind( <value> )
                        enabled = abap_false
                        width   = client->_bind( val       = layout->width
                                                 tab       = cs_layout-t_layout
                                                 tab_index = lv_index ) ).
    ENDLOOP.

  ENDMETHOD.

  METHOD init_layout.

    IF r_data IS NOT BOUND.
      RETURN.
    ENDIF.

    DATA(class) = cl_abap_classdescr=>get_class_name( me ).
    SHIFT class LEFT DELETING LEADING '\CLASS='.

    TRY.
        FINAL(lo_ref) = cl_abap_typedescr=>describe_by_data_ref( r_data ).
        DATA(lo_struct) = CAST cl_abap_structdescr( lo_ref ).
        DATA(control) = z2ui5_cl_pop_layout_v2=>others.
      CATCH cx_root.
        FINAL(lo_tab) = CAST cl_abap_tabledescr( lo_ref ).
        lo_struct = CAST cl_abap_structdescr( lo_tab->get_table_line_type( ) ).
        control = z2ui5_cl_pop_layout_v2=>m_table.
    ENDTRY.

    " TODO: variable is assigned but never used (ABAP cleaner)
    FINAL(table_name) = lo_struct->get_relative_name( ).

    result = z2ui5_cl_pop_layout_v2=>init_layout( control  = control
                                                  data     = r_data
                                                  handle01 = CONV #( class ) ).

  ENDMETHOD.

  METHOD on_event.
    CASE client->get( )-event.

      WHEN 'BACK'.

        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

    ms_data = VALUE #( comp01 = 'AAA'
                       comp02 = 'BBB'
                       COMp03 = 'CCC'
                       s02    = VALUE #( s02_01 = 'S02_01'
                                         s02_02 = 'S02_02'
                                         s02_03 = 'S02_03' )
                       s01_01 = 'S01_01'
                       s01_02 = 'S01_02'
                       s01_03 = 'S01_03' ).

    render_main( ).

  ENDMETHOD.

  METHOD render_main.
    FINAL(page) = z2ui5_cl_xml_view=>factory( ).

    xml_build_simple_form( EXPORTING i_data    = REF #( ms_data )
                                     i_xml     = page
                           CHANGING  cs_layout = ms_layout ).

    client->view_display( page->get_root( )->xml_get( ) ).

  ENDMETHOD.

  METHOD z2ui5_if_app~main.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      on_init( ).

    ENDIF.

    on_event( ).
  ENDMETHOD.

ENDCLASS.
