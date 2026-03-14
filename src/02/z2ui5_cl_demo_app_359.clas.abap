CLASS z2ui5_cl_demo_app_359 DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_first_name TYPE string.
    DATA mv_last_name  TYPE string.
    DATA mv_num_a      TYPE i.
    DATA mv_num_b      TYPE i.
    DATA mv_amount     TYPE string.
    DATA mv_search     TYPE string.

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

    mv_first_name = `John`.
    mv_last_name  = `Doe`.
    mv_num_a      = 42.
    mv_num_b      = 77.
    mv_amount     = `-15`.
    mv_search     = `VIPCustomer`.

    view_display( ).

  ENDMETHOD.

  METHOD view_display.

    DATA(lv_concat) = `{= $` && client->_bind( mv_first_name ) &&
                      ` + ' ' + $` && client->_bind( mv_last_name ) && `}`.
    DATA(lv_max)    = `{= Math.max($` && client->_bind( mv_num_a ) &&
                      `, $` && client->_bind( mv_num_b ) && `)}`.
    DATA(lv_sign)   = `{= $` && client->_bind( mv_amount ) &&
                      ` >= 0 ? 'Positive' : 'Negative' }`.
    DATA(lv_vip_en) = `{= /vip/i.test($` && client->_bind( mv_search ) && `)}`.

    DATA(view) = z2ui5_cl_util_xml=>factory( ).
    DATA(root) = view->_( n = `View` ns = `mvc`
        p = VALUE #( ( n = `displayBlock` v = abap_true )
                     ( n = `height`       v = `100%` )
                     ( n = `xmlns`        v = `sap.m` )
                     ( n = `xmlns:form`   v = `sap.ui.layout.form` )
                     ( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ) ) ).

    DATA(page) = root->_( `Shell` )->_( n = `Page`
        p = VALUE #( ( n = `navButtonPress` v = client->_event_nav_app_leave( ) )
                     ( n = `showNavButton`  v = client->check_app_prev_stack( ) )
                     ( n = `title`          v = `abap2UI5 - Expression Binding` ) ) ).

    page->_( `headerContent`
       )->__( n = `Link`
              p = VALUE #( ( n = `href`   v = `https://ui5.sap.com/sdk/#/topic/daf6852a04b44d118963968a1239d2c0` )
                           ( n = `target` v = `_blank` )
                           ( n = `text`   v = `UI5 Docs` ) ) ).

    DATA(form) = page->_( n = `SimpleForm` ns = `form`
        p = VALUE #( ( n = `editable` v = abap_true )
                     ( n = `layout`   v = `ResponsiveGridLayout` )
                     ( n = `title`    v = `Expression Binding` ) ) ).
    DATA(ct) = form->_( n = `content` ns = `form` ).

    ct->__( n = `Title` a = `text` v = `String Concatenation` ).
    ct->__( n = `Label`  a = `text` v = `First Name` ).
    ct->__( n = `Input`  a = `value` v = client->_bind_edit( mv_first_name ) ).
    ct->__( n = `Label`  a = `text` v = `Last Name` ).
    ct->__( n = `Input`  a = `value` v = client->_bind_edit( mv_last_name ) ).
    ct->__( n = `Label`  a = `text` v = `Result` ).
    ct->__( n = `Text`   a = `text` v = lv_concat ).

    ct->__( n = `Title` a = `text` v = `Arithmetic` ).
    ct->__( n = `Label`  a = `text` v = `Number A` ).
    ct->__( n = `Input`
            p = VALUE #( ( n = `type`  v = `Number` )
                         ( n = `value` v = client->_bind_edit( mv_num_a ) ) ) ).
    ct->__( n = `Label`  a = `text` v = `Number B` ).
    ct->__( n = `Input`
            p = VALUE #( ( n = `type`  v = `Number` )
                         ( n = `value` v = client->_bind_edit( mv_num_b ) ) ) ).
    ct->__( n = `Label`  a = `text` v = `Math.max(A, B)` ).
    ct->__( n = `Text`   a = `text` v = lv_max ).

    ct->__( n = `Title` a = `text` v = `Ternary Operator` ).
    ct->__( n = `Label`  a = `text` v = `Amount` ).
    ct->__( n = `Input`
            p = VALUE #( ( n = `type`  v = `Number` )
                         ( n = `value` v = client->_bind_edit( mv_amount ) ) ) ).
    ct->__( n = `Label`  a = `text` v = `Sign` ).
    ct->__( n = `Text`   a = `text` v = lv_sign ).

    ct->__( n = `Title` a = `text` v = `Regular Expression` ).
    ct->__( n = `Label`  a = `text` v = `Customer Name` ).
    ct->__( n = `Input`  a = `value` v = client->_bind_edit( mv_search ) ).
    ct->__( n = `Label`  a = `text` v = `VIP Action` ).
    ct->__( n = `Button`
            p = VALUE #( ( n = `enabled` v = lv_vip_en )
                         ( n = `text`    v = `Grant VIP Access` )
                         ( n = `type`    v = `Emphasized` ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
