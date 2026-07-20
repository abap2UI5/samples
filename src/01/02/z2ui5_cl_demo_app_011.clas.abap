CLASS z2ui5_cl_demo_app_011 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        selkz    TYPE abap_bool,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        editable TYPE abap_bool,
        checkbox TYPE abap_bool,
      END OF ty_s_row.
    DATA t_tab                 TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.
    DATA check_editable_active TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_011 IMPLEMENTATION.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    DATA temp1 TYPE string.
    DATA tab TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).
    
    page = view->shell(
        )->page(
            title          = `abap2UI5 - Tables and editable`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( )
            id             = `test2` ).

    page->message_strip(
        text     = `A MultiSelect table whose input cells switch between display and edit mode via the ` &&
                   `toolbar, which also adds new rows and deletes the currently selected ones.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    
    CASE check_editable_active.
      WHEN abap_true.
        temp1 = `display`.
      WHEN OTHERS.
        temp1 = `edit`.
    ENDCASE.
    
    tab = page->table(
            items = |\{path: '{ client->_bind( val = t_tab path = abap_true ) }', templateShareable: false\}|
            mode  = `MultiSelect`
        )->header_toolbar(
            )->overflow_toolbar(
                )->title( `title of the table`
                )->button(
                    text  = `test`
                    press = client->_event( `BUTTON_TEST` )
                )->toolbar_spacer(
                )->button(
                    icon  = `sap-icon://delete`
                    text  = `delete selected row`
                    press = client->_event( `BUTTON_DELETE` )
                )->button(
                    icon  = `sap-icon://add`
                    text  = `add`
                    press = client->_event( `BUTTON_ADD` )
                )->button(
                    icon  = `sap-icon://edit`
                    text  = temp1
                    press = client->_event( `BUTTON_EDIT` )
        )->get_parent( )->get_parent( ).

    tab->columns(
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

    tab->items( )->column_list_item( selected = `{SELKZ}`
        )->cells(
            )->input(
                value   = `{TITLE}`
                enabled = `{EDITABLE}`
                id      = `test`
            )->input(
                value   = `{VALUE}`
                enabled = `{EDITABLE}`
            )->input(
                value   = `{INFO}`
                enabled = `{EDITABLE}`
            )->input(
                value   = `{DESCR}`
                enabled = `{EDITABLE}`
            )->checkbox(
                selected = `{CHECKBOX}`
                enabled  = `{EDITABLE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.
      DATA temp2 LIKE t_tab.
      DATA temp3 LIKE LINE OF temp2.
      DATA temp1 TYPE xsdboolean.
      DATA temp4 LIKE LINE OF t_tab.
      DATA lr_tab LIKE REF TO temp4.
      DATA temp5 TYPE z2ui5_cl_demo_app_011=>ty_s_row.

    me->client = client.

    IF client->check_on_init( ) IS NOT INITIAL.

      check_editable_active = abap_false.
      
      CLEAR temp2.
      
      temp3-title = `entry 01`.
      temp3-value = `red`.
      temp3-info = `completed`.
      temp3-descr = `this is a description`.
      temp3-checkbox = abap_true.
      INSERT temp3 INTO TABLE temp2.
      temp3-title = `entry 02`.
      temp3-value = `blue`.
      temp3-info = `completed`.
      temp3-descr = `this is a description`.
      temp3-checkbox = abap_true.
      INSERT temp3 INTO TABLE temp2.
      temp3-title = `entry 03`.
      temp3-value = `green`.
      temp3-info = `completed`.
      temp3-descr = `this is a description`.
      temp3-checkbox = abap_true.
      INSERT temp3 INTO TABLE temp2.
      temp3-title = `entry 04`.
      temp3-value = `orange`.
      temp3-info = `completed`.
      temp3-descr = ``.
      temp3-checkbox = abap_true.
      INSERT temp3 INTO TABLE temp2.
      temp3-title = `entry 05`.
      temp3-value = `grey`.
      temp3-info = `completed`.
      temp3-descr = `this is a description`.
      temp3-checkbox = abap_true.
      INSERT temp3 INTO TABLE temp2.
      INSERT temp3 INTO TABLE temp2.
      t_tab                 = temp2.

      view_display( ).

    ELSEIF client->check_on_event( `BUTTON_EDIT` ) IS NOT INITIAL.
      
      temp1 = boolc( check_editable_active = abap_false ).
      check_editable_active = temp1.
      
      
      LOOP AT t_tab REFERENCE INTO lr_tab.
        lr_tab->editable = check_editable_active.
      ENDLOOP.
      client->view_model_update( ).

    ELSEIF client->check_on_event( `BUTTON_DELETE` ) IS NOT INITIAL.
      DELETE t_tab WHERE selkz = abap_true.
      client->view_model_update( ).

    ELSEIF client->check_on_event( `BUTTON_ADD` ) IS NOT INITIAL.

      
      CLEAR temp5.
      INSERT temp5 INTO TABLE t_tab.
      client->view_model_update( ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
