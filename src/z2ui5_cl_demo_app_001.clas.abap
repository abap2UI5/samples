CLASS z2ui5_cl_demo_app_001 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_product  TYPE string.
    DATA mv_quantity TYPE string.

  PROTECTED SECTION.

    DATA mo_client TYPE REF TO z2ui5_if_client.

    METHODS set_data.
    METHODS display_view.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_001 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->mo_client = mo_client.

    IF mo_client->check_on_init( ).
      display_view( ).
      set_data( ).
    ENDIF.

    on_event( ).
  ENDMETHOD.

  METHOD display_view.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    mo_client->view_display( lo_view->shell(
           )->page(
                   title          = `abap2UI5 - First Example`
                   navbuttonpress = mo_client->_event_nav_app_leave( )
                   shownavbutton  = mo_client->check_app_prev_stack( )
        )->simple_form( title = `Form Title` editable = abap_true
                   )->content( `form`
                       )->title( `Input`
                       )->label( `quantity`
                       )->input( mo_client->_bind_edit( mv_quantity )
                       )->label( `product`
                       )->input( value = mv_product enabled = abap_false
                       )->button(
                           text  = `post`
                           press = mo_client->_event( `BUTTON_POST` )
            )->stringify( ) ).
  ENDMETHOD.

  METHOD on_event.

    IF mo_client->check_on_event( `BUTTON_POST` ).
      mo_client->message_toast_display( |{ mv_product } { mv_quantity } - send to the server| ).
    ENDIF.
  ENDMETHOD.

  METHOD set_data.

    mv_product  = `products`.
    mv_quantity = `500`.
  ENDMETHOD.
ENDCLASS.
