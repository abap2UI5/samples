CLASS z2ui5_cl_demo_app_354 DEFINITION PUBLIC CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
    DATA product  TYPE string.
    DATA quantity TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_354 IMPLEMENTATION.
  METHOD z2ui5_if_app~main.
    IF client->check_on_init( ).
      product  = `products`.
      quantity = `500`.
      DATA(view) = z2ui5_cl_util_xml=>factory( ).
      DATA(lo_content) = view->_( n = `View` ns = `mvc` p = VALUE #(
                                      ( n = `displayBlock` v = `true` )
                                      ( n = `height`       v = `100%` )
                                      ( n = `xmlns`        v = `sap.m` )
                                      ( n = `xmlns:mvc`    v = `sap.ui.core.mvc` )
                                      ( n = `xmlns:form`   v = `sap.ui.layout.form` ) )
                              )->_( `Shell`
                              )->_( n = `Page` p = VALUE #(
                                      ( n = `title`          v = `abap2UI5 - First Example` )
                                      ( n = `navButtonPress` v = client->_event_nav_app_leave( ) )
                                      ( n = `showNavButton`  v = client->check_app_prev_stack( ) ) )
                              )->_( n = `SimpleForm` ns = `form` p = VALUE #(
                                      ( n = `title`    v = `Form Title` )
                                      ( n = `editable` v = abap_true ) )
                              )->_( n = `content` ns = `form` ).
      lo_content->__( n = `Title` a = `text` v = `Input`
               )->__( n = `Label` a = `text` v = `quantity`
               )->__( n = `Input` a = `value` v = client->_bind_edit( quantity )
               )->__( n = `Label` a = `text` v = `product`
               )->__( n = `Input` p = VALUE #(
                         ( n = `value`   v = product )
                         ( n = `enabled` v = `false` ) )
               )->__( n = `Button` p = VALUE #(
                         ( n = `text`  v = `post` )
                         ( n = `press` v = client->_event( `BUTTON_POST` ) ) ) ).
      client->view_display( view->stringify( ) ).
    ELSEIF client->check_on_event( `BUTTON_POST` ).
      client->message_toast_display( |{ product } { quantity } - send to the server| ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
