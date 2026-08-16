" @keywords sap.m.list standardlistitem highlight infostate press selection
" @summary A sap.m.List of StandardListItems: highlight, info state, press events and what a selection sends back.
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
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_048 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      t_tab = VALUE #(
        ( title = `entry_01`  info = `Information`  descr = `this is a description1 1234567890 1234567890`  icon = `sap-icon://badge`      highlight = `Information` )
        ( title = `entry_02`  info = `Success`      descr = `this is a description2 1234567890 1234567890`  icon = `sap-icon://favorite`   highlight = `Success` )
        ( title = `entry_03`  info = `Warning`      descr = `this is a description3 1234567890 1234567890`  icon = `sap-icon://employee`   highlight = `Warning` )
        ( title = `entry_04`  info = `Error`        descr = `this is a description4 1234567890 1234567890`  icon = `sap-icon://accept`     highlight = `Error` )
        ( title = `entry_05`  info = `None`         descr = `this is a description5 1234567890 1234567890`  icon = `sap-icon://activities` highlight = `None` )
        ( title = `entry_06`  info = `Information`  descr = `this is a description6 1234567890 1234567890`  icon = `sap-icon://account`    highlight = `Information` ) ).

    ENDIF.

    CASE client->get_event( ).
      WHEN `EDIT`.
        DATA(lv_row_title) = client->get_event_arg( ).
        client->message_box_display( |EDIT - { lv_row_title }| ).
      WHEN `SELCHANGE`.
        DATA(lt_sel) = t_tab.
        DELETE lt_sel WHERE selected = abap_false.
        client->message_box_display( |SELECTION_CHANGED - { lt_sel[ 1 ]-title }| ).
    ENDCASE.

    DATA(page) = z2ui5_cl_ui5_view_builder=>factory(
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
            )->a( n = `detailPress` v = client->_event( val = `EDIT` t_arg = VALUE #( ( `${TITLE}` )
                                                                                        ( `${DESCR}` )
                                                                                        ( `${ICON}` )
                                                                                        ( `${HIGHLIGHT}` )
                                                                                        ( `${INFO}` )
                                                                                        ( `${SELECTED}` )
                                                                                       ) ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
