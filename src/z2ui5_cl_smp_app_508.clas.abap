" @keywords binding path only bare path _bind_path expression binding sorter binding info composed raw string
" @summary _bind_path( ) hands you the model PATH of an attribute instead of {/PATH}: the piece a composed expression binding, a sorter or a bindElement needs.
"! `client-&gt;_bind( quantity )` returns `{/QUANTITY}` - a complete property
"! binding, ready for a view attribute. Some attributes need the PATH alone:
"! an expression that combines it with a comparison, a binding-info object
"! that adds a sorter or a formatter, a bindElement. `client-&gt;_bind_path(
"! quantity )` returns `/QUANTITY` for exactly that - byte for byte what
"! `_bind( val = quantity path = abap_true )` returns, under a name that
"! says what it does. It registers the attribute like every bind: a path
"! the view names must be in the model, or the client renders nothing.
CLASS z2ui5_cl_smp_app_508 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_row,
        product TYPE string,
        stock   TYPE i,
      END OF ty_s_row.
    DATA t_row TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    DATA quantity TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_508 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      quantity = 120.
      t_row    = VALUE #( ( product = `Monitor 27"`  stock = 5 )
                          ( product = `Headset`      stock = 9 )
                          ( product = `Keyboard`     stock = 71 )
                          ( product = `Notebook 15"` stock = 12 ) ).
      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the two forms of the same binding, next to each other
    DATA(quantity_binding) = client->_bind( quantity ).
    DATA(quantity_path)    = client->_bind_path( quantity ).
    DATA(rows_path)        = client->_bind_path( t_row ).

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory(
        )->ele( n = `View` ns = `mvc`
            )->a( n = `displayBlock` v = `true`
            )->a( n = `height`       v = `100%`
            )->a( n = `xmlns`        v = `sap.m`
            )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
            )->a( n = `xmlns:core`   v = `sap.ui.core`
            )->a( n = `xmlns:form`   v = `sap.ui.layout.form` ).

    DATA(page) = view->ele( `Shell`
        )->ele( `Page`
            )->a( n = `title`          v = `abap2UI5 - Binding - Path Only (_bind_path)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     v = `_bind( ) returns the finished binding string; _bind_path( ) returns the bare path for the ` &&
                   `places that compose their own binding string: the expression that colours the status ` &&
                   `below, and the items binding of the list, which adds a sorter to the path. Change the ` &&
                   `quantity and press Enter to see the expression re-evaluate on the client.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(form) = page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `One attribute, two spellings`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form` ).

    form->tag( `Label`
        )->a( n = `text` v = `quantity, bound with _bind( ) - the full binding` ).
    form->tag( `Input`
        )->a( n = `value`       v = quantity_binding
        )->a( n = `description` t = quantity_binding ).

    " the bare path inside an expression binding: the string is composed in
    " ABAP, and the path in it comes from _bind_path( ) rather than being
    " written by hand - a hand-written path is not in the model
    form->tag( `Label`
        )->a( n = `text` v = `the same attribute inside an expression - needs the bare path` ).
    form->tag( `ObjectStatus`
        )->a( n = `text`  v = |\{= $\{{ quantity_path }\} > 100 ? 'more than 100 in stock' : 'running low' \}|
        )->a( n = `state` v = |\{= $\{{ quantity_path }\} > 100 ? 'Success' : 'Warning' \}| ).
    form->tag( `Text`
        )->a( n = `text` t = |_bind_path( quantity ) returned { quantity_path }| ).

    " the bare path of a table inside a binding-info object: the sorter is
    " client-side, the path still names a bound attribute
    form->tag( `Label`
        )->a( n = `text` v = `a table path with a sorter added - needs the bare path` ).
    form->ele( `List`
        )->a( n = `items` v = |\{ path: '{ rows_path }', sorter: \{ path: 'PRODUCT' \}, templateShareable: false \}|
        )->tag( `StandardListItem`
            )->a( n = `title` v = `{PRODUCT}`
            )->a( n = `info`  v = `{STOCK} in stock` ).
    form->tag( `Text`
        )->a( n = `text` t = |_bind_path( t_row ) returned { rows_path } - the list is sorted by product on the client| ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
