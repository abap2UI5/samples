CLASS z2ui5_cl_demo_app_003 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES Z2UI5_if_app.

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

    DATA t_tab             TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_003 IMPLEMENTATION.

  METHOD Z2UI5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      t_tab = VALUE #( descr = 'this is a description'
                       icon  = 'sap-icon://account'
                       ( title = 'row_01'  info = 'completed' )
                       ( title = 'row_02'  info = 'incompleted' )
                       ( title = 'row_03'  info = 'working' )
                       ( title = 'row_04'  info = 'working' )
                       ( title = 'row_05'  info = 'completed' )
                       ( title = 'row_06'  info = 'completed' ) ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
          )->page( title          = 'abap2UI5 - List'
                   navbuttonpress = client->_event( 'BACK' )
                   shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

      page->list(
                  " TODO: check spelling: Ouput (typo) -> Output (ABAP cleaner)
                  headertext      = 'List Ouput'
                  items           = client->_bind_edit( t_tab )
                  mode            = `SingleSelectMaster`
                  selectionchange = client->_event( 'SELCHANGE' )
          )->standard_list_item( title       = '{TITLE}'
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
        client->message_box_display( |go to details for item { t_tab[ selected = abap_true ]-title }| ).

      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
