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
      DATA(view)       = z2ui5_cl_util_xml=>factory( ).
      DATA(lo_view)    = view->_( n = `View` ns = `mvc` ).
      lo_view->p( n = `displayBlock` v = `true` ).
      lo_view->p( n = `height` v = `100%` ).
      lo_view->p( n = `xmlns` v = `sap.m` ).
      lo_view->p( n = `xmlns:mvc` v = `sap.ui.core.mvc` ).
      lo_view->p( n = `xmlns:core` v = `sap.ui.core` ).
      lo_view->p( n = `xmlns:form` v = `sap.ui.layout.form` ).
      DATA(lo_page)    = lo_view->_( `Shell` )->_( `Page` ).
      lo_page->p( n = `title` v = `abap2UI5 - First Example` ).
      lo_page->p( n = `navButtonPress` v = client->_event_nav_app_leave( ) ).
      lo_page->p( n = `showNavButton` v = client->check_app_prev_stack( ) ).
      DATA(lo_form)    = lo_page->_( n = `SimpleForm` ns = `form` ).
      lo_form->p( n = `title` v = `Form Title` ).
      lo_form->p( n = `editable` v = abap_true ).
      DATA(lo_content) = lo_form->_( n = `content` ns = `form` ).
      lo_content->__( n = `Title` a = `text` v = `Input` ).
      lo_content->__( n = `Label` a = `text` v = `quantity` ).
      lo_content->__( n = `Input` a = `value` v = client->_bind_edit( quantity ) ).
      lo_content->__( n = `Label` a = `text` v = `product` ).
      lo_content->__( n = `Input`
          p = VALUE #(
                ( n = `value` v = product )
                ( n = `enabled` v = `false` ) ) ).
      lo_content->__( n = `Button`
          p = VALUE #(
                ( n = `text` v = `post` )
                ( n = `press` v = client->_event( `BUTTON_POST` ) ) ) ).
      client->view_display( view->stringify( ) ).
    ELSEIF client->check_on_event( `BUTTON_POST` ).
      client->message_toast_display( |{ product } { quantity } - send to the server| ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
