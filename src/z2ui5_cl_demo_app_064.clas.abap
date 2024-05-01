CLASS z2ui5_cl_demo_app_064 DEFINITION
PUBLIC
CREATE PUBLIC .

  PUBLIC SECTION.


    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_s_tab,
        selkz     TYPE abap_bool,
        row_id    TYPE string,
        carrid    TYPE string,
        connid    TYPE string,
        fldate    TYPE string,
        planetype TYPE string,
      END OF ty_s_tab .
    TYPES:
      ty_t_table TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_s_filter_pop,
        option TYPE string,
        low    TYPE string,
        high   TYPE string,
        key    TYPE string,
      END OF ty_s_filter_pop .

    DATA mt_mapping TYPE z2ui5_if_types=>ty_t_name_value .
    DATA mv_search_value TYPE string .
    DATA mt_table TYPE ty_t_table .
    DATA lv_selkz TYPE abap_bool .

    DATA:
      BEGIN OF screen,
        progress_value TYPE string VALUE '0',
        display_value  TYPE string VALUE '',
      END OF screen.
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_on_init.
    METHODS z2ui5_on_event.
    METHODS z2ui5_set_search.
    METHODS z2ui5_set_data.
  PRIVATE SECTION.

    METHODS set_selkz
      IMPORTING
        iv_selkz TYPE abap_bool.
ENDCLASS.

