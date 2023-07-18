CLASS z2ui5_cl_app_demo_03 DEFINITION PUBLIC.

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

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_APP_DEMO_03 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      t_tab = VALUE #(
        ( title = 'row_01'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_02'  info = 'incompleted' descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_03'  info = 'working'     descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_04'  info = 'working'     descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_05'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_06'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
      ).

      DATA(view) = z2ui5_cl_xml_view=>factory( client ).
      DATA(page) = view->shell(
          )->page(
              title          = 'abap2UI5 - List'
              navbuttonpress = client->_event( 'BACK' )
                shownavbutton = abap_true
              )->header_content(
                  )->link(
                      text = 'Source_Code'  target = '_blank'
                      href = view->hlp_get_source_code_url( )
              )->get_parent( ).

      page->list(
          headertext      = 'List Ouput'
          items           = client->_bind_edit( t_tab )
          mode            = `SingleSelectMaster`
          selectionchange = client->_event( 'SELCHANGE' )
          )->standard_list_item(
              title       = '{TITLE}'
              description = '{DESCR}'
              icon        = '{ICON}'
              info        = '{INFO}'
              press       = client->_event( 'TEST' )
              selected    = `{SELECTED}`
         ).

      client->view_display( view->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.

      WHEN 'SELCHANGE'.
        DATA(lt_sel) = t_tab.
        DELETE lt_sel WHERE selected = abap_false.
        client->message_box_display( `go to details for item ` && lt_sel[ 1 ]-title ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
