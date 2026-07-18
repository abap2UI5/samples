CLASS z2ui5_cl_demo_app_463 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_node_level3,
        text TYPE string,
      END OF ty_s_node_level3,
      ty_t_node_level3 TYPE STANDARD TABLE OF ty_s_node_level3 WITH EMPTY KEY,
      BEGIN OF ty_s_node_level2,
        text  TYPE string,
        nodes TYPE ty_t_node_level3,
      END OF ty_s_node_level2,
      ty_t_node_level2 TYPE STANDARD TABLE OF ty_s_node_level2 WITH EMPTY KEY,
      BEGIN OF ty_s_node_level1,
        text  TYPE string,
        nodes TYPE ty_t_node_level2,
      END OF ty_s_node_level1.
    DATA t_nodes TYPE STANDARD TABLE OF ty_s_node_level1 WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_463 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      t_nodes = VALUE #(
          ( text = `Documents` nodes = VALUE #(
              ( text = `Projects` nodes = VALUE #(
                  ( text = `Roadmap.docx` )
                  ( text = `Budget.xlsx` ) ) )
              ( text = `Reports` nodes = VALUE #(
                  ( text = `Q1.pdf` ) ) ) ) )
          ( text = `Pictures` nodes = VALUE #(
              ( text = `Vacation` nodes = VALUE #(
                  ( text = `Beach.jpg` ) ) ) ) ) ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SHOW_MODEL`.
        " the two-way bound inputs have already written the edits back into
        " t_nodes before on_event runs - read the (possibly renamed) roots
        " back and echo them, proving the round-trip
        DATA(lv_roots) = ``.
        LOOP AT t_nodes INTO DATA(ls_node).
          lv_roots = |{ lv_roots }{ COND #( WHEN sy-tabix > 1 THEN `, ` ) }{ ls_node-text }|.
        ENDLOOP.
        client->message_toast_display( |Root nodes now: { lv_roots }| ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
        )->page(
            title          = `abap2UI5 - Tree - editable nodes`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Each node is a CustomTreeItem holding an Input bound two-way to the node text. ` &&
                   `Rename any node and press "Show model": the edits have already written back into ` &&
                   `the nested ABAP table. The expand state is preserved across the roundtrip.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->vbox( `sapUiSmallMargin`
        )->button( text  = `Show model`
                   icon  = `sap-icon://show`
                   press = client->_event( `SHOW_MODEL` ) ).

    " CustomTreeItem is not a typed builder method - build it via _generic;
    " its content aggregation holds the editable Input, bound two-way to
    " {TEXT} because the items aggregation itself is bound with _bind_edit
    DATA(tree) = page->tree( id         = `tree1`
                             headertext = `Files (editable)`
                             items      = client->_bind_edit( t_nodes ) ).

    tree->_generic( `CustomTreeItem`
        )->content(
            )->input( value = `{TEXT}` width = `24rem` ).

    " invisible companion: keeps the expanded nodes open across the roundtrip
    page->_z2ui5( )->tree( `tree1` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
