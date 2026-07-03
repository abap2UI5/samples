CLASS z2ui5_cl_demo_app_364 DEFINITION PUBLIC.

  PUBLIC SECTION.
*   https://github.com/abap2UI5/abap2UI5/issues/2290
*   TreeTable with bound checkboxes - editing a checkbox and sending an
*   event back to the server must not crash the JSON parsing.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_node,
        user      TYPE string,
        enabled   TYPE abap_bool,
        validated TYPE abap_bool,
      END OF ty_s_node.
    TYPES:
      BEGIN OF ty_s_tree,
        user      TYPE string,
        enabled   TYPE abap_bool,
        validated TYPE abap_bool,
        nodes     TYPE STANDARD TABLE OF ty_s_node WITH DEFAULT KEY,
      END OF ty_s_tree.
    DATA t_tree TYPE STANDARD TABLE OF ty_s_tree WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_364 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_tree = VALUE #(
      ( user    = `Manager`
        enabled = abap_false
        nodes   = VALUE #(
          ( user = `Employee 1` enabled = abap_true )
          ( user = `Employee 2` enabled = abap_true )
          ( user = `Employee 3` enabled = abap_true ) ) ) ).

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `BUTTON_SAVE`.

        DATA(counter) = 0.
        LOOP AT t_tree INTO DATA(s_tree).
          LOOP AT s_tree-nodes INTO DATA(s_node) WHERE validated = abap_true.
            counter = counter + 1.
          ENDLOOP.
        ENDLOOP.

        client->message_toast_display( |Saved { counter } checkbox(es)| ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = `Account Validation`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->overflow_toolbar(
        )->content(
            )->button(
                icon  = `sap-icon://save`
                text  = `Save`
                press = client->_event( `BUTTON_SAVE` ) ).

    DATA(columns) = page->tree_table(
            id            = `treeTable`
            rows          = `{path:'` && client->_bind_edit( val = t_tree path = abap_true )
                         && `', parameters: {arrayNames:['NODES'], numberOfExpandedLevels: 1}}`
            selectionmode = `None`
        )->tree_columns( ).

    columns->tree_column( `User`
        )->tree_template(
            )->text( `{USER}` ).

    columns->tree_column( `Validated`
        )->tree_template(
            )->checkbox(
                selected   = `{VALIDATED}`
                enabled    = `{ENABLED}`
                valuestate = `Success` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
