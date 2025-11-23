CLASS z2ui5_cl_demo_app_327 DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_value,
             field1 TYPE i,
             field2 TYPE string,
           END OF ty_value.

    TYPES: BEGIN OF ty_storage,
             type   TYPE string,
             prefix TYPE string,
             key    TYPE string,
             value  TYPE string,
*             value  TYPE ty_value,
           END OF ty_storage.

    TYPES: BEGIN OF ty_storage_type,
             type TYPE string,
           END OF ty_storage_type.

    DATA storage       TYPE ty_storage.
    DATA stored_value  TYPE string.
    DATA storage_types TYPE STANDARD TABLE OF ty_storage_type.

ENDCLASS.


CLASS z2ui5_cl_demo_app_327 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.
    IF client->check_on_init( ).

      storage_types = VALUE #( ( type = `local` )
                               ( type =  `session` ) ).
      storage = VALUE #( type   = `local`
                         prefix = `prefix1`
                         key    = 'key1'
*                         value  = VALUE #( field1 = 1
*                         field2 = 'textfld1' )
                                           ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).

      view->shell(
        )->page( title          = 'abap2UI5 - Storage'
                 navbuttonpress = client->_event( val = 'BACK' )
                 shownavbutton  = client->check_app_prev_stack( )

        )->simple_form( title    = 'Local/Session Storage'
                        editable = abap_true
            )->content( 'form'
                )->label( 'Type'
                      )->select( forceselection = abap_true
                                 selectedkey    = client->_bind_edit( storage-type )
                                 items          = client->_bind( storage_types )
                          )->item( key  = '{TYPE}'
                                   text = '{TYPE}'
                          )->get_parent(
                )->label( 'Prefix'
                )->input( client->_bind_edit( storage-prefix )
                )->label( 'Key'
                )->input( client->_bind_edit( storage-key )
                )->label( 'Value'
                )->input( client->_bind_edit( storage-value )
                )->button( text  = 'store'
                           press = client->_event_client( val   = z2ui5_if_client=>cs_event-store_data
                                                          t_arg = VALUE #( ( |${ client->_bind_edit( storage ) }| ) ) )

                )->button( text  = 'get'
                           press = client->_event( 'GET_STORED_VALUE' )
                                       )->get_parent(
                                       )->get_parent(

        )->_z2ui5( )->storage(
            finished = client->_event(
                val   = `LOCAL_STORAGE_LOADED`
                t_arg = VALUE #( ( `${$parameters>/type}` ) ( `${$parameters>/prefix}` ) ( `${$parameters>/key}` ) ( `${$parameters>/value}` )  ) )
            type     = client->_bind_edit( storage-type )
            prefix   = client->_bind_edit( storage-prefix )
            key      = client->_bind_edit( storage-key )
            value    = client->_bind_edit( stored_value ) ).
      client->view_display( view->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.
      WHEN 'LOCAL_STORAGE_LOADED'.
*        z2ui5_cl_ajson=>parse( client->get_event_arg( 4 ) )->to_abap( IMPORTING ev_container = storage-value ).
        storage-value = client->get_event_arg( 4 ).
        client->view_model_update( ).
      WHEN 'GET_STORED_VALUE'.
*        z2ui5_cl_ajson=>parse( stored_value )->to_abap( IMPORTING ev_container = storage-value ).
        storage-value = stored_value.
        client->view_model_update( ).
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
