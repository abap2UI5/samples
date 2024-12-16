CLASS z2ui5_cl_demo_app_321 DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_product TYPE string.
    DATA mv_quantity TYPE string.
    DATA mv_search TYPE string.

    DATA mt_search TYPE z2ui5_cl_util=>ty_t_name_value.
  PROTECTED SECTION.


    DATA client TYPE REF TO z2ui5_if_client.
    METHODS state_handling
      RETURNING
        VALUE(result) TYPE abap_bool.

ENDCLASS.


CLASS z2ui5_cl_demo_app_321 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.
    me->client = client.
    IF state_handling( ).
      RETURN.
    ENDIF.

    IF client->check_on_navigated( ).
      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      view->_z2ui5( )->history( client->_bind( mv_search ) ).
      client->view_display( val = view->shell(
             )->page(
                     title          = 'abap2UI5 - Navigation with app state'
                     navbuttonpress = client->_event( 'BACK' )
                     shownavbutton  = client->check_app_prev_stack( )
          )->simple_form( title = 'Form Title' editable = abap_true
                     )->content( 'form'
                         )->title( 'Input'
                         )->label( 'quantity'
                         )->input( client->_bind_edit( mv_quantity )
                         )->label( `product`
                         )->input( client->_bind_edit( mv_product )
                         )->button(
                             text  = 'post'
                             press = client->_event( val = 'BUTTON_POST' )
              )->stringify( ) ).
    ENDIF.

    client->message_toast_display( `data updated` ).
  ENDMETHOD.


  METHOD state_handling.

    IF client->check_on_init( ).
      "we check if an app state is already set, if yes leave to this state (draft)
      TRY.
          mt_search = z2ui5_cl_util=>url_param_get_tab( client->get( )-s_config-search ).
          DATA(lv_id) = mt_search[ n =  `z2ui5-xapp-state` ]-v.
          client->nav_app_leave( client->get_app( lv_id ) ).
          result = abap_true.
          RETURN.
        CATCH cx_root.
      ENDTRY.
    ENDIF.

    "set the url parameter with the actual app state id (draft)
    DELETE mt_search WHERE n = `z2ui5-xapp-state`.
    INSERT VALUE #( n = `z2ui5-xapp-state` v = client->get( )-s_draft-id ) INTO TABLE mt_search.
    mv_search = `?` && z2ui5_cl_util=>url_param_create_url( mt_search ).
    client->view_model_update( ).

  ENDMETHOD.

ENDCLASS.
