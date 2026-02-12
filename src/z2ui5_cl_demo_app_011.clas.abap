CLASS z2ui5_cl_demo_app_011 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        selkz    TYPE abap_bool,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        editable TYPE abap_bool,
        checkbox TYPE abap_bool,
      END OF ty_row.

    DATA mt_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
    DATA mv_check_editable_active TYPE abap_bool.

  PROTECTED SECTION.
    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS set_view.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_011 IMPLEMENTATION.

  METHOD set_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    DATA(lo_page) = lo_view->shell(
        )->page(
                title           = `abap2UI5 - Tables and editable`
                navbuttonpress  = mo_client->_event_nav_app_leave( )
                  shownavbutton = abap_true
                  id            = `test2` ).

    DATA(lo_tab) = lo_page->table(
            items = `{path: '` && mo_client->_bind_edit( val = mt_tab path = abap_true ) && `' , templateShareable: false }`
            mode  = `MultiSelect`
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( `title of the table`
                )->button(
                    text  = `test`
                    press = mo_client->_event( `BUTTON_TEST` )
                )->toolbar_spacer(
                )->button(
                    icon  = `sap-icon://delete`
                    text  = `delete selected row`
                    press = mo_client->_event( `BUTTON_DELETE` )
                )->button(
                    icon  = `sap-icon://add`
                    text  = `add`
                    press = mo_client->_event( `BUTTON_ADD` )
                )->button(
                    icon  = `sap-icon://edit`
                    text  = SWITCH #( mv_check_editable_active WHEN abap_true THEN |display| ELSE |edit| )
                    press = mo_client->_event( `BUTTON_EDIT` )
        )->get_parent( )->get_parent( ).

    lo_tab->columns(
        )->column(
            )->text( `Title` )->get_parent(
        )->column(
            )->text( `Color` )->get_parent(
        )->column(
            )->text( `Info` )->get_parent(
        )->column(
            )->text( `Description` )->get_parent(
        )->column(
            )->text( `Checkbox` ).

    lo_tab->items( )->column_list_item( selected = `{SELKZ}`
      )->cells(
          )->input( value   = `{TITLE}`
                    enabled = `{EDITABLE}`
                    id      = `test`
          )->input( value   = `{VALUE}`
                    enabled = `{EDITABLE}`
          )->input( value   = `{INFO}`
                    enabled = `{EDITABLE}`
          )->input( value   = `{DESCR}`
                    enabled = `{EDITABLE}`
          )->checkbox( selected = `{CHECKBOX}`
                       enabled  = `{EDITABLE}` ).

    mo_client->view_display( lo_view->stringify( ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).

      mv_check_editable_active = abap_false.
      mt_tab = VALUE #(
          ( title = `entry 01`  value = `red`    info = `completed`  descr = `this is a description` checkbox = abap_true )
          ( title = `entry 02`  value = `blue`   info = `completed`  descr = `this is a description` checkbox = abap_true )
          ( title = `entry 03`  value = `green`  info = `completed`  descr = `this is a description` checkbox = abap_true )
          ( title = `entry 04`  value = `orange` info = `completed`  descr = `` checkbox = abap_true )
          ( title = `entry 05`  value = `grey`   info = `completed`  descr = `this is a description` checkbox = abap_true )
          ( ) ).

      set_view( ).
      RETURN.

    ENDIF.

    CASE mo_client->get( )-event.
      WHEN `BUTTON_EDIT`.
        mv_check_editable_active = xsdbool( mv_check_editable_active = abap_false ).
        LOOP AT mt_tab REFERENCE INTO DATA(lr_tab).
          lr_tab->editable = mv_check_editable_active.
        ENDLOOP.
        mo_client->view_model_update( ).
      WHEN `BUTTON_DELETE`.
        DELETE mt_tab WHERE selkz = abap_true.
        mo_client->view_model_update( ).
      WHEN `BUTTON_ADD`.
        INSERT VALUE #( ) INTO TABLE mt_tab.
        mo_client->view_model_update( ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
