CLASS z2ui5_cl_demo_app_099 DEFINITION
  PUBLIC
  CREATE PUBLIC.

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
      END OF ty_row.
    TYPES:
      BEGIN OF ty_sort,
        text     TYPE string,
        key      TYPE string,
        selected TYPE abap_bool,
      END OF ty_sort.

    DATA t_tab               TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA t_tab_sort          TYPE STANDARD TABLE OF ty_sort WITH EMPTY KEY.
    DATA t_tab_group         TYPE STANDARD TABLE OF ty_sort WITH EMPTY KEY.
    DATA t_tab_filter        TYPE STANDARD TABLE OF ty_sort WITH EMPTY KEY.
    DATA mv_sorter_group     TYPE string.
    DATA mv_filter           TYPE string.
    DATA mv_sort_descending  TYPE abap_bool.
    DATA mv_group_descending TYPE abap_bool.
    DATA mv_group_desc_str   TYPE string VALUE `false` ##NO_TEXT.

  PROTECTED SECTION.
    DATA client            TYPE REF TO z2ui5_if_client.
    DATA check_initialized TYPE abap_bool.

    METHODS z2ui5_set_data.
    METHODS z2ui5_view_display.
    METHODS z2ui5_view_sort_popup.
    METHODS z2ui5_view_filter_popup.
    METHODS z2ui5_view_group_popup.
    METHODS z2ui5_view_settings_popup.
    METHODS z2ui5_on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_099 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      z2ui5_set_data( ).

      z2ui5_view_display( ).
      RETURN.
    ENDIF.

    z2ui5_on_event( ).

  ENDMETHOD.

  METHOD z2ui5_on_event.

    CASE client->get( )-event.
      WHEN 'BACK'.
        client->nav_app_leave( ).
      WHEN 'ALL'.
        z2ui5_view_settings_popup( ).
      WHEN 'SORT'.
        z2ui5_view_sort_popup( ).
      WHEN 'FILTER'.
        z2ui5_view_filter_popup( ).
      WHEN 'GROUP'.
        z2ui5_view_group_popup( ).
      WHEN 'CONFIRM_SORT'.
        DATA(lt_arg) = client->get( )-t_event_arg.

        IF lt_arg IS NOT INITIAL.

          DATA(sort_field) = lt_arg[ 1 ].

          IF mv_sort_descending = abap_true.
            SORT t_tab BY (sort_field) DESCENDING.
          ELSE.
            SORT t_tab BY (sort_field) ASCENDING.

          ENDIF.

          client->view_model_update( ).

        ENDIF.

      WHEN 'CONFIRM_FILTER'.
        CLEAR mv_filter.
        lt_arg = client->get( )-t_event_arg.

        IF lt_arg IS NOT INITIAL.

          DATA(filter_string) = lt_arg[ 1 ].
          " TODO: variable is assigned but never used (ABAP cleaner)
          SPLIT filter_string AT ':' INTO DATA(lv_dummy) filter_string.
          CONDENSE filter_string NO-GAPS.
          SPLIT filter_string AT `(` INTO DATA(lv_field) DATA(lv_values).
          TRANSLATE lv_field TO UPPER CASE.
          DATA(lv_values_len) = strlen( lv_values ) - 1.
          lv_values = lv_values+0(lv_values_len).
          SPLIT lv_values AT ',' INTO TABLE DATA(lt_values) IN CHARACTER MODE.
          IF sy-subrc = 0.
            LOOP AT lt_values INTO DATA(lv_val).
              mv_filter = |{ mv_filter }\{path:'{ lv_field }',operator: 'EQ',value1:'{ lv_val }'\},|.
            ENDLOOP.
          ENDIF.
          DATA(mv_filter_len) = strlen( mv_filter ) - 1.
          mv_filter = mv_filter+0(mv_filter_len).

          z2ui5_view_display( ).

        ENDIF.

      WHEN 'CONFIRM_GROUP'.
        lt_arg = client->get( )-t_event_arg.

        IF lt_arg IS NOT INITIAL.

          DATA(group_field) = lt_arg[ 1 ].

          IF group_field IS NOT INITIAL.

            IF mv_group_descending = abap_true.
              SORT t_tab BY (group_field) DESCENDING.
            ELSE.
              SORT t_tab BY (group_field) ASCENDING.
            ENDIF.

            mv_sorter_group = group_field.
            TRANSLATE mv_sorter_group TO UPPER CASE.

          ELSE.

            IF mv_group_descending = abap_true.
              SORT t_tab BY (group_field) DESCENDING.
            ELSE.
              SORT t_tab BY (group_field) ASCENDING.
            ENDIF.

            CLEAR mv_sorter_group.
          ENDIF.

          z2ui5_view_display( ).

        ENDIF.

      WHEN 'RESET_GROUP'.
    ENDCASE.

  ENDMETHOD.

  METHOD z2ui5_set_data.

    t_tab = VALUE #( descr = 'this is a description'
                     icon  = 'sap-icon://account'
                     ( title = 'row_01'  info = 'completed' )
                     ( title = 'row_02'  info = 'incompleted' )
                     ( title = 'row_03'  info = 'working' )
                     ( title = 'row_04'  info = 'working' )
                     ( title = 'row_05'  info = 'completed' )
                     ( title = 'row_06'  info = 'completed' ) ).

    t_tab_group = VALUE #( ( text = `Title`       key = `title` )
                           ( text = `Info`        key = `info`  )
                           ( text = `Description` key = `descr` ) ).

    t_tab_sort = VALUE #( ( text = `Title`       key = `title` )
                          ( text = `Info`        key = `info`  )
                          ( text = `Description` key = `descr` ) ).

    t_tab_filter = VALUE #( ( text = `Title`  key = `Title` )
                            ( text = `Descr`  key = `Descr` )
                            ( text = `Info`   key = `Info` ) ).

  ENDMETHOD.

  METHOD z2ui5_view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page( title          = 'abap2UI5 - List'
                 navbuttonpress = client->_event( 'BACK' )
                 shownavbutton  = abap_true
            )->header_content(
                )->link(

            )->get_parent( ).

    page->table( headertext = 'Table Output'
                 items      = |\{path:'{ client->_bind_edit( val  = t_tab
                                                             path = abap_true ) }|
                                && |',sorter:\{path:'{ mv_sorter_group }|
                                && |',group:true\}|
                                && |,filters:[{ mv_filter }] \}|
       )->header_toolbar(
        )->overflow_toolbar(
          )->title( text  = `Table`
                    level = `H2`
          )->toolbar_spacer(
          )->button( icon    = `sap-icon://sort`
                     tooltip = `Sort`
                     press   = client->_event( `SORT` )
          )->button( icon    = `sap-icon://filter`
                     tooltip = `Filter`
                     press   = client->_event( `FILTER` )
          )->button( icon    = `sap-icon://group-2`
                     tooltip = `Group`
                     press   = client->_event( `GROUP` )
          )->button( icon    = `sap-icon://action-settings`
                     tooltip = `Group`
                     press   = client->_event( `ALL` )
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

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_view_filter_popup.

    DATA(popup_filter) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(filter_view) = popup_filter->view_settings_dialog(
                            filteritems = client->_bind_edit( t_tab_filter )
                            confirm     = client->_event( val   = `CONFIRM_FILTER`
                                                          t_arg = VALUE #( ( `${$parameters>/filterString}` ) ) )
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

    client->popup_display( filter_view->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_view_group_popup.

    DATA(popup_group) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(group_view) = popup_group->view_settings_dialog(
        confirm         = client->_event( val   = `CONFIRM_GROUP`
                                          t_arg = VALUE #( ( `${$parameters>/groupItem/mProperties/key}` ) ) )
        reset           = client->_event( `RESET_GROUP` )
        groupdescending = client->_bind_edit( mv_group_descending )
        groupitems      = client->_bind_edit( t_tab_group )
                        )->group_items(
                          )->view_settings_item( text     = `{TEXT}`
                                                 key      = `{KEY}`
                                                 selected = `{SELECTED}`
                         ).

    client->popup_display( group_view->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_view_settings_popup.
    DATA(popup_settings) = z2ui5_cl_xml_view=>factory_popup( ).

    popup_settings = popup_settings->view_settings_dialog( confirm     = client->_event( 'ALL_EVENT' )
                                                           sortitems   = client->_bind_edit( t_tab_sort )
                                                           groupitems  = client->_bind_edit( t_tab_group )
                                                           filteritems = client->_bind_edit( t_tab_filter )
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

    client->popup_display( popup_settings->stringify( ) ).

  ENDMETHOD.

  METHOD z2ui5_view_sort_popup.

    DATA(popup_sort) = z2ui5_cl_xml_view=>factory_popup( ).

    DATA(sort_view) = popup_sort->view_settings_dialog(
        confirm        = client->_event( val   = `CONFIRM_SORT`
                                         t_arg = VALUE #( ( `${$parameters>/sortItem/mProperties/key}` ) ) )
        sortitems      = client->_bind_edit( t_tab_sort )
        sortdescending = client->_bind_edit( mv_sort_descending )
                        )->sort_items(
                          )->view_settings_item( text     = `{TEXT}`
                                                 key      = `{KEY}`
                                                 selected = `{SELECTED}` ).

    client->popup_display( sort_view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
