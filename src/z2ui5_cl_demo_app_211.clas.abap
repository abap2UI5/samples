"!
CLASS Z2UI5_CL_DEMO_APP_211 DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_serializable_object.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_t002,
        id    TYPE string,
        icon  TYPE string,
        count TYPE string,
        table TYPE string,
        descr TYPE string,
        class TYPE string,
      END OF ty_s_t002.
    TYPES ty_t_t002 TYPE STANDARD TABLE OF ty_s_t002 WITH DEFAULT KEY.

    DATA mv_selectedkey     TYPE string.
    DATA mv_selectedkey_tmp TYPE string.
    DATA mt_t002            TYPE ty_t_t002.
    DATA mo_app             TYPE REF TO object.

  PROTECTED SECTION.
    DATA mo_main_page      TYPE REF TO z2ui5_cl_xml_view.

    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS on_init.
    METHODS on_event.
    METHODS render_Main.

    METHODS get_count
      IMPORTING
        tabname       TYPE tabname
      RETURNING
        VALUE(result) TYPE string.

    METHODS Render_sub_app.

  PRIVATE SECTION.

ENDCLASS.


CLASS Z2UI5_CL_DEMO_APP_211 IMPLEMENTATION.

  METHOD get_count.

    DATA o_table TYPE REF TO data.

    FIELD-SYMBOLS <table> TYPE ANY TABLE.

    CHECK tabname IS NOT INITIAL.

    TRY.

        cl_abap_typedescr=>describe_by_name( EXPORTING  p_name         = tabname
                                             RECEIVING  p_descr_ref    = DATA(o_type_desc)
                                             EXCEPTIONS type_not_found = 1 ).

        IF sy-subrc = 1.
          RETURN.
        ENDIF.

        DATA(o_struct_desc) = CAST cl_abap_structdescr( o_type_desc ).

        DATA(new_table_desc) = cl_abap_tabledescr=>create( p_line_type  = o_struct_desc
                                                           p_table_kind = cl_abap_tabledescr=>tablekind_std ).

        CREATE DATA o_table TYPE HANDLE new_table_desc.

        ASSIGN o_table->* TO <table>.

        SELECT * FROM (tabname) INTO CORRESPONDING FIELDS OF TABLE <table>.

        result = lines( <table> ).

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.

  METHOD on_event.
    CASE client->get( )-event.
      WHEN 'ONSELECTICONTABBAR'.

        CASE mv_selectedkey.

          WHEN space.

          WHEN OTHERS.

        ENDCASE.

      WHEN 'BACK'.

    ENDCASE.
  ENDMETHOD.

  METHOD on_init.

    mt_t002 = VALUE #( class = 'Z2UI5_CL_DEMO_APP_212'
                       ( id = '1' count = '5' table = 'Z2UI5_T003' descr = 'Table 01' icon = 'sap-icon://add' )
                       ( id = '2' count = '10' table = 'Z2UI5_T003'  descr = 'Table 01' icon = 'sap-icon://add' )
                       ( id = '3' count = '15' table = 'Z2UI5_T004'  descr = 'Table 02' icon = 'sap-icon://accept' ) ).

    mv_selectedkey = '1'.

  ENDMETHOD.

  METHOD render_main.
    DATA(view) = z2ui5_cl_xml_view=>factory( )->shell( ).

    DATA(page) = view->page( id             = `page_main`
                             title          = 'Customizing'
                             navbuttonpress = client->_event( 'BACK' )
                             shownavbutton  = abap_true
                             class          = 'sapUiContentPadding' ).

    DATA(lo_items) = page->icon_tab_bar( class       = 'sapUiResponsiveContentPadding'
                                         selectedKey = client->_bind_edit( mv_selectedkey )
                                         select      = client->_event( val = 'ONSELECTICONTABBAR' )
                                                       )->items( ).

    LOOP AT mt_t002 REFERENCE INTO DATA(line).

      DATA(text) =  line->descr.
      DATA(with_icon) = line->icon.

      lo_items->icon_tab_filter( icon      = line->icon
                                 iconcolor = 'Positive'
                                 count     = line->count
                                 text      = text
                                 key       = line->id
                                 showall   = with_icon ).

      lo_items->icon_tab_separator( ).

    ENDLOOP.

    mo_main_page = lo_items.
  ENDMETHOD.

  METHOD z2ui5_if_app~main.
    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      on_init( ).

      render_Main( ).

    ENDIF.

    on_event( ).

    Render_sub_app( ).
  ENDMETHOD.

  METHOD Render_sub_app.

    READ TABLE mt_t002 REFERENCE INTO DATA(t002)
         WITH KEY id = mv_selectedkey.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    CASE mv_selectedkey.

      WHEN OTHERS.

        IF mv_selectedkey <> mv_selectedkey_tmp.
          CREATE OBJECT mo_app TYPE (t002->class).
        ENDIF.

        TRY.

            CALL METHOD mo_app->('SET_APP_DATA')
              EXPORTING table = t002->table.

            render_Main( ).

            ASSIGN mo_app->('MO_PARENT_VIEW') TO FIELD-SYMBOL(<view>).
            IF <view> IS ASSIGNED.
              <view> = mo_main_page.
            ENDIF.

            CALL METHOD mo_app->('Z2UI5_IF_APP~MAIN')
              EXPORTING client = client.

          CATCH cx_root.
            RETURN.
        ENDTRY.

    ENDCASE.

    IF mo_app->('MV_VIEW_DISPLAY') = abap_true.
      mo_app->('MV_VIEW_DISPLAY') = abap_false.
      client->view_display( mo_main_page->stringify( ) ).
    ENDIF.

    IF mo_app->('MV_VIEW_MODEL_UPDATE') = abap_true.
      mo_app->('MV_VIEW_MODEL_UPDATE') = abap_false.
      client->view_model_update( ).
    ENDIF.

    IF mv_selectedkey <> mv_selectedkey_tmp.

      client->view_display( mo_main_page->stringify( ) ).

      mv_selectedkey_tmp = mv_selectedkey.

    ENDIF.
  ENDMETHOD.

ENDCLASS.
