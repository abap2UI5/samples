CLASS z2ui5_cl_demo_app_045 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        count    TYPE i,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        checkbox TYPE abap_bool,
      END OF ty_s_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.

    DATA mv_info_filter TYPE string.

    METHODS refresh_data.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_045 IMPLEMENTATION.


  METHOD refresh_data.
      DATA temp1 TYPE ty_s_row.
      DATA temp2 TYPE z2ui5_cl_demo_app_045=>ty_s_row-info.
      DATA ls_row LIKE temp1.

    DO 1000 TIMES.
      
      CLEAR temp1.
      temp1-count = sy-index.
      temp1-value = `red`.
      
      IF sy-index < 50.
        temp2 = `completed`.
      ELSE.
        temp2 = `uncompleted`.
      ENDIF.
      temp1-info = temp2.
      temp1-descr = `this is a description`.
      temp1-checkbox = abap_true.
      
      ls_row = temp1.
      INSERT ls_row INTO TABLE t_tab.
    ENDDO.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.

    IF client->check_on_init( ) IS NOT INITIAL.
      refresh_data( ).
    ENDIF.

    CASE client->get( )-event.

      WHEN `FILTER_INFO`.
        refresh_data( ).
        IF mv_info_filter <> ``.
          DELETE t_tab WHERE info <> mv_info_filter.
        ENDIF.

      WHEN `BUTTON_POST`.
        client->message_box_display( `button post was pressed` ).
    ENDCASE.

    
    page = z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
            title          = `abap2UI5 - Table - Backend Filter`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
            )->header_content(
                )->link(
      )->get_parent( ).

    page->message_strip(
        text     = `A growing, scrollable table filtered on the backend: entering a value in the form and ` &&
                   `pressing filter deletes the non-matching rows server-side before re-rendering.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->simple_form( title    = `Form Title`
                       editable = abap_true
                )->content( `form`
                    )->title( `Filter`
                    )->label( `info`
                    )->input( client->_bind( mv_info_filter )
                    )->button(
                        text  = `filter`
                        press = client->_event( `FILTER_INFO` ) ).

    
    tab = page->scroll_container( height   = `70%`
                                        vertical = abap_true
        )->table(
            growing             = abap_true
            growingthreshold    = `20`
            growingscrolltoload = abap_true
            items               = client->_bind( t_tab )
            sticky              = `ColumnHeaders,HeaderToolbar` ).

    tab->header_toolbar(
        )->overflow_toolbar(
            )->toolbar_spacer( ).

    tab->columns(
        )->column(
            )->text( `Color` )->get_parent(
        )->column(
            )->text( `Info` )->get_parent(
        )->column(
            )->text( `Description` )->get_parent(
        )->column(
            )->text( `Checkbox` )->get_parent(
         )->column(
            )->text( `Counter` ).

    tab->items( )->column_list_item( )->cells(
       )->text( `{VALUE}`
       )->text( `{INFO}`
       )->text( `{DESCR}`
       )->checkbox( selected = `{CHECKBOX}`
                    enabled  = abap_false
       )->text( `{COUNT}` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
