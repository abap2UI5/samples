CLASS z2ui5_cl_demo_app_359 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA first_name TYPE string.
    DATA last_name  TYPE string.
    DATA num_a      TYPE i.
    DATA num_b      TYPE i.
    DATA amount     TYPE string.
    DATA search     TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_359 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_init.

    first_name = `John`.
    last_name  = `Doe`.
    num_a      = 42.
    num_b      = 77.
    amount     = `-15`.
    search     = `VIPCustomer`.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(concat)  = |\{= ${ client->_bind( first_name ) } + ' ' + ${ client->_bind( last_name ) }\}|.
    DATA(max)     = |\{= Math.max(${ client->_bind( num_a ) }, ${ client->_bind( num_b ) })\}|.
    DATA(sign)    = |\{= ${ client->_bind( amount ) } >= 0 ? 'Positive' : 'Negative' \}|.
    DATA(vip_en)  = |\{= /vip/i.test(${ client->_bind( search ) })\}|.

    DATA(view) = z2ui5_cl_util_xml=>factory( ).
    DATA(root) = view->__( n = `View` ns = `mvc`
        p = VALUE #( ( n = `displayBlock` v = abap_true )
                     ( n = `height`       v = `100%` )
                     ( n = `xmlns`        v = `sap.m` )
                     ( n = `xmlns:form`   v = `sap.ui.layout.form` )
                     ( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ) ) ).

    DATA(page) = root->__( `Shell`
       )->__( n = `Page`
              p = VALUE #( ( n = `navButtonPress` v = client->_event_nav_app_leave( ) )
                           ( n = `showNavButton`  v = client->check_app_prev_stack( ) )
                           ( n = `title`          v = `abap2UI5 - Expression Binding` ) ) ).

    page->__( `headerContent`
       )->_( n = `Link`
             p = VALUE #( ( n = `href`   v = `https://ui5.sap.com/sdk/#/topic/daf6852a04b44d118963968a1239d2c0` )
                          ( n = `target` v = `_blank` )
                          ( n = `text`   v = `UI5 Docs` ) ) ).

    DATA(form) = page->__( n = `SimpleForm` ns = `form`
        p = VALUE #( ( n = `editable` v = abap_true )
                     ( n = `layout`   v = `ResponsiveGridLayout` )
                     ( n = `title`    v = `Expression Binding` ) ) ).
    DATA(ct) = form->__( n = `content` ns = `form` ).

    ct->_( n = `Title` a = `text` v = `String Concatenation` ).
    ct->_( n = `Label`  a = `text` v = `First Name` ).
    ct->_( n = `Input`  a = `value` v = client->_bind_edit( first_name ) ).
    ct->_( n = `Label`  a = `text` v = `Last Name` ).
    ct->_( n = `Input`  a = `value` v = client->_bind_edit( last_name ) ).
    ct->_( n = `Label`  a = `text` v = `Result` ).
    ct->_( n = `Text`   a = `text` v = concat ).

    ct->_( n = `Title` a = `text` v = `Arithmetic` ).
    ct->_( n = `Label`  a = `text` v = `Number A` ).
    ct->_( n = `Input`
           p = VALUE #( ( n = `type`  v = `Number` )
                        ( n = `value` v = client->_bind_edit( num_a ) ) ) ).
    ct->_( n = `Label`  a = `text` v = `Number B` ).
    ct->_( n = `Input`
           p = VALUE #( ( n = `type`  v = `Number` )
                        ( n = `value` v = client->_bind_edit( num_b ) ) ) ).
    ct->_( n = `Label`  a = `text` v = `Math.max(A, B)` ).
    ct->_( n = `Text`   a = `text` v = max ).

    ct->_( n = `Title` a = `text` v = `Ternary Operator` ).
    ct->_( n = `Label`  a = `text` v = `Amount` ).
    ct->_( n = `Input`
           p = VALUE #( ( n = `type`  v = `Number` )
                        ( n = `value` v = client->_bind_edit( amount ) ) ) ).
    ct->_( n = `Label`  a = `text` v = `Sign` ).
    ct->_( n = `Text`   a = `text` v = sign ).

    ct->_( n = `Title` a = `text` v = `Regular Expression` ).
    ct->_( n = `Label`  a = `text` v = `Customer Name` ).
    ct->_( n = `Input`  a = `value` v = client->_bind_edit( search ) ).
    ct->_( n = `Label`  a = `text` v = `VIP Action` ).
    ct->_( n = `Button`
           p = VALUE #( ( n = `enabled` v = vip_en )
                        ( n = `text`    v = `Grant VIP Access` )
                        ( n = `type`    v = `Emphasized` ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
