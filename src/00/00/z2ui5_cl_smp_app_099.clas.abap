CLASS z2ui5_cl_smp_app_099 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        title TYPE string,
        info  TYPE string,
        descr TYPE string,
        icon  TYPE string,
      END OF ty_s_row.
    TYPES:
      BEGIN OF ty_s_key,
        key      TYPE string,
        text     TYPE string,
        selected TYPE abap_bool,
      END OF ty_s_key.
    TYPES ty_t_key TYPE STANDARD TABLE OF ty_s_key WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_filter,
        key   TYPE string,
        text  TYPE string,
        items TYPE ty_t_key,
      END OF ty_s_filter.
    " Shape of one ViewSettingsItem as it arrives from the confirm event: the
    " frontend marshals the control into its id plus its public properties.
    TYPES:
      BEGIN OF ty_s_event_item,
        id       TYPE string,
        key      TYPE string,
        text     TYPE string,
        selected TYPE abap_bool,
      END OF ty_s_event_item.
    TYPES ty_t_event_item TYPE STANDARD TABLE OF ty_s_event_item WITH EMPTY KEY.

    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.
    DATA t_sort TYPE ty_t_key.
    DATA t_group TYPE ty_t_key.
    DATA t_filter TYPE STANDARD TABLE OF ty_s_filter WITH EMPTY KEY.
    DATA group_descending TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    DATA group_field TYPE string.
    DATA filter_expr TYPE string.

    METHODS on_init.
    METHODS on_event.
    METHODS on_event_confirm_sort.
    METHODS on_event_confirm_group.
    METHODS on_event_confirm_filter.
    METHODS view_display.
    METHODS popup_display_sort.
    METHODS popup_display_group.
    METHODS popup_display_filter.
    METHODS event_items
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE ty_t_event_item.
    METHODS data_read.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_099 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    data_read( ).

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `SORT`.
        popup_display_sort( ).
      WHEN `GROUP`.
        popup_display_group( ).
      WHEN `FILTER`.
        popup_display_filter( ).
      WHEN `CONFIRM_SORT`.
        on_event_confirm_sort( ).
      WHEN `CONFIRM_GROUP`.
        on_event_confirm_group( ).
      WHEN `CONFIRM_FILTER`.
        on_event_confirm_filter( ).
      WHEN `RESET_GROUP`.
        group_field = ``.
        view_display( ).
    ENDCASE.

  ENDMETHOD.


  METHOD on_event_confirm_sort.

    " sortItem is a single ViewSettingsItem control. It arrives as one JSON
    " object carrying the control's public properties - no reach into UI5
    " internals (the former ${$parameters>/sortItem/mProperties/key}) needed.
    DATA(t_items) = event_items( client->get_event_arg( ) ).
    IF t_items IS INITIAL.
      RETURN.
    ENDIF.

    DATA(field) = t_items[ 1 ]-key.
    IF client->get_event_arg( 2 ) = abap_true.
      SORT t_tab BY (field) DESCENDING.

    ELSE.
      SORT t_tab BY (field) ASCENDING.
    ENDIF.

    client->view_model_update( ).

  ENDMETHOD.


  METHOD on_event_confirm_group.

    DATA(t_items) = event_items( client->get_event_arg( ) ).

    group_field      = COND #( WHEN t_items IS INITIAL THEN `` ELSE t_items[ 1 ]-key ).
    group_descending = boolc( client->get_event_arg( 2 ) = abap_true ).

    view_display( ).

  ENDMETHOD.


  METHOD on_event_confirm_filter.

    " filterItems is an ARRAY of the selected ViewSettingsItem controls. The
    " frontend marshals every one of them, so the backend reads real keys.
    " Parsing the localized `filterString` (the former approach) broke as soon
    " as the logon language changed.
    DATA(t_items) = event_items( client->get_event_arg( ) ).

    " Selected values of the SAME filter category are OR-ed, the categories
    " themselves AND-ed. The leaf key carries its category as `FIELD:value`,
    " a contract this app owns.
    DATA t_fields TYPE STANDARD TABLE OF string WITH EMPTY KEY.
    LOOP AT t_items INTO DATA(s_item).
      SPLIT s_item-key AT `:` INTO DATA(field) DATA(value).
      IF NOT line_exists( t_fields[ table_line = field ] ).
        APPEND field TO t_fields.
      ENDIF.
    ENDLOOP.

    DATA(groups) = ``.
    LOOP AT t_fields INTO field.
      DATA(alternatives) = ``.
      LOOP AT t_items INTO s_item.
        SPLIT s_item-key AT `:` INTO DATA(item_field) value.
        CHECK item_field = field.
        alternatives = |{ alternatives }{ COND #( WHEN alternatives IS NOT INITIAL THEN `,` ) }| &&
                       |\{ path: '{ field }', operator: 'EQ', value1: '{ value }' \}|.
      ENDLOOP.
      groups = |{ groups }{ COND #( WHEN groups IS NOT INITIAL THEN `,` ) }| &&
               |\{ filters: [{ alternatives }], and: false \}|.
    ENDLOOP.

    filter_expr = groups.

    view_display( ).

  ENDMETHOD.


  METHOD event_items.

    " One ViewSettingsItem arrives as a JSON object, several as a JSON array -
    " ajson reads both into the same table when the object is wrapped.
    DATA(lv_json) = condense( val ).
    IF lv_json IS INITIAL.
      RETURN.
    ENDIF.

    IF lv_json(1) <> `[`.
      lv_json = |[{ lv_json }]|.
    ENDIF.

    TRY.
        " the frontend marshals a control with ALL its public properties
        " (enabled, textDirection, wrapping, ...), so only the fields this app
        " models are mapped - a plain to_abap( ) fails on the first extra one
        z2ui5_cl_ajson=>parse( lv_json
          )->to_abap_corresponding_only(
          )->to_abap( IMPORTING ev_container = result ).
      CATCH z2ui5_cx_ajson_error INTO DATA(lx).
        client->message_box_display( lx->get_text( ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD view_display.

    DATA(items) = |\{ path: '{ client->_bind( val  = t_tab
                                              path = abap_true ) }'|.
    IF group_field IS NOT INITIAL.
      items = items && |, sorter: \{ path: '{ group_field }', descending: | &&
                       |{ COND string( WHEN group_descending = abap_true THEN `true` ELSE `false` ) }, group: true \}|.
    ENDIF.
    IF filter_expr IS NOT INITIAL.
      items = items && |, filters: [{ filter_expr }]|.
    ENDIF.
    items = items && ` }`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page( title          = `abap2UI5 - ViewSettingsDialog`
                                       navbuttonpress = client->_event_nav_app_leave( )
                                       shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Sort, group and filter a table through a ViewSettingsDialog. The ` &&
                   `confirm event hands over the selected ViewSettingsItem CONTROLS; ` &&
                   `the frontend marshals them into JSON, so the backend reads their ` &&
                   `keys instead of parsing the localized filterString.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->table( headertext = `Table Output`
                 items      = items
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
                           press   = client->_event( `GROUP` ) )->get_parent( )->get_parent(
        )->columns(
            )->column( )->text( `Title` )->get_parent(
            )->column( )->text( `Info` )->get_parent(
            )->column( )->text( `Description` )->get_parent(
            )->column( )->text( `Icon` )->get_parent( )->get_parent(
        )->items(
            )->column_list_item( valign = `Middle`
                )->cells(
                    )->text( `{TITLE}`
                    )->text( `{INFO}`
                    )->text( `{DESCR}`
                    )->icon( src = `{ICON}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_display_sort.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    popup->view_settings_dialog(
        sortitems      = client->_bind( t_sort )
        sortdescending = abap_false
        confirm        = client->_event( val   = `CONFIRM_SORT`
                                         t_arg = VALUE #( ( `${$parameters>/sortItem}` )
                                                          ( `${$parameters>/sortDescending}` ) ) )
        )->sort_items(
            )->view_settings_item( key      = `{KEY}`
                                   text     = `{TEXT}`
                                   selected = `{SELECTED}` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popup_display_group.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    popup->view_settings_dialog(
        groupitems      = client->_bind( t_group )
        groupdescending = client->_bind( group_descending )
        reset           = client->_event( `RESET_GROUP` )
        confirm         = client->_event( val   = `CONFIRM_GROUP`
                                          t_arg = VALUE #( ( `${$parameters>/groupItem}` )
                                                           ( `${$parameters>/groupDescending}` ) ) )
        )->group_items(
            )->view_settings_item( key      = `{KEY}`
                                   text     = `{TEXT}`
                                   selected = `{SELECTED}` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popup_display_filter.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    popup->view_settings_dialog(
        filteritems = client->_bind( t_filter )
        confirm     = client->_event( val   = `CONFIRM_FILTER`
                                      t_arg = VALUE #( ( `${$parameters>/filterItems}` ) ) )
        )->filter_items(
            )->view_settings_filter_item( key         = `{KEY}`
                                          text        = `{TEXT}`
                                          multiselect = abap_true
                                          items       = `{ITEMS}`
                )->items(
                    )->view_settings_item( key      = `{KEY}`
                                           text     = `{TEXT}`
                                           selected = `{SELECTED}` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD data_read.

    t_tab = VALUE #( icon = `sap-icon://account`
        ( title = `row_01` info = `completed`   descr = `initial load` )
        ( title = `row_02` info = `incompleted` descr = `initial load` )
        ( title = `row_03` info = `working`     descr = `manual entry` )
        ( title = `row_04` info = `working`     descr = `manual entry` )
        ( title = `row_05` info = `completed`   descr = `manual entry` )
        ( title = `row_06` info = `completed`   descr = `initial load` ) ).

    " The sort and group keys are ABAP field names - they are fed straight
    " into SORT ... BY (field) and into the binding sorter path.
    t_sort = VALUE #( ( key = `TITLE` text = `Title` )
                      ( key = `INFO`  text = `Info` )
                      ( key = `DESCR` text = `Description` ) ).

    t_group = t_sort.

    " A leaf key carries its category: `FIELD:value`. The confirm event
    " reports the selected leaves only, so the category has to travel with
    " them.
    t_filter = VALUE #(
        ( key   = `INFO`
          text  = `Info`
          items = VALUE #( ( key = `INFO:completed`   text = `Completed` )
                           ( key = `INFO:incompleted` text = `Incompleted` )
                           ( key = `INFO:working`     text = `Working` ) ) )
        ( key   = `DESCR`
          text  = `Description`
          items = VALUE #( ( key = `DESCR:initial load` text = `Initial load` )
                           ( key = `DESCR:manual entry` text = `Manual entry` ) ) ) ).

  ENDMETHOD.

ENDCLASS.
