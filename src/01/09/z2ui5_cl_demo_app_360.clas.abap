CLASS z2ui5_cl_demo_app_360 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA price      TYPE string.
    DATA currency   TYPE string.
    DATA big_number TYPE string.
    DATA integer    TYPE string.
    DATA date       TYPE string.

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

    price      = `1234.56`.
    currency   = `EUR`.
    big_number = `9876543.21`.
    integer    = `42`.
    date       = `2025-12-31`.

    view_display( ).

  ENDMETHOD.


  METHOD view_display.

    DATA(float_bind) = |\{ path: "{ client->_bind( val = big_number path = abap_true ) }", type: "sap.ui.model.type.Float", formatOptions: \{ decimals: 2, groupingEnabled: true \} \}|.
    DATA(int_bind)   = |\{ path: "{ client->_bind( val = integer path = abap_true ) }", type: "sap.ui.model.type.Integer" \}|.
    DATA(curr_bind)  = |\{ parts: [\{ path: "{ client->_bind( val = price path = abap_true ) }" \},\{ path: "{ client->_bind( val = currency path = abap_true ) }" \}], type: "sap.ui.model.type.Currency" \}|.
    DATA(date_bind)  = |\{ path: "{ client->_bind( val = date path = abap_true ) }", type: "sap.ui.model.type.Date", formatOptions: \{ source: \{ pattern: "yyyy-MM-dd" \}, style: "long" \} \}|.

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
                           ( n = `title`          v = `abap2UI5 - Formatter` ) ) ).

    page->__( `headerContent`
       )->_( n = `Link`
             p = VALUE #( ( n = `href`   v = `https://ui5.sap.com/sdk/#/topic/07e4b920f5734fd78fdaa236f26236d8` )
                          ( n = `target` v = `_blank` )
                          ( n = `text`   v = `UI5 Docs` ) ) ).

    DATA(form) = page->__( n = `SimpleForm` ns = `form`
        p = VALUE #( ( n = `editable` v = abap_true )
                     ( n = `layout`   v = `ResponsiveGridLayout` )
                     ( n = `title`    v = `Formatter` ) ) ).
    DATA(ct) = form->__( n = `content` ns = `form` ).

    ct->_( n = `Title` a = `text` v = `Number` ).
    ct->_( n = `Label`  a = `text` v = `Raw value` ).
    ct->_( n = `Input`  a = `value` v = client->_bind_edit( big_number ) ).
    ct->_( n = `Label`  a = `text` v = `Float (grouped, 2 decimals)` ).
    ct->_( n = `Input`
           p = VALUE #( ( n = `enabled` v = abap_false )
                        ( n = `value`   v = float_bind ) ) ).
    ct->_( n = `Label`  a = `text` v = `Raw integer` ).
    ct->_( n = `Input`  a = `value` v = client->_bind_edit( integer ) ).
    ct->_( n = `Label`  a = `text` v = `Integer (formatted)` ).
    ct->_( n = `Input`
           p = VALUE #( ( n = `enabled` v = abap_false )
                        ( n = `value`   v = int_bind ) ) ).

    ct->_( n = `Title` a = `text` v = `Currency` ).
    ct->_( n = `Label`  a = `text` v = `Price` ).
    ct->_( n = `Input`  a = `value` v = client->_bind_edit( price ) ).
    ct->_( n = `Label`  a = `text` v = `Currency code` ).
    ct->_( n = `Input`  a = `value` v = client->_bind_edit( currency ) ).
    ct->_( n = `Label`  a = `text` v = `Formatted (Currency type)` ).
    ct->_( n = `Input`
           p = VALUE #( ( n = `enabled` v = abap_false )
                        ( n = `value`   v = curr_bind ) ) ).

    ct->_( n = `Title` a = `text` v = `Date` ).
    ct->_( n = `Label`  a = `text` v = `Raw date (yyyy-MM-dd)` ).
    ct->_( n = `Input`  a = `value` v = client->_bind_edit( date ) ).
    ct->_( n = `Label`  a = `text` v = `Formatted (long style)` ).
    ct->_( n = `Input`
           p = VALUE #( ( n = `enabled` v = abap_false )
                        ( n = `value`   v = date_bind ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
