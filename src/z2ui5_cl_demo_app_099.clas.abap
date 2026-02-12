CLASS z2ui5_cl_demo_app_099 DEFINITION PUBLIC.
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
      END OF ty_row .
    TYPES:
      BEGIN OF ty_sort,
        text     TYPE string,
        key      TYPE string,
        selected TYPE abap_bool,
      END OF ty_sort .

    DATA
      mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY .
    DATA
      mt_tab_sort TYPE STANDARD TABLE OF ty_sort WITH EMPTY KEY .
    DATA
      mt_tab_group TYPE STANDARD TABLE OF ty_sort WITH EMPTY KEY .
    DATA
      mt_tab_filter TYPE STANDARD TABLE OF ty_sort WITH EMPTY KEY .
    DATA mv_sorter_group TYPE string .
    DATA mv_filter TYPE string .
    DATA mv_sort_descending TYPE abap_bool .
    DATA mv_group_descending TYPE abap_bool .
  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS set_data.
    METHODS view_display.
    METHODS view_sort_popup.
    METHODS view_filter_popup.
    METHODS view_group_popup.
    METHODS view_settings_popup.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_099 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      set_data( ).

      view_display( ).
      RETURN.
    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD on_event.

    CASE mo_client->get( )-event.
      WHEN `ALL`.
        view_settings_popup( ).
      WHEN `SORT`.
        view_sort_popup( ).
      WHEN `FILTER`.
        view_filter_popup( ).
      WHEN `GROUP`.
        view_group_popup( ).
      WHEN `CONFIRM_SORT`.
        DATA(lt_arg) = mo_client->get( )-t_event_arg.

        IF lt_arg IS NOT INITIAL.

          DATA(lv_sort_field) = lt_arg[ 1 ].

          IF mv_sort_descending = abap_true.
            SORT mt_tab BY (lv_sort_field) DESCENDING.
          ELSE.
            SORT mt_tab BY (lv_sort_field) ASCENDING.

          ENDIF.

          mo_client->view_model_update( ).

        ENDIF.
      WHEN `CONFIRM_FILTER`.
        CLEAR mv_filter.
        lt_arg = mo_client->get( )-t_event_arg.

        IF lt_arg IS NOT INITIAL.

          DATA(lv_filter_string) = lt_arg[ 1 ].
          SPLIT lv_filter_string AT `:` INTO DATA(lv_dummy) lv_filter_string.
          CONDENSE lv_filter_string NO-GAPS.
          SPLIT lv_filter_string AT `(` INTO DATA(lv_field) DATA(lv_values).
          TRANSLATE lv_field TO UPPER CASE.
          DATA(lv_values_len) = strlen( lv_values ) - 1.
          lv_values = lv_values+0(lv_values_len).
          SPLIT lv_values AT `,` INTO TABLE DATA(lt_values) IN CHARACTER MODE.
          IF sy-subrc = 0.
            LOOP AT lt_values INTO DATA(lv_val).
              mv_filter = mv_filter && `{path:'` && lv_field && `',operator: 'EQ',value1:'` && lv_val && `'},`.
            ENDLOOP.
          ENDIF.
          DATA(mv_filter_len) = strlen( mv_filter ) - 1.
          mv_filter = mv_filter+0(mv_filter_len).

          view_display( ).

        ENDIF.
      WHEN `CONFIRM_GROUP`.
        lt_arg = mo_client->get( )-t_event_arg.

        IF lt_arg IS NOT INITIAL.

          DATA(lv_group_field) = lt_arg[ 1 ].

          IF lv_group_field IS NOT INITIAL.

            IF mv_group_descending = abap_true.
              SORT mt_tab BY (lv_group_field) DESCENDING.
            ELSE.
              SORT mt_tab BY (lv_group_field) ASCENDING.
            ENDIF.

            mv_sorter_group = lv_group_field.
            TRANSLATE mv_sorter_group TO UPPER CASE.

          ELSE.

            IF mv_group_descending = abap_true.
              SORT mt_tab BY (lv_group_field) DESCENDING.
            ELSE.
              SORT mt_tab BY (lv_group_field) ASCENDING.
            ENDIF.

            CLEAR mv_sorter_group.
          ENDIF.

          view_display( ).

        ENDIF.
      WHEN `RESET_GROUP`.
    ENDCASE.
  ENDMETHOD.

  METHOD set_data.

    mt_tab = VALUE #(
      ( title = `row_01`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
      ( title = `row_02`  info = `incompleted` descr = `this is a description` icon = `sap-icon://account` )
      ( title = `row_03`  info = `working`     descr = `this is a description` icon = `sap-icon://account` )
      ( title = `row_04`  info = `working`     descr = `this is a description` icon = `sap-icon://account` )
      ( title = `row_05`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
      ( title = `row_06`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` ) ).

    mt_tab_group = VALUE #(
       ( text = `Title`       key = `title` )
       ( text = `Info`        key = `info` )
       ( text = `Description` key = `descr` ) ).

    mt_tab_sort = VALUE #(
       ( text = `Title`       key = `title` )
       ( text = `Info`        key = `info` )
       ( text = `Description` key = `descr` ) ).

    mt_tab_filter = VALUE #(
      ( text = `Title`  key = `Title` )
      ( text = `Descr`  key = `Descr` )
      ( text = `Info`   key = `Info` ) ).
  ENDMETHOD.

  METHOD view_display.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
        )->page(
            title           = `abap2UI5 - List`
            navbuttonpress  = mo_client->_event_nav_app_leave( )
              shownavbutton = abap_true
            )->header_content(
                )->link(
      )->get_parent( ).

    lo_page->table(
        headertext = `Table Output`
        items      = `{path:'` && mo_client->_bind_edit( val = mt_tab path = abap_true )
                            && `',sorter:{path:'` && mv_sorter_group
                            && `',group:` && `true` && `}`
                            && `,filters:[` && mv_filter && `] }`
       )->header_toolbar(
        )->overflow_toolbar(
          )->title( text  = `Table`
                    level = `H2`
          )->toolbar_spacer(
          )->button( icon    = `sap-icon://sort`
                     tooltip = `Sort`
                     press   = mo_client->_event( `SORT` )
          )->button( icon    = `sap-icon://filter`
                     tooltip = `Filter`
                     press   = mo_client->_event( `FILTER` )
          )->button( icon    = `sap-icon://group-2`
                     tooltip = `Group`
                     press   = mo_client->_event( `GROUP` )
          )->button( icon    = `sap-icon://action-settings`
                     tooltip = `Group`
                     press   = mo_client->_event( `ALL` )
         )->get_parent( )->get_parent(
       )->columns(
        )->column( )->text( text = `Title` )->get_parent(
        )->column( )->text( text = `Info` )->get_parent(
        )->column( )->text( text = `Descr` )->get_parent(
        )->column( )->text( text = `Icon` )->get_parent(
       )->get_parent(
      )->items(
        )->column_list_item( valign = `Middle`
          )->cells(
            )->text( text = `{TITLE}`
            )->text( text = `{INFO}`
            )->text( text = `{DESCR}`
            )->avatar( src = `{ICON}` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD view_filter_popup.

    DATA(lo_popup_filter) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(lo_filter_view) = lo_popup_filter->view_settings_dialog( filteritems = mo_client->_bind_edit( mt_tab_filter )
                                                            confirm     = mo_client->_event( val = `CONFIRM_FILTER` t_arg = VALUE #( ( `${$parameters>/filterString}` ) ) )
      )->filter_items(
        )->view_settings_filter_item( multiselect = abap_true
                                      text        = `{TEXT}`
                                      key         = `{KEY}`
          )->items(
            )->view_settings_item( text = `{TEXT}`
                                   key  = `{KEY}` )->get_parent(
*            )->view_settings_item( text = `Completed` key = `Completed` )->get_parent(
*            )->view_settings_item( text = `Incompleted` key = `Incompleted` )->get_parent(
*            )->view_settings_item( text = `Working` key = `Working`
        ).

    mo_client->popup_display( lo_filter_view->stringify( ) ).
  ENDMETHOD.

  METHOD view_group_popup.

    DATA(lo_popup_group) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(lo_group_view) = lo_popup_group->view_settings_dialog( confirm         = mo_client->_event( val = `CONFIRM_GROUP` t_arg = VALUE #( ( `${$parameters>/groupItem/mProperties/key}` ) ) )
                                                          reset           = mo_client->_event( `RESET_GROUP` )
                                                          groupdescending = mo_client->_bind_edit( mv_group_descending )
                                                          groupitems      = mo_client->_bind_edit( mt_tab_group )
                        )->group_items(
                          )->view_settings_item( text     = `{TEXT}`
                                                 key      = `{KEY}`
                                                 selected = `{SELECTED}` ).

    mo_client->popup_display( lo_group_view->stringify( ) ).
  ENDMETHOD.

  METHOD view_settings_popup.

    DATA(lo_popup_settings) = z2ui5_cl_xml_view=>factory_popup( ).

    lo_popup_settings = lo_popup_settings->view_settings_dialog(
                                    confirm     = mo_client->_event( `ALL_EVENT` )
                                    sortitems   = mo_client->_bind_edit( mt_tab_sort )
                                    groupitems  = mo_client->_bind_edit( mt_tab_group )
                                    filteritems = mo_client->_bind_edit( mt_tab_filter )
                        )->sort_items(
                          )->view_settings_item( text     = `{TEXT}`
                                                 key      = `{KEY}`
                                                 selected = `{SELECTED}` )->get_parent( )->get_parent(
                        )->group_items(
                          )->view_settings_item( text     = `{TEXT}`
                                                 key      = `{KEY}`
                                                 selected = `{SELECTED}` )->get_parent( )->get_parent(
                        )->filter_items(
                          )->view_settings_filter_item( text        = `{TEXT}`
                                                        key         = `{KEY}`
                                                        multiselect = abap_true
                            )->items(
                              )->view_settings_item( text = `{TEXT}`
                                                     key  = `{KEY}` ).

    mo_client->popup_display( lo_popup_settings->stringify( ) ).
  ENDMETHOD.

  METHOD view_sort_popup.

    DATA(lo_popup_sort) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(lo_sort_view) = lo_popup_sort->view_settings_dialog(
                                    confirm        = mo_client->_event( val = `CONFIRM_SORT` t_arg = VALUE #( ( `${$parameters>/sortItem/mProperties/key}` ) ) )
                                    sortitems      = mo_client->_bind_edit( mt_tab_sort )
                                    sortdescending = mo_client->_bind_edit( mv_sort_descending )
                        )->sort_items(
                          )->view_settings_item( text     = `{TEXT}`
                                                 key      = `{KEY}`
                                                 selected = `{SELECTED}` ).

    mo_client->popup_display( lo_sort_view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
