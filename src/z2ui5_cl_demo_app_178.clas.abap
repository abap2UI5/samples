CLASS z2ui5_cl_demo_app_178 DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_prodh_node_level3,
        is_selected TYPE abap_bool,
        text        TYPE string,
        prodh       TYPE string,
      END OF ty_prodh_node_level3 .
    TYPES:
      BEGIN OF ty_prodh_node_level2,
        is_selected TYPE abap_bool,
        text        TYPE string,
        prodh       TYPE string,
        nodes       TYPE STANDARD TABLE OF ty_prodh_node_level3 WITH DEFAULT KEY,
      END OF ty_prodh_node_level2 .
    TYPES:
      BEGIN OF ty_prodh_node_level1,
        is_selected TYPE abap_bool,
        text        TYPE string,
        prodh       TYPE string,
        nodes       TYPE STANDARD TABLE OF ty_prodh_node_level2 WITH DEFAULT KEY,
      END OF ty_prodh_node_level1 .
    TYPES
      ty_prodh_nodes TYPE STANDARD TABLE OF ty_prodh_node_level1 WITH DEFAULT KEY .

    DATA mv_prodh_nodes TYPE ty_prodh_nodes .
    DATA mv_initialized TYPE abap_bool .

    METHODS display_view .
  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.
    METHODS initialize.
    METHODS display_popup_tree_select.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_178 IMPLEMENTATION.

  METHOD display_popup_tree_select.

    DATA(lo_dialog) = z2ui5_cl_xml_view=>factory_popup(
        )->dialog( title         = `Choose Product here...`
                   contentheight = `50%`
                   contentwidth  = `50%`
                   beforeopen    = `setState()`
                   beforeclose   = `saveState()` ).

    lo_dialog->tree(
        id    = `tree`
        mode  = `SingleSelectMaster`
        items = mo_client->_bind_edit( mv_prodh_nodes )
        )->items(
            )->standard_tree_item( selected = `{IS_SELECTED}`
                                   title    = `{TEXT}` ).

    lo_dialog->buttons(
        )->button( text = `Continue`
               icon     = `sap-icon://accept`
               type     = `Accept`
               press    = mo_client->_event( `CONTINUE` )
        )->button( text = `Cancel`
               icon     = `sap-icon://decline`
               type     = `Reject`
               press    = mo_client->_event( `CANCEL` ) ).

    mo_client->popup_display( lo_dialog->stringify( ) ).
  ENDMETHOD.

  METHOD display_view.

    DATA(lv_save_state_js) = `function saveState() {` && |\n| &&
                             `  var treeTable = sap.z2ui5.oViewPopup.Fragment.byId("popupId","tree");` && |\n| &&
                             `  sap.z2ui5.treeState = treeTable.getBinding('items').getCurrentTreeState();` && |\n| &&
                             ` }; `.
    DATA(lv_reset_state_js) = `function setState() { ` && |\n| &&
                              ` var treeTable = sap.z2ui5.oViewPopup.Fragment.byId("popupId","tree");` && |\n| &&
                              ` if( sap.z2ui5.treeState == undefined ) {` && |\n| &&
                              `     sap.z2ui5.treeState = treeTable.getBinding('items').getCurrentTreeState();` && |\n| &&
                              ` } else {` && |\n| &&
                              `     treeTable.getBinding("items").setTreeState(sap.z2ui5.treeState);` && |\n| &&
                              `     treeTable.getBinding("items").refresh();` && |\n| &&
                              ` };` && |\n| &&
                              `};`.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    lo_view->_generic( ns   = `html`
                    name = `script` )->_cc_plain_xml( lv_save_state_js ).
    lo_view->_generic( ns   = `html`
                    name = `script` )->_cc_plain_xml( lv_reset_state_js ).
    DATA(lo_page) = lo_view->shell(
         )->page(
            title           = `abap2UI5 - Tree - Open & Close Popup to see the control keeping expanded`
            navbuttonpress  = mo_client->_event_nav_app_leave( )
              shownavbutton = abap_true ).

    mo_client->view_display( lo_page->button( text  = `Open Popup here...`
                                        press = mo_client->_event( `POPUP_TREE` ) )->stringify( ) ).
  ENDMETHOD.

  METHOD initialize.

    mv_prodh_nodes =
      VALUE #( ( text = `Machines`
               prodh  = `00100`
               nodes  = VALUE #( ( text = `Pumps`
                                  prodh = `0010000100`
                                  nodes = VALUE #( ( text  = `Pump 001`
                                                     prodh = `001000010000000100` )
                                                   ( text  = `Pump 002`
                                                     prodh = `001000010000000105` ) )
                       ) ) )
             ( text  = `Paints`
               prodh = `00110`
               nodes = VALUE #( ( text  = `Gloss paints`
                                  prodh = `0011000105`
                                  nodes = VALUE #( ( text  = `Paint 001`
                                                     prodh = `001100010500000100` )
                                                   ( text  = `Paint 002`
                                                     prodh = `001100010500000105` ) )
                       ) )
             ) ).
  ENDMETHOD.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mv_initialized = abap_false.
      mv_initialized = abap_true.
      initialize( ).
      display_view( ).
    ENDIF.

    CASE mo_client->get( )-event.
      WHEN `POPUP_TREE`.
        display_popup_tree_select( ).
      WHEN `CONTINUE`.
        mo_client->popup_destroy( ).
      WHEN `CANCEL`.
        mo_client->popup_destroy( ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
