CLASS z2ui5_cl_smp_app_327 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " Both fields are strings on purpose. The value round-trips through the
    " browser and back through the storage, so whatever sits under the key is
    " outside this app's control - and the framework converts it into these
    " components BEFORE main( ) runs, where no TRY/CATCH of ours can reach it.
    " A numeric component would let one oversized stored value (or a leftover
    " from an earlier shape) fail the conversion on every single app start,
    " leaving no screen from which to clear it.
    TYPES:
      BEGIN OF ty_s_value,
        field1 TYPE string,
        field2 TYPE string,
      END OF ty_s_value.
    TYPES:
      BEGIN OF ty_s_storage,
        type   TYPE string,
        prefix TYPE string,
        key    TYPE string,
        value  TYPE ty_s_value,
      END OF ty_s_storage.
    TYPES:
      BEGIN OF ty_s_type,
        type TYPE string,
      END OF ty_s_type.
    DATA s_storage TYPE ty_s_storage.
    DATA s_stored_value TYPE ty_s_value.
    DATA t_types TYPE STANDARD TABLE OF ty_s_type WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_327 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    t_types   = VALUE #( ( type = `local` ) ( type = `session` ) ).
    s_storage = VALUE #( type   = `local`
                         prefix = `prefix1`
                         key    = `key1`
                         value  = VALUE #( field1 = `1`
                                           field2 = `textfld1` ) ).

    view_display( ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `LOCAL_STORAGE_LOADED`.
        " The z2ui5:Storage control read a value out of the browser storage
        " and reports it through its `finished` event. The payload is a whole
        " structure, so it arrives as JSON and is parsed back into ABAP.
        TRY.
            " corresponding fields only: whatever sits under the key may carry
            " more (or other) fields than this app models - an earlier shape,
            " or a value someone else wrote
            z2ui5_cl_ajson=>parse( client->get_event_arg( 4 )
              )->to_abap_corresponding_only(
              )->to_abap( IMPORTING ev_container = s_storage-value ).
          CATCH z2ui5_cx_ajson_error INTO DATA(lx_load).
            client->message_box_display( lx_load->get_text( ) ).
        ENDTRY.
        client->view_model_update( ).

      WHEN `GET_STORED_VALUE`.
        s_storage-value = s_stored_value.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page( title          = `abap2UI5 - Storage`
                                       navbuttonpress = client->_event_nav_app_leave( )
                                       shownavbutton  = client->check_app_prev_stack( ) ).

    page->message_strip(
        text     = `Reads and writes the browser's local or session storage. The ` &&
                   `value is a whole ABAP structure, not just a string: the write ` &&
                   `side sends it with the STORE_DATA frontend action, the invisible ` &&
                   `z2ui5:Storage control reads it back and reports it as JSON.`
        type     = `Information`
        showicon = abap_true
        class    = `sapUiSmallMargin` ).

    page->simple_form( title    = `Local/Session Storage`
                       editable = abap_true
        )->content( `form`
            )->label( `Type`
            )->select( forceselection = abap_true
                       selectedkey    = client->_bind( s_storage-type )
                       items          = client->_bind( t_types )
                )->item( key  = `{TYPE}`
                         text = `{TYPE}` )->get_parent(
            )->label( `Prefix`
            )->input( client->_bind( s_storage-prefix )
            )->label( `Key`
            )->input( client->_bind( s_storage-key )
            )->label( `Value - Field 1`
            )->input( value = client->_bind( s_storage-value-field1 )
                      type  = `Number`
            )->label( `Value - Field 2`
            )->input( client->_bind( s_storage-value-field2 )
            )->label( ``
            )->button( text  = `store`
                       press = client->_event_client(
                           val   = z2ui5_if_client=>cs_event-store_data
                           t_arg = VALUE #( ( |${ client->_bind( s_storage ) }| ) ) )
            )->button( text  = `get`
                       press = client->_event( `GET_STORED_VALUE` ) ).

    " Invisible companion control: it reads `key` out of the selected storage
    " and fires `finished` when the stored value differs from `value`. The
    " comparison is by value, so a structure does not re-trigger on every
    " render.
    page->_z2ui5( )->storage(
        finished = client->_event( val   = `LOCAL_STORAGE_LOADED`
                                   t_arg = VALUE #( ( `${$parameters>/type}` )
                                                    ( `${$parameters>/prefix}` )
                                                    ( `${$parameters>/key}` )
                                                    ( `${$parameters>/value}` ) ) )
        type     = client->_bind( s_storage-type )
        prefix   = client->_bind( s_storage-prefix )
        key      = client->_bind( s_storage-key )
        value    = client->_bind( s_stored_value ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
