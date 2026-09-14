" @keywords event argument literal quoted expression evaluated check_arg_literal t_arg data binding syntax dollar brace
" @summary An event argument that starts with $ or { is live UI5 expression syntax and gets resolved on the client - check_arg_literal sends it as the text it is.
"! Every argument of an _event( ) wire is written into the view. One that
"! starts with `$` or `{` is written RAW, as live UI5 expression syntax -
"! that is how `${$source&gt;/KEY}` reaches the handler as the row's value
"! instead of as those thirteen characters.
"!
"! Data can start with those characters too: text a user typed, a key from
"! a foreign system. Written raw it is RESOLVED, and what arrives is the
"! result - the bound price instead of the text `${/PRICE}`. s_ctrl-
"! check_arg_literal quotes every argument of that wire as a string, so the
"! wire gives up expressions and carries data. Two buttons over the same
"! argument show both readings side by side.
CLASS z2ui5_cl_smp_app_506 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA price     TYPE string.
    DATA argument  TYPE string.
    DATA raw_arg   TYPE string.
    DATA lit_arg   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_event.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_506 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).

      price    = `1299.00`.
      " the argument both wires start with: the client-side spelling of the
      " bound price, composed from the bind so the path is a registered one
      argument = |$\{{ client->_bind( val = price path = abap_true ) }\}|.
      raw_arg  = `-`.
      lit_arg  = `-`.
      view_display( ).

    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `RAW`.
        " what the client resolved: `${/PRICE}` names the bound price, so
        " its value arrives, not the text
        raw_arg = client->get_event_arg( ).

      WHEN `LITERAL`.
        " the same argument, quoted by check_arg_literal: the text arrives
        lit_arg = client->get_event_arg( ).

      WHEN `REBUILD`.
        " the argument is written into the view at render time, so a new
        " text needs a new view - the two wires below carry it from then on
        raw_arg = `-`.
        lit_arg = `-`.
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD view_display.

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
            )->a( n = `title`          v = `abap2UI5 - Event - Literal Arguments (check_arg_literal)`
            )->a( n = `showNavButton`  b = client->check_app_prev_stack( )
            )->a( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).

    page->tag( `MessageStrip`
        )->a( n = `text`     t = `Both buttons send the same argument. Written raw, the $-expression is resolved and ` &&
                   `the bound price arrives; with s_ctrl-check_arg_literal the wire quotes it and the text ` &&
                   `arrives. Type any other text - $event, {= 1 + 1 } - press Rebuild, and the literal ` &&
                   `wire still delivers it unchanged.`
        )->a( n = `type`     v = `Information`
        )->a( n = `showIcon` b = abap_true
        )->a( n = `class`    v = `sapUiSmallMargin` ).

    DATA(form) = page->ele( n = `SimpleForm` ns = `form`
        )->a( n = `title`    v = `One argument, two wires`
        )->a( n = `editable` b = abap_true
        )->ele( n = `content` ns = `form` ).

    form->tag( `Label`
        )->a( n = `text` v = `The bound price the raw argument resolves to` ).
    form->tag( `Input`
        )->a( n = `value` v = client->_bind( price ) ).

    form->tag( `Label`
        )->a( n = `text` v = `The argument both buttons carry` ).
    form->tag( `Input`
        )->a( n = `value` v = client->_bind( argument ) ).
    form->tag( `Button`
        )->a( n = `text`  v = `Rebuild the view with this argument`
        )->a( n = `press` v = client->_event( `REBUILD` ) ).

    " the raw wire is kept on the binding shape the sample starts with: any
    " other text typed above is only sent through the literal wire, because
    " an argument that is not valid expression syntax would break the view
    DATA(raw_expr) = |$\{{ client->_bind( val = price path = abap_true ) }\}|.
    form->tag( `Label`
        )->a( n = `text` v = `Raw - resolved on the client` ).
    form->tag( `Button`
        )->a( n = `text`  t = |Send { raw_expr } raw|
        )->a( n = `press` v = client->_event( val = `RAW`
                                              arg = raw_expr ) ).
    form->tag( `Text`
        )->a( n = `text` v = client->_bind( raw_arg ) ).

    form->tag( `Label`
        )->a( n = `text` v = `Literal - quoted by check_arg_literal` ).
    form->tag( `Button`
        )->a( n = `text`  t = |Send { argument } as a literal|
        )->a( n = `type`  v = `Emphasized`
        )->a( n = `press` v = client->_event( val    = `LITERAL`
                                              arg    = argument
                                              s_ctrl = VALUE #( check_arg_literal = abap_true ) ) ).
    form->tag( `Text`
        )->a( n = `text` v = client->_bind( lit_arg ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
