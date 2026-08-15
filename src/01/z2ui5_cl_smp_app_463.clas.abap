" @keywords customtreeitem rename input binding write back
CLASS z2ui5_cl_smp_app_463 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_463 IMPLEMENTATION.

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

    CASE client->get_event( ).

      WHEN `SHOW_MODEL`.
        " the bound inputs have already written the edits back into
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

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Tree - Editable Nodes with CustomTreeItem`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text` v = `Each node is a CustomTreeItem holding an Input bound to the node text. ` &&
                   `Rename any node and press "Show model": the edits have already written back into ` &&
                   `the nested ABAP table. The expand state is preserved across the roundtrip.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `SHOW_MODEL` )
            )->a( n = `text`  v = `Show model`
            )->a( n = `icon`  v = `sap-icon://show` ).

    " CustomTreeItem is not a typed builder method - build it via _generic;
    " its content aggregation holds the editable Input, bound to
    " {TEXT} because the items aggregation itself is bound with _bind
    DATA(tree) = page->ele( `Tree`
        )->a( n = `id`         v = `tree1`
        )->a( n = `items`      v = client->_bind( t_nodes )
        )->a( n = `headerText` v = `Files (editable)` ).

    tree->ele( `CustomTreeItem`
        )->ele( `content`
            )->tag( `Input`
                )->a( n = `value` v = `{TEXT}`
                )->a( n = `width` v = `24rem` ).

    " invisible companion: keeps the expanded nodes open across the roundtrip
    page->tag( n = `Tree` ns = `z2ui5` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
