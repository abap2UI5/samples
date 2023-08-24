CLASS z2ui5_cl_app_demo_97 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        selected TYPE abap_bool,
        checkbox TYPE abap_bool,
      END OF ty_row.

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA t_tab2 TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA check_initialized TYPE abap_bool .
    DATA mv_check_enabled_01 TYPE abap_bool VALUE abap_true ##NO_TEXT.
    DATA mv_check_enabled_02 TYPE abap_bool .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display_master.
    METHODS view_display_detail.

  PRIVATE SECTION.

ENDCLASS.



CLASS Z2UI5_CL_APP_DEMO_97 IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_APP_DEMO_97->VIEW_DISPLAY_DETAIL
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD view_display_detail.

    DATA(lo_view_nested) = z2ui5_cl_xml_view=>factory( client ).

    DATA(page) = lo_view_nested->page( title = `Nested View` ).

    DATA(tab) = page->ui_table( rows = client->_bind_edit( val = t_tab2 )
                                editable = abap_false
                                alternaterowcolors = abap_true
                                rowactioncount = '2'
                                enablegrouping = abap_false
                                fixedcolumncount = '1'
                                selectionmode = 'None'
                                sort = client->_event( 'SORT' )
                                filter = client->_event( 'FILTER' )
                                customfilter =  client->_event( 'CUSTOMFILTER' ) ).
    tab->ui_extension( )->overflow_toolbar( )->title( text = 'Products' ).
    DATA(lo_columns) = tab->ui_columns( ).
*    lo_columns->ui_column( width = '4rem' )->checkbox( selected = client->_bind_edit( lv_selkz ) enabled = abap_true select = client->_event( val = `SELKZ` ) )->ui_template( )->checkbox( selected = `{SELKZ}`  ).
    lo_columns->ui_column(  sortproperty = 'TITLE'
                                          filterproperty = 'TITLE' )->text( text = `Index` )->ui_template( )->text(   text = `{TITLE}` ).
    lo_columns->ui_column(  sortproperty = 'VALUE'
                           filterproperty = 'VALUE' )->text( text = `VALUE` )->ui_template( )->input( value = `{VALUE}` editable = abap_false ).
    lo_columns->ui_column(  sortproperty = 'DESCR' filterproperty = 'DESCR' )->text( text = `DESCR` )->ui_template( )->text(   text = `{DESCR}` ).
    lo_columns->ui_column(  sortproperty = 'INFO' filterproperty = 'INFO')->text( text = `INFO` )->ui_template( )->text( text = `{INFO}` ).


    client->nest_view_display(
      val            = lo_view_nested->stringify( )
      id             = `test`
      method_insert  = 'addMidColumnPage'
      method_destroy = 'removeAllMidColumnPages'
    ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method Z2UI5_CL_APP_DEMO_97->VIEW_DISPLAY_MASTER
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD view_display_master.

*    DATA(lr_view) = z2ui5_cl_xml_view=>factory( client ).

    DATA(page) = z2ui5_cl_xml_view=>factory( client
       )->page(
          title          = 'abap2UI5 - Master Detail Page with Nested View'
          navbuttonpress = client->_event( 'BACK' )
            shownavbutton = abap_true ).

    page->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link( text = 'Source_Code'  target = '_blank' href = page->hlp_get_source_code_url(  )
         )->get_parent( ).

    DATA(col_layout) =  page->flexible_column_layout( layout = 'TwoColumnsMidExpanded' id ='test' ).

    DATA(lr_master) = col_layout->begin_column_pages( ).

    DATA(lr_list) = lr_master->list(
          headertext      = 'List Ouput'
          items           = client->_bind_edit( t_tab )
          mode            = `SingleSelectMaster`
          selectionchange = client->_event( 'SELCHANGE' )
          )->standard_list_item(
              title       = '{TITLE}'
              description = '{DESCR}'
              icon        = '{ICON}'
              info        = '{INFO}'
              press       = client->_event( 'TEST' )
              selected    = `{SELECTED}`
         ).

    client->view_display( lr_list->stringify( ) ).

  ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method Z2UI5_CL_APP_DEMO_97->Z2UI5_IF_APP~MAIN
* +-------------------------------------------------------------------------------------------------+
* | [--->] CLIENT                         TYPE REF TO Z2UI5_IF_CLIENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      t_tab = VALUE #(
        ( title = 'row_01'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_02'  info = 'incompleted' descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_03'  info = 'working'     descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_04'  info = 'working'     descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_05'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_06'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
      ).


      view_display_master(  ).
      view_display_detail(  ).

    ENDIF.

    CASE client->get( )-event.

      WHEN `SELCHANGE`.
        DATA(lt_sel) = t_tab.
        DELETE lt_sel WHERE selected = abap_false.

        READ TABLE lt_sel INTO DATA(ls_sel) INDEX 1.

        APPEND ls_sel TO t_tab2.

        client->nest_view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
