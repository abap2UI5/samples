CLASS z2ui5_cl_demo_app_178 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES z2ui5_if_app .

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
    TYPES:
      ty_prodh_nodes TYPE STANDARD TABLE OF ty_prodh_node_level1 WITH DEFAULT KEY .

    DATA prodh_nodes TYPE ty_prodh_nodes .
    DATA is_initialized TYPE abap_bool .

    METHODS ui5_display_view .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    METHODS ui5_initialize.
    METHODS ui5_display_popup_tree_select.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_178 IMPLEMENTATION.


  METHOD ui5_display_popup_tree_select.

    DATA(dialog) = z2ui5_cl_xml_view=>factory_popup(
        )->dialog( title = 'Choose Product here...' contentheight = '50%' contentwidth  = '50%' beforeopen = `setState()` beforeclose = `saveState()` ).

    dialog->tree(
        id = `tree`
        mode  = 'SingleSelectMaster'
        items = client->_bind_edit( prodh_nodes )
        )->items(
            )->standard_tree_item( selected = '{IS_SELECTED}' title = '{TEXT}' ).

    dialog->buttons(
        )->button( text  = 'Continue'
               icon  = `sap-icon://accept`
               type  = `Accept`
               press = client->_event( 'CONTINUE' )
        )->button( text  = 'Cancel'
               icon  = `sap-icon://decline`
               type  = `Reject`
               press = client->_event( 'CANCEL' ) ).


    client->popup_display( dialog->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_display_view.
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

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->_generic( ns = `html` name = `script` )->_cc_plain_xml( lv_save_state_js ).
    view->_generic( ns = `html` name = `script` )->_cc_plain_xml( lv_reset_state_js ).
    DATA(page) = view->shell(
         )->page(
            title          = 'abap2UI5 - Tree - Open & Close Popup to see the control keeping expanded'
            navbuttonpress = client->_event( 'BACK' )
              shownavbutton = abap_true ).

    client->view_display( page->button( text = 'Open Popup here...' press = client->_event( 'POPUP_TREE' ) )->stringify( ) ).

  ENDMETHOD.


  METHOD ui5_initialize.
    prodh_nodes =
    VALUE #( ( text = 'Machines'
               prodh = '00100'
               nodes = VALUE #( ( text = 'Pumps'
                                  prodh = '0010000100'
                                  nodes = VALUE #( ( text = 'Pump 001'
                                                     prodh = '001000010000000100' )
                                                   ( text = 'Pump 002'
                                                     prodh = '001000010000000105' )
                                          )
                       ) )
             )
             ( text = 'Paints'
               prodh = '00110'
               nodes = VALUE #( ( text = 'Gloss paints'
                                  prodh = '0011000105'
                                  nodes = VALUE #( ( text = 'Paint 001'
                                                     prodh = '001100010500000100' )
                                                   ( text = 'Paint 002'
                                                     prodh = '001100010500000105' )
                                          )
                       ) )
             )
    ).
  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF is_initialized = abap_false.
      is_initialized = abap_true.
      ui5_initialize( ).
      ui5_display_view( ).
    ENDIF.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'POPUP_TREE'.
        ui5_display_popup_tree_select( ).

      WHEN 'CONTINUE'.
        client->popup_destroy( ).

      WHEN 'CANCEL'.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
