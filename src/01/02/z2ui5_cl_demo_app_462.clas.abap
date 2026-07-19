CLASS z2ui5_cl_demo_app_462 DEFINITION PUBLIC.

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
    METHODS popup_display.

  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_462 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      t_nodes = VALUE #(
          ( text = `Sales` nodes = VALUE #(
              ( text = `Orders` nodes = VALUE #(
                  ( text = `4711 - Notebook Basic` )
                  ( text = `4712 - Ergo Screen` ) ) )
              ( text = `Quotations` nodes = VALUE #(
                  ( text = `Q-001 - ITelO Vault` ) ) ) ) )
          ( text = `Purchasing` nodes = VALUE #(
              ( text = `Suppliers` nodes = VALUE #(
                  ( text = `Very Best Screens` ) ) ) ) ) ).
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

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).
    DATA(dialog) = popup->dialog( `abap2UI5 - Tree in a dialog` ).

    " the popup view slot gets its own copy of the model - the nested table
    " bound here renders in the dialog exactly like in a main view
    dialog->tree( id         = `treePopup`
                  headertext = `Documents`
                  items      = client->_bind_edit( t_nodes )
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

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell(
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
