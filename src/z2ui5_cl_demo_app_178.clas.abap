CLASS z2ui5_cl_demo_app_178 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

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
        expanded    TYPE abap_bool,
        nodes       TYPE STANDARD TABLE OF ty_prodh_node_level3 WITH DEFAULT KEY,
      END OF ty_prodh_node_level2 .
    TYPES:
      BEGIN OF ty_prodh_node_level1,
        is_selected TYPE abap_bool,
        text        TYPE string,
        prodh       TYPE string,
        expanded    TYPE abap_bool,
        nodes       TYPE STANDARD TABLE OF ty_prodh_node_level2 WITH DEFAULT KEY,
      END OF ty_prodh_node_level1 .
    TYPES:
      ty_prodh_nodes TYPE STANDARD TABLE OF ty_prodh_node_level1 WITH DEFAULT KEY .
    TYPES:
      BEGIN OF ty_prodh_node_level2_ex,
        expanded TYPE abap_bool,
      END OF ty_prodh_node_level2_ex .
    TYPES:
      BEGIN OF ty_prodh_node_level1_ex,
        expanded TYPE abap_bool,
        nodes    TYPE STANDARD TABLE OF ty_prodh_node_level2_ex WITH DEFAULT KEY,
      END OF ty_prodh_node_level1_ex .
    TYPES:
      ty_prodh_nodes_ex TYPE STANDARD TABLE OF ty_prodh_node_level1_ex WITH DEFAULT KEY .

    DATA prodh_nodes TYPE ty_prodh_nodes .
    DATA prodh_nodes_ex TYPE ty_prodh_nodes_ex .
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

    client->_bind_edit( prodh_nodes_ex ).

    DATA(dialog) = z2ui5_cl_xml_view=>factory_popup(
        )->dialog( title = 'Choose Product here...' contentheight = '50%' contentwidth  = '50%' ).

    dialog->tree(
        mode  = 'SingleSelectMaster'
        items = client->_bind_edit( prodh_nodes )
*        toggleopenstate = client->_event( val = 'TOGGLE_STATE' t_arg = VALUE #( ( `${$parameters>/itemIndex}` ) ( `${$parameters>/expanded}` ) ) )
        toggleopenstate = client->_event( val = 'TOGGLE_STATE' t_arg = VALUE #( ( `${$parameters>/itemContext/sPath}` ) ( `${$parameters>/expanded}` ) ) )
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

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Popup Tree select Entry'
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
    prodh_nodes_ex =
      VALUE #( ( expanded = abap_false
                 nodes = VALUE #(
                                  ( expanded = abap_false )
                                 )
                )
                ( expanded = abap_false
                  nodes = VALUE #(
                                  ( expanded = abap_false )
                                 )
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

      WHEN 'TOGGLE_STATE'.
        DATA(lt_arg) = client->get( )-t_event_arg.
        DATA(row) = lt_arg[ 1 ].
        DATA(expanded) = lt_arg[ 2 ].

        SPLIT row AT '/' INTO TABLE DATA(lt_indxs).

        IF row CS '/NODES/'.
          DATA(lv_node) = lt_indxs[ 4 ].
          DATA(lv_child_node) = lt_indxs[ 6 ].
          ASSIGN prodh_nodes_ex[ lv_node + 1 ]-nodes[ lv_child_node + 1 ]-expanded TO FIELD-SYMBOL(<fss>).
          <fss> = expanded.
        ELSE.
          lv_node = lt_indxs[ 4 ].
          ASSIGN prodh_nodes_ex[ lv_node + 1 ]-expanded TO FIELD-SYMBOL(<fss1>).
          <fss1> = expanded.
        ENDIF.

        client->popup_model_update( ).


      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'POPUP_TREE'.
        ui5_display_popup_tree_select( ).

      WHEN 'CONTINUE'.
        client->popup_destroy( ).
        client->message_box_display( `Selected entry is set in the backend` ).

      WHEN 'CANCEL'.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
