CLASS z2ui5_cl_demo_app_lp_04 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_product  TYPE string.
    DATA mv_product_url  TYPE string.
    DATA mv_quantity TYPE string.

    DATA mv_check_launchpad_active TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z2ui5_cl_demo_app_lp_04 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    DATA(lo_view) = z2ui5_cl_xml_view=>factory( ).
    mv_product_url = z2ui5_cl_util=>url_param_get(
                    val = `product`
                    url = client->get( )-s_config-search ).
    mv_check_launchpad_active = client->get( )-check_launchpad_active.

    DATA(lt_params) = client->get( )-t_comp_params.
    TRY.
        mv_product = lt_params[ n = `PRODUCT` ]-v.
      CATCH cx_root.
    ENDTRY.
    IF client->check_on_init( ).

      mv_quantity = `500`.

      client->view_display( lo_view->shell(
            )->page(
                    showheader     = xsdbool( abap_false = client->get( )-check_launchpad_active )
                    title          = `abap2UI5 -  Cross App Navigation App 128`
                    navbuttonpress = client->_event_nav_app_leave( )
                    shownavbutton  = client->check_app_prev_stack( )
                )->header_content(
                    )->link(
                        text   = `Source_Code`

                        target = `_blank`
                )->get_parent(
                )->simple_form( title    = `App 128`
                                editable = abap_true
                    )->content( `form`
                        )->title( `Input`
                        )->label( `product nav param`
                        )->input( client->_bind_edit( mv_product )
                        )->label( `CHECK_LAUNCHPAD_ACTIVE`
                        )->input( mv_check_launchpad_active
                        )->button( press = client->_event( )
                        )->button( text  = `BACK`
                                   press = client->_event_client( client->cs_event-cross_app_nav_to_prev_app )
                        )->button(
                            text  = `go to app 127`
                            press = client->_event_client(
            val   = client->cs_event-cross_app_nav_to_ext
            t_arg = VALUE #( ( `{ semanticObject: "Z2UI5_CL_LP_SAMPLE_03",  action: "display" }` ) ( `{ ProductID : "123234" }`) ) )
             )->stringify( ) ).

    ENDIF.

    client->view_model_update( ).

    CASE client->get( )-event.
      WHEN `BUTTON_POST`.

*        client->message_toast_display( |{ product } { quantity } - send to the server| ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
