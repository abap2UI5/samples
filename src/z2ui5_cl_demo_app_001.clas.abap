CLASS z2ui5_cl_demo_app_001 DEFINITION PUBLIC CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_demo_app_001 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      product  = `products`.
      quantity = `500`.

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      view->shell(
          )->page(
              title          = `abap2UI5 - First Example`
              navbuttonpress = client->_event_nav_app_leave( )
              shownavbutton  = client->check_app_prev_stack( )
              )->simple_form(
                  title    = `Form Title`
                  editable = abap_true
                  )->content( `form`
                  )->title( `Input`
                  )->label( `quantity`
                  )->input( client->_bind_edit( quantity )
                  )->label( `product`
                  )->input(
                      value   = product
                      enabled = abap_false
                  )->button(
                      text  = `post`
                      press = client->_event( `BUTTON_POST` ) ).
      client->view_display( view->stringify( ) ).

    ELSEIF client->check_on_event( `BUTTON_POST` ).
      client->message_toast_display( |{ product } { quantity } - send to the server| ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
