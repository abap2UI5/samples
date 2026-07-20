CLASS z2ui5_cl_demo_app_462 DEFINITION PUBLIC.

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
    METHODS popup_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_462 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.
      DATA temp1 LIKE t_nodes.
      DATA temp2 LIKE LINE OF temp1.
      DATA temp3 TYPE z2ui5_cl_demo_app_462=>ty_t_node_level2.
      DATA temp4 LIKE LINE OF temp3.
      DATA temp7 TYPE z2ui5_cl_demo_app_462=>ty_t_node_level3.
      DATA temp8 LIKE LINE OF temp7.
      DATA temp9 TYPE z2ui5_cl_demo_app_462=>ty_t_node_level3.
      DATA temp10 LIKE LINE OF temp9.
      DATA temp5 TYPE z2ui5_cl_demo_app_462=>ty_t_node_level2.
      DATA temp6 LIKE LINE OF temp5.
      DATA temp11 TYPE z2ui5_cl_demo_app_462=>ty_t_node_level3.
      DATA temp12 LIKE LINE OF temp11.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      
      CLEAR temp1.
      
      temp2-text = `Sales`.
      
      CLEAR temp3.
      
      temp4-text = `Orders`.
      
      CLEAR temp7.
      
      temp8-text = `4711 - Notebook Basic`.
      INSERT temp8 INTO TABLE temp7.
      temp8-text = `4712 - Ergo Screen`.
      INSERT temp8 INTO TABLE temp7.
      temp4-nodes = temp7.
      INSERT temp4 INTO TABLE temp3.
      temp4-text = `Quotations`.
      
      CLEAR temp9.
      
      temp10-text = `Q-001 - ITelO Vault`.
      INSERT temp10 INTO TABLE temp9.
      temp4-nodes = temp9.
      INSERT temp4 INTO TABLE temp3.
      temp2-nodes = temp3.
      INSERT temp2 INTO TABLE temp1.
      temp2-text = `Purchasing`.
      
      CLEAR temp5.
      
      temp6-text = `Suppliers`.
      
      CLEAR temp11.
      
      temp12-text = `Very Best Screens`.
      INSERT temp12 INTO TABLE temp11.
      temp6-nodes = temp11.
      INSERT temp6 INTO TABLE temp5.
      temp2-nodes = temp5.
      INSERT temp2 INTO TABLE temp1.
      t_nodes = temp1.
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `OPEN_POPUP`.
        popup_display( ).

      WHEN `CLOSE_POPUP`.
        " closing goes through the backend ON PURPOSE: the z2ui5.cc.Tree
        " companion snapshots the expand state right before every roundtrip,
        " so this event captures it while the dialog still exists - a pure
        " client-side popup_close would skip the snapshot
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_display.

    DATA popup TYPE REF TO z2ui5_cl_xml_view.
    DATA dialog TYPE REF TO z2ui5_cl_xml_view.
    popup = z2ui5_cl_xml_view=>factory_popup( ).
    
    dialog = popup->dialog( `abap2UI5 - Tree in a dialog` ).

    " the popup view slot gets its own copy of the model - the nested table
    " bound here renders in the dialog exactly like in a main view
    dialog->tree( id         = `treePopup`
                  headertext = `Documents`
                  items      = client->_bind( t_nodes )
        )->standard_tree_item( title = `{TEXT}` ).

    " invisible companion: snapshots the tree's expand state before each
    " roundtrip and re-applies it after rendering - reopening the dialog
    " shows the same nodes expanded as when it was closed
    dialog->_z2ui5( )->tree( `treePopup` ).

    dialog->buttons(
        )->button( text  = `Close`
                   press = client->_event( `CLOSE_POPUP` ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_xml_view.
    DATA page TYPE REF TO z2ui5_cl_xml_view.
    view = z2ui5_cl_xml_view=>factory( ).

    
    page = view->shell(
        )->page(
            title          = `abap2UI5 - Tree - inside a popup`
            navbuttonpress = client->_event_nav_app_leave( )
            shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `The button opens a Dialog whose content is a sap.m.Tree over a nested ABAP ` &&
                   `table. Expand some nodes, close and reopen: the z2ui5.cc.Tree companion ` &&
                   `preserves the expand state across the roundtrips.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->vbox( `sapUiSmallMargin`
        )->button( text  = `Open tree popup`
                   icon  = `sap-icon://tree`
                   press = client->_event( `OPEN_POPUP` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
