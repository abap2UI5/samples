CLASS Z2UI5_CL_DEMO_APP_048 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES Z2UI5_if_app.

    TYPES:
      BEGIN OF ty_row,
        title         TYPE string,
        value         TYPE string,
        descr         TYPE string,
        icon          TYPE string,
        info          TYPE string,
        highlight     TYPE string,
        wrapCharLimit TYPE i,
        selected      TYPE abap_bool,
        checkbox      TYPE abap_bool,
      END OF ty_row.

    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA check_initialized TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_048 IMPLEMENTATION.


  METHOD Z2UI5_if_app~main.

    IF check_initialized = abap_false.
      check_initialized = abap_true.

      t_tab = VALUE #(
        ( title = 'entry_01'   info = 'Information'   descr = 'this is a description1 1234567890 1234567890'  icon = 'sap-icon://badge'      highlight = 'Information' wrapCharLimit = '100' )
        ( title = 'entry_02'  info = 'Success'        descr = 'this is a description2 1234567890 1234567890'  icon = 'sap-icon://favorite'   highlight = 'Success'  wrapCharLimit = '10')
        ( title = 'entry_03'  info = 'Warning'        descr = 'this is a description3 1234567890 1234567890'  icon = 'sap-icon://employee'   highlight = 'Warning'  wrapCharLimit = '100')
        ( title = 'entry_04'  info = 'Error'          descr = 'this is a description4 1234567890 1234567890'  icon = 'sap-icon://accept'     highlight = 'Error'  wrapCharLimit = '10' )
        ( title = 'entry_05'  info = 'None'           descr = 'this is a description5 1234567890 1234567890'  icon = 'sap-icon://activities' highlight = 'None'  wrapCharLimit = '10')
        ( title = 'entry_06'  info = 'Information'    descr = 'this is a description6 1234567890 1234567890'  icon = 'sap-icon://account'    highlight = 'Information'   wrapCharLimit = '100' )
      ).

    ENDIF.

    CASE client->get( )-event.
      WHEN 'EDIT'.
        DATA(lt_arg) = client->get( )-t_event_arg.
        DATA(lv_row_title) = lt_arg[ 1 ].
        client->message_box_display( `EDIT - ` && lv_row_title ).
      WHEN 'SELCHANGE'.
        DATA(lt_sel) = t_tab.
        DELETE lt_sel WHERE selected = abap_false.
        client->message_box_display( `SELECTION_CHANGED -` && lt_sel[ 1 ]-title ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
            title          = 'abap2UI5 - List'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true
            )->header_content(
                  )->link(
                    text = 'Demo'  target = '_blank'
                    href = `https://twitter.com/abap2UI5/status/1657279838586109953`
                )->link(
                    text = 'Source_Code'  target = '_blank'
                    href = z2ui5_cl_demo_utility=>factory( client )->app_get_url_source_code( )
            )->get_parent( ).

    page->list(
        headertext      = 'List Ouput'
        items           = client->_bind_edit( t_tab )
        mode            = `SingleSelectMaster`
        selectionchange = client->_event( 'SELCHANGE' )
    )->_generic(
         name = `StandardListItem`
            t_prop = VALUE #(
                ( n = `title`       v = '{TITLE}' )
                ( n = `description` v = '{DESCR}' )
                ( n = `icon`        v = '{ICON}' )
                ( n = `iconInset`   v = 'false' )
                ( n = `highlight`   v = '{HIGHLIGHT}' )
                ( n = `info`        v = '{INFO}' )
                ( n = `infoState`   v = '{HIGHLIGHT}' )
               ( n = `infoStateInverted`   v = 'true' )
              ( n = 'type'      v = `Detail` )
              ( n = 'wrapping'      v = `true` )
              ( n = 'wrapCharLimit'      v = `{WRAPCHARLIMIT}` )
              ( n = 'selected'    v = `{SELECTED}` )
              ( n = 'detailPress'      v = client->_event( val = 'EDIT' t_arg = VALUE #( ( `${TITLE}`  )  ) ) )

              ) ).

    client->view_display( page->get_root( )->xml_get( ) ).

  ENDMETHOD.
ENDCLASS.
