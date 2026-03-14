CLASS z2ui5_cl_demo_app_356 DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA input_a TYPE string.
    DATA input_b TYPE string.
    DATA input_c TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_356 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    DATA(view) = z2ui5_cl_util_xml=>factory( ).
    DATA(root) = view->_( n = `View` ns = `mvc`
        p = VALUE #( ( n = `displayBlock` v = abap_true )
                     ( n = `height`       v = `100%` )
                     ( n = `xmlns`        v = `sap.m` )
                     ( n = `xmlns:l`      v = `sap.ui.layout` )
                     ( n = `xmlns:mvc`    v = `sap.ui.core.mvc` ) ) ).

    DATA(page) = root->_( `Shell` )->_( n = `Page`
        p = VALUE #( ( n = `navButtonPress` v = client->_event_nav_app_leave( ) )
                     ( n = `showNavButton`  v = client->check_app_prev_stack( ) )
                     ( n = `title`          v = `abap2UI5 - Label` ) ) ).

    page->_( `headerContent`
       )->__( n = `Link`
              p = VALUE #( ( n = `href`   v = `https://ui5.sap.com/sdk/#/entity/sap.m.Label/sample/sap.m.sample.Label` )
                           ( n = `target` v = `_blank` )
                           ( n = `text`   v = `UI5 Demo Kit` ) ) ).

    DATA(layout) = page->_( n = `VerticalLayout` ns = `l`
        p = VALUE #( ( n = `class` v = `sapUiContentPadding` )
                     ( n = `width` v = `100%` ) ) ).

    layout->__( n = `Label`
                p = VALUE #( ( n = `labelFor` v = `input-a` )
                             ( n = `text`     v = `Label A (required)` ) )
           )->__( n = `Input`
                  p = VALUE #( ( n = `id`       v = `input-a` )
                               ( n = `required` v = abap_true )
                               ( n = `value`    v = client->_bind_edit( input_a ) ) )
           )->__( n = `Label`
                  p = VALUE #( ( n = `design`   v = `Bold` )
                               ( n = `labelFor` v = `input-b` )
                               ( n = `text`     v = `Label B (bold)` ) )
           )->__( n = `Input`
                  p = VALUE #( ( n = `id`    v = `input-b` )
                               ( n = `value` v = client->_bind_edit( input_b ) ) )
           )->__( n = `Label`
                  p = VALUE #( ( n = `labelFor` v = `input-c` )
                               ( n = `text`     v = `Label C (normal)` ) )
           )->__( n = `Input`
                  p = VALUE #( ( n = `id`    v = `input-c` )
                               ( n = `value` v = client->_bind_edit( input_c ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
