CLASS z2ui5_cl_demo_app_003 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        selected TYPE abap_bool,
        checkbox TYPE abap_bool,
      END OF ty_s_row.
    DATA t_tab TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_003 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      t_tab = VALUE #(
          ( title = `row_01`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
          ( title = `row_02`  info = `incompleted` descr = `this is a description` icon = `sap-icon://account` )
          ( title = `row_03`  info = `working`     descr = `this is a description` icon = `sap-icon://account` )
          ( title = `row_04`  info = `working`     descr = `this is a description` icon = `sap-icon://account` )
          ( title = `row_05`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
          ( title = `row_06`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` ) ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
          )->page(
              title          = `abap2UI5 - List`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( ) ).

      page->list(
          headertext      = `List Ouput`
          items           = client->_bind_edit( t_tab )
          mode            = `SingleSelectMaster`
          selectionchange = client->_event( `SELCHANGE` )
          )->standard_list_item(
              title       = `{TITLE}`
              description = `{DESCR}`
              icon        = `{ICON}`
              info        = `{INFO}`
              press       = client->_event( `TEST` )
              selected    = `{SELECTED}` ).

      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `SELCHANGE` ).
      client->message_box_display( |go to details for item { t_tab[ selected = abap_true ]-title }| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
