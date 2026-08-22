" @keywords localstorage sessionstorage persist store_data offline
" @summary Writes to the browser's local and session storage and reads it back, so a value survives a reload without any state in the backend.
" @docs https://abap2ui5.github.io/docs/cookbook/browser_interaction/clipboard
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
    DATA t_types TYPE STANDARD TABLE OF ty_s_type WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS on_event.
    METHODS view_display.
    METHODS json_get_value
      IMPORTING
        json          TYPE string
        name          TYPE string
      RETURNING
        VALUE(result) TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_327 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      on_init( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    DATA temp1 LIKE t_types.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-type = `local`.
    INSERT temp2 INTO TABLE temp1.
    temp2-type = `session`.
    INSERT temp2 INTO TABLE temp1.
    t_types   = temp1.
    CLEAR s_storage.
    s_storage-type = `local`.
    s_storage-prefix = `prefix1`.
    s_storage-key = `key1`.
    CLEAR s_storage-value.
    s_storage-value-field1 = `1`.
    s_storage-value-field2 = `textfld1`.

    view_display( ).

  ENDMETHOD.


  METHOD on_event.
        DATA lv_json TYPE string.

    CASE client->get_event( ).

      WHEN `LOCAL_STORAGE_LOADED`.
        " The z2ui5:Storage control read a value out of the browser storage
        " and reports it through its `finished` event. The payload is a whole
        " structure, so it arrives as JSON - here it is picked apart field by
        " field, which is also what keeps this tolerant: whatever sits under
        " the key may carry more (or other) fields than this app models - an
        " earlier shape, or a value someone else wrote. A field that is not
        " there simply stays empty.
        
        lv_json = client->get_event_arg( 4 ).
        CLEAR s_storage-value.
        s_storage-value-field1 = json_get_value( json = lv_json
name = `FIELD1` ).
        s_storage-value-field2 = json_get_value( json = lv_json
name = `FIELD2` ).

      WHEN `GET_STORED_VALUE`.
        s_storage-value = s_stored_value.

    ENDCASE.

  ENDMETHOD.


  METHOD json_get_value.

    " A minimal reader for one string field of a flat JSON object: find
    " `"<name>":"` and take what stands up to the next quote. The model writes
    " the ABAP component names in upper case, hence the case-insensitive
    " search. An app parsing arbitrary JSON wants a real parser instead.
    DATA lv_marker TYPE string.
    DATA lv_off TYPE i.
    lv_marker = |"{ name }":"|.

    
    lv_off = find( val  = json
                         sub  = lv_marker
                         case = abap_false ).
    IF lv_off < 0.
      RETURN.
    ENDIF.

    result = substring_before( val = substring( val = json
                                                off = lv_off + strlen( lv_marker ) )
                               sub = `"` ).

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
    DATA temp1 LIKE LINE OF temp3.
    DATA temp5 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form`
            )->a( n = `xmlns:z2ui5`  v = `z2ui5.cc` ).

    
    page = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Browser - Local and Session Storage`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text` v = `Reads and writes the browser's local or session storage. The ` &&
                   `value is a whole ABAP structure, not just a string: the write ` &&
                   `side sends it with the STORE_DATA frontend action, the invisible ` &&
                   `z2ui5:Storage control reads it back and reports it as JSON.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    
    CLEAR temp3.
    
    temp1 = |${ client->_bind( s_storage ) }|.
    INSERT temp1 INTO TABLE temp3.
    page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `Local/Session Storage`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form`
            )->tag( `Label`
                )->a( n = `text`           v = `Type`
            )->ele( `Select`
                )->a( n = `forceSelection` b = abap_true
                )->a( n = `selectedKey`    v = client->_bind( s_storage-type )
                )->a( n = `items`          v = client->_bind( t_types )
                )->tag( n = `Item` ns = `core`
                    )->a( n = `key`  v = `{TYPE}`
                    )->a( n = `text` v = `{TYPE}`
            )->end(
            )->tag( `Label`
                )->a( n = `text`  v = `Prefix`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( s_storage-prefix )
            )->tag( `Label`
                )->a( n = `text`  v = `Key`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( s_storage-key )
            )->tag( `Label`
                )->a( n = `text`  v = `Value - Field 1`
            )->tag( `Input`
                )->a( n = `type`  v = `Number`
                )->a( n = `value` v = client->_bind( s_storage-value-field1 )
            )->tag( `Label`
                )->a( n = `text`  v = `Value - Field 2`
            )->tag( `Input`
                )->a( n = `value` v = client->_bind( s_storage-value-field2 )
            )->tag( `Label`
                )->a( n = `text`  v = ``
            )->tag( `Button`
                )->a( n = `press` v = client->follow_up_action(
                           val   = z2ui5_if_client=>cs_event-store_data
                           t_arg = temp3 )
                )->a( n = `text`  v = `store`
            )->tag( `Button`
                )->a( n = `press` v = client->_event( `GET_STORED_VALUE` )
                )->a( n = `text`  v = `get` ).

    " Invisible companion control: it reads `key` out of the selected storage
    " and fires `finished` when the stored value differs from `value`. The
    " comparison is by value, so a structure does not re-trigger on every
    " render.
    
    CLEAR temp5.
    INSERT `${$parameters>/type}` INTO TABLE temp5.
    INSERT `${$parameters>/prefix}` INTO TABLE temp5.
    INSERT `${$parameters>/key}` INTO TABLE temp5.
    INSERT `${$parameters>/value}` INTO TABLE temp5.
    page->tag( n = `Storage` ns = `z2ui5`
        )->a( n = `finished` v = client->_event( val   = `LOCAL_STORAGE_LOADED`
                                   t_arg = temp5 )
        )->a( n = `type`   v = client->_bind( s_storage-type )
        )->a( n = `prefix` v = client->_bind( s_storage-prefix )
        )->a( n = `key`    v = client->_bind( s_storage-key )
        )->a( n = `value`  v = client->_bind( s_stored_value ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
