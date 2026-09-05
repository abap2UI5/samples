" @keywords customtreeitem rename input binding write back
" @summary Editable tree nodes with a CustomTreeItem, so a rename in the tree writes back into the ABAP hierarchy.
" @docs https://abap2ui5.github.io/docs/cookbook/model/trees
CLASS z2ui5_cl_smp_app_463 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_node_level3,
        text TYPE string,
      END OF ty_s_node_level3,
      ty_t_node_level3 TYPE STANDARD TABLE OF ty_s_node_level3 WITH DEFAULT KEY,
      BEGIN OF ty_s_node_level2,
        text  TYPE string,
        nodes TYPE ty_t_node_level3,
      END OF ty_s_node_level2,
      ty_t_node_level2 TYPE STANDARD TABLE OF ty_s_node_level2 WITH DEFAULT KEY,
      BEGIN OF ty_s_node_level1,
        text  TYPE string,
        nodes TYPE ty_t_node_level2,
      END OF ty_s_node_level1.
    DATA t_nodes TYPE STANDARD TABLE OF ty_s_node_level1 WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_463 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_nodes.
      DATA temp2 LIKE LINE OF temp1.
      DATA temp3 TYPE z2ui5_cl_smp_app_463=>ty_t_node_level2.
      DATA temp4 LIKE LINE OF temp3.
      DATA temp7 TYPE z2ui5_cl_smp_app_463=>ty_t_node_level3.
      DATA temp8 LIKE LINE OF temp7.
      DATA temp9 TYPE z2ui5_cl_smp_app_463=>ty_t_node_level3.
      DATA temp10 LIKE LINE OF temp9.
      DATA temp5 TYPE z2ui5_cl_smp_app_463=>ty_t_node_level2.
      DATA temp6 LIKE LINE OF temp5.
      DATA temp11 TYPE z2ui5_cl_smp_app_463=>ty_t_node_level3.
      DATA temp12 LIKE LINE OF temp11.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      
      CLEAR temp1.
      
      temp2-text = `Documents`.
      
      CLEAR temp3.
      
      temp4-text = `Projects`.
      
      CLEAR temp7.
      
      temp8-text = `Roadmap.docx`.
      INSERT temp8 INTO TABLE temp7.
      temp8-text = `Budget.xlsx`.
      INSERT temp8 INTO TABLE temp7.
      temp4-nodes = temp7.
      INSERT temp4 INTO TABLE temp3.
      temp4-text = `Reports`.
      
      CLEAR temp9.
      
      temp10-text = `Q1.pdf`.
      INSERT temp10 INTO TABLE temp9.
      temp4-nodes = temp9.
      INSERT temp4 INTO TABLE temp3.
      temp2-nodes = temp3.
      INSERT temp2 INTO TABLE temp1.
      temp2-text = `Pictures`.
      
      CLEAR temp5.
      
      temp6-text = `Vacation`.
      
      CLEAR temp11.
      
      temp12-text = `Beach.jpg`.
      INSERT temp12 INTO TABLE temp11.
      temp6-nodes = temp11.
      INSERT temp6 INTO TABLE temp5.
      temp2-nodes = temp5.
      INSERT temp2 INTO TABLE temp1.
      t_nodes = temp1.
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.
      DATA lv_roots TYPE string.
      DATA ls_node LIKE LINE OF t_nodes.
        DATA temp3 TYPE string.

    IF client->get_event( ) = `SHOW_MODEL`.
      " the bound inputs have already written the edits back into
      " t_nodes before on_event runs - read the (possibly renamed) roots
      " back and echo them, proving the round-trip
      
      lv_roots = ``.
      
      LOOP AT t_nodes INTO ls_node.
        
        IF sy-tabix > 1.
          temp3 = `, `.
        ELSE.
          CLEAR temp3.
        ENDIF.
        lv_roots = |{ lv_roots }{ temp3 }{ ls_node-text }|.
      ENDLOOP.
      client->message_toast_display( |Root nodes now: { lv_roots }| ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tree TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc` ).

    
    page = view->ele( `Shell`
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
    
    tree = page->ele( `Tree`
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
