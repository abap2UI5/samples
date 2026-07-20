CLASS z2ui5_cl_demo_app_019 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        selkz TYPE abap_bool,
        title TYPE string,
        value TYPE string,
        descr TYPE string,
      END OF ty_s_row.
    TYPES ty_t_rows TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.
    DATA t_tab     TYPE ty_t_rows.
    DATA t_tab_sel TYPE ty_t_rows.
    DATA sel_mode  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_019 IMPLEMENTATION.

  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).
    
    page = view->shell(
            )->page(
                title          = `abap2UI5 - Table with different Selection Modes`
                navbuttonpress = client->_event_nav_app_leave( )
                shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `A SegmentedButton switches the table's selection mode (None, Single, Multi) at ` &&
                   `runtime; a second table below collects the rows selected in the first.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->segmented_button(
            selected_key     = client->_bind( sel_mode )
            selection_change = client->_event( `BUTTON_SEGMENT_CHANGE` ) )->get(
                )->items( )->get(
                    )->segmented_button_item(
                        key  = `None`
                        text = `None`
                    )->segmented_button_item(
                        key  = `SingleSelect`
                        text = `SingleSelect`
                    )->segmented_button_item(
                        key  = `SingleSelectLeft`
                        text = `SingleSelectLeft`
                    )->segmented_button_item(
                        key  = `SingleSelectMaster`
                        text = `SingleSelectMaster`
                    )->segmented_button_item(
                        key  = `MultiSelect`
                        text = `MultiSelect` ).

    page->table(
            headertext = `Table`
            mode       = sel_mode
            items      = client->_bind( t_tab )
            )->columns(
                )->column( )->text( `Title` )->get_parent(
                )->column( )->text( `Value` )->get_parent(
                )->column( )->text( `Description`
            )->get_parent( )->get_parent(
            )->items(
                )->column_list_item( selected = `{SELKZ}`
                    )->cells(
                        )->text( `{TITLE}`
                        )->text( `{VALUE}`
                        )->text( `{DESCR}` ).

    page->table( client->_bind( t_tab_sel )
            )->header_toolbar(
                )->overflow_toolbar(
                    )->title( `Selected Entries`
                    )->button(
                        icon  = `sap-icon://pull-down`
                        text  = `copy selected entries`
                        press = client->_event( `BUTTON_READ_SEL` )
          )->get_parent( )->get_parent(
          )->columns(
            )->column( )->text( `Title` )->get_parent(
            )->column( )->text( `Value` )->get_parent(
            )->column( )->text( `Description`
            )->get_parent( )->get_parent(
            )->items( )->column_list_item( )->cells(
                )->text( `{TITLE}`
                )->text( `{VALUE}`
                )->text( `{DESCR}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
      DATA temp1 TYPE z2ui5_cl_demo_app_019=>ty_t_rows.
      DATA temp2 LIKE LINE OF temp1.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      sel_mode = `None`.
      
      CLEAR temp1.
      
      temp2-descr = `this is a description`.
      temp2-title = `title_01`.
      temp2-value = `value_01`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `title_02`.
      temp2-value = `value_02`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `title_03`.
      temp2-value = `value_03`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `title_04`.
      temp2-value = `value_04`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `title_05`.
      temp2-value = `value_05`.
      INSERT temp2 INTO TABLE temp1.
      t_tab    = temp1.

    ELSEIF client->check_on_event( `BUTTON_SEGMENT_CHANGE` ) IS NOT INITIAL.
      client->message_toast_display( `Selection Mode changed` ).

    ELSEIF client->check_on_event( `BUTTON_READ_SEL` ) IS NOT INITIAL.

      t_tab_sel = t_tab.
      DELETE t_tab_sel WHERE selkz <> abap_true.
    ENDIF.

    view_display( ).

  ENDMETHOD.

ENDCLASS.