CLASS z2ui5_cl_demo_app_064 IMPLEMENTATION.



  METHOD set_selkz.

    FIELD-SYMBOLS: <ls_table> TYPE ty_s_tab.

    LOOP AT mt_table ASSIGNING <ls_table>.
      <ls_table>-selkz = iv_selkz.
    ENDLOOP.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.
      z2ui5_on_init( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.

  METHOD z2ui5_on_event.
    DATA lt_arg TYPE string_table.
    DATA ls_arg TYPE string.

    CASE client->get( )-event.
      WHEN 'BUTTON_SEARCH' OR 'BUTTON_START'.
        client->message_toast_display( 'Search Entries' ).
        z2ui5_set_data( ).
        z2ui5_set_search( ).
        client->view_model_update( ).
      WHEN 'SORT'.

        lt_arg = client->get( )-t_event_arg.
        client->message_toast_display( 'Event SORT' ).
      WHEN 'FILTER'.
        lt_arg = client->get( )-t_event_arg.
        client->message_toast_display( 'Event FILTER' ).
      WHEN 'SELKZ'.
        client->message_toast_display( |'Event SELKZ' { lv_selkz } | ).
        set_selkz( lv_selkz ).
        client->view_model_update( ).
      WHEN 'CUSTOMFILTER'.
        lt_arg = client->get( )-t_event_arg.
        client->message_toast_display( 'Event CUSTOMFILTER' ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
      WHEN 'ROWEDIT'.
        lt_arg = client->get( )-t_event_arg.

        READ TABLE lt_arg INTO ls_arg INDEX 1.
        IF sy-subrc = 0.
          client->message_toast_display( |Event ROWEDIT Row Index { ls_arg } | ).
        ENDIF.
      WHEN 'ROW_ACTION_ITEM_NAVIGATION'.
        lt_arg = client->get( )-t_event_arg.
        READ TABLE lt_arg INTO ls_arg INDEX 1.
        IF sy-subrc = 0.
          client->message_toast_display( |Event ROW_ACTION_ITEM_NAVIGATION Row Index { ls_arg } | ).
        ENDIF.
      WHEN 'ROW_ACTION_ITEM_EDIT'.
        lt_arg = client->get( )-t_event_arg.
        READ TABLE lt_arg INTO ls_arg INDEX 1.
        IF sy-subrc = 0.
          client->message_toast_display( |Event ROW_ACTION_ITEM_EDIT Row Index { ls_arg } | ).
        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    DATA temp1 TYPE z2ui5_if_types=>ty_t_name_value.
    DATA temp2 LIKE LINE OF temp1.
    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page1 TYPE REF TO z2ui5_cl_xml_view.
    DATA temp5 TYPE xsdboolean.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA header_title TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_box TYPE REF TO z2ui5_cl_xml_view.
    DATA cont TYPE REF TO z2ui5_cl_xml_view.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    DATA lo_columns TYPE REF TO z2ui5_cl_xml_view.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    CLEAR temp1.

    view = z2ui5_cl_xml_view=>factory( ).

    temp5 = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ).
    page1 = view->page( id = 'page_main'
    title = 'abap2UI5 - sap.ui.table.Table Features'
    navbuttonpress = client->_event( 'BACK' )
    shownavbutton = temp5
    class = 'sapUiContentPadding' ).

    page1->header_content(
    )->link(
    text = 'Source_Code' target = '_blank'
    ).

*/
    DATA layout TYPE REF TO z2ui5_cl_xml_view.
    layout = page1->vertical_layout( class = 'sapuicontentpadding' width = '100%' ).
    layout->vbox( )->progress_indicator(
    percentvalue = client->_bind_edit( screen-progress_value )
    displayvalue = client->_bind_edit( screen-display_value )
    showvalue = abap_true

           state           = 'Success'
          ).
*/
    page = page1->dynamic_page( headerexpanded = abap_true headerpinned = abap_true ).

    header_title = page->title( ns = 'f'  )->get( )->dynamic_page_title( ).
    header_title->heading( ns = 'f' )->hbox( )->title( `Search Field` ).
    header_title->expanded_content( 'f' ).
    header_title->snapped_content( ns = 'f' ).


    lo_box = page->header( )->dynamic_page_header( pinnable = abap_true
         )->flex_box( alignitems = `Start` justifycontent = `SpaceBetween` )->flex_box( alignitems = `Start` ).

    lo_box->vbox( )->text( `Search` )->search_field(
         value  = client->_bind_edit( mv_search_value )
         search = client->_event( 'BUTTON_SEARCH' )
         change = client->_event( 'BUTTON_SEARCH' )
        livechange = client->_event( 'BUTTON_SEARCH' )
       width  = `17.5rem`
       id     = `SEARCH` ).
    lo_box->get_parent( )->hbox( justifycontent = 'end' )->button(
    text = 'go'
    press = client->_event( 'button_start' )
    type = 'emphasized' ).

    cont = page->content( ns = 'f' ).

    tab = cont->ui_table( rows = client->_bind( val = mt_table )
    editable = abap_false
    alternaterowcolors = abap_true
    rowactioncount = '2'
    enablegrouping = abap_false
    fixedcolumncount = '1'
    selectionmode = 'None'
    sort = client->_event( 'SORT' )
    filter = client->_event( 'FILTER' )
    customfilter = client->_event( 'CUSTOMFILTER' ) ).
    tab->ui_extension( )->overflow_toolbar( )->title( text = 'Products' ).

    lo_columns = tab->ui_columns( ).
    lo_columns->ui_column( width = '4rem' )->checkbox( selected = client->_bind_edit( lv_selkz ) enabled = abap_true select = client->_event( val = 'SELKZ' ) )->ui_template( )->checkbox( selected = '{SELKZ}' ).
    lo_columns->ui_column( width = '5rem' sortproperty = 'ROW_ID'
    filterproperty = 'ROW_ID' )->text( text = 'index' )->ui_template( )->text( text = '{row_id}' ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'CARRID' filterproperty = 'CARRID' )->text( text = 'carrid' )->ui_template( )->text( text = `{carrid}` ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'CONNID' filterproperty = 'CONNID')->text( text = 'connid' )->ui_template( )->text( text = `{connid}` ).
    lo_columns->ui_column( width = '11rem' sortproperty = 'FLDATE' filterproperty = 'FLDATE' )->text( text = 'fldate' )->ui_template( )->text( text = `{fldate}`).
    lo_columns->ui_column( width = '11rem' sortproperty = 'PLANETYPE' filterproperty = 'PLANETYPE' )->text( text = 'planetype' )->ui_template( )->text( text = `{planetype}` ).

    CLEAR temp3.
    INSERT `${row_id}` INTO TABLE temp3.

    CLEAR temp4.
    INSERT `${row_id}` INTO TABLE temp4.
    lo_columns->get_parent( )->ui_row_action_template( )->ui_row_action(
    )->ui_row_action_item( type = 'Navigation'
    press = client->_event( val = 'ROW_ACTION_ITEM_NAVIGATION' t_arg = temp3 )
    )->get_parent( )->ui_row_action_item( icon = 'sap-icon://edit' text = 'Edit' press = client->_event( val = 'ROW_ACTION_ITEM_EDIT' t_arg = temp4 ) ).

    lo_columns->ui_column( width = '4rem' )->text( )->ui_template( )->overflow_toolbar( )->overflow_toolbar_button(

    icon = 'sap-icon://edit' type = 'Transparent' press = client->_event(

    val = `rowedit` t_arg = VALUE #( ( `${row_id}` ) ) ) ).

    client->view_display( view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_set_data.

*    DATA temp5 TYPE ty_t_table.
*    DATA temp6 LIKE LINE OF temp5.
*    CLEAR temp5.
*
**/ fetch 1
*    SELECT * UP TO 10 ROWS APPENDING CORRESPONDING FIELDS OF TABLE temp5 FROM sflight.
*    screen-progress_value = 25.
*    screen-display_value = 'fetch 1'.
*    WAIT UP TO 2 SECONDS.
**/ fetch 2
*    SELECT * UP TO 10 ROWS APPENDING CORRESPONDING FIELDS OF TABLE temp5 FROM sflight.
*    screen-progress_value = 50.
*    screen-display_value = 'fetch 2'.
*    WAIT UP TO 2 SECONDS.
**/ fetch 3
*    SELECT * UP TO 10 ROWS APPENDING CORRESPONDING FIELDS OF TABLE temp5 FROM sflight.
*    screen-progress_value = 75.
*    screen-display_value = 'fetch 3'.
*    WAIT UP TO 2 SECONDS.
**/ fetch 4
*    SELECT * UP TO 10 ROWS APPENDING CORRESPONDING FIELDS OF TABLE temp5 FROM sflight.
*    screen-progress_value = 100.
*    screen-display_value = 'fetch 4'.
*    WAIT UP TO 2 SECONDS.
*
*    mt_table = temp5.
  ENDMETHOD.

  METHOD z2ui5_set_search.
    DATA temp7 LIKE LINE OF mt_table.
    DATA lr_row LIKE REF TO temp7.
    DATA lv_row TYPE string.
    DATA lv_index TYPE i.
    FIELD-SYMBOLS <field> TYPE any.

    IF mv_search_value IS NOT INITIAL.

      LOOP AT mt_table REFERENCE INTO lr_row.

        lv_row = ``.

        lv_index = 1.
        DO.

          ASSIGN COMPONENT lv_index OF STRUCTURE lr_row->* TO <field>.
          IF sy-subrc <> 0.
            EXIT.
          ENDIF.
          lv_row = lv_row && <field>.
          lv_index = lv_index + 1.
        ENDDO.

        IF lv_row NS mv_search_value.
          DELETE mt_table.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
