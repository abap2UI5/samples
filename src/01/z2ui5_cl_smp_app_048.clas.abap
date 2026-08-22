" @keywords sap.m.list standardlistitem highlight infostate press selection
" @summary A sap.m.List of StandardListItems: highlight, info state, press events and what a selection sends back.
" @docs https://abap2ui5.github.io/docs/tutorials/walkthrough/step-5
CLASS z2ui5_cl_smp_app_048 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        title     TYPE string,
        value     TYPE string,
        descr     TYPE string,
        icon      TYPE string,
        info      TYPE string,
        highlight TYPE string,
        selected  TYPE abap_bool,
        checkbox  TYPE abap_bool,
      END OF ty_s_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_048 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_tab.
      DATA temp2 LIKE LINE OF temp1.
        DATA lv_row_title TYPE string.
        DATA lt_sel LIKE t_tab.
        DATA temp3 LIKE LINE OF lt_sel.
        DATA temp4 LIKE sy-tabix.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp5 TYPE string_table.

    IF client->check_on_init( ) IS NOT INITIAL.

      
      CLEAR temp1.
      
      temp2-title = `entry_01`.
      temp2-info = `Information`.
      temp2-descr = `this is a description1 1234567890 1234567890`.
      temp2-icon = `sap-icon://badge`.
      temp2-highlight = `Information`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `entry_02`.
      temp2-info = `Success`.
      temp2-descr = `this is a description2 1234567890 1234567890`.
      temp2-icon = `sap-icon://favorite`.
      temp2-highlight = `Success`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `entry_03`.
      temp2-info = `Warning`.
      temp2-descr = `this is a description3 1234567890 1234567890`.
      temp2-icon = `sap-icon://employee`.
      temp2-highlight = `Warning`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `entry_04`.
      temp2-info = `Error`.
      temp2-descr = `this is a description4 1234567890 1234567890`.
      temp2-icon = `sap-icon://accept`.
      temp2-highlight = `Error`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `entry_05`.
      temp2-info = `None`.
      temp2-descr = `this is a description5 1234567890 1234567890`.
      temp2-icon = `sap-icon://activities`.
      temp2-highlight = `None`.
      INSERT temp2 INTO TABLE temp1.
      temp2-title = `entry_06`.
      temp2-info = `Information`.
      temp2-descr = `this is a description6 1234567890 1234567890`.
      temp2-icon = `sap-icon://account`.
      temp2-highlight = `Information`.
      INSERT temp2 INTO TABLE temp1.
      t_tab = temp1.

    ENDIF.

    CASE client->get_event( ).
      WHEN `EDIT`.
        
        lv_row_title = client->get_event_arg( ).
        client->message_box_display( |EDIT - { lv_row_title }| ).
      WHEN `SELCHANGE`.
        
        lt_sel = t_tab.
        DELETE lt_sel WHERE selected = abap_false.
        
        
        temp4 = sy-tabix.
        READ TABLE lt_sel INDEX 1 INTO temp3.
        sy-tabix = temp4.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        client->message_box_display( |SELECTION_CHANGED - { temp3-title }| ).
    ENDCASE.

    
    page = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->ele( `Shell`
                )->ele( `Page`
                    )->a( n = `title`          v = `abap2UI5 - List - StandardListItem, Highlight and Events`
                    )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
                    )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `A List of generic StandardListItems showing highlight bars, colored infoState and ` &&
                   `wrapping texts; the detail button and selection changes raise backend events with message boxes.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    CLEAR temp5.
    INSERT `${TITLE}` INTO TABLE temp5.
    INSERT `${DESCR}` INTO TABLE temp5.
    INSERT `${ICON}` INTO TABLE temp5.
    INSERT `${HIGHLIGHT}` INTO TABLE temp5.
    INSERT `${INFO}` INTO TABLE temp5.
    INSERT `${SELECTED}` INTO TABLE temp5.
    page->ele( `List`
        )->a( n = `headerText`      v = `List Output`
        )->a( n = `items`           v = client->_bind( t_tab )
        )->a( n = `mode`            v = `SingleSelectMaster`
        )->a( n = `selectionChange` v = client->_event( `SELCHANGE` )
        )->ele( `StandardListItem`
            )->a( n = `title`       v = `{TITLE}`
            )->a( n = `description` v = `{DESCR}`
            )->a( n = `icon`        v = `{ICON}`
            )->a( n = `iconInset`   v = `false`
            )->a( n = `highlight`   v = `{HIGHLIGHT}`
            )->a( n = `info`        v = `{INFO}`
            )->a( n = `infoState`   v = `{HIGHLIGHT}`
            )->a( n = `type`        v = `Detail`
            )->a( n = `wrapping`    v = `true`
            )->a( n = `selected`    v = `{SELECTED}`
            )->a( n = `detailPress` v = client->_event( val = `EDIT` t_arg = temp5 ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
