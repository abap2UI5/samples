CLASS z2ui5_cl_demo_app_061 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mt_tab TYPE REF TO data.

  PROTECTED SECTION.
    DATA mo_client TYPE REF TO z2ui5_if_client.
    METHODS set_view.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_061 IMPLEMENTATION.

  METHOD set_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
        )->page(
                title          = `abap2UI5 - RTTI created Table`
                navbuttonpress = mo_client->_event_nav_app_leave( )
                shownavbutton  = mo_client->check_app_prev_stack( ) ).

    FIELD-SYMBOLS <lo_tab> TYPE table.
    ASSIGN mt_tab->* TO <lo_tab>.

    DATA(lo_tab) = lo_page->table(
            items = mo_client->_bind_edit( <lo_tab> )
            mode  = `MultiSelect`
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( `Dynamic typed table`
                )->toolbar_spacer(
                )->button(
                    text  = `server <-> client`
                    press = mo_client->_event( `SEND` )
        )->get_parent( )->get_parent( ).

    lo_tab->columns(
        )->column(
            )->text( `uuid` )->get_parent(
        )->column(
            )->text( `time` )->get_parent(
        )->column(
            )->text( `previous` )->get_parent( ).

    lo_tab->items( )->column_list_item( selected = `{SELKZ}`
      )->cells(
          )->input( value = `{ID}`
          )->input( value = `{TIMESTAMPL}`
          )->input( value = `{ID_PREV}` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    FIELD-SYMBOLS <lo_tab> TYPE table.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      CREATE DATA mt_tab TYPE STANDARD TABLE OF (`Z2UI5_T_01`).

      ASSIGN mt_tab->* TO <lo_tab>.

      INSERT VALUE z2ui5_t_01( id = `this is an uuid`  timestampl = `2023234243`  id_prev = `previous` )
        INTO TABLE <lo_tab>.

      INSERT VALUE z2ui5_t_01( id = `this is an uuid`  timestampl = `2023234243`  id_prev = `previous` )
          INTO TABLE <lo_tab>.
      INSERT VALUE z2ui5_t_01( id = `this is an uuid`  timestampl = `2023234243`  id_prev = `previous` )
          INTO TABLE <lo_tab>.

    ENDIF.
    set_view( ).
  ENDMETHOD.
ENDCLASS.
