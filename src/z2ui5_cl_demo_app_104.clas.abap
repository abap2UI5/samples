CLASS z2ui5_cl_demo_app_104 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mo_app_sub TYPE REF TO object .
    DATA mv_classname TYPE string.

    TYPES:
      BEGIN OF ty_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        selected TYPE abap_bool,
        checkbox TYPE abap_bool,
      END OF ty_row .

    DATA
      mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY .
    DATA
      mt_tab2 TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY .
    DATA mv_layout TYPE string .
    DATA mo_grid_sub TYPE REF TO z2ui5_cl_xml_view .
    DATA lo_view_nested TYPE REF TO z2ui5_cl_xml_view.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS view_display_master.
    METHODS view_display_detail.
    METHODS on_event_sub.
    METHODS on_init_sub.

  PRIVATE SECTION.

ENDCLASS.

CLASS z2ui5_cl_demo_app_104 IMPLEMENTATION.

  METHOD on_event_sub.

    IF mo_app_sub IS BOUND.

      ASSIGN mo_app_sub->(`MO_VIEW_PARENT`) TO FIELD-SYMBOL(<fs>).
      <fs> = mo_grid_sub.
      CALL METHOD mo_app_sub->(`Z2UI5_IF_APP~MAIN`) EXPORTING mo_client = mo_client.

    ENDIF.
  ENDMETHOD.

  METHOD on_init_sub.

    mv_classname = to_upper( mv_classname ).
    CREATE OBJECT mo_app_sub TYPE (mv_classname).

    ASSIGN mo_app_sub->(`MO_VIEW_PARENT`) TO FIELD-SYMBOL(<fs>).
    <fs> = mo_grid_sub.
    CALL METHOD mo_app_sub->(`Z2UI5_IF_APP~MAIN`) EXPORTING mo_client = mo_client.
  ENDMETHOD.

  METHOD view_display_detail.

    lo_view_nested = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view_nested->page( title = `Nested View` ).
    mo_grid_sub = lo_page->grid( `L12 M12 S12`
        )->content( `layout` ).
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
                                                     id     =`test` ).

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
        ( title = `Class 1`  info = `z2ui5_cl_demo_app_105`   descr = `this is a description` icon = `sap-icon://account` )
        ( title = `Class 2`  info = `z2ui5_cl_demo_app_112` descr = `this is a description` icon = `sap-icon://account` ) ).

      mv_layout = `OneColumn`.
      view_display_master( ).
      view_display_detail( ).

    ENDIF.

    IF mo_client->check_on_event( `SELCHANGE` ).

      DATA(lt_sel) = mt_tab.
      DELETE lt_sel WHERE selected = abap_false.

      READ TABLE lt_sel INTO DATA(ls_sel) INDEX 1.
      APPEND ls_sel TO mt_tab2.

      IF mv_classname IS NOT INITIAL.
        view_display_master( ).
      ENDIF.
      mv_classname = ls_sel-info.

      mv_layout = `TwoColumnsMidExpanded`.
      mo_client->view_model_update( ).
      view_display_detail( ).
      on_init_sub( ).

      mo_client->nest_view_display(
        val            = lo_view_nested->stringify( )
        id             = `test`
        method_insert  = `addMidColumnPage`
        method_destroy = `removeAllMidColumnPages` ).
    ENDIF.

    on_event_sub( ).
  ENDMETHOD.
ENDCLASS.
