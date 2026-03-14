CLASS z2ui5_cl_demo_app_360 DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA mv_price      TYPE string.
    DATA mv_currency   TYPE string.
    DATA mv_big_number TYPE string.
    DATA mv_integer    TYPE string.
    DATA mv_date       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS on_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_360 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      on_init( ).
    ENDIF.

  ENDMETHOD.

  METHOD on_init.

    mv_price      = `1234.56`.
    mv_currency   = `EUR`.
    mv_big_number = `9876543.21`.
    mv_integer    = `42`.
    mv_date       = `2025-12-31`.

    view_display( ).

  ENDMETHOD.

  METHOD view_display.

    DATA(lv_float_bind) = `{ path: "` &&
        client->_bind( val = mv_big_number path = abap_true ) &&
        `", type: "sap.ui.model.type.Float",` &&
        ` formatOptions: { decimals: 2, groupingEnabled: true } }`.
    DATA(lv_int_bind)   = `{ path: "` &&
        client->_bind( val = mv_integer path = abap_true ) &&
        `", type: "sap.ui.model.type.Integer" }`.
    DATA(lv_curr_bind)  = `{ parts: [{ path: "` &&
        client->_bind( val = mv_price    path = abap_true ) && `" },` &&
        `{ path: "` && client->_bind( val = mv_currency path = abap_true ) &&
        `" }], type: "sap.ui.model.type.Currency" }`.
    DATA(lv_date_bind)  = `{ path: "` &&
        client->_bind( val = mv_date path = abap_true ) &&
        `", type: "sap.ui.model.type.Date",` &&
        ` formatOptions: { source: { pattern: "yyyy-MM-dd" }, style: "long" } }`.

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
                     ( n = `title`          v = `abap2UI5 - Formatter` ) ) ).

    page->_( `headerContent`
       )->__( n = `Link`
              p = VALUE #( ( n = `href`   v = `https://ui5.sap.com/sdk/#/topic/07e4b920f5734fd78fdaa236f26236d8` )
                           ( n = `target` v = `_blank` )
                           ( n = `text`   v = `UI5 Docs` ) ) ).

    DATA(form) = page->_( n = `SimpleForm` ns = `form`
        p = VALUE #( ( n = `editable` v = abap_true )
                     ( n = `layout`   v = `ResponsiveGridLayout` )
                     ( n = `title`    v = `Formatter` ) ) ).
    DATA(ct) = form->_( n = `content` ns = `form` ).

    ct->__( n = `Title` a = `text` v = `Number` ).
    ct->__( n = `Label`  a = `text` v = `Raw value` ).
    ct->__( n = `Input`  a = `value` v = client->_bind_edit( mv_big_number ) ).
    ct->__( n = `Label`  a = `text` v = `Float (grouped, 2 decimals)` ).
    ct->__( n = `Input`
            p = VALUE #( ( n = `enabled` v = abap_false )
                         ( n = `value`   v = lv_float_bind ) ) ).
    ct->__( n = `Label`  a = `text` v = `Raw integer` ).
    ct->__( n = `Input`  a = `value` v = client->_bind_edit( mv_integer ) ).
    ct->__( n = `Label`  a = `text` v = `Integer (formatted)` ).
    ct->__( n = `Input`
            p = VALUE #( ( n = `enabled` v = abap_false )
                         ( n = `value`   v = lv_int_bind ) ) ).

    ct->__( n = `Title` a = `text` v = `Currency` ).
    ct->__( n = `Label`  a = `text` v = `Price` ).
    ct->__( n = `Input`  a = `value` v = client->_bind_edit( mv_price ) ).
    ct->__( n = `Label`  a = `text` v = `Currency code` ).
    ct->__( n = `Input`  a = `value` v = client->_bind_edit( mv_currency ) ).
    ct->__( n = `Label`  a = `text` v = `Formatted (Currency type)` ).
    ct->__( n = `Input`
            p = VALUE #( ( n = `enabled` v = abap_false )
                         ( n = `value`   v = lv_curr_bind ) ) ).

    ct->__( n = `Title` a = `text` v = `Date` ).
    ct->__( n = `Label`  a = `text` v = `Raw date (yyyy-MM-dd)` ).
    ct->__( n = `Input`  a = `value` v = client->_bind_edit( mv_date ) ).
    ct->__( n = `Label`  a = `text` v = `Formatted (long style)` ).
    ct->__( n = `Input`
            p = VALUE #( ( n = `enabled` v = abap_false )
                         ( n = `value`   v = lv_date_bind ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
