CLASS z2ui5_cl_demo_app_174 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_tab,
        selkz            TYPE abap_bool,
        product          TYPE string,
        create_date      TYPE string,
        create_by        TYPE string,
        storage_location TYPE string,
        quantity         TYPE i,
      END OF ty_s_tab.
    TYPES ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    DATA mt_table TYPE ty_t_table.

    DATA ms_layout  TYPE Z2UI5_CL_POPUP_LAYOUT_V2=>ty_s_layout.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA mv_check_initialized TYPE abap_bool.
    METHODS on_event.
    METHODS view_display.
    METHODS set_data.
    METHODS on_after_layout.
    METHODS on_event_layout.
    METHODS create_layout.

  PRIVATE SECTION.

ENDCLASS.


CLASS z2ui5_cl_demo_app_174 IMPLEMENTATION.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
     WHEN OTHERS.
         on_event_LAYOUT( ).
    ENDCASE.

  ENDMETHOD.


  METHOD set_data.

    "replace this with a db select here...
    mt_table = VALUE #(
        ( product = 'table'    create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'chair'    create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'sofa'     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'sofa'     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'sofa'     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'computer' create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'oven'     create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
        ( product = 'table2'   create_date = `01.01.2023` create_by = `Peter` storage_location = `AREA_001` quantity = 400 )
    ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    view = view->shell( )->page( id = `page_main`
             title          = 'abap2UI5 - Popup Layout'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
         ).

  DATA(table) = view->table(
      growing    = 'true'
      width      = 'auto'
      items      = client->_bind( val = mt_table )
      headerText = 'Table'
    ).

    DATA(headder) =  table->header_toolbar(
               )->overflow_toolbar(
                 )->Title(   text =  'Table'
                 )->toolbar_spacer(
                 ).

    headder = Z2UI5_CL_POPUP_LAYOUT_V2=>render_layout_function( xml    = headder
                                                             client = client ).

    DATA(columns) = table->columns( ).


    LOOP AT ms_layout-t_layout REFERENCE INTO DATA(layout).
      DATA(lv_index) = sy-tabix.

      columns->column(
                       visible         = client->_bind( val = layout->visible         tab = ms_layout-t_layout tab_index = lv_index )
                       halign          = client->_bind( val = layout->halign          tab = ms_layout-t_layout tab_index = lv_index )
                       importance      = client->_bind( val = layout->importance      tab = ms_layout-t_layout tab_index = lv_index )
                       mergeduplicates = client->_bind( val = layout->merge           tab = ms_layout-t_layout tab_index = lv_index )
                       minscreenwidth  = client->_bind( val = layout->width           tab = ms_layout-t_layout tab_index = lv_index )
       )->text( layout->fname ).

    ENDLOOP.


    DATA(cells) = columns->get_parent( )->items(
                                       )->column_list_item( vAlign = 'Middle'
                                                            type   = 'Navigation'
                                                            press  = client->_event( val   = 'ROW_SELECT'
                                                                                     t_arg = VALUE #( ( `${ROW_ID}`  ) ) )
                                       )->cells( ).

    LOOP AT ms_layout-t_layout REFERENCE INTO layout.

      cells->object_identifier( text = '{' && layout->fname && '}' ).

    ENDLOOP.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF mv_check_initialized = abap_false.
      mv_check_initialized = abap_true.

      set_data( ).

      create_layout( ).

      view_display( ).

      RETURN.

    ENDIF.

    on_after_LAYOUT( ).

    IF client->get( )-event IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.

  METHOD create_layout.

    DATA: tab         TYPE REF TO data.
    DATA: lr_tabdescr TYPE REF TO cl_abap_tabledescr.
    FIELD-SYMBOLS: <fs_tab> TYPE ANY TABLE.

    lr_tabdescr ?= cl_abap_tabledescr=>describe_by_data( mt_table ).
    CREATE DATA tab TYPE HANDLE lr_tabdescr.
    ASSIGN tab->* TO <fs_tab>.
    <fs_tab> = mt_table.

    DATA(class)   = cl_abap_classdescr=>get_class_name( me ).

    ms_layout = Z2UI5_CL_POPUP_LAYOUT_V2=>init_layout(
      tab   = tab
      class = CONV #( class ) ).

  ENDMETHOD.


  METHOD on_after_layout.

    " Kommen wir aus einer anderen APP
    IF client->get( )-check_on_navigated = abap_true.

      TRY.
          " War es das Layout?
          DATA(app) = CAST Z2UI5_CL_POPUP_LAYOUT_V2( client->get_app( client->get( )-s_draft-id_prev_app ) ).

          ms_layout = app->ms_layout.

          view_display( ).

        CATCH cx_root.
      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD on_event_layout.

    client = Z2UI5_CL_POPUP_LAYOUT_V2=>on_event_layout(
      client = client
      layout = ms_layout ).

  ENDMETHOD.

ENDCLASS.
