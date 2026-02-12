CLASS z2ui5_cl_demo_app_046 DEFINITION PUBLIC.

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
        checkbox TYPE abap_bool,
      END OF ty_row.

    DATA mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA mv_display TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_046 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      mv_display = `LIST`.

      mt_tab = VALUE #(
        ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
        ( title = `Peter`  info = `incompleted` descr = `this is a description` icon = `sap-icon://account` )
        ( title = `Peter`  info = `working`     descr = `this is a description` icon = `sap-icon://account` )
        ( title = `Peter`  info = `working`     descr = `this is a description` icon = `sap-icon://account` )
        ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` )
        ( title = `Peter`  info = `completed`   descr = `this is a description` icon = `sap-icon://account` ) ).

    ELSE.

      IF client->get( )-event IS NOT INITIAL.
        mv_display = client->get( )-event.
      ENDIF.

    ENDIF.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
        )->page(
            title          = `abap2UI5 - Table output in two different Ways - Changing UI without Model`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
            )->header_content(
                )->button( text  = `Display List`
                           press = client->_event( `LIST` )
                )->button( text  = `Display Table`
                           press = client->_event( `TABLE` )
                )->link(
      )->get_parent( ).

    CASE mv_display.
      WHEN `LIST`.
        lo_page->list(
            headertext = `List Control`
            items      = client->_bind( mt_tab )
            )->standard_list_item(
                title       = `{TITLE}`
                description = `{DESCR}`
                icon        = `{ICON}`
                info        = `{INFO}` ).
      WHEN `TABLE`.

        DATA(lo_tab) = lo_page->table(
          headertext = `Table Control`
          items      = client->_bind( mt_tab ) ).

        lo_tab->columns(
            )->column(
                )->text( `Title` )->get_parent(
            )->column(
                )->text( `Descr` )->get_parent(
            )->column(
                )->text( `Icon` )->get_parent(
             )->column(
                )->text( `Info` ).

        lo_tab->items( )->column_list_item( )->cells(
           )->text( `{TITLE}`
           )->text( `{DESCR}`
           )->text( `{ICON}`
           )->text( `{INFO}` ).
    ENDCASE.

    client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.
ENDCLASS.
