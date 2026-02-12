CLASS z2ui5_cl_demo_app_097 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

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

    DATA mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA mt_tab2 TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA mv_layout TYPE string.
  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS view_display_master.
    METHODS view_display_detail.

  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_097 IMPLEMENTATION.

  METHOD view_display_detail.

    DATA(lo_view_nested) = z2ui5_cl_xml_view=>factory( ).

    DATA(lo_page) = lo_view_nested->page( title = `Nested View` ).

    DATA(lo_tab) = lo_page->ui_table( rows               = mo_client->_bind_edit( val = mt_tab2 view = mo_client->cs_view-nested )
                                editable           = abap_false
                                alternaterowcolors = abap_true
                                rowactioncount     = `1`
                                enablegrouping     = abap_false
                                fixedcolumncount   = `1`
                                selectionmode      = `None`
                                sort               = mo_client->_event( `SORT` )
                                filter             = mo_client->_event( `FILTER` )
                                customfilter       = mo_client->_event( `CUSTOMFILTER` ) ).
    lo_tab->ui_extension( )->overflow_toolbar( )->title( text = `Products` ).
    DATA(lo_columns) = lo_tab->ui_columns( ).

    lo_columns->ui_column( sortproperty                  = `TITLE`
                                          filterproperty = `TITLE` )->text( text = `Index` )->ui_template( )->text( text = `{TITLE}` ).
    lo_columns->ui_column( sortproperty   = `DESCR`
                           filterproperty = `DESCR` )->text( text = `DESCR` )->ui_template( )->text( text = `{DESCR}` ).
    lo_columns->ui_column( sortproperty   = `INFO`
                           filterproperty = `INFO` )->text( text = `INFO` )->ui_template( )->text( text = `{INFO}` ).
    lo_columns->get_parent( )->ui_row_action_template( )->ui_row_action(
       )->ui_row_action_item( icon = `sap-icon://delete`
                           press   = mo_client->_event( val = `ROW_DELETE` t_arg = VALUE #( ( `${TITLE}` ) ) ) ).

    mo_client->nest_view_display(
      val            = lo_view_nested->stringify( )
      id             = `test`
      method_insert  = `addMidColumnPage`
      method_destroy = `removeAllMidColumnPages` ).
  ENDMETHOD.

  METHOD view_display_master.

    DATA(lo_page) = z2ui5_cl_xml_view=>factory(
       )->page(
          title           = `abap2UI5 - Master Detail Page with Nested View`
          navbuttonpress  = mo_client->_event_nav_app_leave( )
            shownavbutton = abap_true ).

    lo_page->header_content(
             )->link( text   = `Demo`
                      target = `_blank`
                      href   = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link(
         )->get_parent( ).

    DATA(lo_col_layout) = lo_page->flexible_column_layout( layout = mo_client->_bind_edit( mv_layout )
                                                     id     = `test` ).

    DATA(lr_master) = lo_col_layout->begin_column_pages( ).

    DATA(lr_list) = lr_master->list(
          headertext      = `List Ouput`
          items           = mo_client->_bind_edit( val = mt_tab view = mo_client->cs_view-main )
          mode            = `SingleSelectMaster`
          selectionchange = mo_client->_event( `SELCHANGE` )
          )->standard_list_item(
              title       = `{TITLE}`
              description = `{DESCR}`
              icon        = `{ICON}`
              info        = `{INFO}`
              press       = mo_client->_event( `TEST` )
              selected    = `{SELECTED}` ).

    mo_client->view_display( lr_list->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      mt_tab = VALUE #(
        ( title = `row_01`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
        ( title = `row_02`  info = `incompleted` descr = `this is a description` icon = `sap-icon://account` )
        ( title = `row_03`  info = `working`     descr = `this is a description` icon = `sap-icon://account` )
        ( title = `row_04`  info = `working`     descr = `this is a description` icon = `sap-icon://account` )
        ( title = `row_05`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
        ( title = `row_06`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` ) ).

      mv_layout = `OneColumn`.

      view_display_master( ).
      view_display_detail( ).

    ENDIF.

    CASE mo_client->get( )-event.
      WHEN `ROW_DELETE`.
        DATA(lt_arg) = mo_client->get( )-t_event_arg.
        READ TABLE lt_arg INTO DATA(ls_arg) INDEX 1.
        IF ls_arg IS NOT INITIAL.
          DELETE mt_tab2 WHERE title = ls_arg.
        ENDIF.

        mo_client->nest_view_model_update( ).
      WHEN `SELCHANGE`.
        DATA(lt_sel) = mt_tab.
        DELETE lt_sel WHERE selected = abap_false.

        READ TABLE lt_sel INTO DATA(ls_sel) INDEX 1.
        APPEND ls_sel TO mt_tab2.

        mv_layout = `TwoColumnsMidExpanded`.

        mo_client->nest_view_model_update( ).
        mo_client->view_model_update( ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
