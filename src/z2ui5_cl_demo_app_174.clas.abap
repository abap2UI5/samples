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
    DATA ms_layout  TYPE z2ui5_cl_popup_layout_v2=>ty_s_layout.

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
        client->nav_app_leave( ).
      WHEN OTHERS.
        on_event_layout( ).
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
             shownavbutton = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(table) = view->table(
      growing    = 'true'
      width      = 'auto'
      items      = client->_bind( val = mt_table )
      headertext = 'Table'
    ).

    DATA(headder) =  table->header_toolbar(
               )->overflow_toolbar(
                 )->title(   text =  'Table'
                 )->toolbar_spacer( ).

    headder->button( text =  'Layout'
                         icon = 'sap-icon://action-settings'
                         press = client->_event( val = 'LAYOUT_EDIT' ) ).

    DATA(columns) = table->columns( ).

    LOOP AT ms_layout-t_layout REFERENCE INTO DATA(layout).
      DATA(lv_index) = sy-tabix.

      columns->column(
        visible         = client->_bind( val = layout->visible    tab = ms_layout-t_layout tab_index = lv_index )
        halign          = client->_bind( val = layout->halign     tab = ms_layout-t_layout tab_index = lv_index )
        importance      = client->_bind( val = layout->importance tab = ms_layout-t_layout tab_index = lv_index )
        mergeduplicates = client->_bind( val = layout->merge      tab = ms_layout-t_layout tab_index = lv_index )
        minscreenwidth  = client->_bind( val = layout->width      tab = ms_layout-t_layout tab_index = lv_index )
                          )->text( layout->fname ).

    ENDLOOP.


    DATA(cells) = columns->get_parent( )->items(
           )->column_list_item( valign = 'Middle'
                                type   = 'Navigation'
                                press  = client->_event(
                                    val   = 'ROW_SELECT'
                                    t_arg = VALUE #( ( `${ROW_ID}` ) ) )
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

    IF client->get( )-check_on_navigated = abap_true.
      on_after_layout( ).
      RETURN.
    ENDIF.

    IF client->get( )-event IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.

  METHOD create_layout.

    ms_layout = z2ui5_cl_popup_layout_v2=>init_layout(
      tab       = REF #( mt_table )
      classname = z2ui5_cl_util=>rtti_get_classname_by_ref( me ) ).

  ENDMETHOD.


  METHOD on_after_layout.

    TRY.
        DATA(app) = CAST z2ui5_cl_popup_layout_v2( client->get_app( client->get( )-s_draft-id_prev_app ) ).
        DATA(ls_result) = app->result( ).
        IF ls_result-check_cancel = abap_true.
          RETURN.
        ENDIF.
        ms_layout = app->ms_layout.
        view_display( ).

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD on_event_layout.


    CASE client->get( )-event.

      WHEN 'LAYOUT_EDIT'.
        client->nav_app_call( z2ui5_cl_popup_layout_v2=>factory( layout = ms_layout
                                       extended_layout = abap_true   ) ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
