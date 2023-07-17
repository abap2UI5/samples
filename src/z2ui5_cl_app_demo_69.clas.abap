CLASS z2ui5_cl_app_demo_69 DEFINITION
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
      END OF ty_prodh_node_level3,
      BEGIN OF ty_prodh_node_level2,
        is_selected TYPE abap_bool,
        text        TYPE string,
        prodh       TYPE string,
        nodes       TYPE STANDARD TABLE OF ty_prodh_node_level3 WITH DEFAULT KEY,
      END OF ty_prodh_node_level2,
      BEGIN OF ty_prodh_node_level1,
        is_selected TYPE abap_bool,
        text        TYPE string,
        prodh       TYPE string,
        nodes       TYPE STANDARD TABLE OF ty_prodh_node_level2 WITH DEFAULT KEY,
      END OF ty_prodh_node_level1,
      ty_prodh_nodes TYPE STANDARD TABLE OF ty_prodh_node_level1 WITH DEFAULT KEY.

    DATA prodh_nodes    TYPE ty_prodh_nodes.
    DATA is_initialized TYPE abap_bool.

    METHODS ui5_display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.
    METHODS ui5_initialize.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_app_demo_69 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF is_initialized = abap_false.
      is_initialized = abap_true.
      ui5_initialize( ).
      ui5_display_view( client ).
    ENDIF.

    CASE client->get( )-event.

      when `EVENT_ITEM`.
           data(lt_arg) = client->get( )-t_event_arg.
          client->message_box_display( `event ` && lt_arg[ 1 ] ).

      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).

      WHEN 'CONTINUE'.
        client->popup_destroy( ).
        client->message_box_display( `Selected entry is set in the backend` ).

      WHEN 'CANCEL'.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD ui5_initialize.
    prodh_nodes =
    VALUE #( ( text = 'Apps'
               prodh = '00100'
               nodes = VALUE #( ( text = 'Frontend'
                                  prodh = '0010000100'
                                  nodes = VALUE #( ( text = 'App_001'
                                                     prodh = '001000010000000100' )
                                                   ( text = 'App_002'
                                                     prodh = '001000010000000105' )
                                          )
                       ) )
             )
             ( text = 'Configuration'
               prodh = '00110'
               nodes = VALUE #( ( text = 'User Interface'
                                  prodh = '0011000105'
                                  nodes = VALUE #( ( text = 'Theme'
                                                     prodh = '001100010500000100' )
                                                   ( text = 'Library'
                                                     prodh = '001100010500000105' )
                                    )      )
                                 ( text = 'Database'
                                  prodh = '0011000105'
                                  nodes = VALUE #( ( text = 'HANA'
                                                     prodh = '001100010500000100' )
                                                   ( text = 'ANY DB'
                                                     prodh = '001100010500000105' )
                                 )          )

             ) )
    ).


  ENDMETHOD.


  METHOD ui5_display_view.


    DATA(view) = z2ui5_cl_xml_view=>factory( client ).
    data(lo_view) = view->shell( )->page(
             title          = 'abap2UI5 - Partial Rendering with nested Views'
             navbuttonpress = client->_event( 'BACK' )
             shownavbutton  = abap_true
         )->header_content(
             )->link( text = 'Demo'    target = '_blank'    href = `https://twitter.com/abap2UI5/status/1645816100813152256`
             )->link(
                 text = 'Source_Code' target = '_blank'
                 href = view->hlp_get_source_code_url( )
         )->get_parent(
          ).

*    DATA(dialog) = z2ui5_cl_xml_view=>factory_popup( client
*        )->dialog( title = 'Choose Product here...' contentheight = '50%' contentwidth  = '50%' ).

    lo_view->tree(
*        mode  = 'SingleSelectMaster'
        items = client->_bind_edit( prodh_nodes )
        )->items(
            )->standard_tree_item( type = 'Active' selected = '{IS_SELECTED}' title = '{TEXT}' press = client->_event( val = `EVENT_ITEM` t_arg = VALUE #( ( `${TEXT}`  )  ) ) ).

*    lo_view->button( text  = 'Continue'
*               icon  = `sap-icon://accept`
*               type  = `Accept`
*               press = client->_event( 'CONTINUE' )
*        )->button( text  = 'Cancel'
*               icon  = `sap-icon://decline`
*               type  = `Reject`
*               press = client->_event( 'CANCEL' ) ).

    client->view_display( lo_view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
