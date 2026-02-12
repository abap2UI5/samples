CLASS z2ui5_cl_demo_app_019 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        selkz TYPE abap_bool,
        title TYPE string,
        value TYPE string,
        descr TYPE string,
      END OF ty_row.

    DATA mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA mt_tab_sel TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA mv_sel_mode TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_019 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      mv_sel_mode = `None`.
      mt_tab = VALUE #( descr = `this is a description`
              (  title = `title_01`  value = `value_01` )
              (  title = `title_02`  value = `value_02` )
              (  title = `title_03`  value = `value_03` )
              (  title = `title_04`  value = `value_04` )
              (  title = `title_05`  value = `value_05` ) ).

    ENDIF.

    CASE client->get( )-event.
      WHEN `BUTTON_SEGMENT_CHANGE`.
        client->message_toast_display( `Selection Mode changed` ).
      WHEN `BUTTON_READ_SEL`.
        mt_tab_sel = mt_tab.
        DELETE mt_tab_sel WHERE selkz <> abap_true.
    ENDCASE.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
            )->page(
                title          = `abap2UI5 - Table with different Selection Modes`
                navbuttonpress = client->_event_nav_app_leave( )
                shownavbutton  = client->check_app_prev_stack( ) ).

    lo_page->segmented_button(
            selected_key     = client->_bind_edit( mv_sel_mode )
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

    lo_page->table(
            headertext = `Table`
            mode       = mv_sel_mode
            items      = client->_bind_edit( mt_tab )
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

    lo_page->table( client->_bind( mt_tab_sel )
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

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
