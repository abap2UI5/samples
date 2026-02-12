CLASS z2ui5_cl_demo_app_093 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_product  TYPE string.
    DATA mv_quantity TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_093 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      mv_product  = `tomato`.
      mv_quantity = `500`.

      DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).

      lo_view->_generic( ns   = `html`
                      name = `script`)->_cc_plain_xml( `sap.z2ui5.myFunction();` ).

      client->view_display( lo_view->shell(
            )->page(
                    title          = `abap2UI5 - First Example`
                    navbuttonpress = client->_event_nav_app_leave( )
                    shownavbutton  = client->check_app_prev_stack( )
                )->simple_form( title    = `Form Title`
                                editable = abap_true
                    )->content( `form`
                        )->title( `Input`
                        )->label( `quantity`
                        )->input( client->_bind_edit( mv_quantity )
                        )->label( `product`
                        )->input( value   = mv_product
                                  enabled = abap_false
                        )->button(
                            text  = `post`
                            press = client->_event( `BUTTON_POST` )
             )->stringify( ) ).

    ENDIF.

    CASE client->get( )-event.
      WHEN `BUTTON_POST`.
        client->message_toast_display( |{ mv_product } { mv_quantity } - send to the server| ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
