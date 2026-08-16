" @keywords popup expand state hierarchy nodes
" @summary A tree inside a dialog, including which nodes stay expanded when the popup is opened again.
" @docs https://abap2ui5.github.io/docs/cookbook/model/trees
CLASS z2ui5_cl_smp_app_462 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smp_app_462 IMPLEMENTATION.


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
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSE.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

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

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`       v = `sap.m`
            )->a( n = `xmlns:core`  v = `sap.ui.core`
            )->a( n = `xmlns:z2ui5` v = `z2ui5.cc` ).
    DATA(dialog) = popup->ele( `Dialog`
        )->a( n = `title` v = `abap2UI5 - Tree in a dialog` ).

    " the popup view slot gets its own copy of the model - the nested table
    " bound here renders in the dialog exactly like in a main view
    dialog->ele( `Tree`
        )->a( n = `id`         v = `treePopup`
        )->a( n = `items`      v = client->_bind( t_nodes )
        )->a( n = `headerText` v = `Documents`
        )->tag( `StandardTreeItem`
            )->a( n = `title` v = `{TEXT}` ).

    " invisible companion: snapshots the tree's expand state before each
    " roundtrip and re-applies it after rendering - reopening the dialog
    " shows the same nodes expanded as when it was closed
    dialog->tag( n = `Tree` ns = `z2ui5` ).

    dialog->ele( `buttons`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `CLOSE_POPUP` )
            )->a( n = `text`  v = `Close` ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Tree - Inside a Dialog`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text` v = `The button opens a Dialog whose content is a sap.m.Tree over a nested ABAP ` &&
                   `table. Expand some nodes, close and reopen: the z2ui5.cc.Tree companion ` &&
                   `preserves the expand state across the roundtrips.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    page->ele( `VBox`
        )->a( n = `class` v = `sapUiSmallMargin`
        )->tag( `Button`
            )->a( n = `press` v = client->_event( `OPEN_POPUP` )
            )->a( n = `text`  v = `Open tree popup`
            )->a( n = `icon`  v = `sap-icon://tree` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
