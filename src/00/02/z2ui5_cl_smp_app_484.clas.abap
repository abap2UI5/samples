CLASS z2ui5_cl_smp_app_484 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA product  TYPE string.
    DATA quantity TYPE string.

    DATA check_launchpad_active TYPE abap_bool.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smp_app_484 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    check_launchpad_active = client->get( )-check_launchpad_active.

    DATA(t_params) = client->get( )-t_comp_params.
    TRY.
        product = t_params[ n = `PRODUCT` ]-v.
        quantity = t_params[ n = `QUANTITY` ]-v.
      CATCH cx_root.
    ENDTRY.

    IF client->check_on_init( ).

      DATA(view) = z2ui5_cl_xml_view=>factory( ).
      DATA(page) = view->shell(
            )->page(
                    showheader     = xsdbool( abap_false = client->get( )-check_launchpad_active )
                    title          = `abap2UI5 - Launchpad - Cross-App Navigation (Receiver)`
                    navbuttonpress = client->_event_nav_app_leave( )
                    shownavbutton  = client->check_app_prev_stack( ) ).

      page->message_strip(
          text     = `RECEIVER side of launchpad cross-app navigation: started via the sender ` &&
                     `tile (z2ui5_cl_smp_app_483), it reads the Product and Quantity values the ` &&
                     `sender handed over from its startup parameters (t_comp_params) and shows ` &&
                     `them below. ` &&
                     `The button navigates back to the sender the same way. Only works inside ` &&
                     `a launchpad with both tiles configured.`
          type     = `Information`
          showicon = abap_true
          class    = `sapUiSmallMargin` ).

      page->simple_form( title    = `Cross-App Navigation - Receiver`
                         editable = abap_true
          )->content( `form`
              )->label( `Product (received navigation parameter)`
              )->input( value   = client->_bind( product )
                        enabled = abap_false
              )->label( `Quantity (received navigation parameter)`
              )->input( value   = client->_bind( quantity )
                        enabled = abap_false
              )->label( `Launchpad active`
              )->input( value   = check_launchpad_active
                        enabled = abap_false
              )->button( text    = `back to the previous app`
                         visible = check_launchpad_active
                         press   = client->_event_client( client->cs_event-cross_app_nav_to_prev_app )
              )->button(
                  text    = `navigate to the sender app`
                  visible = check_launchpad_active
                  press   = client->_event_client(
                      val   = client->cs_event-cross_app_nav_to_ext
                      t_arg = VALUE #( ( `{ semanticObject: "Z2UI5_CL_LP_SAMPLE_03",  action: "display" }` ) ) ) ).

      client->view_display( view->stringify( ) ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
